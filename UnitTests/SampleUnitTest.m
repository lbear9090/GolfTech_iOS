@interface SampleUnitTest : SenTestCase

@end

@implementation SampleUnitTest

- (void)testExample {
    [OCMockObject mockForClass:NSString.class];
}

@end
