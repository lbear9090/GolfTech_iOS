#import "TechniqueCell.h"
#import "ViewBuilderResult.h"
#import "ViewBuilder.h"
#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
@implementation TechniqueCell {
    CGRect _layoutBounds;
    Boolean isIPAD;
}

- (float)contentHeight {
    return 75.0;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectButton.frame = CGRectInset(self.selectButton.frame, 0, -23);
    if([self.summaryText respondsToSelector:@selector(setTextContainerInset:)])
        self.summaryText.textContainerInset = UIEdgeInsetsMake(4, 3, 0, 0);
    isIPAD = IPAD;
    return self;
}
- (void)playPressed:(id)sender {
    if(IPAD) {
        for (TechniqueCell *cell in [self.tableViewController tableView].visibleCells) {
            [cell.summaryText setBackgroundColor:[UIColor whiteColor]];
            //[cell setBackgroundColor:[UIColor whiteColor]];
        }
      //  [self setBackgroundColor:[UIColor lightGrayColor]];
        [self.summaryText setBackgroundColor:[UIColor lightGrayColor]];
        [self setHighlighted:true];
    }
    [self.tableViewController playVideo:self.videoItem];
}
- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect layoutBounds = self.contentView.bounds;

    if(CGRectEqualToRect(layoutBounds, _layoutBounds))
        return;
    _layoutBounds = layoutBounds;

    ViewBuilder* builder = [ViewBuilder horizontalBuilderForFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentHeight)];
    [builder addSpace:133];
    [builder addSpace:8];
    [builder addFlexibleSpaceWithFactor:1];
    [builder addSpace:0];
    [builder addCenteredView:self.selectButton];
    [builder addSpace:8];
    ViewBuilderResult* result = [builder build];
    self.imagePlayButton.frame = [result frameAtIndex:0];
    if(isIPAD) {
    CGRect textRect =[result frameAtIndex:2];
        textRect.size.width *= 1.3;
        self.summaryText.frame = textRect;
    } else {
        self.summaryText.frame = [result frameAtIndex:2];
    }
    
    
    self.selectButton.frame = [result frameAtIndex:4];

    self.play.frame = self.playButtonFrame;
}

- (CGRect)playButtonFrame {
    CGRect f = self.imagePlayButton.bounds;
    return CGRectMake(f.origin.x, f.origin.y, f.size.width / 2.0, f.size.height);
}

@end