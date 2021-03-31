#import "Isgl3dDirector.h"
#import "AppDelegate.h"
#import "DependencyInjector.h"
#import "TabBarBuilder.h"
#import "ScoreController.h"
#import "Reachability.h"
#import "TechniqueListController.h"
#import "TechniquesController.h"
#import "ExercisesController.h"
#import "CameraController.h"
#import "ScrollWheel.h"
#import "AudioVideoFactory.h"
#import "DemoController.h"
#import "UIColorAdditions.h"
#import "VideoController.h"
#import "ExerciseVideoController.h"

#ifndef NSFoundationVersionNumber_iOS_7_1
# define NSFoundationVersionNumber_iOS_7_1 1047.25
#endif
#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
@interface AppDelegate ()
@property(nonatomic, strong) UITabBarController *tabBarCtrl;
@property(nonatomic, strong) Repository *repository;

@end


@implementation AppDelegate {
    DependencyInjector *_injector;
   
}
@synthesize window = _window,shouldRotate;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    shouldRotate = false;
    
    //[ScrollWheel performSelector:@selector(preloadWheel) withObject:nil afterDelay:0];
    _injector = [[DependencyInjector class] new];
    [_injector registerSingleton:NSFileManager.defaultManager withName:@"fileManager"];
    [_injector registerSingleton:[Reachability reachabilityForLocalWiFi] withName:@"reachability"];
    [_injector singletonOfClass:AudioVideoFactory.class];
    self.repository = [_injector singletonOfClass:[Repository class]];
    [_injector singletonOfClass:[Device class]];

    UIViewController *technique = [_injector autowire:[TechniquesController new]];
   
    UIViewController *exercise = nil;//[_injector autowire:[ExercisesController new]];
    VideoController *proVideos = nil;
    VideoController *myVideos = nil;
    if(IPAD) {
            exercise = [_injector autowire:[ExerciseVideoController new]];
        
      proVideos = [_injector autowire:[VideoController new]];
      myVideos = [_injector autowire:[VideoController new]];
    
        myVideos.myVideo = true;
        
    } else {
           exercise = [_injector autowire:[ExercisesController new]];
       proVideos = [_injector autowire:[CameraController cameraControllerWithVideosEditable:NO]];
       myVideos = [_injector autowire:[CameraController cameraControllerWithVideosEditable:YES]];
    }
   
    //UIViewController *myVideos = [_injector autowire:[CameraController cameraControllerWithVideosEditable:YES]];

    //UIViewController* manual = [TextViewController textViewWith:@"manual" title:nil inverted:YES];
    UIViewController *demo = [DemoController new];

    TabBarBuilder *tabs = [_injector createInstanceOfClass:[TabBarBuilder class]];
   [tabs addNavigationTab:technique image:@"tab teknik" tabTitle:NSLocalizedString(@"Teknik", nil) pageTitle:NSLocalizedString(@"Teknik", nil)];
    [tabs addNavigationTab:proVideos image:@"tab pro video" tabTitle:NSLocalizedString(@"Pro video", nil) pageTitle:NSLocalizedString(@"Pro video", nil)];
    [tabs addNavigationTab:myVideos image:@"tab mina video" tabTitle:NSLocalizedString(@"Mina video", nil) pageTitle:NSLocalizedString(@"Mina video", nil)];
    [tabs addNavigationTab:exercise image:@"tab ova" tabTitle:NSLocalizedString(@"Öva", nil) pageTitle:NSLocalizedString(@"Öva", nil)];
    [tabs addNavigationTab:demo image:@"tab demo" tabTitle:NSLocalizedString(@"Mer", nil) pageTitle:nil];
    self.tabBarCtrl = [tabs build];

    

    _window = self.window;
    _window.backgroundColor = UIColor.whiteColor;
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
     //  self.tabBarCtrl.delegate = self;
    _window.rootViewController = self.tabBarCtrl;
    [_window makeKeyAndVisible];

    [self modifyAppearance];

    return YES;
}

-(NSUInteger)application:(UIApplication *)application
supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        return UIInterfaceOrientationMaskPortrait;
    
}else  /* iPad */ {
    if(shouldRotate) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }else{
        return UIInterfaceOrientationMaskLandscape;
    }
}
}

#pragma clang diagnostic push
#pragma ide diagnostic ignored "UnavailableInDeploymentTarget"

- (void)modifyAppearance {
    if(![_window respondsToSelector:@selector(setTintColor:)])
        return;

    UIColor *tint = [UIColor colorWithRGBHex:BrandedHexColor];
    _window.tintColor = UIColor.whiteColor;

    NSDictionary *textColor = @{NSForegroundColorAttributeName : UIColor.whiteColor};
    [UINavigationBar appearance].titleTextAttributes = textColor;
    [UINavigationBar appearance].barTintColor = tint;

    [UITabBar appearance].tintColor = tint; // color selected icon
    [UITabBar appearance].barTintColor = UIColor.whiteColor; // color tab bar

    [UITextField appearance].tintColor = [UIColor blackColor];
    [UITextView appearance].tintColor = [UIColor blackColor];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma clang diagnostic pop

- (void)applicationWillResignActive:(UIApplication *)application {
  //  Isgl3dDirector *director = [Isgl3dDirector sharedInstance];
  //  [director stopAnimation];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    AssertNotNull(self.repository);
    [self.repository save];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
   // Isgl3dDirector *director = [Isgl3dDirector sharedInstance];
    //[director startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    AssertNotNull(self.repository);
    [self.repository save];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Meddelande" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

@end
