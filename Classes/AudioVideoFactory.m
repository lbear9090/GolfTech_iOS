#import <AVFoundation/AVFoundation.h>
#import "AudioVideoFactory.h"
#import "PlayerView.h"

@implementation AudioVideoFactory {
}
- (AVPlayerItem*)playerItemWithAsset:(AVAsset*)asset {
    return [AVPlayerItem playerItemWithAsset:asset];
}

- (PlayerView*)playerWithAsset:(AVAsset*)asset delegate:(id)delegate {
    AssertNotNull(self.dependencyInjector);
    PlayerView* result = [[self.dependencyInjector instanceOfClass:PlayerView.class] initWithAsset:asset];
    result.delegate = delegate;
    return result;
}

- (AVAsset*)createVideoAsset:(NSString*)path {
    AssertNotNull(self.fileManager);
    NSAssert([self.fileManager fileExistsAtPath:path isDirectory:NO], @"Couldn't find file at %@", path);
    NSURL* url = [NSURL fileURLWithPath:path];
    return [AVURLAsset URLAssetWithURL:url options:@{AVURLAssetPreferPreciseDurationAndTimingKey : @YES}];
}

- (UIImage*)representativeImageFor:(AVAsset*)asset {
    AVAssetImageGenerator* imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    Float64 durationSeconds = CMTimeGetSeconds([asset duration]);
    CMTime midpoint = CMTimeMakeWithSeconds(durationSeconds / 2.0, 600);
    NSError* error = nil;
    CMTime actualTime;
    CGImageRef halfWayImage = [imageGenerator copyCGImageAtTime:midpoint actualTime:&actualTime error:&error];
    Float64 midpointSeconds = CMTimeGetSeconds(midpoint);
    NSAssert(error == nil, @"Error when capturing snapshot at %f from asset %@, error is %@", midpointSeconds, asset, error);

    CGFloat width = CGImageGetWidth(halfWayImage);
    CGFloat height = CGImageGetHeight(halfWayImage);
    CGImageRef croppedImage = CGImageCreateWithImageInRect(halfWayImage, CGRectMake(0, (height - width) / 2.0f, width, width));

    UIImage* result = [UIImage imageWithCGImage:croppedImage];
    CGImageRelease(halfWayImage);
    CGImageRelease(croppedImage);
    return result;
}

@end
