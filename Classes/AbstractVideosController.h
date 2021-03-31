#import <Foundation/Foundation.h>
#import "BaseTableViewController.h"
#import "VideoCell.h"

@interface AbstractVideosController : BaseTableViewController <VideoCellDelegate>
@property(nonatomic, strong) Repository* repository;
@end