//
//  VideoController.h
//  Golf
//
//  Created by Thomas on 22/04/15.
//
//

#import <Foundation/Foundation.h>
#import "Repository.h"
#import "VideoItem.h"
#import "CameraController.h"
@interface VideoController : UIViewController<UIImagePickerControllerDelegate,VideoListDelegate>
@property BOOL compareMode;

@property (nonatomic) Boolean myVideo;
@property(nonatomic, strong) Repository* repository;
- (void) playVideoPressed: (id <VideoItem>)videoItem;
- (void) reinsertVideo:(id <VideoItem>)videoItem;
- (BOOL)hasCamera;
@end
