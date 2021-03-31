#import <Foundation/Foundation.h>

@interface PagerController : UIViewController <UIScrollViewDelegate>
+ (UIViewController*)pagerControllerWithPages:(NSArray*)array;
- (void)moveToPage:(NSUInteger)page;
@end