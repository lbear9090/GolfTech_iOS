#import <AVFoundation/AVFoundation.h>
#import "DependencyInjector.h"

@class PlayerView;

@interface AudioVideoFactory : NSObject
@property(nonatomic, weak) DependencyInjector* dependencyInjector;
@property(nonatomic, strong) NSFileManager* fileManager;
- (AVPlayerItem*)playerItemWithAsset:(AVAsset*)asset;
- (PlayerView*)playerWithAsset:(AVAsset*)asset delegate:(id)delegate;
- (AVAsset*)createVideoAsset:(NSString*)path;
- (UIImage*)representativeImageFor:(AVAsset*)asset;
@end