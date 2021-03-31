#import "VideoMask.h"
#import "AbstractRecordingController.h"

@implementation VideoMask {
}

- (id)init {
    self = [super initWithFrame:CGRectZero];
    self.opaque = NO;
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    CGFloat width = 320.0;
    CGFloat height = roundf(width / VideoAspectRatio);
    CGRect rectangle = CGRectMake(0, (self.frame.size.height - height) / 2.0, width, height);
    [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.3] setStroke];
    UIRectFrame(CGRectInset(rectangle, 0, 0));
    UIRectFrame(CGRectInset(rectangle, 1, 1));
    UIRectFrame(CGRectInset(rectangle, 2, 2));
    UIRectFrame(CGRectInset(rectangle, 3, 3));
}

@end