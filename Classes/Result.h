#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Result : NSManagedObject {
}
@property(nonatomic, copy) NSString* exerciseId;
@property(nonatomic, weak, readonly) NSDate* time;
@property(nonatomic, assign) NSUInteger score;
@end
