#import "TextViewController.h"

//@interface TextViewController ()
//@property(nonatomic, strong) UIWebView* webView;
//@property(nonatomic, assign) BOOL inverted;
//@property(nonatomic, copy) NSString* fileName;
//@property NSString *lastName;
//- (void)  setFileName:(NSString *)fileName;
//@end

@implementation TextViewController
@synthesize fileName,lastName;
+ (id)textViewWith:(NSString*)aFileName title:(NSString*)title inverted:(BOOL)inverted {
    TextViewController* result = [[TextViewController class] new];
    result.fileName = aFileName;
    result.title = title;
    result.inverted = inverted;
    return result;
}

- (void)reloadWebView {
    NSString* path = [[NSBundle mainBundle] pathForResource:self.fileName ofType:@"html"];
    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:path], @"Couldn't find resource %@", path);
    NSLog(@"Showing %@", path);
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];

    [self.webView loadRequest:request];

}

- (void)loadView {
    [super loadView];
    NSString* path = [[NSBundle mainBundle] pathForResource:self.fileName ofType:@"html"];
    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:path], @"Couldn't find resource %@", path);
    NSLog(@"Showing %@", path);
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    self.webView = ([[UIWebView class] new]);
    self.webView.delegate = self;
    [self.webView loadRequest:request];
    self.webView.alpha = 1; //0.001;
    [self.view addSubview:self.webView];

    id scrollView = (self.webView.subviews)[0];
    if([scrollView respondsToSelector:@selector(setIndicatorStyle:)])
        [scrollView setIndicatorStyle:self.inverted ? UIScrollViewIndicatorStyleWhite : UIScrollViewIndicatorStyleBlack];

    self.view.backgroundColor = self.inverted ? [UIColor blackColor] : [UIColor whiteColor];

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Tillbaka", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.webView.frame = self.view.bounds;
    //if(self.navigationItem.leftBarButtonItem == nil)
    //	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIImageView checkedImageViewNamed:@"logo"]];
}

#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView*)aWebView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    if(navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView*)aWebView {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:0.2];
    [UIView setAnimationDuration:0.2];
    self.webView.alpha = 1;
    self.webView.backgroundColor =[UIColor whiteColor];
    [UIView commitAnimations];
}

@end
