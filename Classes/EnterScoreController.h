#import <UIKit/UIKit.h>
#import "Exercise.h"
#import "BaseTableViewController.h"
#import "DependencyInjector.h"

@protocol EnterScoreControllerDelegate
- (void)didEnterScoreForExercise:(Exercise*)exercise;
@end

@interface EnterScoreController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
}
@property(nonatomic, strong) Exercise* exercise;
@property(nonatomic, weak) DependencyInjector* dependencyInjector;
@property(nonatomic, weak) id <EnterScoreControllerDelegate> delegate;
@end
