#import "ScoreController.h"
#import "UIColorAdditions.h"
#import "UILabelAdditions.h"
#import "ViewBuilder.h"
#import "UIImageAdditions.h"

@interface CategoryFormatter : NSNumberFormatter {
}
@end

@implementation CategoryFormatter

- (NSString*)stringForObjectValue:(id)obj {
    return @[@"", NSLocalizedString(@"Putt", nil), NSLocalizedString(@"Chip", nil), NSLocalizedString(@"Bunker", nil), NSLocalizedString(@"Pitch", nil)][[obj integerValue]];
}

@end


@interface ScoreController ()
@property(nonatomic, strong) CPTGraphHostingView* graphView;
@property(nonatomic, strong) UILabel* titleLabel;
@property(nonatomic, strong) UILabel* subtitleLabel;
@end

#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
static const int scoresShown = 4;

@implementation ScoreController
bool isPAD ;
- (id)init {
    self = [super init];
    isPAD = IPAD;
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIImageView checkedImageViewNamed:@"logo"]];
    return self;
    
}


- (NSArray*)resultsForPlot:(CPTPlot*)plot {
    return nil;
}

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot*)plot {
    return scoresShown;
}

- (NSNumber*)numberForPlot:(CPTPlot*)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    AssertNotNull(self.repository);

    if(fieldEnum == CPTBarPlotFieldBarLocation) {
        return [NSNumber numberWithInteger:index + 1];
    } else {
        return [NSNumber numberWithDouble:[[[self.repository findCategories][index] evaluation] average]];
    }
}

- (CPTGraphHostingView*)drawGraph {
    CPTMutableLineStyle* lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor whiteColor];
    lineStyle.lineWidth = 2;

    CPTMutableTextStyle* textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color = [CPTColor whiteColor];
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
    graph.backgroundColor = [[UIColor clearColor] CGColor];
   
    if(isPAD) {
        CGRect currentFrame = self.view.frame;
        self.graphView = [[CPTGraphHostingView alloc] initWithFrame:currentFrame];
    } else {
        self.graphView = [[CPTGraphHostingView alloc] initWithFrame:CGRectZero];
    }
    self.graphView.hostedGraph = graph;

    CPTXYPlotSpace* plotSpace = (CPTXYPlotSpace*) graph.defaultPlotSpace;

    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInt(0)] length:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInt(scoresShown + 1)]];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInt(0)] length:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInt(20)]];

    CPTBarPlot* plot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor colorWithCGColor:[[UIColor colorWithRGBHex:0xade354] CGColor]] horizontalBars:NO];
    plot.barWidth = [NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromFloat(0.3f)];
    plot.dataSource = self;

    CPTXYAxisSet* axisSet = (CPTXYAxisSet*) graph.axisSet;
    CPTXYAxis* x = axisSet.xAxis;
    x.minorTicksPerInterval = 0;
    x.majorTickLineStyle = nil;
    x.axisLineStyle = nil;
    x.labelFormatter = ([[CategoryFormatter class] new]);
    x.labelTextStyle = textStyle;
    x.visibleRange = [[CPTPlotRange alloc] initWithLocation:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInt(1)] length:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInt(scoresShown - 1)]];

    CPTXYAxis* y = axisSet.yAxis;
    y.labelTextStyle = textStyle;
    y.minorTicksPerInterval = 0;
    CPTMutableLineStyle* lineStyle2 = [CPTMutableLineStyle lineStyle];
    lineStyle2.lineColor = [CPTColor lightGrayColor];
    y.majorGridLineStyle = lineStyle2;
    
    y.majorIntervalLength = [NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInt(2)] ;//CPTDecimalFromInt(2);
    y.axisLineStyle = nil;
    y.labelFormatter = formatter;
    y.visibleRange = [[CPTPlotRange alloc] initWithLocation:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInt(0)] length:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInt(18)]];

    [graph addPlot:plot];

    [self.view addSubview:self.graphView];
    return self.graphView;
}

- (void)loadView {
    [super loadView];
    //UIColor *greenColor2 = [UIColor colorWithRGBHex:0x758F4E];
    self.titleLabel = [UILabel labelWithBoldText:NSLocalizedString(@"Current Total Level", nil) fontSize:16 textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor] toView:self.view];
    //self.subtitleLabel = [UILabel labelWithBoldText:[self.repository findUser].name fontSize:16 textColor:greenColor2 backgroundColor:[UIColor clearColor] toView:self.view];

    [self drawGraph];
    if(isPAD) {
        UIImage * targetImage = [UIImage imageNamed:@"bakgrund score@2x.png"];
        // redraw the image to fit |yourView|'s size
        UIGraphicsBeginImageContextWithOptions( self.graphView.frame.size, NO, 0.f);
        [targetImage drawInRect:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
        UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
       //  self.graphView.layer.contents = (id)[UIImage imageNamed:@"bakgrund score@2x"].CGImage;
     self.graphView.backgroundColor = [UIColor colorWithPatternImage:resultImage];
    } else {
     self.graphView.backgroundColor = [UIColor colorWithPatternImage:[UIImage checkedImageNamed:@"bakgrund score"]];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    ViewBuilder* builder = [ViewBuilder verticalBuilderForView:self.view];
    [builder addSpace:4];
    [builder addCenteredView:self.titleLabel];
    [builder addSpace:8];
    [builder addCenteredView:self.subtitleLabel];
    [builder addSpace:0];
    [builder addFlexibleSpaceWithFactor:1];
    ViewBuilderResult* results = [builder build];

    self.graphView.frame = [results frameAtIndex:5];
    [self.graphView.hostedGraph reloadData];
    //self.subtitleLabel.text = [self.repository findUser].name;
    if([self.subtitleLabel.text length] > 0) {
        [self.subtitleLabel sizeToFit];
    }
}

@end
