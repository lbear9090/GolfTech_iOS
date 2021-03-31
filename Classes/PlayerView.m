#import "PlayerView.h"
#import "UIColorAdditions.h"
#import "OverlayView.h"
#import "ToolBoxView.h"
#import "OverlayObject.h"
static const int VideoTimeScale = 600;

@interface PlayerView ()
@property(nonatomic, strong) AVPlayer* player;

@end

@implementation PlayerView {
    AVPlayerItem* _playerItem;
    NSTimeInterval _targetPosition;
    BOOL _seeking;
}
@synthesize playing = _playing, delegate = _delegate, playbackSpeed = _playBackSpeed,pinchRecognizer,panRecognizer,rotationRecognizer,mLastScale,mCurrentPanX,mCurrentPanY,mCurrentScale,mZooming,mTempCurrentPanX,mTempCurrentPanY,isPaintMode,tool,isPainting,longPressRecognizer,doubleRecognizer,isPaintingByPinch,viewId,
mCurrentPaintingStartPoint;
@synthesize overlayView,toolboxView;

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (id)initWithAsset:(AVAsset*)asset {
    AssertNotNull(self.audioVideoFactory);
    
    self = [super init];
    self.multipleTouchEnabled = YES;
    self.userInteractionEnabled = YES;
    
    // rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationGesture:)];
    //  [self addGestureRecognizer:rotationRecognizer];
 
    longPressRecognizer = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                           action:@selector(handleLongPress:)];
    [longPressRecognizer setMinimumPressDuration:0.01];
    longPressRecognizer.delegate = self;
    
    doubleRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleRecognizer setNumberOfTouchesRequired:2];
    [doubleRecognizer setMinimumPressDuration:0.1];
    doubleRecognizer.delegate = self;
  
    pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
    pinchRecognizer.delegate = self;

    panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    panRecognizer.delegate = self;
    [panRecognizer setMaximumNumberOfTouches:1];
    self.gestureRecognizers = @[pinchRecognizer, panRecognizer,longPressRecognizer,doubleRecognizer];
   
    // [self.panRecognizer requireGestureRecognizerToFail:self.pinchRecognizer];
    
    self.backgroundColor = [UIColor colorWithRGBHex:0x202020];
    self.playing = NO;
    _playBackSpeed = 1.0;
    mCurrentScale = 1.0;
    mLastScale = 1.0;
    mCurrentPanX = 0.0;
    mCurrentPanY = 0.0;
    mTempCurrentPanX=0,mTempCurrentPanY=0;
    mZooming = false;
    _playerItem = [self.audioVideoFactory playerItemWithAsset:asset];
    [_playerItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptions) 0 context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
    self.player = [AVPlayer playerWithPlayerItem:_playerItem];

   
    self.videoFillMode = AVLayerVideoGravityResizeAspect;//ResizeAspectFill;
    AVPlayerLayer* layer = (AVPlayerLayer*) [self layer];
    layer.videoGravity = AVLayerVideoGravityResizeAspect;
    CGRect frame = CGRectMake(0,0,640,920);
    overlayView = [[OverlayView alloc] initWithFrame: frame];
    overlayView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    overlayView.opaque = NO;

   
    [self addSubview:overlayView];

    [self setUserInteractionEnabled:YES];
    self.clipsToBounds = YES;
    return self;

}

-(void)changeVideo:(AVAsset*) item {
    NSLog(@"changeVideo");
    AVPlayerItem *replaceVideo = [self.audioVideoFactory playerItemWithAsset:item];

    [self.player replaceCurrentItemWithPlayerItem:replaceVideo];
    
    
    [_playerItem removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    _playerItem = replaceVideo;
    [_playerItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptions) 0 context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
   // self.player.playing = NO;
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_playerItem removeObserver:self forKeyPath:@"status"];
   
    //[self removeGestureRecognizer:rotationRecognizer];
     [self removeGestureRecognizer:panRecognizer];
     [self removeGestureRecognizer:pinchRecognizer];
    [self removeGestureRecognizer:longPressRecognizer];
    
}

- (AVPlayer*)player {
    return [(AVPlayerLayer*) [self layer] player];
}

- (void)setPlayer:(AVPlayer*)player {
    [(AVPlayerLayer*) [self layer] setPlayer:player];
}

- (void)setVideoFillMode:(NSString*)fillMode {
    AVPlayerLayer* playerLayer = (AVPlayerLayer*) [self layer];
    playerLayer.videoGravity = fillMode;
}

- (BOOL)isReadyToPlay {
    return self.player.currentItem != nil && [self.player.currentItem status] == AVPlayerItemStatusReadyToPlay;
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
    //MLog(@"Observing %@ on object change is %@",keyPath,change);
    if(_playerItem == object && [keyPath isEqual:@"status"]) {
        NSLog(@"Status is %ld", _playerItem.status);
        if(_playerItem.error!=nil) {
             NSLog(@"playerItem.error %ld", _playerItem.status);
        }
             // if(_playerItem.error)
        NSAssert(_playerItem.error == nil, @"PlayerItem error %@", _playerItem.error);
        id __unsafe_unretained weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf update];
        });
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)setPlaying:(BOOL)isPlaying {
    _playing = isPlaying;
    [self update];
}

- (BOOL)isAtStart {
    double position = CMTimeGetSeconds(_playerItem.currentTime);
    return position <= 0.0;
}

- (BOOL)isAtEnd {
    double duration = CMTimeGetSeconds(_playerItem.duration);
    double position = CMTimeGetSeconds(_playerItem.currentTime);
    double fromEnd = duration - position;
    return fromEnd <= 0.0;
}

- (void)playerItemDidReachEnd:(NSNotification*)notification {
    self.playing = NO;
    [self update];
}

- (void)setPlaybackSpeed:(float)speed {
    _playBackSpeed = speed;
    [self update];
}

- (float)playbackSpeed {
    return _playBackSpeed;
}

- (void)update {
    self.player.rate = self.playing ? _playBackSpeed : 0.0;
    [self.delegate playerStatusWasUpdated];
}

- (void)seekPosition:(NSTimeInterval)position {
    if(self.player.status != AVPlayerItemStatusReadyToPlay || _seeking)
        return;
    _targetPosition = position;
    CMTime cmPosition = CMTimeMakeWithSeconds(position, VideoTimeScale);
    if(CMTimeCompare(cmPosition, _playerItem.duration) == 1)
        return;
    //MLog(@"Seeking to %f %p", position, self);
    _seeking = YES;
    [self.player seekToTime:cmPosition toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
        if(!finished)
            MLog(@"++++ Skipping video");
        _seeking = NO;
    }];
}

- (NSTimeInterval)position {
    //MLog(@"Current position is %.2f target is %f.2", CMTimeGetSeconds(self.player.currentTime), _targetPosition);
    return _seeking ? _targetPosition : CMTimeGetSeconds(self.player.currentTime);
}

#pragma mark gestures functions

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
- (void)handleDoubleTap:(UILongPressGestureRecognizer*)gesture
{
   // NSLog(@"#####Paintng doubletap");
    if(isPainting && self.tool.state != FREE) {
    CGPoint location1 = [gesture locationOfTouch:0 inView:self];
    CGPoint location2 = [gesture locationOfTouch:1 inView:self];
        
    [self drawSymbol:location2 location1:location1];
    }
}
- (void)handleLongPress:(UILongPressGestureRecognizer*)gesture
{
  
    if(self.isPaintMode) {
        if (gesture.state == UIGestureRecognizerStateBegan) {
            isPainting = true;
            OverlayObject *circle = [[OverlayObject alloc] init];
            CGPoint location1 =  [gesture locationOfTouch:0 inView:self];
            [circle setPos_x:location1.x ];
            [circle setPos_y:location1.y ];
            [circle setWidth:20 / mCurrentScale ];
            [circle setHeight:20 / mCurrentScale ];
            circle.path = [UIBezierPath bezierPath];
            float viewbox_top_x = ((self.frame.size.width / 2) / mCurrentScale) + mCurrentPanX;
            float viewbox_top_y = ((self.frame.size.height / 2) / mCurrentScale)+ mCurrentPanY;
            float calc_x = ((viewbox_top_x - 0) *(0-(self.frame.size.width / 2))) / ((self.frame.size.width / 2)-0) + (self.frame.size.width / 2);
            float calc_y = ((viewbox_top_y - 0) *(0-(self.frame.size.height / 2))) / ((self.frame.size.height / 2)-0) + (self.frame.size.height / 2);
            if(self.tool.state == FREE) {
             [circle.path moveToPoint:CGPointMake((location1.x / mCurrentScale) + calc_x,
                                                 (location1.y / mCurrentScale) + calc_y)];
            }
                [overlayView.overlayObjects addObject:circle];
            if(overlayView.dualMode) {
            [self.delegate symbolDrawed:self.viewId];
            }
        }

    }
}

- (void)rotationGesture:(UIRotationGestureRecognizer*)gesture
{
    switch( gesture.state )
    {
        case UIGestureRecognizerStateBegan:
            //  NSLog(@"rotationGesture began");
            break;
            
        case UIGestureRecognizerStateChanged:
            //    NSLog(@"rotationGesture changed");
            break;
        case UIGestureRecognizerStateEnded:
            // NSLog(@"rotationGesture ended");
            break;
        case UIGestureRecognizerStateCancelled:
            // NSLog(@"rotationGesture cnl");
            break;
        case UIGestureRecognizerStateFailed:
            //NSLog(@"rotationGesture faiuled");
            break;
        case UIGestureRecognizerStatePossible:
            // NSLog(@"rotationGesture possible");
            break;
            
    }
}
-(void)zoomOut:(UIPinchGestureRecognizer*) sender {
    
    mCurrentScale +=  ([sender scale] - mLastScale ) * mCurrentScale ;
    if(mCurrentScale > 8){
        mCurrentScale =8;
    } else {
        mLastScale = [sender scale];
    }
    
    
        mLastScale = [sender scale];
    
    
    
    if (sender.state == UIGestureRecognizerStateBegan) {

        mZooming = true;
    }
    
    CATransform3D panTransform =CATransform3DMakeTranslation( mTempCurrentPanX,  mTempCurrentPanY   ,1.0f);
    CATransform3D scaleTransform = CATransform3DMakeScale(mCurrentScale,mCurrentScale,1.0f);
    CATransform3D combinedTransform = CATransform3DConcat(panTransform, scaleTransform);
    
    [[self layer] setSublayerTransform:combinedTransform ];//
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        
        if(mZooming) {
            [toolboxView unselectAllMenuButtons];
            [self setIsPaintMode:false];
            
        }
              //  [self setIsPainting:false];
        [self checkMaxPanning];
        mZooming = false;
        mLastScale = 1.0;
       
    }

}
- (void)drawSymbol:(CGPoint)location2 location1:(CGPoint)location1
{

    OverlayObject *overlayObject = overlayView.overlayObjects.lastObject;

    
    float viewbox_top_x = ((self.frame.size.width / 2) / mCurrentScale) + mCurrentPanX;
    float viewbox_top_y = ((self.frame.size.height / 2) / mCurrentScale)+ mCurrentPanY;
 //   float calc_x = ((viewbox_top_x - 0) *(0-160)) / (160-0) + 160;
 //   float calc_y = ((viewbox_top_y - 0) *(0-180)) / (180-0) + 180;
       float calc_x = ((viewbox_top_x - 0) *(0-(self.frame.size.width / 2))) / ((self.frame.size.width / 2)-0) + (self.frame.size.width / 2);
       float calc_y = ((viewbox_top_y - 0) *(0-(self.frame.size.height / 2))) / ((self.frame.size.height / 2)-0) + (self.frame.size.height / 2);
    
    
    ToolBoxItem *toolItem = [ToolBoxItem alloc];
    [toolItem setColor:self.tool.color];
    [toolItem setState:self.tool.state];
    [overlayObject setTool:toolItem];
    if(overlayObject.tool.state == FREE) {
        [overlayObject.path addLineToPoint:CGPointMake((location2.x / mCurrentScale) + calc_x,
                                                       (location2.y / mCurrentScale) + calc_y)];
    } else {
    [overlayObject setObject:CGPointMake((location1.x / mCurrentScale) + calc_x,
                                         (location1.y / mCurrentScale) + calc_y)
                   secondTap:CGPointMake((location2.x / mCurrentScale) + calc_x,
                                         (location2.y / mCurrentScale) + calc_y) scale:mCurrentScale];
    }
    [overlayView setNeedsDisplay];
}

- (void)pinchGesture:(UIPinchGestureRecognizer*)gesture
{
    if(isPainting && self.tool.state != FREE) {
        isPaintingByPinch = true;
            NSUInteger numTouches = [gesture numberOfTouches];
        if(numTouches > 1) {
            CGPoint location1 = [gesture locationOfTouch:0 inView:self];
            CGPoint location2 = [gesture locationOfTouch:1 inView:self];
          
            [self drawSymbol:location2 location1:location1];
        }
        if(gesture.state == UIGestureRecognizerStateEnded) {
           // isPainting = false;
            isPaintingByPinch = false;
             [self setIsPainting:false];
            //  [self setIsPaintMode:false];
        }
    } else {
        [self zoomOut:gesture];
    }
    
}



-(void)pan:(UIPanGestureRecognizer*) sender {
 	CGPoint translation = [sender translationInView:self];
    
    AVPlayerLayer* layer = (AVPlayerLayer*) sender.view.layer;
   
    CGFloat panX = mCurrentPanX + translation.x/ mCurrentScale;
    CGFloat panY = mCurrentPanY + translation.y/ mCurrentScale;

    mTempCurrentPanX = panX;
     mTempCurrentPanY = panY;
    NSLog(@"panning");

    CATransform3D panTransform =CATransform3DMakeTranslation(panX,    panY,1.0f);
    CATransform3D scaleTransform = CATransform3DMakeScale(mCurrentScale,mCurrentScale,1.0f);
    CATransform3D combinedTransform = CATransform3DConcat(panTransform, scaleTransform);
    [layer setSublayerTransform:combinedTransform ];
    
    if(sender.state == UIGestureRecognizerStateEnded) {
        mCurrentPanX =  panX;
        mCurrentPanY =  panY;
        [self checkMaxPanning];
     }
}
-(void)checkMaxPanning {
    float viewbox_top_pan_x = ((self.frame.size.width / 2) * (mCurrentScale -1)) ;
    float viewbox_top_pan_y = ((self.frame.size.height / 2) * (mCurrentScale -1));
    float viewbox_buttom_pan_x = viewbox_top_pan_x  - (viewbox_top_pan_x*2) ;
    float viewbox_buttom_pan_y = viewbox_top_pan_y  - (viewbox_top_pan_y*2) ;
    if(mTempCurrentPanX *mCurrentScale > viewbox_top_pan_x) {
        mTempCurrentPanX =viewbox_top_pan_x / mCurrentScale;
        mCurrentPanX = mTempCurrentPanX;
    }
    
    if( mTempCurrentPanY*mCurrentScale > viewbox_top_pan_y) {
        mTempCurrentPanY =viewbox_top_pan_y / mCurrentScale;
          mCurrentPanY = mTempCurrentPanY;
    }
    
    if(mTempCurrentPanX *mCurrentScale < viewbox_buttom_pan_x) {
        mTempCurrentPanX =viewbox_buttom_pan_x / mCurrentScale;
        mCurrentPanX = mTempCurrentPanX;
    }
    
    if( mTempCurrentPanY*mCurrentScale < viewbox_buttom_pan_y) {
        mTempCurrentPanY =viewbox_buttom_pan_y / mCurrentScale;
        mCurrentPanY = mTempCurrentPanY;
    }
    
    if(mCurrentScale <= 1.0){
        mCurrentScale =1.0;
        mCurrentPanX = 0.0;
        mCurrentPanY = 0.0;
        mTempCurrentPanX =0.0;
        mTempCurrentPanY = 0.0;
    }
    
        [UIView animateWithDuration:2.0
                         animations:^{
                             CATransform3D panTransform =CATransform3DMakeTranslation(mTempCurrentPanX,mTempCurrentPanY,1.0f);
                             CATransform3D scaleTransform = CATransform3DMakeScale(mCurrentScale,mCurrentScale,1.0f);
                             CATransform3D combinedTransform = CATransform3DConcat(panTransform, scaleTransform);
                              AVPlayerLayer* layer = (AVPlayerLayer*) self.layer;
                             [layer setSublayerTransform:combinedTransform ];
                         }];
    
}

- (void)panGesture:(UIPanGestureRecognizer*)gesture
{

    if(self.isPaintMode) {
        if (gesture.state == UIGestureRecognizerStateEnded) {
            
            if(!isPaintingByPinch){
                
                [gesture setDelaysTouchesBegan:YES];
                [self setIsPainting:false];
            }
        }
        if (gesture.state == UIGestureRecognizerStateBegan) {
            // Store inital
           mCurrentPaintingStartPoint =  [gesture locationInView:self];
       } else if(!isPaintingByPinch &&isPainting ){
          
            [self drawSymbol:[gesture locationInView:self] location1:mCurrentPaintingStartPoint];
       }

        
    } else {
      [self pan:gesture];
    }

}

@end
