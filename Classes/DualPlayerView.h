#import <AVFoundation/AVFoundation.h>
#import "PlayerViewProtocol.h"
#import "DependencyInjector.h"
#import "AudioVideoFactory.h"
#import "ToolBoxView.h"
#import "OverlayObject.h"

@interface DualPlayerView : UIView <PlayerViewProtocol,ToolBoxProtocol>
@property(nonatomic, strong) AudioVideoFactory* audioVideoFactory;
@property(nonatomic, readonly) PlayerView* leftPlayer;
@property(nonatomic, readonly) PlayerView* rightPlayer;
@property(nonatomic, readonly) BOOL leftSelected;
@property(nonatomic, readonly) BOOL rightSelected;
@property(nonatomic, strong) NSMutableArray* viewLatestObjects;
- (id)initWithLeftAsset:(AVAsset*)left andRightAsset:(AVAsset*)right;
- (void)seekPositionLeft:(NSTimeInterval)position1 right:(NSTimeInterval)position2;
- (void)setSelectionLeft:(BOOL)left right:(BOOL)right;
- (void)setToolBoxView:(ToolBoxView*) tool;
@end
