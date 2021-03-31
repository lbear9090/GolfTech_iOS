#import <Foundation/Foundation.h>

@interface NSObject (NSObjectAdditions)

+ (NSSet*)declaredProperties;
- (NSSet*)declaredProperties;
- (BOOL)isPropertyRetained:(NSString*)name;
+ (NSBundle*)bundleForClassMethod:(SEL)selector;
+ (NSBundle*)bundleForInstanceMethod:(SEL)selector;
+ (NSArray*)namesOfSettersForPropertiesOfClass:(Class)clazz;

@end
