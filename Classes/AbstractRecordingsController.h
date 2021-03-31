#import "BaseTableViewController.h"
#import "AbstractVideosController.h"

@interface AbstractRecordingsController : AbstractVideosController
- (void)playPressed:(id <VideoItem>)recording;
@end