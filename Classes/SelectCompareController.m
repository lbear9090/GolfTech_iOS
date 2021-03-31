#import "SelectCompareController.h"
#import "NSArray+NSArrayGPSAdditions.h"
#import "SelectRecordingCell.h"
#import "CompareVideoController.h"
#import "UIColorAdditions.h"

@interface SelectCompareController ()
@property(nonatomic, strong) UISegmentedControl *videoTypeSelector;
@end

@implementation SelectCompareController {
}

- (NSArray *)cellClasses {
    return @[SelectRecordingCell.class];
}

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = UIColor.redColor;
    self.navigationItem.title = NSLocalizedString(@"Jämför med", nil);

    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor colorWithRGBHex:0xF1F0F0];

    self.videoTypeSelector = [[UISegmentedControl alloc] initWithItems:@[@"Pro video", @"Mina video"]];
    self.videoTypeSelector.tintColor = [UIColor colorWithRGBHex:BrandedHexColor];
    self.videoTypeSelector.selectedSegmentIndex = 0;
    [self.videoTypeSelector addTarget:self action:@selector(videoTypePressed:) forControlEvents:UIControlEventValueChanged];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.videoTypeSelector.frame.size.height + 30)];
    self.videoTypeSelector.center = self.tableView.tableHeaderView.center;
    [self.tableView.tableHeaderView addSubview:self.videoTypeSelector];

    AssertNotNull(self.alreadySelectedItem);
    [self loadData];
}

- (void)loadData {
    self.domainObjectArrays = self.videoTypeSelector.selectedSegmentIndex == 0 ? @[[self.repository.findProVideos arrayByDeletingObject:self.alreadySelectedItem]] : @[[self.repository.findRecordings arrayByDeletingObject:self.alreadySelectedItem]];
    [self.tableView reloadData];
}

- (void)didSelectDomainObject:(id)domainObject {
    CompareVideoController *ctrl = [self.dependencyInjector createInstanceOfClass:CompareVideoController.class];
    ctrl.videoItem = self.alreadySelectedItem;
    ctrl.secondVideoItem = domainObject;
    [self presentViewController:ctrl animated:YES completion:nil];
}


- (void)videoTypePressed:(id)sender {
    [self loadData];
}

@end


