#import "Result.h"

@interface Result ()
@property(nonatomic, assign) NSTimeInterval timeValue;
@end


@implementation Result
@dynamic timeValue, exerciseId;

- (id)initWithEntity:(NSEntityDescription*)entity insertIntoManagedObjectContext:(NSManagedObjectContext*)context {
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    return self;
}

- (void)awakeFromInsert {
    NSTimeInterval now = [[NSDate date] timeIntervalSinceReferenceDate];
    [self setValue:@(now) forKey:@"timeValue"];
}

- (NSDate*)time {
    return [NSDate dateWithTimeIntervalSinceReferenceDate:[[self valueForKey:@"timeValue"] doubleValue]];
}

- (NSUInteger)score {
    [self willAccessValueForKey:@"score"];
    NSNumber* result = [self primitiveValueForKey:@"score"];
    [self didAccessValueForKey:@"score"];
    return [result integerValue];
}

- (void)setScore:(NSUInteger)score {
    [self willChangeValueForKey:@"score"];
    [self setPrimitiveValue:[NSNumber numberWithInteger:score] forKey:@"score"];
    [self didChangeValueForKey:@"score"];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Result(%p,exerciseId:%@,%@,score:%d)", self, self.exerciseId, self.time, self.score];
}

@end
