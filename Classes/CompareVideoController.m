#import "CompareVideoController.h"
#import "DualPlayerView.h"
#import "ViewBuilder.h"
#import "UIViewAdditions.h"
#import "DualVideoPosition.h"
#import "UILabelAdditions.h"
#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
@implementation CompareVideoController {
    NSMutableArray *_selectVideoButtons;
    UILabel *_leftTimeLabels[10];
    UILabel *_rightTimeLabels[10];
    DualVideoPosition *_position;
    BOOL _playing;
    NSUInteger _oldIndex;
    NSTimeInterval _playStart;
    Boolean isIPAD;
}
@synthesize toolboxView;
#pragma mark UIViewController overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    _oldIndex = NSIntegerMin;
    self.view.backgroundColor = UIColor.blackColor;
    isIPAD = IPAD;
    UIButton *done = [UIButton buttonWithType:UIButtonTypeCustom];
    [done setTitle:@"Klar" forState:UIControlStateNormal];
    [done sizeToFit];
    done.frame = CGRectMake(10, 4, done.frame.size.width + 20, done.frame.size.height);
    [done addTarget:self action:@selector(donePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:done];
    [self.view setUserInteractionEnabled:YES];
    _selectVideoButtons = [NSMutableArray array];
    [self.view addSubview:_selectVideoButtons[0] = [self createOnOffButtonWithTarget:self andSelector:@selector(videoSelected:)]];
    [self.view addSubview:_selectVideoButtons[1] = [self createOnOffButtonWithTarget:self andSelector:@selector(videoSelected:)]];
    [self.view addSubview:_selectVideoButtons[2] = [self createOnOffButtonWithTarget:self andSelector:@selector(videoSelected:)]];
    [self videoSelected:_selectVideoButtons[1]];

#ifdef TEST
    UIColor* background = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    _leftTimeLabels[0] = [UILabel labelWithBoldText:@"mm 99.99" fontSize:12 textColor:UIColor.whiteColor backgroundColor:background toView:self.view];
    _leftTimeLabels[1] = [UILabel labelWithBoldText:@"mm 99.99" fontSize:12 textColor:UIColor.whiteColor backgroundColor:background toView:self.view];
    _leftTimeLabels[2] = [UILabel labelWithBoldText:@"mm 99.99" fontSize:12 textColor:UIColor.whiteColor backgroundColor:background toView:self.view];
    _leftTimeLabels[3] = [UILabel labelWithBoldText:@"mm 99.99" fontSize:12 textColor:UIColor.whiteColor backgroundColor:background toView:self.view];
    _leftTimeLabels[4] = [UILabel labelWithBoldText:@"mm 99.99" fontSize:12 textColor:UIColor.whiteColor backgroundColor:background toView:self.view];
    _leftTimeLabels[5] = [UILabel labelWithBoldText:@"mm 99.99" fontSize:12 textColor:UIColor.whiteColor backgroundColor:background toView:self.view];
    _leftTimeLabels[6] = [UILabel labelWithBoldText:@"mm 99.99" fontSize:12 textColor:UIColor.whiteColor backgroundColor:background toView:self.view];
    _leftTimeLabels[7] = [UILabel labelWithBoldText:@"mm 99.99" fontSize:12 textColor:UIColor.whiteColor backgroundColor:background toView:self.view];
    _leftTimeLabels[8] = [UILabel labelWithBoldText:@"mm 99.99" fontSize:12 textColor:UIColor.whiteColor backgroundColor:background toView:self.view];
    _leftTimeLabels[9] = [UILabel labelWithBoldText:@"mm 99.99" fontSize:12 textColor:UIColor.whiteColor backgroundColor:background toView:self.view];
    _rightTimeLabels[0] = [UILabel labelWithBoldText:@"mm 99.99" fontSize:12 textColor:UIColor.whiteColor backgroundColor:background toView:self.view];
    _rightTimeLabels[1] = [UILabel labelWithBoldText:@"mm 99.99" fontSize:12 textColor:UIColor.whiteColor backgroundColor:background toView:self.view];
    _rightTimeLabels[2] = [UILabel labelWithBoldText:@"mm 99.99" fontSize:12 textColor:UIColor.whiteColor backgroundColor:background toView:self.view];
    _rightTimeLabels[3] = [UILabel labelWithBoldText:@"mm 99.99" fontSize:12 textColor:UIColor.whiteColor backgroundColor:background toView:self.view];
    _rightTimeLabels[4] = [UILabel labelWithBoldText:@"mm 99.99" fontSize:12 textColor:UIColor.whiteColor backgroundColor:background toView:self.view];
    _rightTimeLabels[5] = [UILabel labelWithBoldText:@"mm 99.99" fontSize:12 textColor:UIColor.whiteColor backgroundColor:background toView:self.view];
    _rightTimeLabels[6] = [UILabel labelWithBoldText:@"mm 99.99" fontSize:12 textColor:UIColor.whiteColor backgroundColor:background toView:self.view];
    _rightTimeLabels[7] = [UILabel labelWithBoldText:@"mm 99.99" fontSize:12 textColor:UIColor.whiteColor backgroundColor:background toView:self.view];
    _rightTimeLabels[8] = [UILabel labelWithBoldText:@"mm 99.99" fontSize:12 textColor:UIColor.whiteColor backgroundColor:background toView:self.view];
#endif

    [UILabel labelWithBoldText:@"mm 99.99" fontSize:12 textColor:UIColor.whiteColor backgroundColor:UIColor.redColor toView:nil];
}

- (DualPlayerView *)dualPlayer {
    return (DualPlayerView *) self.player;
}

- (void)videoSelected:(id)sender {
    NSUInteger index = [_selectVideoButtons indexOfObject:sender];

    for(int i = 0; i < 3; i++) {
        UIButton *btn = (UIButton *) _selectVideoButtons[i];
        [btn setSelected:(i == index)];
    }
    [self.dualPlayer setSelectionLeft:index == 0 || index == 1 right:index == 1 || index == 2];
    if(_oldIndex == 0 && index != 0 || _oldIndex == 2 && index != 2) {
        _playStart = _position.position;
    }
    _oldIndex = index;
}

- (NSTimeInterval)returnPosition {
    return MAX(_playStart, _position.start);
}

- (void)syncUI {
    [super syncUI];
    if(self.isScrubbing) {
        if(self.leftSelected && self.rightSelected) {
            [_position forwardInBothTo:self.scrollWheel.currentPosition];
        } else if(self.leftSelected) {
            [_position forwardInLeftTo:self.scrollWheel.currentPosition];
        } else if(self.rightSelected) {
            [_position forwardInRightTo:self.scrollWheel.currentPosition];
        }
        [self.dualPlayer seekPositionLeft:_position.position1 right:_position.position2];
    } else {
        if(_playing) {
            if(self.leftSelected && self.rightSelected && _position.leftInRange) {
                [_position playLeftPositionTo:self.dualPlayer.leftPlayer.position];
            } else if(self.leftSelected && self.rightSelected && _position.rightInRange) {
                [_position playRightPositionTo:self.dualPlayer.rightPlayer.position];
            } else if(self.leftSelected) {
                [_position forwardLeftPositionTo:self.dualPlayer.leftPlayer.position];
            } else if(self.rightSelected) {
                [_position forwardRightPositionTo:self.dualPlayer.rightPlayer.position];
            }

            if(self.leftSelected && self.rightSelected && _position.position >= _position.end) {
                _playing = NO;
                [_position forwardInBothTo:self.returnPosition];
                [self.dualPlayer seekPositionLeft:_position.position1 right:_position.position2];
            } else if(self.leftSelected && !self.rightSelected && _position.position1 >= _position.end1) {
                _playing = NO;
                [_position forwardInLeftTo:_position.start];
                [self.dualPlayer seekPositionLeft:_position.position1 right:_position.position2];
            } else if(!self.leftSelected && self.rightSelected && _position.position2 >= _position.end2) {
                _playing = NO;
                [_position forwardInRightTo:_position.start];
                [self.dualPlayer seekPositionLeft:_position.position1 right:_position.position2];
            }

            self.scrollWheel.currentPosition = _position.position;
        }

        [self.dualPlayer.leftPlayer setPlaying:_playing && self.leftSelected && _position.leftAlmostInRange && !self.dualPlayer.leftPlayer.isAtEnd];
        [self.dualPlayer.rightPlayer setPlaying:_playing && self.rightSelected && _position.rightAlmostInRange && !self.dualPlayer.rightPlayer.isAtEnd];
    }

    if(self.leftSelected && self.rightSelected) {
        self.scrollWheel.minPosition = _position.start;
        self.scrollWheel.maxPosition = _position.end;
    } else if(self.leftSelected) {
        self.scrollWheel.minPosition = _position.start1;
        self.scrollWheel.maxPosition = _position.end1;
    } else if(self.rightSelected) {
        self.scrollWheel.minPosition = _position.start2;
        self.scrollWheel.maxPosition = _position.end2;
    }

    //[self debugInfo];
}

- (void)debugInfo {
    _leftTimeLabels[0].text = ([NSString stringWithFormat:@"pp1 %.2f", self.dualPlayer.leftPlayer.position]);
    _leftTimeLabels[1].text = ([NSString stringWithFormat:@"p1  %.2f", _position.position1]);
    _leftTimeLabels[2].text = ([NSString stringWithFormat:@"s1  %.2f", _position.start1]);
    _leftTimeLabels[3].text = ([NSString stringWithFormat:@"e1  %.2f", _position.end1]);
    _leftTimeLabels[4].text = ([NSString stringWithFormat:@"d1  %.2f", _position.duration1]);
    _leftTimeLabels[5].text = ([NSString stringWithFormat:@"p   %.2f", _position.position]);
    _leftTimeLabels[6].text = ([NSString stringWithFormat:@"s   %.2f", _position.start]);
    _leftTimeLabels[7].text = ([NSString stringWithFormat:@"e   %.2f", _position.end]);
    _leftTimeLabels[8].text = ([NSString stringWithFormat:@"d   %.2f", _position.duration]);
    _leftTimeLabels[9].text = ([NSString stringWithFormat:@"ps   %.2f", _playStart]);
    _rightTimeLabels[0].text = ([NSString stringWithFormat:@"pp2 %.2f", self.dualPlayer.rightPlayer.position]);
    _rightTimeLabels[1].text = ([NSString stringWithFormat:@"p2  %.2f", _position.position2]);
    _rightTimeLabels[2].text = ([NSString stringWithFormat:@"s2  %.2f", _position.start2]);
    _rightTimeLabels[3].text = ([NSString stringWithFormat:@"e2  %.2f", _position.end2]);
    _rightTimeLabels[4].text = ([NSString stringWithFormat:@"d2  %.2f", _position.duration2]);
    _rightTimeLabels[5].text = ([NSString stringWithFormat:@"df  %.2f", _position.start1 - _position.start2]);
    _rightTimeLabels[6].text = ([NSString stringWithFormat:@"py  %d", _playing]);
    _rightTimeLabels[7].text = ([NSString stringWithFormat:@"py1  %d", self.dualPlayer.leftPlayer.playing]);
    _rightTimeLabels[8].text = ([NSString stringWithFormat:@"py2  %d", self.dualPlayer.rightPlayer.playing]);
}

- (UIView <PlayerViewProtocol> *)createPlayer {
    AssertNotNull(self.dependencyInjector);
    AVAsset *leftAsset = self.videoItem.videoAsset;
    AVAsset *rightAsset = self.secondVideoItem.videoAsset;
    DualPlayerView *player = [[self.dependencyInjector instanceOfClass:DualPlayerView.class] initWithLeftAsset:leftAsset andRightAsset:rightAsset];
    player.delegate = self;
    [self.view addSubview:player];

    _position = [[DualVideoPosition alloc] initWithLeftDuration:CMTimeGetSeconds(leftAsset.duration) rightDuration:CMTimeGetSeconds(rightAsset.duration)];
 
    return player;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    CGFloat width = 480.0, height = 320;
     CGFloat screenWidth = self.view.frame.size.height;
    if(isIPAD) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenScale = [[UIScreen mainScreen] scale];
        if(screenRect.size.height >screenRect.size.width ) {
         screenWidth = screenRect.size.height;
        } else {
             screenWidth = screenRect.size.width;
        }
        
      //  CGFloat screenHeight = screenRect.size.height;
        width = 900;
        height = 640;
    } else {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        screenWidth = screenRect.size.height;
        if(screenRect.size.height >screenRect.size.width ) {
            screenWidth = screenRect.size.height;
        } else {
            screenWidth = screenRect.size.width;
        }
        width = 480.0;
        height = 320;
    }
    
   
    CGFloat buttonOffsetX = 70.0, buttonOffsetY = 23;

    CGFloat almostMiddle = screenWidth / 2.0f;
    [_selectVideoButtons[0] setCenter:CGPointMake(almostMiddle - buttonOffsetX, buttonOffsetY)];
    [_selectVideoButtons[1] setCenter:CGPointMake(almostMiddle, buttonOffsetY)];
    [_selectVideoButtons[2] setCenter:CGPointMake(almostMiddle + buttonOffsetX, buttonOffsetY)];

    int index = 0;
    CGFloat inc = 20;
    _leftTimeLabels[index].center = CGPointMake(almostMiddle - 120, buttonOffsetY);
    _rightTimeLabels[index].center = CGPointMake(almostMiddle + 120, buttonOffsetY);
    index++;
    buttonOffsetY += inc;
    _leftTimeLabels[index].center = CGPointMake(almostMiddle - 120, buttonOffsetY);
    _rightTimeLabels[index].center = CGPointMake(almostMiddle + 120, buttonOffsetY);
    index++;
    buttonOffsetY += inc;
    _leftTimeLabels[index].center = CGPointMake(almostMiddle - 120, buttonOffsetY);
    _rightTimeLabels[index].center = CGPointMake(almostMiddle + 120, buttonOffsetY);
    index++;
    buttonOffsetY += inc;
    _leftTimeLabels[index].center = CGPointMake(almostMiddle - 120, buttonOffsetY);
    _rightTimeLabels[index].center = CGPointMake(almostMiddle + 120, buttonOffsetY);
    index++;
    buttonOffsetY += inc;
    _leftTimeLabels[index].center = CGPointMake(almostMiddle - 120, buttonOffsetY);
    _rightTimeLabels[index].center = CGPointMake(almostMiddle + 120, buttonOffsetY);
    index++;
    buttonOffsetY += inc;
    _leftTimeLabels[index].center = CGPointMake(almostMiddle - 120, buttonOffsetY);
    _rightTimeLabels[index].center = CGPointMake(almostMiddle + 120, buttonOffsetY);
    index++;
    buttonOffsetY += inc;
    _leftTimeLabels[index].center = CGPointMake(almostMiddle - 120, buttonOffsetY);
    _rightTimeLabels[index].center = CGPointMake(almostMiddle + 120, buttonOffsetY);
    index++;
    buttonOffsetY += inc;
    _leftTimeLabels[index].center = CGPointMake(almostMiddle - 120, buttonOffsetY);
    _rightTimeLabels[index].center = CGPointMake(almostMiddle + 120, buttonOffsetY);
    index++;
    buttonOffsetY += inc;
    _leftTimeLabels[index].center = CGPointMake(almostMiddle - 120, buttonOffsetY);
    _rightTimeLabels[index].center = CGPointMake(almostMiddle + 120, buttonOffsetY);
    index++;
    buttonOffsetY += inc;
    _leftTimeLabels[index].center = CGPointMake(almostMiddle - 120, buttonOffsetY);
    _rightTimeLabels[index].center = CGPointMake(almostMiddle + 120, buttonOffsetY);

    CGRect rootFrame = CGRectMake((screenWidth - width) / 2.0f, 0, width, height);
    ViewBuilder *rootBuilder = [ViewBuilder verticalBuilderForFrame:rootFrame];
    float playerHeight = roundf(width / VideoAspectRatio / 2.0f);
    [rootBuilder addSpace:playerHeight];
    [rootBuilder addSpace:0];
    [rootBuilder addFlexibleSpaceWithFactor:1];
    [rootBuilder addSpace:0];
    ViewBuilderResult *rootResult = [rootBuilder build];
    [self.player setFrame:[rootResult frameAtIndex:0]];
    CGRect controlsFrame = [rootResult frameAtIndex:2];

    ViewBuilder *controlsBuilder = [ViewBuilder horizontalBuilderForFrame:controlsFrame];
    [controlsBuilder addFlexibleSpaceWithFactor:1];
    [controlsBuilder addSpace:self.scrollWheel.visibleFrame.size.width];
    [controlsBuilder addFlexibleSpaceWithFactor:1];
    ViewBuilderResult *controlsResult = [controlsBuilder build];
    self.playButton.center = PointAtCenter([controlsResult frameAtIndex:0]);
    self.scrollWheel.center = PointAtCenter([controlsResult frameAtIndex:1]);
   
    CGRect slowFrame = [controlsResult frameAtIndex:2];

    ViewBuilder *slowBuilder = [ViewBuilder horizontalBuilderForFrame:slowFrame];
    [slowBuilder addFlexibleSpaceWithFactor:1];
    [slowBuilder addCenteredView:self.slowButton];
    [slowBuilder addSpace:6];
    [slowBuilder addCenteredView:self.slowLabel];
    [slowBuilder addSpace:2];
    [slowBuilder addCenteredView:self.showLegendButton];
    [slowBuilder addFlexibleSpaceWithFactor:1];
    [slowBuilder build];
    [self initToolBoxView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);    // ios < 6
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if(IPAD) {
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        if (orientation == UIDeviceOrientationLandscapeLeft) {
            return UIInterfaceOrientationLandscapeRight;
        } else {
            return UIInterfaceOrientationLandscapeLeft;
        }
        
    } else {
        return UIInterfaceOrientationLandscapeRight;  // ios 6
    }
    
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if(IPAD){
        return UIInterfaceOrientationMaskLandscape;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (BOOL)shouldAutorotate {
    if(IPAD){
        return YES;
    } else {
        return NO;
    }
}

#pragma mark private methods

- (void)donePressed:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)playPressed:(id)sender {
       [self.scrollWheel setMaxPosition:_position.end];
    [super playPressed:sender];
}

- (void)setIsPlaying:(BOOL)playing {
    _playing = playing;
}

- (BOOL)leftSelected {return self.dualPlayer.leftSelected;}

- (BOOL)rightSelected {return self.dualPlayer.rightSelected;}


- (void)initToolBoxView {
    if(toolboxView == nil) {
        CGRect playerFrame = self.dualPlayer.frame;
        CGRect toolFrame ;
        if(isIPAD) {
                 CGRect screenRect = [[UIScreen mainScreen] bounds];
            CGFloat screenWidth = 0;
            if(screenRect.size.height >screenRect.size.width ) {
                screenWidth = screenRect.size.height;
            } else {
                screenWidth = screenRect.size.width;
            }
               toolFrame = CGRectMake(screenWidth - 40, playerFrame.origin.y, 40.0, playerFrame.size.height);
        } else {
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            CGFloat screenWidth = 0;
            if(screenRect.size.height >screenRect.size.width ) {
                screenWidth = screenRect.size.height;
            } else {
                screenWidth = screenRect.size.width;
            }
              toolFrame = CGRectMake(screenWidth - 40, playerFrame.origin.y, 40.0, self.view.frame.size.width);
        }
      
        toolboxView = [[ToolBoxView alloc] initWithFrame:toolFrame];
        toolboxView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        //tool.opaque = NO;
        [toolboxView setUserInteractionEnabled:YES];
        [toolboxView setDelegate:[self dualPlayer]];
        [toolboxView setDualMode:true];
        [self.dualPlayer setToolBoxView:toolboxView];

        [UIView animateWithDuration:1 delay:1.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
            // self.player.frame = playerSmallFrame;
            [self.view addSubview:toolboxView];
        } completion:nil];
    }
}

- (void)drawPressed:(id)sender {
    [self.toolboxView setHidden:!self.toolboxView.hidden];
}

@end
