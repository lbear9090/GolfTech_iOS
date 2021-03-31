#import "AbstractVideosController.h"
#import "VideoItem.h"
#import "AbstractRecordingsController.h"

@interface SelectCompareController : AbstractRecordingsController
@property(nonatomic, strong) id <VideoItem> alreadySelectedItem;
@end