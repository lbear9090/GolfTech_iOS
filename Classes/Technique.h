#import "VideoItem.h"

@class Category;

typedef enum {NotDownloaded, Downloading, Downloaded} TechniqueState;

@interface Technique : NSObject <VideoItem>
@property (nonatomic, copy) void (^onDownloadCompleted)(void);
@property (nonatomic, copy) void (^onDownloadFailed)(void);
@property(nonatomic, copy) NSString* code;
@property(nonatomic, strong) Category* category;
@property(nonatomic, copy) NSString* title;
@property(strong, nonatomic, readonly) UIView* imageView;
@property(strong, nonatomic, readonly) NSString* identity;
@property(nonatomic, strong, readonly) Technique* video;
@property(nonatomic, assign) TechniqueState state;
- (NSURL*)videoUrl;
- (id)identity;
- (NSString*)imageName;
- (BOOL)isAvailable;
- (void)startDownload;
@end