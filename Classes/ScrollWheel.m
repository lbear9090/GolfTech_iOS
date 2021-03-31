#import "Isgl3dEAGLView.h"
#import "ScrollWheel.h"
#import "ScrollWheelImpl.h"
#import "ScrollWheelDelegate.h"

static const CGFloat Deacceleration = 0.95;
static const CGFloat DeaccelerationInterval = 0.02;
static const CGFloat MinimumInertiaSpeed = 10;
static const CGFloat SecondsPerAngle = -2.1 / 360.0;
static const CGFloat AnglesPerVelocity = -0.01;

static ScrollWheelImpl* ScrollWheelInstance = nil;
static Isgl3dEAGLView* GLViewInstance = nil;

@implementation ScrollWheel {
    UIPanGestureRecognizer* _gesture;
    CGFloat _intertiaSpeed;
}

- (NSTimeInterval)currentPosition {
    return ScrollWheelInstance.currentAngle * SecondsPerAngle;
}

- (void)setCurrentPosition:(NSTimeInterval)currentPosition {
    ScrollWheelInstance.currentAngle = (CGFloat) currentPosition / SecondsPerAngle;
}

- (void)setMaxPosition:(NSTimeInterval)maxPosition {
    ScrollWheelInstance.maxAngle = (CGFloat) maxPosition / SecondsPerAngle;
}

- (void)setMinPosition:(NSTimeInterval)minPosition {
    ScrollWheelInstance.minAngle = (CGFloat) minPosition / SecondsPerAngle;
}

+ (void)preloadWheel {
    static BOOL initalized = NO;
    if(initalized)
        return;
    initalized = YES;
    Isgl3dDirector* director = [Isgl3dDirector sharedInstance];
    director.backgroundColorString = @"333333ff";
    //isgl3dDirector.deviceOrientation = Isgl3dOrientationLandscapeLeft;
    //self.director.displayFPS = YES;
    //isgl3dDirector.autoRotationStrategy = Isgl3dAutoRotationByUIViewController;
    //isgl3dDirector.allowedAutoRotations = Isgl3dAllowedAutoRotationsLandscapeOnly;
    //[self.director.enableRetinaDisplay:YES];
    director.antiAliasingEnabled = YES;
    [director setAnimationInterval:1.0 / 60];

    GLViewInstance = [Isgl3dEAGLView viewWithFrameForES2:CGRectInset(ScrollWheelArea, ScrollWheelTouchAreaInset, ScrollWheelTouchAreaInset)];
    director.openGLView = GLViewInstance;

    ScrollWheelInstance = [ScrollWheelImpl view];
    [director addView:ScrollWheelInstance];
    [director run];
}

- (id)init {
    self = [super initWithFrame:ScrollWheelArea];
    [self.class preloadWheel];
    _gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
    _gesture.maximumNumberOfTouches = 1;
    [self addGestureRecognizer:_gesture];

    return self;
}

- (void)willMoveToWindow:(UIWindow*)newWindow {
    [super willMoveToWindow:newWindow];
    if(newWindow != nil)
        [self viewWillAppear];
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    if(self.window == nil)
        [self didDisappear];
}

- (void)viewWillAppear {
    [self addSubview:GLViewInstance];
}

- (void)didDisappear {
   // [GLViewInstance removeFromSuperview];
}

- (CGRect)visibleFrame {
    return CGRectInset(self.frame, ScrollWheelTouchAreaInset, ScrollWheelTouchAreaInset);
}

- (void)panned:(UIPanGestureRecognizer*)gesture {
    CGPoint velocity = [gesture velocityInView:self];
    //MLog(@"Gesture %d",gesture.state);
    switch(gesture.state) {
        case UIGestureRecognizerStateBegan:
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(deaccelerate) object:nil];
            [_delegate beginScrubbing];
            [self applyVelocity:velocity.x];
            break;
        case UIGestureRecognizerStateChanged:
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(deaccelerate) object:nil];
            //NSLog(@"Panned %f state %d",velocity.x, gesture.state);
            [self applyVelocity:velocity.x];
            //[_delegate seekRelativePosition:velocityX/10000.0];
            break;
        case UIGestureRecognizerStateEnded:
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(deaccelerate) object:nil];
            // let go
            //NSLog(@"Final velocity is %f",velocity.x);
            _intertiaSpeed = velocity.x;
            [self deaccelerate];
            break;
        case UIGestureRecognizerStatePossible:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            // Ignored gestures
            break;
    }
}

- (void)applyVelocity:(CGFloat)velocity {
    [ScrollWheelInstance rotate:velocity * AnglesPerVelocity];
}

- (void)deaccelerate {
    CGFloat deacceleration = Deacceleration;
    if(fabsf(_intertiaSpeed) < MinimumInertiaSpeed) {
        [_delegate endScrubbing];
        return;
    }
    //MLog(@"Slowing down %f",_intertiaSpeed);
    [self applyVelocity:_intertiaSpeed];
    _intertiaSpeed = _intertiaSpeed * deacceleration;
    [self performSelector:@selector(deaccelerate) withObject:nil afterDelay:DeaccelerationInterval];
}

@end