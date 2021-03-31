#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "Category.h"

@interface ScoreController : UIViewController <CPTPlotDataSource> {
}
@property(nonatomic, strong, readonly) Repository* repository;
@property(nonatomic, strong) NSArray* categories;

@end
