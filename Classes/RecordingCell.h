#import "VideoCell.h"

@interface RecordingCell : BaseCell
@property(nonatomic, strong) UIView* imagePlayButton;
@property(nonatomic, strong) UIButton* selectButton;
@property(nonatomic, readonly) id <VideoItem> videoItem;
@property(nonatomic, strong) UILabel* titleLabel;
@property(nonatomic, strong) UITextView* summaryText;
- (void)playPressed:(id)sender;
- (void)sharePressed:(id)sender;
- (CGFloat)height;
- (void)createSelectButton;
- (void)createPlayButton;
- (void)setPreviewImage:(UIImage*)image;
- (BOOL)isMyRecording;
+ (BOOL)selectable;
@end