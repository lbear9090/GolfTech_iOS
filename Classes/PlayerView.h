#import <AVFoundation/AVFoundation.h>
#import "PlayerViewProtocol.h"
#import "AudioVideoFactory.h"
#import "OverlayView.h"
#import "ToolBoxItem.h"
#import "ToolBoxView.h"
@interface PlayerView : UIView <PlayerViewProtocol,UIGestureRecognizerDelegate>
{

    UIPanGestureRecognizer* panRecognizer ;
    UIPinchGestureRecognizer* pinchRecognizer;
    UIRotationGestureRecognizer* rotationRecognizer;
    UILongPressGestureRecognizer* longPressRecognizer;
    CGFloat mLastScale;
    CGFloat mCurrentScale;
   CGFloat mCurrentPanX;
   CGFloat mCurrentPanY;
    CGFloat mTempCurrentPanX;
    CGFloat mTempCurrentPanY;
    CGPoint mCurrentPaintingStartPoint;
    BOOL mZooming;
    BOOL isPaintMode;
    BOOL isPainting;
    BOOL isPaintingByPinch;

    ToolBoxItem *tool;
}
@property(nonatomic, strong) AudioVideoFactory* audioVideoFactory;
    -(void)changeVideo:(AVAsset*) item;
- (id)initWithAsset:(AVAsset*)asset;
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;
-(void)zoomOut:(UIPinchGestureRecognizer*) sender;
-(void)pan:(UIPanGestureRecognizer*) sender;
@property (nonatomic, assign) CGFloat mLastScale;
@property (nonatomic, assign) CGFloat mCurrentScale;
@property (nonatomic, assign) CGFloat mCurrentPanX;
@property (nonatomic, assign) CGFloat mCurrentPanY;
@property (nonatomic, assign) CGPoint mCurrentPaintingStartPoint;

@property (nonatomic, assign) CGFloat mTempCurrentPanX;
@property (nonatomic, assign) CGFloat mTempCurrentPanY;
@property (nonatomic, retain) UIPanGestureRecognizer* panRecognizer;
@property (nonatomic, retain) UIPinchGestureRecognizer* pinchRecognizer;
@property (nonatomic, retain) UIRotationGestureRecognizer* rotationRecognizer;
@property (nonatomic, retain) UILongPressGestureRecognizer* longPressRecognizer;
@property (nonatomic, retain) UILongPressGestureRecognizer *doubleRecognizer;
@property (nonatomic) int viewId;

 @property(nonatomic, strong) OverlayView* overlayView;
@property(nonatomic, assign) ToolBoxView* toolboxView;

@property (nonatomic, assign) BOOL mZooming;
@property (nonatomic, assign) BOOL isPaintMode;
@property (nonatomic, assign) BOOL isPainting;
@property (nonatomic, assign) BOOL isPaintingByPinch;
@property (nonatomic, retain) ToolBoxItem* tool;

@end
