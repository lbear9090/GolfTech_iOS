#import "VideoPosition.h"

@implementation VideoPosition {
    NSTimeInterval _duration;
    NSTimeInterval _position;
}
- (id)initWithDuration:(NSTimeInterval)duration {
    self = [super init];
    _duration = duration;
    return self;
}

- (void)moveTo:(NSTimeInterval)newPosition {
    [self moveFor:newPosition - _position];
}

- (void)moveFor:(NSTimeInterval)duration {
    _position = MAX(MIN(_position + duration, _duration), 0.0);
}

@end