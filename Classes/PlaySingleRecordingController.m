#import "PlaySingleRecordingController.h"
#import "ViewBuilder.h"
#import "UIViewAdditions.h"
#import "UIImageAdditions.h"
#import "VideoPosition.h"

#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
@implementation PlaySingleRecordingController {
    VideoPosition* _videoPosition;
    UIImage* _shadowImage;
    UIImage* _backgroundImage;
    ToolBoxView *_toolboxView;
    PlayerView *_playerView;
    Boolean isIPAD;
}

- (UIView <PlayerViewProtocol>*)createPlayer {
    AssertNotNull(self.audioVideoFactory);
    AssertNotNull(self.scrollWheel);
    PlayerView* player = [[self.dependencyInjector instanceOfClass:PlayerView.class] initWithAsset:self.videoItem.videoAsset];
    _playerView = player;

    self.scrollWheel.maxPosition = (float) self.videoItem.duration;
    player.delegate = self;
    
    [self.view addSubview:player];

    _videoPosition = [[VideoPosition alloc] initWithDuration:self.videoItem.duration];
    return player;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isIPAD = IPAD;
    if(!isIPAD) {
     self.view.backgroundColor = ([UIColor colorWithPatternImage:[UIImage checkedImageNamed:@"bakgrund"]]);
    } else {
        self.view.backgroundColor = ([UIColor blackColor]);
    }
    [self saveNavbar:self.navigationController];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
       self.scrollWheel.maxPosition = (float) self.videoItem.duration;
      // self.scrollWheel. = (float) self.videoItem.duration;
    if(!self.device.isLongphone || isIPAD) {
        [self hideNavbar:self.navigationController];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];


    if(!self.device.isLongphone || isIPAD) {
        [self restoreNavbar:self.navigationController];
    }

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    AssertNotNull(self.device);

    BOOL isLong = self.device.isLongphone;

    ViewBuilder* rootBuilder = [ViewBuilder verticalBuilderForView:self.view];
    [rootBuilder addSpace:0];
    if(isIPAD) {
        [rootBuilder addSpace:roundf(600)];// / (isLong ? LongPlayerVideoAspectRatio : ShortPlayerVideoAspectRatio))];
    } else {
        [rootBuilder addSpace:roundf(320 / (isLong ? LongPlayerVideoAspectRatio : ShortPlayerVideoAspectRatio))];
    }
    [rootBuilder addSpace:0];
    [rootBuilder addFlexibleSpaceWithFactor:1];
    [rootBuilder addSpace:0];
    ViewBuilderResult* rootResult = [rootBuilder build];
    self.player.frame = [rootResult frameAtIndex:1];
    CGRect controlFrame = [rootResult frameAtIndex:3];
        if(isIPAD) {
            controlFrame.origin.y -=30;
        }

    ViewBuilder *controlBuilder = [ViewBuilder horizontalBuilderForFrame:controlFrame];
    [controlBuilder addSpace:6];
    [controlBuilder addFlexibleSpaceWithFactor:1];
    [controlBuilder addSpace:4];
    [controlBuilder addSpace:self.scrollWheel.frame.size.width];
    [controlBuilder addSpace:2];
    [controlBuilder addFlexibleSpaceWithFactor:1];
    [controlBuilder addSpace:8];
    ViewBuilderResult *controlResult = [controlBuilder build];
    self.playButton.center = PointAtCenter([controlResult frameAtIndex:1]);
    self.scrollWheel.center = PointAtCenter([controlResult frameAtIndex:3]);
    self.slowLabel.center = PointAtCenter([controlResult frameAtIndex:5]);

    [self initToolBoxView];
}

- (void)syncUI {
    [super syncUI];
    if(self.isScrubbing) {
        [_videoPosition moveTo:self.scrollWheel.currentPosition];
        [self.player seekPosition:_videoPosition.position];
    } else {
        //MLog(@"Video position is %f", self.player.position);
        [_videoPosition moveTo:self.player.position];
        self.scrollWheel.currentPosition = _videoPosition.position;

        if(self.player.isAtEnd) {
            [self.player seekPosition:0];
            self.player.playing = NO;
        }
    }
}

- (void)playPressed:(id)sender {
    if(self.player.isAtEnd)
        [self.player seekPosition:0];
    
    [super playPressed:sender];

    //[self.playerView VideoItem = ];
}

-(void)changeVideo: (AVAsset*) item {
    [self viewWillDisappear:false];
    _videoPosition = nil;
    _videoPosition = [[VideoPosition alloc] initWithDuration:self.videoItem.duration];

    
    [_playerView changeVideo:item];
    [self viewWillAppear:false];
}

#pragma mark ToolBoxProtocol
- (void)currentTool:(ToolBoxItem*)tool {

    _playerView.isPaintMode = tool.state != NONE;
    _playerView.tool = tool;
}

- (void)undoLatest {
    [_playerView.overlayView undoLatest];
}


- (void)eraseAll {
    [_playerView.overlayView eraseAll];
}

-(void) initToolBoxView {
    if(_toolboxView != nil)
        return;
    CGRect frame = _playerView.frame;
    CGFloat offset = self.device.isLongphone ? 0 : 70;
    CGRect toolFrame = CGRectMake(frame.origin.x, frame.origin.y + offset, 40.0, frame.size.height - offset);
    _toolboxView = [[ToolBoxView alloc] initWithFrame:toolFrame];
    _toolboxView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    //tool.opaque = NO;
    [_toolboxView setUserInteractionEnabled:YES];
    [_toolboxView setDelegate:self];
    [_playerView setToolboxView:_toolboxView];

    [UIView animateWithDuration:1 delay:1.5 options:UIViewAnimationOptionCurveEaseOut animations:^ {[self.view addSubview:_toolboxView];}
                     completion:nil];
}

- (void)drawPressed:(id)sender {
    [_toolboxView setHidden:!_toolboxView.hidden];
}

- (void)saveNavbar:(UINavigationController*)nav {
    _shadowImage = nav.navigationBar.shadowImage;
    _backgroundImage = [nav.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
}

- (void)restoreNavbar:(UINavigationController*)nav {
    nav.navigationBar.shadowImage = _shadowImage;
    [nav.navigationBar setBackgroundImage:_backgroundImage forBarMetrics:UIBarMetricsDefault];
    nav.navigationBar.translucent = NO;
}

- (void)hideNavbar:(UINavigationController*)nav {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
}

@end
