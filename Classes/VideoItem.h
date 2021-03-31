#import <AVFoundation/AVFoundation.h>

@protocol VideoItem <NSObject>
@property(nonatomic, copy) NSString* title;
@property(nonatomic, copy) NSString* summary;
@property(nonatomic, readonly) NSString* videoPath;
@property(nonatomic, readonly) UIImage* image;


@optional
@property(nonatomic, readonly) NSURL* videoUrl;
@property(nonatomic, readonly) AVAsset* videoAsset;
@property(nonatomic, readonly) NSTimeInterval duration;
@end