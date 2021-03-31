#import <Foundation/Foundation.h>

@interface TabBarBuilder : NSObject <UINavigationControllerDelegate>
- (void)addPlainTab:(UIViewController*)tab image:(NSString*)resourceName tabTitle:(NSString*)tabTitle;
- (void)addNavigationTab:(UIViewController*)content image:(NSString*)resourceName tabTitle:(NSString*)tabTitle pageTitle:(NSString*)pageTitle;
- (UITabBarController*)build;
@end
