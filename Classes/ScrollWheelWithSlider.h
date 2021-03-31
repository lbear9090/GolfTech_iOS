@protocol ScrollWheelDelegate;

@interface ScrollWheelWithSlider : UIView
@property(nonatomic, weak) id <ScrollWheelDelegate> delegate;
@property(nonatomic, assign) NSTimeInterval currentPosition;

- (CGRect)visibleFrame;
- (void)setMaxPosition:(NSTimeInterval)maxPosition;
- (void)setMinPosition:(NSTimeInterval)minPosition;
@end