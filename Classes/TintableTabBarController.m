#import "TintableTabBarController.h"

@implementation TintableTabBarController {
}

- (void)addTint:(UIColor*)color {
    [super viewDidLoad];

    CGRect frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, 49);
    UIView* v = [[UIView alloc] initWithFrame:frame];
    v.backgroundColor = color;
    v.alpha = 0.5;
    [self.tabBar addSubview:v];
}

@end