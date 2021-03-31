#import "NSArray+NSArrayGPSAdditions.h"

@implementation NSArray (NSArrayGPSAdditions)

- (NSArray*)arrayByDeletingObject:(id)object {
    NSMutableArray* result = [self mutableCopy];
    [result removeObject:object];
    return result;
}

@end