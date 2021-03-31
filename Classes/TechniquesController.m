#import "TechniquesController.h"
#import "CategorySelectorView.h"
#import "TechniqueListController.h"
#import "ViewBuilder.h"
#import "UIImageAdditions.h"
#import "UIColorAdditions.h"
#import <MediaPlayer/MediaPlayer.h>
#import "TextViewController.h"
#import <AVKit/AVPlayerViewController.h>



#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
@implementation TechniquesController {
    CategorySelectorView *_selector;
    TechniqueListController *_techniques;
    TextViewController* info;
    AVPlayerViewController *playerViewController;
    UIImageView *imageHolder;
    UIActivityIndicatorView* spinner;
    UIImageView *playBtn;
    Technique* bundledVideo;
    Boolean isIPAD;
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
        bundledVideo.onDownloadCompleted = ^{
            [self playVideo:bundledVideo];
            
        };
        
        return;
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(IPAD) {
      
        
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)    name:UIDeviceOrientationDidChangeNotification  object:nil];

    if(bundledVideo != nil){
       // [self playVideo:bundledVideo];
    }
    }
}

- (void)orientationChanged:(NSNotification *)notification{
    if(isIPAD){
        
        [self adjustViewForResize];
      //  [self playVideo:  bundledVideo];
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
        [playerViewController.view addSubview:imageHolder];
        if(!bundledVideo.isAvailable && bundledVideo.state == NotDownloaded) {
            [playerViewController.view addSubview:playBtn];
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
        if(playBtn != nil){
             [playBtn removeFromSuperview];
           
        }
    }
    

    
    if(isIPAD) {
        [info setTitle:[bundledVideo title]];
        [info setFileName:bundledVideo.identity];
        [info reloadWebView];
    }
}

- (void) viewDidLoad {
    [super viewDidLoad];
        if(isIPAD) {
            NSArray *paths = [ _techniques.tableView indexPathsForVisibleRows];
            BaseCell* cell = (BaseCell*)[_techniques.tableView cellForRowAtIndexPath:paths[0]];
            bundledVideo =cell.domainObject;
           // [self playVideo:  cell.domainObject];
            
           
        }
}
- (void)showVideoPage:(id <VideoItem>)video {
    ////MLog(@"Showing video text %@",video.title);
    Technique* bundledVideo1 = (Technique*) video;

    if(isIPAD) {
        [info setTitle:[bundledVideo1 title]];
        [info setFileName:[bundledVideo1 identity]];
        [info loadView];
    }else{
      [self.navigationController pushViewController:info animated:YES];
    }
  //
}

- (id)init {
    self = [super initWithNibName:nil bundle:nil];
    isIPAD = IPAD;
    return self;
}

- (void)loadView {
    [super loadView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIImageView checkedImageViewNamed:@"logo"]];
    self.view.backgroundColor = [UIColor colorWithRGBHex:0xF1F0F0];
   
    if(isIPAD) {
        info = (TextViewController*)[TextViewController textViewWith:@"" title:@"" inverted:NO];
        [self addVideoPreview2];
    }
    _selector = [self.dependencyInjector createInstanceOfClass:CategorySelectorView.class];
    _techniques = [self.dependencyInjector createInstanceOfClass:TechniqueListController.class];
    _techniques.delegate = self;
    _selector.delegate = _techniques;
    
    [self addChildViewController:_techniques];
    [self.view addSubview:_selector];
    [self.view addSubview:_techniques.view];


   
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(isIPAD){
        
        [self adjustViewForResize];
        [self playVideo:  bundledVideo];
        [playerViewController.player pause] ;
        
    }
}

-(void) movieFinished {
    NSLog(@"movie finito");
}
-(void) addVideoPreview2 {
    playerViewController = [[AVPlayerViewController alloc] init];
    playerViewController.player = [AVPlayer playerWithURL:[[NSBundle mainBundle]
                                                           URLForResource:@"Besan"
                                                           withExtension:@"mp4"]];
    
    [self.view addSubview:playerViewController.view];
    

    
 



}
-(void) adjustViewForResize {
    CGRect currentFrame = self.view.frame;
    
    currentFrame.size.width =  currentFrame.size.width - ( currentFrame.size.width / 3.5 );
    currentFrame.size.height =  currentFrame.size.height - ( currentFrame.size.height / 2.4 );
    currentFrame.origin.y=0;
    playerViewController.view.frame = currentFrame;//CGRectMake(0, 0, 600, 370);
  //  movieBox.frame = currentFrame;
    

    
    
    CGRect currentFrame1 = self.view.frame;
    currentFrame1.size.width =  currentFrame1.size.width - ( currentFrame1.size.width / 3.5 );
    currentFrame1.origin.y = currentFrame1.size.height - ( currentFrame1.size.height / 2.2 ) + 40; // currentFrame.size.height + 100;
    currentFrame1.size.height =  ( currentFrame1.size.height / 2.2 ) -75;
    info.view.frame =currentFrame1;
    
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    ViewBuilder *builder = [ViewBuilder verticalBuilderForView:self.view];
   //  ViewBuilder *builder = [ViewBuilder horizontalBuilderForView:self.view];
    [builder addSpace:74 + 8*2];
    [builder addFlexibleSpaceWithFactor:1];

   
    
    ViewBuilderResult *result = [builder build];
    if(isIPAD){
        CGRect rect = [result frameAtIndex:0];
        
        rect.origin.x = rect.size.width - ( rect.size.width / 3.5 );
        rect.size.width = rect.size.width / 3.5;
        _selector.frame = rect;
        
        _techniques.view.frame = [result frameAtIndex:1];
        CGRect  rectList =[result frameAtIndex:1];
        rectList.origin.x = rectList.size.width - ( rectList.size.width / 3.5 );
        rectList.size.width = ( rectList.size.width / 3.5);

        _techniques.view.frame = rectList;

        
        CGRect currentFrame1 = self.view.frame;
        currentFrame1.size.width =  currentFrame1.size.width - ( currentFrame1.size.width / 3.5 );
        currentFrame1.origin.y = currentFrame1.size.height - ( currentFrame1.size.height / 2.2 ) + 40; // currentFrame.size.height + 100;
        currentFrame1.size.height =  ( currentFrame1.size.height / 2.2 ) -75;
        info.view.frame =currentFrame1;
        info.view.backgroundColor = [UIColor whiteColor];
        [self addChildViewController:info];
        [self.view addSubview:info.view];
        
        
    } else {
        _selector.frame = [result frameAtIndex:0];
        _techniques.view.frame = [result frameAtIndex:1];
    }

}

@end
