#import "ScrollWheelWithSlider.h"
#import "ScrollWheelDelegate.h"
#import "ScrollWheel.h"
#import "UIColorAdditions.h"
#import "NewScrollWheel.h"
static const int SliderHeight = 30;

@interface ScrollWheelWithSlider () <ScrollWheelDelegate>
@end

@implementation ScrollWheelWithSlider {
    //ScrollWheel *_scrollWheel;
    NewScrollWheel *_scrollWheel;
    UISlider *_slider;
}

- (id)init {
    self = [super init];

    //_scrollWheel = [ScrollWheel new];
    
     _scrollWheel = [NewScrollWheel new];
   _scrollWheel.frame = CGRectMake( 0, 0, 220, 46);
    _scrollWheel.delegate = self;
    [self addSubview:_scrollWheel];

    self.frame = CGRectMake(0, 0, _scrollWheel.frame.size.width, _scrollWheel.frame.size.height + SliderHeight - ScrollWheelTouchAreaInset);
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, SliderHeight)];
    _slider.minimumTrackTintColor = [UIColor colorWithRGBHex:LightBrandedHexColor];
    _slider.userInteractionEnabled = NO;
    [_slider setThumbImage:[UIImage imageNamed:@"scrollbar markor"] forState:UIControlStateNormal];
    [self addSubview:_slider];

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _slider.frame = CGRectMake(0,0,self.bounds.size.width,SliderHeight);
    _slider.frame = CGRectInset(_slider.frame, ScrollWheelTouchAreaInset - 2, 0);
    _scrollWheel.frame = CGRectMake(0, SliderHeight - ScrollWheelTouchAreaInset, _scrollWheel.frame.size.width, _scrollWheel.frame.size.height);

}

- (NSTimeInterval)currentPosition {
 
    
    return _scrollWheel.currentSpeed;
}

- (void)setCurrentPosition:(NSTimeInterval)currentPosition {

    [_scrollWheel setScrollSpeed: currentPosition];
    [_slider setValue:(float) currentPosition animated:YES];
}

- (CGRect)visibleFrame {
    return _scrollWheel.frame;
}

- (void)setMaxPosition:(NSTimeInterval)maxPosition {
    _scrollWheel.maxPosition = maxPosition;
    [_slider setMaximumValue:maxPosition];
    [_slider setNeedsDisplay];
    //    _slider.maximumValue = (float) maxPosition;
}

- (void)setMinPosition:(NSTimeInterval)minPosition {
    _scrollWheel.minPosition = minPosition;
    _slider.minimumValue = (float) minPosition;
}

- (void)syncUI {
    [_slider setValue:(float) _scrollWheel.currentSpeed animated:YES];
    [self performSelector:@selector(syncUI) withObject:nil afterDelay:1.0/60];
}

- (void)beginScrubbing {
    [self syncUI];
    [self.delegate beginScrubbing];
}

- (void)endScrubbing {
    [self.class cancelPreviousPerformRequestsWithTarget:self selector:@selector(syncUI) object:nil];
    [self.delegate endScrubbing];
}

@end
