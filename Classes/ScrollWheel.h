@class ScrollWheelImpl;
@protocol ScrollWheelDelegate;

static const CGFloat ScrollWheelTouchAreaInset = 10.0;
static const CGRect ScrollWheelArea = {{0, 0}, {220, 46}}; // size of wheel is proprtional to height

@interface ScrollWheel : UIView
@property(nonatomic, weak) id <ScrollWheelDelegate> delegate;
@property(nonatomic, assign) NSTimeInterval currentPosition;

+ (void)preloadWheel;
- (CGRect)visibleFrame;
- (void)setMaxPosition:(NSTimeInterval)maxPosition;
- (void)setMinPosition:(NSTimeInterval)minPosition;
@end