#import "VideoItem.h"
#import "AbstractRecordingController.h"

@interface CompareVideoController : AbstractRecordingController
@property(nonatomic, strong) id <VideoItem> secondVideoItem;
@property(nonatomic, strong) ToolBoxView* toolboxView;
- (UIView <PlayerViewProtocol>*)createPlayer;
@end