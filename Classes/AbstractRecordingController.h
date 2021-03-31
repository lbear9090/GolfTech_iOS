#import <Foundation/Foundation.h>
#import "PlayerView.h"
#import "Recording.h"
#import "Repository.h"
#import "ScrollWheelWithSlider.h"
#import "VideoItem.h"
#import "ScrollWheelDelegate.h"

static const float VideoAspectRatio = 8.0f / 9.0f;
static const float LongPlayerVideoAspectRatio = 8.0f / 10.5f;
static const float ShortPlayerVideoAspectRatio = 8.0f / 10.0f;

@interface AbstractRecordingController : UIViewController <PlayerViewDelegate, ScrollWheelDelegate>
@property(nonatomic, strong) NSFileManager *fileManager;
@property(nonatomic, strong) id <VideoItem> videoItem;
@property(nonatomic, strong) Repository *repository;
@property(nonatomic, weak) id <PlayerViewDelegate> delegate;
@property(nonatomic, weak) DependencyInjector *dependencyInjector;
@property(nonatomic, strong) UIView <PlayerViewProtocol> *player;
@property(nonatomic, strong) UIButton *playButton;
@property(nonatomic, strong) UIButton *slowButton;
@property(nonatomic, strong) UIBarButtonItem *compareBtn;

@property(nonatomic, strong) UIButton *showLegendButton;
@property(nonatomic, strong) ScrollWheelWithSlider *scrollWheel;
@property(nonatomic, strong) UIButton *slowLabel;
@property(nonatomic, readonly) BOOL isScrubbing;
- (UIView <PlayerViewProtocol> *)createPlayer;
- (void)playPressed:(id)sender;
- (void)drawPressed:(id)sender;
- (void)syncUI;
- (BOOL)isPlaying;
- (UIButton *)createOnOffButtonWithTarget:(id)target andSelector:(SEL)selector;
@end
