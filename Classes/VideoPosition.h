@interface VideoPosition : NSObject

@property(nonatomic, readonly) NSTimeInterval position;
@property(nonatomic, readonly) NSTimeInterval duration;
- (id)initWithDuration:(NSTimeInterval)duration;
- (void)moveTo:(NSTimeInterval)newPosition;
- (void)moveFor:(NSTimeInterval)duration;

@end