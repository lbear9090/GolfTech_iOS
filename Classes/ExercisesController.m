#import "AbstractVideosController.h"
#import "ExercisesController.h"
#import "ExerciseCell.h"
#import "UIImageAdditions.h"
#import "StatisticsController.h"
#import "PagerController.h"
#import "ScoreController.h"
#import "UIColorAdditions.h"
#import "GPSNavigationController.h"
#import <AVKit/AVPlayerViewController.h>
#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
@implementation ExercisesController {
    Boolean isIPAD;
}
@synthesize delegate,resultClass;
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

- (void)loadView {
    [super loadView];
    isIPAD = IPAD;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor colorWithRGBHex:0xF1F0F0];


    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIImageView checkedImageViewNamed:@"logo"]];
    self.navigationItem.title = @"Öva";
        if(!isIPAD) {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Statistik", nil) style:UIBarButtonItemStylePlain target:self action:@selector(openStatistics)];
    }
    NSMutableArray* objects = [NSMutableArray array];
    for(Category* category in self.repository.findScorableCategories) {
        [objects addObject:category.scorables];
    }
    NSAssert(objects.count == 4, nil);
    self.domainObjectArrays = objects;
}

#pragma mark BaseTableViewController

- (NSArray*)cellClasses {
    
    if(resultClass != nil)
        return resultClass;
    resultClass = [NSMutableArray array];
    for(int i = 0; i < self.repository.findScorableCategories.count; i++) {
        [resultClass addObject:ExerciseCell.class];
    }

    return resultClass;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0 : [UIImageView checkedImageViewNamed:@"ova separator"].bounds.size.height;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    static NSMutableArray* result = nil;
    if(result == nil) {
        result = [NSMutableArray arrayWithCapacity:4];
        for(int i = 0; i < self.domainObjectArrays.count; i++) {
            result[i] = [UIImageView checkedImageViewNamed:@"ova separator"];
        }
    }
    return result[section];
}

#pragma mark EnterScoreControllerDelegate

- (void)didEnterScoreForExercise:(Exercise*)exercise {
    [self openStatistics:exercise];
}

#pragma mark UIViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"Before reloading exercise");
    [self.tableView reloadData];
    NSLog(@"After reloading exercise");
}

#pragma mark private

- (void)openStatistics:(Exercise*)exercise {
    StatisticsController* stats = [self.dependencyInjector createInstanceOfClass:StatisticsController.class];
    stats.exercise = exercise;
    UIViewController* pager = [PagerController pagerControllerWithPages:@[stats]];
    [self.navigationController pushViewController:pager animated:YES];

    dispatch_async(dispatch_get_main_queue(), ^{
        //[self pager:pager moveToExercise:exercise];
    });
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

- (void)edit:(Exercise*)exercise {
    AssertNotNull(exercise);
    EnterScoreController* detail = [self.dependencyInjector createInstanceOfClass:[EnterScoreController class]];
    detail.exercise = exercise;
    detail.delegate = self;
    UINavigationController* ctrl = [[GPSNavigationController alloc] initWithRootViewController:detail];
    [self.navigationController presentViewController:ctrl animated:YES completion:^{
    }];
}

@end
