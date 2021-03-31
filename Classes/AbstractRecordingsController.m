#import "AbstractRecordingsController.h"
#import "UIColorAdditions.h"

@implementation AbstractRecordingsController {
}

- (void)loadView {
    [super loadView];
    self.tableView.backgroundColor = [UIColor colorWithRGBHex:0xF1F0F0];
    self.tableView.separatorColor = UIColor.clearColor;

}

- (void)playPressed:(id <VideoItem>)recording {
}

@end