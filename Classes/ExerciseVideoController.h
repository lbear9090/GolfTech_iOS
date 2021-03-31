//
//  ExerciseVideoController.h
//  Golf
//
//  Created by Thomas on 10/05/15.
//
//

#import <Foundation/Foundation.h>
#import "Repository.h"
#import "VideoItem.h"
#import "CameraController.h"
@interface ExerciseVideoController : UIViewController <VideoCellDelegate>
-(void)tapDetected;
@property(nonatomic, weak) DependencyInjector* dependencyInjector;
@property(nonatomic, strong) Repository* repository;
@end
