#import <MobileCoreServices/UTCoreTypes.h>
#import "RecordVideoController.h"
#import "ViewBuilder.h"
#import "UIViewAdditions.h"
#import "UIImageAdditions.h"
#import "VideoMask.h"
#import <AVFoundation/AVFoundation.h>
#import "AbstractRecordingController.h"

static const CGFloat TimerDelay = 10;
static const CGFloat TimerDuration = 8;
static NSString* UTTypeMovie = nil;

NSUInteger DeviceSystemMajorVersion() {
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}

@implementation RecordVideoController {
    UIButton* _timerButton;
    VideoMask* _videoMask;
    NSTimer* _tickTimer;
    AVAudioPlayer* _tickPlayer;
}

- (void)dealloc {
    [self.class cancelPreviousPerformRequestsWithTarget:self];
    [_tickTimer invalidate];
}


+ (void)initialize {
    UTTypeMovie = (NSString*) kUTTypeMovie;
}

- (void)loadView {
    [super loadView];
    //self.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self setSourceType:UIImagePickerControllerSourceTypeCamera];
    self.mediaTypes = @[UTTypeMovie];
    self.allowsEditing = YES;
    [self setCameraFlashMode:UIImagePickerControllerCameraFlashModeOff];
    //self.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    [self setShowsCameraControls:false];
    _timerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_timerButton setImage:[UIImage checkedImageNamed:@"knapp timer"] forState:UIControlStateNormal];
    [_timerButton addTarget:self action:@selector(timerPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_timerButton sizeToFit];
  //  [self.view addSubview:_timerButton];

    CGFloat width = 320.0;
    CGFloat height = roundf(width / VideoAspectRatio);
    _videoMask = [VideoMask new];
    _videoMask.frame = CGRectMake(0,0,width,height);
    //[self.view addSubview:_videoMask];
    //[self setCameraOverlayView:_videoMask];
    //self.cameraOverlayView = _videoMask;

    
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    _timerButton.enabled = NO;
    _timerButton.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.class cancelPreviousPerformRequestsWithTarget:self];
    [_tickTimer invalidate];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    _videoMask.center = self.view.center;

    CGRect controlFrame, remainder;
    
    BOOL isIos7 = DeviceSystemMajorVersion() > 6;
    CGFloat controlBarHeight = isIos7 ? 72 : 100;
    CGRectDivide(self.view.bounds, &controlFrame, &remainder, controlBarHeight, CGRectMaxYEdge);

    CGFloat space = 10;
    ViewBuilder* controlBuilder = [ViewBuilder horizontalBuilderForFrame:controlFrame];
    [controlBuilder addSpace:space];
    [controlBuilder addFlexibleSpaceWithFactor:1];
    [controlBuilder addSpace:space];
    [controlBuilder addFlexibleSpaceWithFactor:1];
    [controlBuilder addSpace:space];
    [controlBuilder addFlexibleSpaceWithFactor:1];
    [controlBuilder addSpace:space];
    ViewBuilderResult* controlResult = [controlBuilder build];
    _timerButton.center = PointAtCenter([controlResult frameAtIndex:5]);

    ([self flashButton]).alpha = 0;

    ([self cameraToggleButton]).alpha = 0;

    [self.shutterButton addTarget:self action:@selector(recordPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.retakeButton addTarget:self action:@selector(retakePressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (UIButton*)cameraToggleButton {
    NSArray* ios7Buttons = [self.view findSubViewsOfClass:[self camString:@"FlipButton"]];
    NSArray* buttons = [self.view findSubViewsOfClass:[self plString:@"CameraToggleButton"]];
    if(buttons.count > 0)
        return buttons[0];
    if(ios7Buttons.count > 0)
        return ios7Buttons[0];
    NSLog(@"Missing 2 %@",NSStringFromSelector(_cmd));
    [self.view logSubviews];
    return nil;
}

- (UIButton*)retakeButton {
    NSArray* buttons = [self.view findSubViewsOfClass:[self plString:@"CropOverlayBottomBarButton"]];
    if(buttons.count > 0)
        return buttons[0];

    NSArray* ios7bars = [self.view findSubViewsOfClass:[self plString:@"CropOverlayPreviewBottomBar"]];
    if(ios7bars.count > 0) {
        NSArray* ios7buttons = [ios7bars[0] findSubViewsOfClass:NSStringFromClass(UIButton.class)];
        
        if(ios7buttons.count > 0)
            return ios7buttons[0];
    }
    NSLog(@"Missing %@",NSStringFromSelector(_cmd));
    [self.view logSubviews];
    return nil;
}

- (UIButton*)flashButton {
    NSArray* ios7buttons = [self.view findSubViewsOfClass:[self camString:@"FlashButton"]];
    NSArray* buttons = [self.view findSubViewsOfClass:[self plString:@"CameraFlashButton"]];
    if(buttons.count > 0)
        return buttons[0];
    if(ios7buttons.count > 0)
        return ios7buttons[0];
    NSLog(@"Missing %@",NSStringFromSelector(_cmd));
    [self.view logSubviews];
    return nil;
}

- (void)recordPressed:(id)sender {
    _timerButton.hidden = YES;
    [self.class cancelPreviousPerformRequestsWithTarget:self];
    [_tickTimer invalidate];
}

- (void)retakePressed:(id)sender {
    _timerButton.hidden = NO;
    _timerButton.enabled = YES;
}

- (void)tick {
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];

    NSString* path = [[NSBundle mainBundle] pathForResource:@"ljud tick" ofType:@"mp3"];
    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:path], @"File not found %@", path);
    NSURL* url = [NSURL fileURLWithPath:path];

    NSError* activationError = nil;
    [[AVAudioSession sharedInstance] setActive:YES error:&activationError];
    NSAssert(activationError == nil, @"Failed activating audio");
    _tickPlayer = ([[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil]);
    AssertNotNull(_tickPlayer);
    [_tickPlayer setVolume:0.5];
    [_tickPlayer prepareToPlay];
    [_tickPlayer play];
}

- (void)timerPressed:(id)sender {
    _timerButton.enabled = NO;
    [self performSelector:@selector(timerStartRecording:) withObject:nil afterDelay:TimerDelay];
    _tickTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_tickTimer forMode:NSDefaultRunLoopMode];
}

- (void)timerStartRecording:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self startVideoCapture];
        //[self.shutterButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    });
    
   // [self startVideoCapture];
    [self performSelector:@selector(timerStopRecording:) withObject:nil afterDelay:TimerDuration];
    [_tickTimer invalidate];
}

- (void)timerStopRecording:(id)sender {
    _timerButton.enabled = YES;
    _timerButton.hidden = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self.shutterButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                [self stopVideoCapture];
    });
   // [self.shutterButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (UIButton*)shutterButton {
    NSArray* largeButtons = [self.view findSubViewsOfClass:[self plString:@"CameraLargeShutterButton"]];
    NSArray* smallButtons = [self.view findSubViewsOfClass:[self plString:@"CameraButton"]];
    NSArray* ios7Buttons = [self.view findSubViewsOfClass:[self camString:@"ShutterButton"]];
    if(largeButtons.count > 0)
        return largeButtons[0];
    if(smallButtons.count > 0)
        return smallButtons[0];
    if(ios7Buttons.count > 0)
        return ios7Buttons[0];
    NSLog(@"Missing %@",NSStringFromSelector(_cmd));
    [self.view logSubviews];
    return nil;
}

- (NSString*)plString:(NSString*)string {
    return [NSString stringWithFormat:@"PL%@", string];
}

- (NSString*)camString:(NSString*)string {
    return [NSString stringWithFormat:@"CAM%@", string];
}

@end
