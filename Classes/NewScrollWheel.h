//
//  NewScrollWheel.h
//  Golf
//
//  Created by Thomas on 20/07/15.
//
//

#import <UIKit/UIKit.h>
#import "ScrollWheelDelegate.h"
#define INITIAL_SPEED = 1.0f;
@interface NewScrollWheel : UIView {
	CGFloat _speed;
}
@property(nonatomic, weak) id <ScrollWheelDelegate> delegate;
@property(nonatomic, assign) NSTimeInterval currentPosition;
@property(nonatomic, assign) CGFloat maxPosition;
@property(nonatomic, assign) CGFloat minPosition;
-(void) setScrollSpeed:(CGFloat) newSpeed;
- (void) startAnimate ;
- (void) stopAnimate ;
-(CGFloat) currentSpeed;
@end

