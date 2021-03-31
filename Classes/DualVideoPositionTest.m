#import "DualVideoPosition.h"

@interface DualVideoPositionTest : SenTestCase

@end

@implementation DualVideoPositionTest {
    DualVideoPosition* _position;
}

- (void)setUp {
    _position = [[DualVideoPosition alloc] initWithLeftDuration:20 rightDuration:10];
    STAssertEqualObjects(_position.description, @"position:0.0 position1:0.0 position2:0.0 duration:20.0 start1:0.0 start2:0.0 play:11", nil);
}

- (void)testScrubbingBoth {
    [_position forwardInBothTo:10];
    STAssertEqualObjects(_position.description, @"position:10.0 position1:10.0 position2:10.0 duration:20.0 start1:0.0 start2:0.0 play:10", nil);
    [_position forwardInBothTo:30];
    STAssertEqualObjects(_position.description, @"position:20.0 position1:20.0 position2:10.0 duration:20.0 start1:0.0 start2:0.0 play:00", nil);
}

- (void)testScrubOneAtATime {
    [_position forwardInLeft:10];
    STAssertEqualObjects(_position.description, @"position:10.0 position1:10.0 position2:0.0 duration:20.0 start1:0.0 start2:10.0 play:11", nil);
    [_position forwardInLeft:20];
    STAssertEqualObjects(_position.description, @"position:20.0 position1:20.0 position2:0.0 duration:30.0 start1:0.0 start2:20.0 play:01", nil);
    [_position forwardInRight:30];
    STAssertEqualObjects(_position.description, @"position:30.0 position1:20.0 position2:10.0 duration:20.0 start1:10.0 start2:20.0 play:00", nil);
    [_position forwardInRight:-10];
    STAssertEqualObjects(_position.description, @"position:20.0 position1:20.0 position2:0.0 duration:30.0 start1:0.0 start2:20.0 play:01", nil);
    [_position forwardInBoth:5];
    STAssertEqualObjects(_position.description, @"position:25.0 position1:20.0 position2:5.0 duration:30.0 start1:0.0 start2:20.0 play:01", nil);
    [_position forwardInLeft:-1];
    STAssertEqualObjects(_position.description, @"position:24.0 position1:20.0 position2:5.0 duration:29.0 start1:0.0 start2:19.0 play:01", nil);
}

- (void)testPlayBoth {
    [_position forwardLeftPositionTo:10 andRightPositionTo:11];
    STAssertEqualObjects(_position.description, @"position:10.5 position1:10.5 position2:10.0 duration:20.0 start1:0.0 start2:0.0 play:10", nil);
    [_position forwardLeftPositionTo:-10.5];
    //STAssertEqualObjects(_position.description, @"position:0.0 position1:0.0 position2:10.0 duration:30.0 start1:0.0 start2:-10.0 play:10", nil);
}

- (void)testPlayOneAtATime {
    [_position forwardLeftPositionTo:10];
    STAssertEqualObjects(_position.description, @"position:10.0 position1:10.0 position2:0.0 duration:20.0 start1:0.0 start2:10.0 play:11", nil);
    [_position forwardRightPositionTo:1.0];
    STAssertEqualObjects(_position.description, @"position:11.0 position1:10.0 position2:1.0 duration:20.0 start1:1.0 start2:10.0 play:11", nil);
}

@end
