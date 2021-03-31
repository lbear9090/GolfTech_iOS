#import "TabBarBuilder.h"
#import "UIImageAdditions.h"
#import "GPSNavigationController.h"

@interface TabBarBuilder ()
@property(nonatomic, strong) NSMutableArray *tabs;
@end


@implementation TabBarBuilder

- (id)init {
    self.tabs = ([[NSMutableArray class] new]);
    return self;
}


- (void)addPlainTab:(UIViewController *)tab image:(NSString *)resourceName tabTitle:(NSString *)tabTitle {
    UIImage *image = [UIImage checkedImageNamed:resourceName];
    tab.tabBarItem = ([[UITabBarItem class] new]);
    tab.tabBarItem.image = image;
    tab.tabBarItem.title = tabTitle;
    [self.tabs addObject:tab];
}

- (void)addNavigationTab:(UIViewController *)content image:(NSString *)resourceName tabTitle:(NSString *)tabTitle pageTitle:(NSString *)pageTitle {
    content.title = pageTitle;
    UINavigationController *tab = [[GPSNavigationController alloc] initWithRootViewController:content];
    if([tab.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
        //tab.navigationBar.barTintColor = self.tintColor;
    } else {
        //tab.navigationBar.tintColor = self.tintColor;
    }
    [self addPlainTab:tab image:resourceName tabTitle:tabTitle];
}

- (UITabBarController *)build {
    UITabBarController *ctrl = [UITabBarController new];
    ctrl.viewControllers = self.tabs;
    return ctrl;
}

#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navCtrl willShowViewController:(UIViewController *)viewCtrl animated:(BOOL)animated {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}

- (void)navigationController:(UINavigationController *)navCtrl didShowViewController:(UIViewController *)viewCtrl animated:(BOOL)animated {
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

@end
