//
//  NewScrollWheel.m
//  Golf
//
//  Created by Thomas on 20/07/15.
//
//

#import "NewScrollWheel.h"
static const CGFloat Deacceleration = 0.95;
static const CGFloat DeaccelerationInterval = 0.02;
static const CGFloat MinimumInertiaSpeed = 10;
static const CGFloat SecondsPerAngle = -2.1 / 360.0;
static const CGFloat AnglesPerVelocity = -0.01;

@implementation NewScrollWheel {
    UIPanGestureRecognizer* _gesture;
    CGFloat _intertiaSpeed;
}
@synthesize delegate;
@synthesize currentPosition,maxPosition,minPosition;
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
        
        // set initial UIView state
        _speed = 1.0;
        
        
    }
    self.clearsContextBeforeDrawing = TRUE;
    _gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
    _gesture.maximumNumberOfTouches = 1;
    [self addGestureRecognizer:_gesture];
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // save the context's previous state:
    CGContextSaveGState(context);
    CGContextClearRect(context, self.frame);
    CGContextSetLineWidth(context, 1);
    // set the colour when drawing lines R,G,B,A. (we will set it to the same colour we used as the start and end point of our gradient )
   
    float current_width = self.frame.size.width / 50;
    //NSLog(@"current pos=%f",currentPosition);
    float milli_pos = currentPosition *1000;
    float evenPos = 100 * floor((milli_pos/100)+0.5);
    for(int i=0;i<50;i++) {
        float milli_current = i * ((maxPosition - minPosition) / 50) * 1000;
        if((milli_pos + (milli_current)) > evenPos ) {
             evenPos = 100 * floor(((milli_pos + (milli_current))/100)+0.5) + 100;
             CGContextSetRGBStrokeColor(context, 0.4,0.4,0.4,1.0);
            CGContextMoveToPoint(context, i *current_width, 0.0f); //start at this point
            CGContextAddLineToPoint(context, i *current_width, 30.0f); //draw to this point
        } else {
             CGContextSetRGBStrokeColor(context, 0.4,0.4,0.4,1.0);
            CGContextMoveToPoint(context, i *current_width, 0.0f); //start at this point
            CGContextAddLineToPoint(context, i *current_width, 15.0f); //draw to this point
        }
      
      //  NSLog(@"Even pos=%f currentPos=%f",evenPos,milli_pos);

       // CGContextMoveToPoint(context, i *current_width, 0.0f); //start at this point
       // CGContextAddLineToPoint(context, i *current_width, 30.0f); //draw to this point
    }
    // and now draw the Path!
    CGContextStrokePath(context);

}

-(void) startAnimate {
    
}

- (void) stopAnimate  {
    
}
- (void)panned:(UIPanGestureRecognizer*)gesture {
    CGPoint velocity = [gesture velocityInView:self];
    //MLog(@"Gesture %d",gesture.state);
    switch(gesture.state) {
        case UIGestureRecognizerStateBegan:
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(deaccelerate) object:nil];
            [delegate beginScrubbing];
            [self applyVelocity:velocity.x];
            break;
        case UIGestureRecognizerStateChanged:
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(deaccelerate) object:nil];
           // NSLog(@"Panned %f state %d",velocity.x, gesture.state);
            [self applyVelocity:velocity.x];
            //[_delegate seekRelativePosition:velocityX/10000.0];
            break;
        case UIGestureRecognizerStateEnded:
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(deaccelerate) object:nil];
            // let go
            //NSLog(@"Final velocity is %f",velocity.x);
            _intertiaSpeed = velocity.x;
            [self deaccelerate];
            break;
        case UIGestureRecognizerStatePossible:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            // Ignored gestures
            break;
    }
}

-(CGFloat) currentSpeed {
    return _speed;
}

-(void) setScrollSpeed:(CGFloat) newSpeed {
    _speed = newSpeed;
    currentPosition = _speed;
    [self setNeedsDisplay];
}
- (void)applyVelocity:(CGFloat)velocity {
    _speed =currentPosition - (velocity * AnglesPerVelocity) / 250;
       currentPosition = _speed;
    [self setNeedsDisplay];
    //[ScrollWheelInstance rotate:velocity * AnglesPerVelocity];
}

- (void)deaccelerate {
    CGFloat deacceleration = Deacceleration;
    if(fabsf(_intertiaSpeed) < MinimumInertiaSpeed) {
        [delegate endScrubbing];
        return;
    }
   // MLog(@"Slowing down %f",_intertiaSpeed);
    [self applyVelocity:_intertiaSpeed];
    _intertiaSpeed = _intertiaSpeed * deacceleration;
    [self performSelector:@selector(deaccelerate) withObject:nil afterDelay:DeaccelerationInterval];
}
@end
