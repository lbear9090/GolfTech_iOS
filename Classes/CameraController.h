#import "BaseTableViewController.h"
#import "AbstractVideosController.h"
#import "AbstractRecordingsController.h"
#import "Device.h"

@class Recording;

@protocol VideoListDelegate <NSObject>
@required
- (void) playVideoPressed: (id <VideoItem>)videoItem;
- (void) shareVideoPressed: (id <VideoItem>)videoItem;
@end

@interface CameraController : AbstractRecordingsController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(nonatomic, strong) Device* device;
- (void)addHeader;
- (void)removeHeader;
- (void)refreshTable;
+ (id)cameraControllerWithVideosEditable:(BOOL)editable;
- (void)recordPressed:(id)sender;
- (void)importPressed:(id)sender;
@property (retain) id delegate;
@property (nonatomic) BOOL isPro;
@end
