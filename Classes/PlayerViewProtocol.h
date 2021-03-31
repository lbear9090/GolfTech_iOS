@protocol PlayerViewDelegate
- (void)playerStatusWasUpdated;
@optional
-(void)symbolDrawed:(int) sid;
@end


@protocol PlayerViewProtocol <NSObject>
@property(nonatomic, assign) BOOL playing;
@property(nonatomic, weak) id <PlayerViewDelegate> delegate;
@property(nonatomic, readonly) NSTimeInterval position;
@property(nonatomic, assign) float playbackSpeed;
@property(nonatomic, readonly) BOOL isAtStart;
@property(nonatomic, readonly) BOOL isAtEnd;

- (BOOL)isReadyToPlay;
- (void)seekPosition:(NSTimeInterval)position;
@end