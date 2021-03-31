#import <CoreData/CoreData.h>
#import <AVFoundation/AVFoundation.h>
#import "VideoItem.h"
#import "Repository.h"
#import "AudioVideoFactory.h"

@interface Recording : NSManagedObject <VideoItem>
@property(nonatomic, copy) NSString* title;
@property(nonatomic, readonly) NSString* imageName;
@property(nonatomic, readonly) NSString* videoPath;
@property(nonatomic, strong) NSDate* createdAt;
@property(nonatomic, copy) NSString* path;
@property(nonatomic, strong) Repository* repository;
@property(nonatomic, strong) NSFileManager* fileManager;
@property(nonatomic, strong) AudioVideoFactory* audioVideoFactory;
@property(nonatomic) Boolean isOwnRecording;
- (UIImage*)image;
@end