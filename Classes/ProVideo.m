#import <AVFoundation/AVFoundation.h>
#import "VideoItem.h"
#import "ProVideo.h"

@implementation ProVideo {
    AVAsset* _asset;
}
@synthesize imageName, summary;

- (NSString*)videoPath {
    return self.path;
}

- (AVAsset*)videoAsset {
    AssertNotNull(self.audioVideoFactory);
    //if(_asset == nil)
    _asset = [self.audioVideoFactory createVideoAsset:self.videoPath];
    return _asset;
}

- (NSTimeInterval)duration {
    return CMTimeGetSeconds(self.videoAsset.duration);
}

- (UIImage*)image {
    return [UIImage imageNamed:self.imageName];
}

@end