//
//  ExerciseVideoController.m
//  Golf
//
//  Created by Thomas on 10/05/15.
//
//

#import "ExerciseVideoController.h"
#import "TechniquesController.h"
#import "CategorySelectorView.h"
#import "TechniqueListController.h"
#import "ViewBuilder.h"
#import "UIImageAdditions.h"
#import "UIColorAdditions.h"
#import <MediaPlayer/MediaPlayer.h>
#import "TextViewController.h"
#import "ExercisesController.h"
#import "ScoreController.h"
#import "StatisticsController.h"
#import "PagerController.h"
#import <AVKit/AVPlayerViewController.h>
#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@implementation ExerciseVideoController {
    ExercisesController *exercise;
    //TechniqueListController *_techniques;
    TextViewController* info;
    MPMoviePlayerController *player;
    AVPlayerViewController *playerViewController;
    UIImageView *imageHolder;
    UIActivityIndicatorView* spinner;
    UIImageView *playBtn;
    Technique* bundledVideo;
    UIView *movieBox;
}


-(void)tapDetected{
    NSLog(@"single Tap on imageview");
    //Technique* bundledVideo = (Technique*) video;
    if(!bundledVideo.isAvailable && bundledVideo.state == NotDownloaded) {
        [playBtn removeFromSuperview];
        if(spinner != nil) [spinner removeFromSuperview];
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.frame =playerViewController.view.frame;
        [spinner startAnimating];
        [playerViewController.view addSubview:spinner];
        [bundledVideo startDownload];
         __block ExerciseVideoController *blocksafeSelf = self;
        bundledVideo.onDownloadCompleted = ^{
           [blocksafeSelf playVideo:bundledVideo];
            
        };
        
        return;
    }
}

-(void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
        [playerViewController.player pause] ;
}

- (void)playVideo:(id <VideoItem>)video {
    
    bundledVideo = (Technique*) video;
    playerViewController.player = [AVPlayer playerWithURL:bundledVideo.videoUrl];
    [playerViewController.player play];
    
    if(bundledVideo.state !=  Downloaded){
        if(imageHolder != nil) {
            [imageHolder removeFromSuperview];
        }
        if(playBtn !=nil){
            [playBtn removeFromSuperview];
        }
        movieBox = [[UIView alloc] initWithFrame:playerViewController.view.frame];
        [movieBox setBackgroundColor:[UIColor blackColor]];
        imageHolder = [[UIImageView alloc] initWithFrame:playerViewController.view.frame];
        playBtn =[[UIImageView alloc]init ];
        playBtn.image =[UIImage imageNamed:@"PlayButton.png"];
        CGRect currentFrame = CGRectMake(playerViewController.view.frame.size.width / 2,
                                         playerViewController.view.frame.size.height / 2,
                                         75, 75);
        
        playBtn.frame = currentFrame;
        UITapGestureRecognizer *single_tap_recognizer;
        playBtn.contentMode = UIViewContentModeScaleAspectFit;
        single_tap_recognizer = [[UITapGestureRecognizer alloc] initWithTarget : self action: @selector(tapDetected)] ;
        [single_tap_recognizer setNumberOfTouchesRequired : 1];
        [playBtn addGestureRecognizer : single_tap_recognizer];
        [playBtn setUserInteractionEnabled:YES];
        
        imageHolder.image = [video image];
        imageHolder.contentMode = UIViewContentModeScaleAspectFit;
        
       
        if(!bundledVideo.isAvailable && bundledVideo.state == NotDownloaded) {
            [playerViewController.view addSubview:movieBox];
             [playerViewController.view addSubview:imageHolder];
            [playerViewController.view addSubview:playBtn];
        } else {
           [playerViewController.view addSubview:imageHolder];
        }
        
        
        if(bundledVideo.state == Downloading) {
            // Add spinner
            if(spinner != nil) [spinner removeFromSuperview];
            spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            spinner.frame =playerViewController.view.frame;
            [spinner startAnimating];
            [playerViewController.view addSubview:spinner];
            
        }
        
    } else {

        if(bundledVideo.state == Downloading) {
            // Add spinner
            if(spinner != nil) [spinner removeFromSuperview];
            spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            spinner.frame =playerViewController.view.frame;
            [spinner startAnimating];
            [playerViewController.view addSubview:spinner];
            
        }
        if(imageHolder !=nil) {
            [imageHolder removeFromSuperview];
            [spinner stopAnimating];
            [spinner removeFromSuperview];
            
        }
        if(movieBox != nil) {
            [movieBox removeFromSuperview];
        }
        if(playBtn != nil){
            [playBtn removeFromSuperview];
            
        }
    }
    

    [playerViewController.player pause] ;
    [info setTitle:[bundledVideo title]];
    [info setFileName:bundledVideo.identity];
    [info reloadWebView];
  //  if(IPAD) {

   // }
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)    name:UIDeviceOrientationDidChangeNotification  object:nil];

    [self adjustViewForResize];
}
- (void)orientationChanged:(NSNotification *)notification{
   // if(isIPAD){
        
     //   [self adjustViewForResize];
       // [self playVideo:  bundledVideo];
    //}
}

- (void) viewDidLoad {
    [super viewDidLoad];
    if(IPAD) {
       // NSArray *paths = [ exercise.tableView indexPathsForVisibleRows];
       // BaseCell* cell = [(BaseCell*)[exercise.tableView cellForRowAtIndexPath:paths[0]];
      //                    [exercise.domainObjectArrays objectAtIndex:0];
        bundledVideo =[[exercise.domainObjectArrays objectAtIndex:0] objectAtIndex:0];
      
    }
}
- (void)showVideoPage:(id <VideoItem>)video {
    ////MLog(@"Showing video text %@",video.title);
    Technique* bundledVideo1 = (Technique*) video;
    
    //if(IPAD) {
        [info setTitle:[bundledVideo1 title]];
        [info setFileName:[bundledVideo1 identity]];
        [info loadView];
    //}
}

- (id)init {
    self = [super initWithNibName:nil bundle:nil];
    
    return self;
}

- (void)loadView {
    [super loadView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIImageView checkedImageViewNamed:@"logo"]];
    self.view.backgroundColor = [UIColor colorWithRGBHex:0xF1F0F0];
    if(!IPAD) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Statistik", nil) style:UIBarButtonItemStylePlain target:self action:@selector(openStatistics)];
    }
   // if(IPAD) {
        info = (TextViewController*)[TextViewController textViewWith:@"" title:@"" inverted:NO];
        
   // }
  
    exercise = [self.dependencyInjector createInstanceOfClass:ExercisesController.class];
    exercise.delegate = self;
 
    
    [self addChildViewController:exercise];

    [self.view addSubview:exercise.view];
  //  if(IPAD){
        
        [self addVideoPreview2];
   // }
    CGRect currentFrame = self.view.frame;
    
    currentFrame.size.width =  currentFrame.size.width - ( currentFrame.size.width / 3 );
    currentFrame.size.height =  currentFrame.size.height - ( currentFrame.size.height / 2.5 );
    
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)openStatistics {
    NSMutableArray* pages = [NSMutableArray array];
    [pages addObject:[self.dependencyInjector createInstanceOfClass:ScoreController.class]];
    for(Category* category in self.repository.findScorableCategories) {
        for(Exercise* scorable in category.scorables) {
            StatisticsController* stats = [self.dependencyInjector createInstanceOfClass:StatisticsController.class];
            stats.exercise = scorable;
            [pages addObject:stats];
        }
    }
    UIViewController* pager = [PagerController pagerControllerWithPages:pages];
    [self.navigationController pushViewController:pager animated:YES];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(IPAD){
        
        [self adjustViewForResize];
       // [self playVideo:  bundledVideo];
        
    }
}

-(void) movieFinished {
    NSLog(@"movie finito");
}
-(void) adjustViewForResize {
    CGRect currentFrame = self.view.frame;
    
    currentFrame.size.width =  currentFrame.size.width - ( currentFrame.size.width / 3.5 );
    currentFrame.size.height =  currentFrame.size.height - ( currentFrame.size.height / 2.4 );
    currentFrame.origin.y=0;
    playerViewController.view.frame = currentFrame;//CGRectMake(0, 0, 600, 370);
  
      if(imageHolder !=nil) {
          imageHolder.frame =currentFrame;
      }
    
    
    
    CGRect currentFrame1 = self.view.frame;
    currentFrame1.size.width =  currentFrame1.size.width - ( currentFrame1.size.width / 3.5 );
    currentFrame1.origin.y = currentFrame1.size.height - ( currentFrame1.size.height / 2.4 ) + 40; // currentFrame.size.height + 100;
    currentFrame1.size.height =  ( currentFrame1.size.height / 2.2 ) -75;
    info.view.frame =currentFrame1;
    
}

-(void) addVideoPreview2 {
    playerViewController = [[AVPlayerViewController alloc] init];
    playerViewController.player = [AVPlayer playerWithURL:[[NSBundle mainBundle]
                                                           URLForResource:@"Besan"
                                                           withExtension:@"mp4"]];
    

    CGRect currentFrame = self.view.frame;
    
    currentFrame.size.width =  currentFrame.size.width - ( currentFrame.size.width / 3.5 );
    currentFrame.size.height =  currentFrame.size.height - ( currentFrame.size.height / 2.4 );
    currentFrame.origin.y=0;
    playerViewController.view.frame = currentFrame;//CGRectMake(0, 0, 600, 370);
    
        [self.view addSubview:playerViewController.view];

    [self addChildViewController:info];
    [self.view addSubview:info.view];
    


    
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
  
        CGRect rect = self.view.frame;
        
        rect.origin.x = rect.size.width - ( rect.size.width / 3.5 );
        rect.origin.y = 0;
        rect.size.width = rect.size.width / 3.5;
        
        exercise.view.frame =rect;
    CGRect currentFrame = self.view.frame;
    
    currentFrame.size.width =  currentFrame.size.width - ( currentFrame.size.width / 3.5 );
    currentFrame.size.height =  currentFrame.size.height - ( currentFrame.size.height / 2.4 );
    currentFrame.origin.y=0;
    playerViewController.view.frame = currentFrame;//CGRectMake(0, 0, 600, 370);
        CGRect currentFrame1 = self.view.frame;
        currentFrame1.size.width =  currentFrame1.size.width - ( currentFrame1.size.width / 3.45 );
        currentFrame1.origin.y = currentFrame1.size.height - ( currentFrame1.size.height / 2.4 ) + 40; // currentFrame.size.height + 100;
        currentFrame1.size.height =  ( currentFrame1.size.height / 2.2 ) -75;
        info.view.frame =currentFrame1;
        info.view.backgroundColor = [UIColor whiteColor];

        
        

    
}
@end
