#import <Foundation/Foundation.h>
#import "BaseTableViewController.h"
#import "Repository.h"
#import "Category.h"
#import "VideoCell.h"
#import "AbstractVideosController.h"

@interface TechniqueListController : AbstractVideosController

- (void)didSelectCategory:(Category*)category;
@property(nonatomic, weak) id <VideoCellDelegate> delegate;
@end