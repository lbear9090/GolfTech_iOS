#import "AbstractRecordingController.h"
#import "Device.h"
#import "ToolBoxView.h"

@interface PlaySingleRecordingController : AbstractRecordingController <ToolBoxProtocol>
@property(nonatomic, strong) Device *device;
@property(nonatomic, strong) AudioVideoFactory *audioVideoFactory;
- (UIView <PlayerViewProtocol> *)createPlayer;
-(void)changeVideo: (AVAsset*) item ;
@end