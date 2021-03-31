#import <Foundation/Foundation.h>
#import "BaseCell.h"
#import "Technique.h"
#import "VideoItem.h"

@class Repository;

@protocol VideoCellDelegate
- (void)playVideo:(id <VideoItem>)video;
- (void)showVideoPage:(id <VideoItem>)video;
@end


@interface VideoCell : BaseCell
@property(nonatomic, strong) Repository* repository;
@property(nonatomic, strong) UIButton* imagePlayButton;
@property(nonatomic, strong) UITextView* summaryText;
@property(nonatomic, strong) UIButton* selectButton;
@property(nonatomic, strong) UIImageView* play;
@property(nonatomic, readonly) id <VideoItem> videoItem;
- (float)rowSpacing;
- (float)contentHeight;
@end