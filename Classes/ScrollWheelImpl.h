#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma clang diagnostic ignored "-Wgcc-compat"
#pragma clang diagnostic ignored "-Wlogical-op-parentheses"
#pragma clang diagnostic ignored "-Wmissing-braces"
#pragma clang diagnostic ignored "-Wfloat-equal"
#pragma clang diagnostic ignored "-Wcovered-switch-default"
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#pragma clang diagnostic ignored "-Wunreachable-code"
#pragma clang diagnostic ignored "-Wunused-function"
#pragma clang diagnostic ignored "-Wundef"
#pragma clang diagnostic ignored "-Wcast-align"
#import "isgl3d.h"
#pragma clang diagnostic pop

@interface ScrollWheelImpl : Isgl3dBasic3DView 
@property(nonatomic, assign) CGFloat maxAngle;
@property(nonatomic, assign) CGFloat minAngle;
@property(nonatomic, assign) CGFloat currentAngle;
- (void)rotate:(CGFloat)angle;
@end


