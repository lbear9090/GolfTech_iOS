#import <Foundation/Foundation.h>
#import "DependencyInjector.h"
#import "Repository.h"
#import "VideoCell.h"
#import "Technique.h"

@interface TechniquesController : UIViewController <VideoCellDelegate>
//-(void)tapDetected:(id <VideoItem>)video;
-(void)tapDetected;
-(void) adjustViewForResize;
@property(nonatomic, weak) DependencyInjector* dependencyInjector;
@property(nonatomic, strong) Repository* repository;
@end