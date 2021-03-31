#import "StatisticsController.h"
#import "UIColorAdditions.h"
#import "Result.h"
#import "ViewBuilder.h"
#import "UILabelAdditions.h"
#import "NSDateFormatterAdditions.h"
#import "UIImageAdditions.h"

@interface StatisticsController ()
@property(nonatomic, strong) CPTScatterPlot* plot;
@property(nonatomic, strong) CPTGraphHostingView* graphView;
@property(nonatomic, strong) UILabel* titleLeft;
@property(nonatomic, strong) UILabel* titleRight;
@property(nonatomic, strong) UILabel* subtitleLeft;
@property(nonatomic, strong) UILabel* subtitleRight;
@end


static const int scoresShown = 6;

@interface DateFormatter : NSNumberFormatter {
}
@property(nonatomic, strong) NSArray* results;
@end
#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
@implementation DateFormatter

+ (id)formatterForResults:(NSArray*)results {
    DateFormatter* result = [[self class] new];
    result.results = results;
    return result;
}

- (NSString*)stringForObjectValue:(id)obj {
    NSInteger index = [obj integerValue] - 1;
    NSInteger adjustedIndex = [self.results count] > scoresShown ? [self.results count] - scoresShown + index : index;
    if(adjustedIndex >= [self.results count] || adjustedIndex < 0)
        return @"";
    NSDate* date = [(Result*) (self.results)[adjustedIndex] time];
    return [[NSDateFormatter monthDayFormatter] stringFromDate:date];
}

@end


@implementation StatisticsController

- (NSArray*)resultsForPlot:(CPTPlot*)plot {
    AssertNotNull(self.exercise);
    return self.exercise.results;
}

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot*)plot {
    return MINVALUE(scoresShown, [[self resultsForPlot:plot] count]);
}

- (NSNumber*)numberForPlot:(CPTPlot*)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    NSArray* results = [self resultsForPlot:plot];
    NSUInteger adjustedIndex = [results count] > scoresShown ? [results count] - scoresShown + index : index;

    if(fieldEnum == CPTScatterPlotFieldX) {
        return [NSNumber numberWithInteger:index + 1];
    } else {
        return [NSNumber numberWithInteger:[results[adjustedIndex] score]];
    }
}

- (void)drawGraph {
    CPTColor* greenColor = [CPTColor colorWithCGColor:[[UIColor colorWithRGBHex:BrandedHexColor] CGColor]];

    CPTMutableLineStyle* lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor blackColor];
    lineStyle.lineWidth = 2;

    CPTMutableTextStyle* textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color = [CPTColor blackColor];
    textStyle.fontName = [[UIFont boldSystemFontOfSize:10] fontName];
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:0];

    CPTXYGraph* graph = [[CPTXYGraph alloc] initWithFrame:self.view.bounds xScaleType:CPTScaleTypeCategory yScaleType:CPTScaleTypeLinear];
    graph.paddingLeft = 10;
    graph.paddingTop = 0;
    graph.paddingRight = 10;
    graph.paddingBottom = 10;
    graph.plotAreaFrame.paddingLeft = 20;
    graph.plotAreaFrame.paddingTop = 0;
    graph.plotAreaFrame.paddingRight = 0;
    graph.plotAreaFrame.paddingBottom = 19;
    
    if(IPAD) {
        UIImage * targetImage = [UIImage imageNamed:@"bakgrund nivatest@2x.png"];
        // redraw the image to fit |yourView|'s size
        UIGraphicsBeginImageContextWithOptions( graph.frame.size, NO, 0.f);
        [targetImage drawInRect:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
       // UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //  self.graphView.layer.contents = (id)[UIImage imageNamed:@"bakgrund score@2x"].CGImage;
       // UIColor* evaluationColor = [UIColor colorWithPatternImage:resultImage];
        //graph.backgroundColor = [self.exercise.isEvaluation ? evaluationColor : UIColor.clearColor CGColor];
       
    } else {
        UIColor* evaluationColor = [UIColor colorWithPatternImage:[UIImage checkedImageNamed:@"bakgrund nivatest"]];
        graph.backgroundColor = [self.exercise.isEvaluation ? evaluationColor : UIColor.clearColor CGColor];
    }


    self.graphView = [[CPTGraphHostingView alloc] initWithFrame:CGRectZero];
    self.graphView.hostedGraph = graph;

    CPTXYPlotSpace* plotSpace = (CPTXYPlotSpace*) graph.defaultPlotSpace;
    
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInt(0)] length:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInt(scoresShown + 1)]];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInt(0)] length:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInt(20)]];

    CPTScatterPlot* plot = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
    plot.dataSource = self;
    CPTMutableLineStyle* dataLineStyle = [CPTMutableLineStyle lineStyle];
    dataLineStyle.lineWidth = 3.0f;
    dataLineStyle.lineColor = greenColor;
    plot.dataLineStyle = dataLineStyle;

    CPTPlotSymbol* circlePlotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    circlePlotSymbol.fill = [CPTFill fillWithColor:greenColor];
    circlePlotSymbol.lineStyle = nil;
    circlePlotSymbol.size = CGSizeMake(10, 10);
    plot.plotSymbol = circlePlotSymbol;

    CPTXYAxisSet* axisSet = (CPTXYAxisSet*) graph.axisSet;
    CPTXYAxis* x = axisSet.xAxis;
    x.minorTicksPerInterval = 0;
    x.majorTickLineStyle = nil;
    x.axisLineStyle = nil;
    x.labelFormatter = [DateFormatter formatterForResults:[self.exercise results]];
    x.labelTextStyle = textStyle;
    x.visibleRange = [[CPTPlotRange alloc] initWithLocation:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInt(1)] length:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInt(scoresShown - 1)]];

    CPTXYAxis* y = axisSet.yAxis;
    y.labelTextStyle = textStyle;
    y.minorTicksPerInterval = 0;
    CPTMutableLineStyle* majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineColor = [CPTColor lightGrayColor];
    y.majorGridLineStyle = majorGridLineStyle;

    y.majorIntervalLength = [NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInt(2)];
    y.axisLineStyle = nil;
    y.labelFormatter = formatter;
    y.visibleRange = [[CPTPlotRange alloc] initWithLocation:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInt(0)] length:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInt(18)]];

    [graph addPlot:plot];

    [self.view addSubview:self.graphView];
    self.plot = plot;
}

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor clearColor];

    CGFloat titleFontSize = 14;
    //UIColor *greenColor2 = [UIColor colorWithRGBHex:0x758F4E];
    self.titleLeft = [UILabel labelWithBoldText:NSLocalizedString(@"Utvecklingskurvor:", nil) fontSize:titleFontSize textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] toView:self.view];
    //self.titleRight = [UILabel labelWithBoldText:user.name fontSize:titleFontSize textColor:greenColor2 backgroundColor:[UIColor clearColor] toView:self.view];

    [self drawGraph];
    Exercise* ex = self.exercise;
    NSString* subtitleLeftText = ex.isEvaluation ? [NSLocalizedString(@"Utvärdering ", nil) stringByAppendingString:ex.category.title] : NSLocalizedString(@"Övning:", nil);
    self.subtitleLeft = [UILabel labelWithBoldText:subtitleLeftText fontSize:titleFontSize textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] toView:self.view];
    [self.subtitleLeft sizeToFit];

    self.subtitleRight = [UILabel labelWithBoldText:ex.isEvaluation ? nil : ex.title fontSize:titleFontSize textColor:[UIColor colorWithRGBHex:BrandedHexColor] backgroundColor:[UIColor clearColor] toView:self.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGFloat spacing = 8.0;

    ViewBuilder* contentBuilder = [ViewBuilder verticalBuilderForView:self.view];
    [contentBuilder addSpace:spacing];
    [contentBuilder addSpace:self.titleLeft.frame.size.height];
    [contentBuilder addSpace:spacing];
    [contentBuilder addSpace:self.subtitleLeft.frame.size.height];
    [contentBuilder addFlexibleSpaceWithFactor:1];
    ViewBuilderResult* contentResults = [contentBuilder build];
    CGRect titleFrame = [contentResults frameAtIndex:1];
    CGRect subtitleFrame = [contentResults frameAtIndex:3];
    self.graphView.frame = [contentResults frameAtIndex:4];

    ViewBuilder* titleBuilder = [ViewBuilder horizontalBuilderForFrame:titleFrame];
    [titleBuilder addSpace:10];
    [titleBuilder addCenteredView:self.titleLeft];
    [titleBuilder addSpace:spacing];
    [titleBuilder addFlexibleSpaceWithFactor:1];
    [titleBuilder addSpace:10];
    ViewBuilderResult* titleResults = [titleBuilder build];
    self.titleLeft.frame = [titleResults frameAtIndex:1];
    self.titleRight.frame = [titleResults frameAtIndex:3];

    ViewBuilder* subtitleBuilder = [ViewBuilder horizontalBuilderForFrame:subtitleFrame];
    [subtitleBuilder addSpace:10];
    [subtitleBuilder addCenteredView:self.subtitleLeft];
    [subtitleBuilder addSpace:spacing];
    [subtitleBuilder addFlexibleSpaceWithFactor:1];
    [subtitleBuilder addSpace:10];
    ViewBuilderResult* subtitleResults = [subtitleBuilder build];
    self.subtitleLeft.frame = [subtitleResults frameAtIndex:1];
    self.subtitleRight.frame = [subtitleResults frameAtIndex:3];
}

@end
