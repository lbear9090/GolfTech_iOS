#import <Foundation/Foundation.h>
#import "BaseTableViewController.h"
#import "Repository.h"
#import "Category.h"
#import "VideoCell.h"
#import "EnterScoreController.h"

@interface ExercisesController : AbstractVideosController <EnterScoreControllerDelegate>
@property (retain) id delegate;
@property (retain)  NSMutableArray* resultClass;
@end
