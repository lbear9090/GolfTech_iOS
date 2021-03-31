#import "ExerciseCell.h"
#import "ViewBuilder.h"
#import "UILabelAdditions.h"
#import "Exercise.h"
#import "UIImageAdditions.h"
#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
@implementation ExerciseCell {
    UIButton* _enter;
    UILabel* _score;
    CGRect _layoutBounds;
}
@synthesize _score,_enter;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.accessoryType = UITableViewCellAccessoryNone;
    self.summaryText.contentInset = UIEdgeInsetsMake(-2, -8, 0, 0);
    if([self.summaryText respondsToSelector:@selector(setTextContainerInset:)])
        self.summaryText.textContainerInset = UIEdgeInsetsMake(4, 3, 0, 0);
    _score = [UILabel labelWithBoldText:nil fontSize:13 textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] toView:self.contentView];
    _score.text = @"XX";
    [_score sizeToFit];
    [self.contentView addSubview:_score];

    _enter = [UIButton buttonWithType:UIButtonTypeCustom];
    _enter.backgroundColor = [UIColor clearColor];
    [_enter addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    [_enter setImage:[UIImage checkedImageNamed:@"knapp ange poang"] forState:UIControlStateNormal];
    [_enter sizeToFit];
    [self.contentView addSubview:_enter];

    return self;
}

- (void)wasPopulatedWithDomainObject:(id)exercise {
    [super wasPopulatedWithDomainObject:exercise];
    _score.text = ((Exercise*) exercise).latestScoreDescription;
}

- (void)playPressed:(id)sender {
    
    if(IPAD) {
        for (ExerciseCell *cell in [self.tableViewController tableView].visibleCells) {
            [cell.summaryText setBackgroundColor:[UIColor whiteColor]];
            //[cell._score setBackgroundColor:[UIColor clearColor]];
            //[cell._enter setBackgroundColor:[UIColor clearColor]];
        }
    
        [self.summaryText setBackgroundColor:[UIColor lightGrayColor]];
        //[_score setBackgroundColor:[UIColor lightGrayColor]];
        //[_enter setBackgroundColor:[UIColor lightGrayColor]];
    }

    [self.tableViewController playVideo:self.videoItem];
}

- (void)edit:(id)sender {
    [self.tableViewController edit:self.domainObject];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect layoutBounds = self.contentView.bounds;

    if(CGRectEqualToRect(layoutBounds, _layoutBounds))
        return;
    _layoutBounds = layoutBounds;

    ViewBuilder* contentBuilder = [ViewBuilder horizontalBuilderForFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentHeight)];
    [contentBuilder addSpace:self.contentHeight]; // imagePlay
    [contentBuilder addSpace:8];
    [contentBuilder addFlexibleSpaceWithFactor:1]; // rightHalf
    [contentBuilder addSpace:8 - 3];
    ViewBuilderResult* contentResult = [contentBuilder build];
    self.imagePlayButton.frame = [contentResult frameAtIndex:0];
    CGRect rightHalfFrame = [contentResult frameAtIndex:2];
    self.play.frame = self.imagePlayButton.bounds;

    ViewBuilder* rightHalfBuilder = [ViewBuilder verticalBuilderForFrame:rightHalfFrame];
    [rightHalfBuilder addSpace:0];
    [rightHalfBuilder addFlexibleSpaceWithFactor:1]; // summaryText
    [rightHalfBuilder addSpace:0];
    [rightHalfBuilder addSpace:self.selectButton.bounds.size.height];
    [rightHalfBuilder addSpace:0];
    ViewBuilderResult* rightHalfResults = [rightHalfBuilder build];
    self.summaryText.frame = [rightHalfResults frameAtIndex:1];
    CGRect buttonRowRect = [rightHalfResults frameAtIndex:3];

    ViewBuilder* buttonRowBuilder = [ViewBuilder horizontalBuilderForFrame:buttonRowRect];
    [buttonRowBuilder addFlexibleSpaceWithFactor:1];
    [buttonRowBuilder addSpace:0];
    [buttonRowBuilder addFlexibleSpaceWithFactor:1];
    [buttonRowBuilder addSpace:0];
    [buttonRowBuilder addFlexibleSpaceWithFactor:1];
    ViewBuilderResult* buttonRowResults = [buttonRowBuilder build];
    _score.frame = [buttonRowResults frameAtIndex:0];
    _enter.frame = [buttonRowResults frameAtIndex:2];
    CGRect selectFrame = [buttonRowResults frameAtIndex:4];

    ViewBuilder* selectBuilder = [ViewBuilder horizontalBuilderForFrame:selectFrame];
    [selectBuilder addFlexibleSpaceWithFactor:1];
    [selectBuilder addRightView:self.selectButton];
    ViewBuilderResult* selectResults = [selectBuilder build];
    self.selectButton.frame = [selectResults frameAtIndex:1];
}

@end
