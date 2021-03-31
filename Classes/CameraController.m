#import <MobileCoreServices/MobileCoreServices.h>
#import "RecordingCell.h"
#import "AbstractRecordingController.h"
#import "PlaySingleRecordingController.h"
#import "RecordVideoController.h"
#import "UIImageAdditions.h"
#import "CameraController.h"
#import "UIColorAdditions.h"
#import "Reachability.h"
#import "AppDelegate.h"
static NSString* UTTypeMovie = nil;
#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
@interface CameraController ()
@property(nonatomic) BOOL editable;
@property(nonatomic, strong) UISegmentedControl *videoTypeSelector;

@end

@implementation CameraController {
    Boolean isIPAD;
}
@synthesize delegate,isPro,videoTypeSelector;
+ (void)initialize {
    UTTypeMovie = (NSString*) kUTTypeMovie;
}

#pragma mark overrides

+ (id)cameraControllerWithVideosEditable:(BOOL)editable {
    CameraController *result = [CameraController new];
    result.editable = editable;
    return result;
}

- (void)addHeader {
    self.videoTypeSelector = [[UISegmentedControl alloc] initWithItems:@[@"Pro video", @"Mina video"]];
    self.videoTypeSelector.tintColor = [UIColor colorWithRGBHex:BrandedHexColor];
    self.videoTypeSelector.selectedSegmentIndex = isPro ?0:1;
    [self.videoTypeSelector addTarget:self action:@selector(videoTypePressed:) forControlEvents:UIControlEventValueChanged];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.videoTypeSelector.frame.size.height + 30)];
    self.videoTypeSelector.center = self.tableView.tableHeaderView.center;
    [self.tableView.tableHeaderView addSubview:self.videoTypeSelector];
}
- (void)videoTypePressed:(id)sender
 {
     if(self.videoTypeSelector.selectedSegmentIndex == 0) {
         isPro = true;
     } else {
         isPro = false;
     }
     [self reloadDomainObjects];
}
- (void)removeHeader{
    [self.videoTypeSelector removeFromSuperview];
    self.tableView.tableHeaderView = nil;
     // isPro = true;
    [self reloadDomainObjects];
}

- (void)loadView {
    [super loadView];
        isIPAD = IPAD;
    if(!isIPAD) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tillbaka" style:UIBarButtonItemStyleDone target:nil action:nil];
        [self updateNavbarButtons];
    }

    [self reloadDomainObjects];
    [self.tableView reloadData];
}

- (void) refreshTable {

    [self reloadDomainObjects];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
  //  AssertNotNull(self.device);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    if(isIPAD)return FALSE;
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info {
    int64_t startMilliseconds = (int64_t) ([[info objectForKey:@"_UIImagePickerControllerVideoEditingStart"] doubleValue] * 1000);
    int64_t endMilliseconds = (int64_t) ([[info objectForKey:@"_UIImagePickerControllerVideoEditingEnd"] doubleValue] * 1000);

    NSString* outputPath = [self tempOutputPath];

    AVURLAsset* asset = [AVURLAsset URLAssetWithURL:[info objectForKey:UIImagePickerControllerMediaURL] options:nil];
    AVAssetExportSession* session = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetHighestQuality];
    session.outputURL = [NSURL fileURLWithPath:outputPath];
    session.outputFileType = AVFileTypeQuickTimeMovie;
    session.timeRange = CMTimeRangeMake(CMTimeMake(startMilliseconds, 1000), CMTimeMake(endMilliseconds - startMilliseconds, 1000));

    [session exportAsynchronouslyWithCompletionHandler:^{
        switch(session.status) {
            case AVAssetExportSessionStatusCompleted: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.repository saveRecording:outputPath];
                    [self reloadDomainObjects];
                    [self.tableView reloadData];
                });
                break;
            }
            case AVAssetExportSessionStatusFailed:
            case AVAssetExportSessionStatusCancelled:
            default:
                break;
        }
    }];

    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (NSString*)tempOutputPath {
    NSString* documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSFileManager* manager = [NSFileManager defaultManager];

    NSString* outputPath = [documentsDirectory stringByAppendingPathComponent:@"output"];
    [manager createDirectoryAtPath:outputPath withIntermediateDirectories:YES attributes:nil error:nil];

    outputPath = [outputPath stringByAppendingPathComponent:@"output.mp4"];
    // Remove Existing File
    [manager removeItemAtPath:outputPath error:nil];
    return outputPath;
}

#pragma mark UITableViewController overrides

- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath {
    if(isIPAD) {
            return !self.isPro;
    } else {
    return self.editable;
    }

}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
    if(editingStyle != UITableViewCellEditingStyleDelete)
        return;
    if(IPAD) {
        [self.repository deleteRecording:[self domainObjectForPath:indexPath]];
        [self reloadDomainObjects];
        [self.tableView reloadData];
    } else {
        [tableView beginUpdates];
        [self.repository deleteRecording:[self domainObjectForPath:indexPath]];
        [self reloadDomainObjects];
  
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [tableView endUpdates];
        
    }

}

#pragma mark BaseTableViewController

- (NSArray*)cellClasses {
    return @[RecordingCell.class];
}

#pragma mark actions

- (void)recordPressed:(id)sender {
    if(![self hasCamera]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Kamera saknas", nil) message:NSLocalizedString(@"Ingen kamera hittades", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.shouldRotate = true;
    UIImagePickerController* recordModal = [UIImagePickerController new];//[RecordVideoController new];
    [recordModal setSourceType:UIImagePickerControllerSourceTypeCamera];
    recordModal.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    recordModal.allowsEditing = YES;
    
    [recordModal setCameraFlashMode:UIImagePickerControllerCameraFlashModeOff];
    [recordModal setShowsCameraControls:true];
    // VideoMask* _videoMask = ;
    CGFloat width = 320.0;
    CGFloat height = roundf(width / VideoAspectRatio);
   // VideoMask* _videoMask = [VideoMask new];
    //_videoMask.frame = CGRectMake(recordModal.view.center.x - (width/2) ,recordModal.view.center.y - (height/2),width,height);
    //[self.view addSubview:_videoMask];
    //[recordModal setCameraOverlayView:_videoMask];
    
    recordModal.delegate = self;
    
    [self presentViewController:recordModal animated:YES completion:^{
        app.shouldRotate = false;
    }];
}

- (void)importPressed:(id)sender {
    //importPressed
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.shouldRotate = true;
    UIImagePickerController* recordModal = [UIImagePickerController new];
    recordModal.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    recordModal.mediaTypes = @[UTTypeMovie];
    recordModal.allowsEditing = YES;
    recordModal.delegate = self;
    [self presentViewController:recordModal animated:YES completion:^{
        app.shouldRotate = false;
    }];
}

- (void)sharePressed:(id <VideoItem>)swing {
    

    
  //  UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:dataToShare applicationActivities:nil];
//    activityViewController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeMessage];
    
  //  [self.parentViewController.navigationController presentViewController:activityViewController animated:YES completion:nil];
    if(isIPAD) {
        [[self delegate] shareVideoPressed:swing];
    }
    
}
- (void)playPressed:(id <VideoItem>)swing {
    
    if(isIPAD) {
      [[self delegate] playVideoPressed:swing];
    } else {
      //  [[self delegate] playVideoPressed:swing];
        
        AbstractRecordingController* swingPlayer = [self.dependencyInjector createInstanceOfClass:PlaySingleRecordingController.class];
        swingPlayer.videoItem = swing;
        swingPlayer.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:swingPlayer animated:YES];
    }
}

#pragma mark private

- (BOOL)hasCamera {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (void)reloadDomainObjects {
    if(!isIPAD) {
        BOOL pro = !self.editable;
        
        self.domainObjectArrays = @[pro ? self.repository.findProVideos : self.repository.findRecordings];
    } else {
        if(self.repository.dependencyInjector != nil) {
            self.domainObjectArrays = @[isPro ? self.repository.findProVideos : self.repository.findRecordings];
        } else {
            DependencyInjector *injector = [[DependencyInjector class] new];
            [injector registerSingleton:NSFileManager.defaultManager withName:@"fileManager"];
            [injector registerSingleton:[Reachability reachabilityForLocalWiFi] withName:@"reachability"];
            [injector singletonOfClass:AudioVideoFactory.class];
            self.repository.dependencyInjector =injector;
             self.domainObjectArrays = @[isPro ? self.repository.findProVideos : self.repository.findRecordings];
        }

 
    }
      [self.tableView reloadData];
}



- (void)updateNavbarButtons {
    if(!isIPAD) {
    if(self.editable) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(importPressed:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(recordPressed:)];
    } else {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIImageView checkedImageViewNamed:@"logo"]];
        self.navigationItem.rightBarButtonItem = nil;
    }
    }
}

@end
