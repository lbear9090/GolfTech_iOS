#import "TechniqueListController.h"
#import "TechniqueCell.h"
#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
@implementation TechniqueListController {
    Boolean isIPAD;
}
@synthesize delegate;
- (id)init {
    self = [super init];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    isIPAD = IPAD;
    return self;
}

- (NSArray*)cellClasses {
    static NSArray* result = nil;
    if(result == nil)
        result = @[[TechniqueCell class]];
    return result;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self chooseCategory:self.repository.findCategories[0]];

}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat below = self.tabBarController.tabBar.bounds.size.height;
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, below, 0); // TODO
    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;
}

- (void)chooseCategory:(Category*)category {

    self.domainObjectArrays = @[category.techniques,];
    
    [self.tableView reloadData];

}

- (void)didSelectCategory:(Category*)category {
    [self chooseCategory:category];
}

- (void)playVideo:(id <VideoItem>)video {
    Technique* technique = (Technique*) video;


    if(isIPAD) {
         [delegate playVideo:video];
    } else {
        if(!technique.isAvailable && technique.state == NotDownloaded) {
               [technique startDownload];
              return;
          }
        if(technique.state != Downloaded)
            return;
        [super playVideo:video];
    }
   
    
  
}

@end