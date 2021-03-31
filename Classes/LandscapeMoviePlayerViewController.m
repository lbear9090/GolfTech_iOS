#import "LandscapeMoviePlayerViewController.h"

@implementation LandscapeMoviePlayerViewController
#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);    // ios < 6
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    //return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
    return UIInterfaceOrientationLandscapeLeft;  // ios 6
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate {
    if(IPAD) {
    return YES;
    } else {
        return NO;
    }
}

@end
