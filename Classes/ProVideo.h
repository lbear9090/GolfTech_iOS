#import <Foundation/Foundation.h>
#import "AudioVideoFactory.h"

@interface ProVideo : NSObject <VideoItem>
@property(nonatomic, copy) NSString* title;
@property(nonatomic, strong) NSString* imageName;
@property(nonatomic, copy) NSString* path;
@property(nonatomic, strong) NSFileManager* fileManager;
@property(nonatomic, strong) AudioVideoFactory* audioVideoFactory;
@property(nonatomic, assign) NSInteger position;
- (UIImage*)image;
@end