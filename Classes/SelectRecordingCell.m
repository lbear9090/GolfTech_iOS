#import "SelectRecordingCell.h"
#import "BaseTableViewController.h"

@implementation SelectRecordingCell {
}

+ (BOOL)selectable {return NO;}

- (void)createPlayButton {
    self.imagePlayButton = [UIImageView new];
    [self.contentView addSubview:self.imagePlayButton];
}

- (void)createSelectButton {
}

- (void)setPreviewImage:(UIImage*)image {
    ((UIImageView*) self.imagePlayButton).image = image;
}

- (void)playPressed:(id)sender {
    [self.tableViewController didSelectDomainObject:self.domainObject];
}

@end