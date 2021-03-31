#import <AVFoundation/AVFoundation.h>
#import "Recording.h"

@interface Recording ()
@property(nonatomic, strong) NSString* name;
@end

@implementation Recording {
    AVAsset* _asset;
    UIImage* _image;
}
@dynamic name, createdAt, path;
@synthesize fileManager = _filerManager, repository = _repository, audioVideoFactory = _audioVideoFactory,isOwnRecording;

- (id)initWithEntity:(NSEntityDescription*)entity insertIntoManagedObjectContext:(NSManagedObjectContext*)context {
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    //AssertNotNull(self.repository);
    return self;
}

- (void)awakeFromFetch {
    //AssertNotNull(self.repository);
    [super awakeFromFetch];
}

- (void)awakeFromInsert {
    //AssertNotNull(self.repository);
    [super awakeFromInsert];
}

- (NSString*)imageName {
    return @"bn1t1";
}

- (UIImage*)image {
    if(_image != nil)
        return _image;
    AssertNotNull(self.audioVideoFactory);
    _image = [self.audioVideoFactory representativeImageFor:self.videoAsset];
    return _image;
}


- (NSString*)summary {
    return self.name;
}

- (void)setSummary:(NSString*)summary {
    self.name = summary;
    [self.repository asyncSave];
}

- (NSString*)title {
    return [NSDateFormatter localizedStringFromDate:self.createdAt dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
}

- (void)setTitle:(NSString*)title {
    NSAssert(false, @"Not editable");
}


- (NSString*)videoPath {
    AssertNotNull(self.repository);
    NSString __block* result = nil;
    __weak Recording* blockSelf = self;
    if([NSThread isMainThread]) {
        result = [self.repository getFullVideoPath:self];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            result = [blockSelf.repository getFullVideoPath:blockSelf];
        });
    }
    return result;
}

- (AVAsset*)videoAsset {
    AssertNotNull(self.audioVideoFactory);
    if(_asset == nil)
        _asset = [self.audioVideoFactory createVideoAsset:self.videoPath];
    return _asset;
}

- (NSTimeInterval)duration {
    return CMTimeGetSeconds(self.videoAsset.duration);
}

@end