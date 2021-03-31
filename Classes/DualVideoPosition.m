#import "DualVideoPosition.h"

@interface DualVideoPosition ()
@property(nonatomic) NSTimeInterval start1;
@property(nonatomic) NSTimeInterval start2;
@property(nonatomic) NSTimeInterval position;
@end

@implementation DualVideoPosition {
    NSTimeInterval _start1;
    NSTimeInterval _start2;
    NSTimeInterval _duration1;
    NSTimeInterval _duration2;
    NSTimeInterval _position;
}

- (BOOL)leftInRange {
    return _position >= _start1 && _position < self.end1;
}

- (BOOL)rightInRange {
    return _position >= _start2 && _position <= self.end2;
}

- (BOOL)leftAlmostInRange {
    return _position - _start1 > -0.1 && _position - self.end1 < 0.1;
}

- (BOOL)rightAlmostInRange {
    return _position - _start2 > -0.1 && _position - self.end2 < 0.1;
}


- (id)initWithLeftDuration:(NSTimeInterval)duration1 rightDuration:(NSTimeInterval)duration2 {
    self = [super init];
    _start1 = 0.0;
    _start2 = 0.0;
    _position = 0.0;
    _duration1 = duration1;
    _duration2 = duration2;
    return self;
}

- (NSTimeInterval)end1 {return self.start1 + _duration1;}

- (NSTimeInterval)end2 {return self.start2 + _duration2;}

- (NSTimeInterval)end {return MAX(self.end1, self.end2);}

- (NSTimeInterval)start {return MIN(self.start1, self.start2);}

- (NSTimeInterval)position1 {return MAX(MIN(self.position, self.end1), self.start1) - self.start1;}

- (NSTimeInterval)position2 {return MAX(MIN(self.position, self.end2), self.start2) - self.start2;}

- (NSTimeInterval)duration {return self.end - self.start;}


- (void)forwardInBothTo:(NSTimeInterval)newPosition {
    [self forwardInBoth:newPosition - self.position];
}

- (void)forwardInLeftTo:(NSTimeInterval)newPosition {
    [self forwardInLeft:newPosition - self.position];
}

- (void)forwardInRightTo:(NSTimeInterval)newPosition {
    [self forwardInRight:newPosition - self.position];
}

- (void)forwardInBoth:(NSTimeInterval)duration {
    self.position = MAX(MIN(self.position + duration, self.end), self.start);
}

- (void)forwardInLeft:(NSTimeInterval)duration {
    NSTimeInterval change = MAX(MIN(self.position + duration, self.end), self.start) - self.position;
    self.position = self.position + change;
    self.start2 = self.start2 + change;
}

- (void)forwardInRight:(NSTimeInterval)duration {
    NSTimeInterval change = MAX(MIN(self.position + duration, self.end), self.start) - self.position;
    self.position = self.position + change;
    self.start1 = self.start1 + change;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"position:%.1f position1:%.1f position2:%.1f duration:%.1f start1:%.1f start2:%.1f play:%d%d", _position, self.position1, self.position2, self.duration, _start1, _start2, self.leftInRange, self.rightInRange];
}

- (void)forwardLeftPositionTo:(NSTimeInterval)left andRightPositionTo:(NSTimeInterval)right {
    [self forwardPositionTo:(left + right) / 2.0];
}

- (void)forwardPositionTo:(NSTimeInterval)position {
    NSTimeInterval change = position - (self.position1 + self.position2) / 2.0;
    [self forwardInBothTo:self.position + change];
}

- (void)forwardLeftPositionTo:(NSTimeInterval)position {
    NSTimeInterval change = position - self.position1;
    [self forwardInLeft:change];
}

- (void)forwardRightPositionTo:(NSTimeInterval)position {
    NSTimeInterval change = position - self.position2;
    [self forwardInRight:change];
}

- (void)playLeftPositionTo:(NSTimeInterval)position {
    NSTimeInterval duration = position - self.position1;
    NSTimeInterval change = MAX(MIN(self.position + duration, self.end), self.start) - self.position;
    self.position = self.position + change;
}

- (void)playRightPositionTo:(NSTimeInterval)position {
    NSTimeInterval duration = position - self.position2;
    NSTimeInterval change = MAX(MIN(self.position + duration, self.end), self.start) - self.position;
    self.position = self.position + change;
}

@end