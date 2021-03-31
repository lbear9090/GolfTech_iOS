#import "AbstractRecordingController.h"
#import "UIImageAdditions.h"
#import "SelectCompareController.h"
#import "UILabelAdditions.h"
#import "UIColorAdditions.h"
#import "ProVideo.h"
#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
static const NSTimeInterval ScrubbingInterval = 1.0 / 50.0;

@implementation AbstractRecordingController {
    BOOL _isScrubbing;
    NSTimer *_timer;
}

#pragma mark view lifecycle
@synthesize compareBtn;
- (void)loadView {
    [super loadView];
    AssertNotNull(self.videoItem);

    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playButton setBackgroundImage:[UIImage checkedImageNamed:@"knapp spela"] forState:UIControlStateNormal];
    [self.playButton setBackgroundImage:[UIImage checkedImageNamed:@"knapp pausa"] forState:UIControlStateSelected];
    [self.playButton addTarget:self action:@selector(playPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.playButton sizeToFit];
    [self.view addSubview:self.playButton];

    self.slowButton = ([self createOnOffButtonWithTarget:self andSelector:@selector(slowPressed:)]);
    [self.slowButton setHidden:true];
    [self.view addSubview:self.slowButton];

    self.showLegendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.showLegendButton.tintColor = [UIColor colorWithRGBHex:LightBrandedHexColor];
    [self.showLegendButton setTitle:@"Rita" forState:UIControlStateNormal];
    [self.showLegendButton sizeToFit];
    [self.showLegendButton addTarget:self action:@selector(drawPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.showLegendButton];
    [self.showLegendButton setHidden:true];
    self.slowLabel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.slowLabel.tintColor = [UIColor whiteColor];
    [self.slowLabel setTitle:@"Sakta" forState:UIControlStateNormal];
    [self.slowLabel sizeToFit];
    [self.slowLabel addTarget:self action:@selector(slowPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.slowLabel];

    if(self.scrollWheel == nil){
            self.scrollWheel = [ScrollWheelWithSlider new];
            self.scrollWheel.delegate = self;
        [self.view addSubview:self.scrollWheel];
        }

    compareBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Jämför", nil) style:UIBarButtonItemStylePlain target:self action:@selector(comparePressed:)];
    if(![self.videoItem isMemberOfClass:ProVideo.class]){
            self.navigationItem.rightBarButtonItem = compareBtn;
        }
    self.player = [self createPlayer];
    
}

- (UIButton *)createOnOffButtonWithTarget:(id)target andSelector:(SEL)selector {
    UIButton *result = [UIButton buttonWithType:UIButtonTypeCustom];
    [result setBackgroundImage:[UIImage checkedImageNamed:@"knapp ejvald"] forState:UIControlStateNormal];
    [result setBackgroundImage:[UIImage checkedImageNamed:@"knapp vald"] forState:UIControlStateSelected];
    [result addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [result sizeToFit];
    return result;
}

- (UIView <PlayerViewProtocol> *)createPlayer {
    NSAssert(false, @"Implement in subclass");
    return nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.scrollWheel.currentPosition = 0.0;
    if(IPAD){
            self.scrollWheel.maxPosition = (float) self.videoItem.duration;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:ScrubbingInterval target:self selector:@selector(syncUI) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
   // [self.scrollWheel removeFromSuperview];
  //  self.scrollWheel = nil;
    [_timer invalidate];
    _timer = nil;
    self.isPlaying = NO;
    //[super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.scrollWheel.currentPosition = 0.0;
  //  _timer = [NSTimer scheduledTimerWithTimeInterval:ScrubbingInterval target:self selector:@selector(syncUI) userInfo:nil repeats:YES];

    [self syncUI];
}

#pragma mark PlayerViewDelegate
- (void)playerStatusWasUpdated {
    //[self syncUI];
}

#pragma mark ScrollViewDelegate

- (void)beginScrubbing {
    _isScrubbing = YES;
    self.isPlaying = NO;
    [self syncUI];
}

- (void)endScrubbing {
    _isScrubbing = NO;
}

#pragma mark Actions

- (void)playPressed:(id)sender {
    self.isPlaying = !self.isPlaying;
    [self syncUI];
}

- (void)drawPressed:(id)sender {
}

- (void)comparePressed:(id)sender {
    SelectCompareController *ctrl = [self.dependencyInjector createInstanceOfClass:SelectCompareController.class];
    ctrl.alreadySelectedItem = _videoItem;
    [self.navigationController pushViewController:ctrl animated:YES];

}

- (void)slowPressed:(UIButton *)sender __unused {
    self.slowButton.selected = !self.slowButton.selected;
    float speeds[] = {1.0, 0.5};
    float newSpeed = speeds[self.slowButton.selected ? 1 : 0];
    self.player.playbackSpeed = newSpeed;
    if(self.slowButton.selected) {
        [self.playButton setBackgroundImage:[UIImage checkedImageNamed:@"knapp_spela_sakta@2x"] forState:UIControlStateNormal];
        [self.playButton setBackgroundImage:[UIImage checkedImageNamed:@"knapp_pausa_sakta@2x"] forState:UIControlStateSelected];
          self.slowLabel.tintColor = [UIColor  colorWithRGBHex:LightBrandedHexColor];
    } else {
        [self.playButton setBackgroundImage:[UIImage checkedImageNamed:@"knapp spela"] forState:UIControlStateNormal];
        [self.playButton setBackgroundImage:[UIImage checkedImageNamed:@"knapp pausa"] forState:UIControlStateSelected];
          self.slowLabel.tintColor = [UIColor whiteColor];
    }
    
    
}

#pragma mark private

- (void)syncUI {
    self.playButton.selected = self.isPlaying;
    self.playButton.enabled = self.player.isReadyToPlay;
}

- (BOOL)isPlaying {

    return self.player.playing;
}

- (void)setIsPlaying:(BOOL)playing {
    self.player.playing = playing;
}

@end