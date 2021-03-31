//
//  VideoController.m
//  Golf
//
//  Created by Thomas on 22/04/15.
//
//

#import "VideoController.h"
#import "ViewBuilder.h"
#import "UIImageAdditions.h"
#import "UIColorAdditions.h"
#import "CameraController.h"
#import "DependencyInjector.h"
#import "Reachability.h"
#import "AudioVideoFactory.h"
#import "Repository.h"
#import "AbstractRecordingController.h"
#import "PlaySingleRecordingController.h"
#import "BaseCell.h"
#import "VideoItem.h"
#import "ProVideo.h"
#import "CompareVideoController.h"
#import "RecordVideoController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "AppDelegate.h"
#import "VideoMask.h"
#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
@implementation VideoController {
    CameraController *proVideo;
    PlaySingleRecordingController* swingPlayer;
    UIActivityIndicatorView* spinner;
    CompareVideoController *ctrl;
    ProVideo* currentVideo ;
    DependencyInjector *injector;
    UIBarButtonItem* addCompareBtn;
    UIBarButtonItem* recVideoBtn;
    UIBarButtonItem* addVideoBtn;
    Boolean isIPAD;
}
@synthesize compareMode,myVideo;
- (void) shareVideoPressed: (id <VideoItem>)videoItem {
        NSArray *dataToShare = @[[NSString stringWithFormat:NSLocalizedString(@"Dela email", nil), videoItem.title, videoItem.summary], [NSURL fileURLWithPath:videoItem.videoPath]];
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:dataToShare applicationActivities:nil];
    
        activityViewController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeMessage];
    activityViewController.popoverPresentationController.sourceView = self.view;
 [self presentViewController:activityViewController animated:YES completion:nil];
}
- (void) playVideoPressed: (id <VideoItem>)videoItem {
    if(IPAD) {
        if(compareMode) {
            
            
            ctrl = [injector createInstanceOfClass:CompareVideoController.class];
            ctrl.videoItem = currentVideo;
            // [swingPlayer.view removeFromSuperview];
            // swingPlayer = nil;
            ctrl.secondVideoItem = videoItem;
            //  [swingPlayer.view removeFromSuperview];
            // swingPlayer = nil;
            [self presentViewController:ctrl animated:YES completion:nil];
            
        } else {
            //  [swingPlayer.view removeFromSuperview];
            swingPlayer.videoItem =videoItem;
            
            [swingPlayer changeVideo:videoItem.videoAsset ];
            
            currentVideo =videoItem;
            
            //[self reinsertVideo:videoItem];
        }
    } else {
        //AbstractRecordingController* swingPlayer = [self.dependencyInjector createInstanceOfClass:PlaySingleRecordingController.class];
        swingPlayer.videoItem = videoItem;
        swingPlayer.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:swingPlayer animated:YES];
    }
    //swingPlayer.videoItem = videoItem;
    //swingPlayer.hidesBottomBarWhenPushed = YES;
    //[self.view addSubview:swingPlayer];
    
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    
}

- (void) viewDidLoad {
    compareMode = false;
    [super viewDidLoad];
    
}

- (id)init {
    self = [super initWithNibName:nil bundle:nil];
    injector = [[DependencyInjector class] new];
    [injector registerSingleton:NSFileManager.defaultManager withName:@"fileManager"];
    [injector registerSingleton:[Reachability reachabilityForLocalWiFi] withName:@"reachability"];
    [injector singletonOfClass:AudioVideoFactory.class];
    [injector singletonOfClass:[Device class]];
    isIPAD = IPAD;
    self.repository = [injector singletonOfClass:[Repository class]];
    if(myVideo) {
            proVideo = [injector autowire:[CameraController cameraControllerWithVideosEditable:YES]];
    } else {
        proVideo = [injector autowire:[CameraController cameraControllerWithVideosEditable:NO]];
    }

    swingPlayer = [injector createInstanceOfClass:PlaySingleRecordingController.class];
  //  self.myVideo = false;
    return self;
}
- (void) reinsertVideo:(id <VideoItem>)videoItem {
    
    
    swingPlayer.videoItem = videoItem;
    CGRect currentFrame = self.view.frame;
    currentFrame.origin.y = 0;
    
    currentFrame.size.width =  currentFrame.size.width - ( currentFrame.size.width / 3 );
    //currentFrame.size.height =  currentFrame.size.height - ( currentFrame.size.height / 2.5 );
    swingPlayer.view.frame = currentFrame;
    [self.view addSubview:swingPlayer.view];
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [swingPlayer viewWillAppear:animated];
    ctrl = nil;
    if(isIPAD){
        //  CGRect rect = [result frameAtIndex:0];
        // rect.origin.x = rect.size.width - ( rect.size.width / 3 );
        //rect.size.width = rect.size.width / 3;
        
        // proVideo.view.frame = [result frameAtIndex:1];
        //CGRect  rectList =[result frameAtIndex:1];
        //rectList.origin.x = rectList.size.width - ( rectList.size.width / 3.5 );
        //rectList.size.width = rectList.size.width / 3 - 40;
        CGRect currentFrame = self.view.frame;
        currentFrame.origin.y = 0;
        
        currentFrame.size.width =  currentFrame.size.width - ( currentFrame.size.width / 3.5 );
        //currentFrame.size.height =  currentFrame.size.height - ( currentFrame.size.height / 2.5 );
        swingPlayer.videoItem = currentVideo;
        swingPlayer.view.frame = currentFrame;
        CGRect rightTabRect = self.view.frame;
        rightTabRect.origin.x =currentFrame.size.width;
        rightTabRect.origin.y=0;
        rightTabRect.size.height -= 50;
        rightTabRect.size.width = self.view.frame.size.width - currentFrame.size.width;
        proVideo.view.frame = rightTabRect;
        
        
    }
    if(myVideo)
    {
        if(compareMode) {
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addCompareBtn, nil];
        } else {
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addVideoBtn, recVideoBtn,addCompareBtn, nil];
        }
        
    } else {
        //self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addCompareBtn, nil];
    }
    
    
}
- (void)loadView {
    [super loadView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIImageView checkedImageViewNamed:@"logo"]];
    self.view.backgroundColor = [UIColor colorWithRGBHex:0xF1F0F0];
    
    
    
    // proVideo = [CameraController alloc];
    
    proVideo.delegate = self;
    if(myVideo) {
        proVideo.isPro = false;
    } else {
        proVideo.isPro = true;
    }
    
    [self.view addSubview:proVideo.view];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    NSArray *paths = [ proVideo.tableView indexPathsForVisibleRows];
    BaseCell* cell = (BaseCell*)[proVideo.tableView cellForRowAtIndexPath:paths[0]];
    currentVideo = cell.domainObject;
    

    if(isIPAD){
        
        CGRect currentFrame = self.view.frame;
        currentFrame.origin.y = 0;
        
        currentFrame.size.width =  currentFrame.size.width - ( currentFrame.size.width / 3.5 );
        //currentFrame.size.height =  currentFrame.size.height - ( currentFrame.size.height / 2.5 );
        swingPlayer.videoItem = currentVideo;
        swingPlayer.view.frame = currentFrame;
        CGRect rightTabRect = self.view.frame;
        rightTabRect.origin.x =currentFrame.size.width;
        rightTabRect.size.width = self.view.frame.size.width - currentFrame.size.width;
        rightTabRect.size.height -= 70;
        proVideo.view.frame = rightTabRect;
    }
    
    [self reinsertVideo: currentVideo];
    // builder = nil;
    // result = nil;
    
    if(isIPAD) {
        addVideoBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(importPressed:)];
        recVideoBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(recordPressed:)];
        
        addCompareBtn =[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Jämför", nil) style:UIBarButtonItemStylePlain target:self action:@selector(comparePressed:)];
        if(myVideo)
        {
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addVideoBtn, recVideoBtn,addCompareBtn, nil];
        } else {
            //self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addCompareBtn, nil];
        }
    }
}

#pragma mark private

- (BOOL)hasCamera {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

#pragma mark actions

- (void)recordPressed:(id)sender {
    if(![self hasCamera]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Kamera saknas", nil) message:NSLocalizedString(@"Ingen kamera hittades", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    //[proVideo recordPressed:sender];
    //return;
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
    VideoMask* _videoMask = [VideoMask new];
    _videoMask.frame = CGRectMake(recordModal.view.center.x - (width/2) ,recordModal.view.center.y - (height/2),width,height);
    //[self.view addSubview:_videoMask];
    [recordModal setCameraOverlayView:_videoMask];
    
    recordModal.delegate = self;
    [self presentViewController:recordModal animated:YES completion:^{
        app.shouldRotate = false;
    }];
    
}

- (void)importPressed:(id)sender {
    //[proVideo importPressed:sender];
    //return;
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.shouldRotate = true;
    UIImagePickerController* recordModal = [UIImagePickerController new];
    //UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    recordModal.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    recordModal.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    recordModal.mediaTypes = @[(NSString*)kUTTypeMovie];
    recordModal.allowsEditing = YES;
    recordModal.delegate = self;
    
    [self presentViewController:recordModal animated:YES completion:^{
          app.shouldRotate = false;
    }];
    
}

- (void)comparePressed:(id)sender {
    compareMode = !compareMode;
    if(myVideo) {
        [proVideo setIsPro:false];
    } else {
        [proVideo setIsPro:true];
    }
    if(compareMode) {
        addCompareBtn.title = @"Klar";
        [self.navigationItem setTitle:@"Jämför Video"];
        self.navigationItem.rightBarButtonItems =        [NSArray arrayWithObjects:addCompareBtn, nil];
        [proVideo addHeader];
    } else {
        addCompareBtn.title = @"Jämför";
        if(myVideo){
           [self.navigationItem setTitle:@"Mina video"];
        } else {
            [self.navigationItem setTitle:@"Pro video"];
        }
        self.navigationItem.rightBarButtonItems=   [NSArray arrayWithObjects:addVideoBtn, recVideoBtn,addCompareBtn, nil];
        [proVideo removeHeader];
    }
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    
    
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if(isIPAD){
        
        CGRect currentFrame = self.view.frame;
        currentFrame.origin.y = 0;
        
        currentFrame.size.width =  currentFrame.size.width - ( currentFrame.size.width / 3.5 );
        //currentFrame.size.height =  currentFrame.size.height - ( currentFrame.size.height / 2.5 );
        swingPlayer.videoItem = currentVideo;
        swingPlayer.view.frame = currentFrame;
        CGRect rightTabRect = self.view.frame;
        rightTabRect.origin.x =currentFrame.size.width;
        rightTabRect.size.width = self.view.frame.size.width - currentFrame.size.width;
        rightTabRect.size.height -= 70;
        proVideo.view.frame = rightTabRect;
    }
}
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
                     [proVideo refreshTable];
                });
                break;
            }
            case AVAssetExportSessionStatusFailed:
            case AVAssetExportSessionStatusCancelled:
            default:
                break;
        }
    }];
    
    [self dismissViewControllerAnimated:YES completion:^{
       [proVideo refreshTable];
    }];
 
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

@end
