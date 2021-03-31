#import <MediaPlayer/MediaPlayer.h>
#import "AbstractVideosController.h"
#import "LandscapeMoviePlayerViewController.h"
#import "TextViewController.h"
#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
@implementation AbstractVideosController {
    Boolean isIPAD;
}

+ (void)initialize {
    [super initialize];
    static BOOL intialized = NO;
    if(intialized)
        return;
    intialized = YES;
    /*
    NSURLCredential *credential = [NSURLCredential credentialWithUser:decode("eurppd") password:decode("dnhuvehujd") persistence:NSURLCredentialPersistenceForSession];
    NSURLProtectionSpace *protectionSpace = [[NSURLProtectionSpace alloc] initWithHost:@"www.golfclinic.se" port:80 protocol:@"http" realm:nil authenticationMethod:NSURLAuthenticationMethodDefault];
    [[NSURLCredentialStorage sharedCredentialStorage] setDefaultCredential:credential forProtectionSpace:protectionSpace];
    */
}

- (id)init {
    self = [super initWithStyle:UITableViewStylePlain];
    isIPAD =IPAD;
    return self;
}

- (void)playVideo:(id <VideoItem>)video {
    NSURL* url = video.videoUrl;
    MLog(@"Playing %@", url);
    LandscapeMoviePlayerViewController* player = [[LandscapeMoviePlayerViewController alloc] initWithContentURL:url];
    [self presentMoviePlayerViewControllerAnimated:player];
    [player.moviePlayer play];
}

- (void)showVideoPage:(id <VideoItem>)video {
    ////MLog(@"Showing video text %@",video.title);
    if(!isIPAD) {
     Technique* bundledVideo = (Technique*) video;
     UIViewController* info = [TextViewController textViewWith:[bundledVideo identity] title:[bundledVideo title] inverted:NO];
     [self.navigationController pushViewController:info animated:YES];
    }
}

@end