#import "DualPlayerView.h"
#import "PlayerView.h"

@interface DualPlayerView () <PlayerViewDelegate>
@end

@implementation DualPlayerView {
    PlayerView* _leftPlayer;
    PlayerView* _rightPlayer;
    BOOL _leftSelected;
    BOOL _rightSelected;
}
@synthesize delegate = _delegate;
@synthesize viewLatestObjects;

- (id)initWithLeftAsset:(AVAsset*)left andRightAsset:(AVAsset*)right {
    self = [self init];
    AssertNotNull(self.audioVideoFactory);

    _leftPlayer = [self.audioVideoFactory playerWithAsset:left delegate:self];
    [self addSubview:_leftPlayer];

    _rightPlayer = [self.audioVideoFactory playerWithAsset:right delegate:self];
    [self addSubview:_rightPlayer];
    _rightPlayer.overlayView.dualMode = true;
    _leftPlayer.overlayView.dualMode = true;
    _rightPlayer.viewId = 1;
    _leftPlayer.viewId = 2;
    self.playing = NO;
     viewLatestObjects = [[NSMutableArray alloc] init];
    return self;
}

- (void)playerStatusWasUpdated {
    [self.delegate playerStatusWasUpdated];
}

- (void)symbolDrawed:(int) sid {
     [viewLatestObjects addObject:[NSNumber numberWithInt:sid]];

}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    CGRect leftRect, rightRect;
    CGRectDivide(self.bounds, &leftRect, &rightRect, self.bounds.size.width / 2.0, CGRectMinXEdge);
    _leftPlayer.frame = leftRect;
    _rightPlayer.frame = rightRect;
}

- (NSTimeInterval)duration {
    return 0;
    //return _dualPosition.duration;
}

- (BOOL)isReadyToPlay {
    return _leftPlayer.isReadyToPlay && _rightPlayer.isReadyToPlay;
}

- (BOOL)playing {
    return _leftPlayer.playing || _rightPlayer.playing;
}

- (void)setPlaying:(BOOL)playing {
    _leftPlayer.playing = playing && _leftSelected;
    _rightPlayer.playing = playing && _rightSelected;
}

- (void)setPlaybackSpeed:(float)speed {
    _leftPlayer.playbackSpeed = _leftSelected ? speed : 0;
    _rightPlayer.playbackSpeed = _leftSelected ? speed : 0;
}

- (float)playbackSpeed {
    if(_leftSelected)
        return _leftPlayer.playbackSpeed;
    else
        return _rightPlayer.playbackSpeed;
}

- (BOOL)isAtStart {
    return _leftPlayer.isAtStart && _rightPlayer.isAtStart;
}

- (BOOL)isAtEnd {
    return _leftPlayer.isAtEnd && _rightPlayer.isAtEnd;
}

- (void)seekPosition:(NSTimeInterval)position {
    NSAssert(false, @"Not used");
}

- (void)seekPositionLeft:(NSTimeInterval)position1 right:(NSTimeInterval)position2 {
    [_leftPlayer seekPosition:position1];
    [_rightPlayer seekPosition:position2];
}

- (NSTimeInterval)position {
    NSAssert(false, @"Not used");
    return 0;
}

- (void)setSelectionLeft:(BOOL)left right:(BOOL)right {
    _leftSelected = left;
    _rightSelected = right;
}
- (void)setToolBoxView:(ToolBoxView*) tool {
    _leftPlayer.toolboxView = tool;
        _rightPlayer.toolboxView = tool;
}
#pragma mark ToolBoxProtocol
- (void)currentTool:(ToolBoxItem*)tool {
    
    _leftPlayer.isPaintMode = tool.state != NONE;
    _leftPlayer.tool = tool;
    _rightPlayer.isPaintMode = tool.state != NONE;
    _rightPlayer.tool = tool;
}

- (void)undoLatest {
    NSNumber *lastId = (NSNumber*) [viewLatestObjects lastObject];

    if([lastId integerValue] == 1) {
      [_rightPlayer.overlayView undoLatest] ;
    } else {
        [_leftPlayer.overlayView undoLatest] ;
    }
    [viewLatestObjects removeLastObject];
   
}


- (void)eraseAll {
    [_leftPlayer.overlayView eraseAll] ;
    [_rightPlayer.overlayView eraseAll] ;
    [self.viewLatestObjects removeAllObjects];
}
@end
