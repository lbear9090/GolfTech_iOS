#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "Category.h"

@interface StatisticsController : UIViewController <CPTPlotDataSource, UIScrollViewDelegate> {
}
@property(nonatomic, strong) Repository* repository;
@property(nonatomic, strong) Exercise* exercise;

@end
