#import "DemoController.h"
#import "UIImageAdditions.h"
#import "LandscapeMoviePlayerViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
@interface DemoController () <MFMailComposeViewControllerDelegate>
@property(nonatomic, strong) UIImageView *background;
@end

@implementation DemoController {
    UIButton *_button[5];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIImageView checkedImageViewNamed:@"logo"]];
    if(IPAD) {
      self.background = [UIImageView checkedImageViewNamed:@"about"];
    } else {
      self.background = [UIImageView checkedImageViewNamed:@"bakgrund demo"];
    }
    [self.view addSubview:self.background];
    self.background.userInteractionEnabled = YES;

    _button[0] = ([self createButtonWithTitle:@"Instruktion" selector:@selector(playPressed:)]);
    _button[1] = ([self createButtonWithTitle:@"Feedback" selector:@selector(feedbackPressed:)]);
    _button[2] = ([self createButtonWithTitle:@"Nyhetsbrev" selector:@selector(subscribePressed:)]);
    _button[3] = ([self createButtonWithTitle:@"Facebook" selector:@selector(facebookPressed:)]);
    _button[4] = ([self createButtonWithTitle:@"Att spela in" selector:@selector(playSpelaPressed:)]);

    self.view.backgroundColor = UIColor.whiteColor;
}

- (UIButton *)createButtonWithTitle:(NSString *)title selector:(SEL)selector {
    UIButton *result = [UIButton buttonWithType:UIButtonTypeCustom];
    [result setTitle:title forState:UIControlStateNormal];
    UIImage *image = [[UIImage checkedImageNamed:@"GreenOpaqueButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [result setBackgroundImage:image forState:UIControlStateNormal];
    [result addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    result.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [result sizeToFit];
    result.frame = CGRectMake(0, 0, 90, result.frame.size.height);
    [self.background addSubview:result];
    return result;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.background.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.background.bounds.size.width, self.background.bounds.size.height);

    CGFloat spacing = 50;
    CGRect rect = self.background.bounds;
    CGFloat x = rect.size.width * 0.78;
    CGFloat y = rect.size.height * 0.1;
    int i = -1;
    _button[++i].center = CGPointMake(x, y + i * spacing);
    _button[++i].center = CGPointMake(x, y + i * spacing);
    _button[++i].center = CGPointMake(x, y + i * spacing);
    _button[++i].center = CGPointMake(x, y + i * spacing);
    _button[++i].center = CGPointMake(x, y + i * spacing);
}

- (void)playPressed:(id)sender {
    LandscapeMoviePlayerViewController *player = [[LandscapeMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:@"https://golftech.se/golftechvideos/sv/demo.mp4"]];
    [self presentMoviePlayerViewControllerAnimated:player];
    [player.moviePlayer play];
}

- (void)feedbackPressed:(id)sender {
    [self composeEmailWithTitle:NSLocalizedString(@"Feedback titel", nil) message:NSLocalizedString(@"Feedback email text", nil)];
}

- (void)subscribePressed:(id)sender {
    [self composeEmailWithTitle:NSLocalizedString(@"Nyhetsbrev titel", nil) message:NSLocalizedString(@"Nyhetsbrev text", nil)];
}

- (void)facebookPressed:(id)sender {
    NSURL *facebookURL = [NSURL URLWithString:@"fb://profile/185522031560523"];
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:facebookURL]) {
        [app openURL:facebookURL];
    } else {
        [app openURL:[NSURL URLWithString:@"https://facebook.com/185522031560523"]];
    }
}

- (void)playSpelaPressed:(id)sender {
    LandscapeMoviePlayerViewController *player = [[LandscapeMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:@"https://golftech.se/golftechvideos/sv/spela-in.mp4"]];
    [self presentMoviePlayerViewControllerAnimated:player];
    [player.moviePlayer play];
}

- (void)composeEmailWithTitle:(NSString *)title message:(NSString *)message {
    if(![MFMailComposeViewController canSendMail]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Email saknas", nil)
            message:NSLocalizedString(@"Det går inte att skicka email", nil)
            delegate:nil
            cancelButtonTitle:NSLocalizedString(@"OK", nil)
            otherButtonTitles:nil];
        [alert show];
        return;
    }
    MFMailComposeViewController *controller = [MFMailComposeViewController new];
    controller.toRecipients = @[NSLocalizedString(@"Email feedback", @"info@golftech.se")];
    controller.subject = title;
    controller.mailComposeDelegate = self;
    [controller setMessageBody:message isHTML:NO];
    [self presentViewController:controller animated:YES completion:nil];
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
