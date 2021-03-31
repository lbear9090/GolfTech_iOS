//
//  Circle.m
//  Golf
//
//  Created by Thomas Söderberg on 3/18/14.
//
//

#import "OverlayObject.h"

@implementation OverlayObject
@synthesize height;
@synthesize width;
@synthesize pos_x;
@synthesize pos_y;
@synthesize pos2_x;
@synthesize pos2_y;
@synthesize selectedArea;
@synthesize selected;
@synthesize tool;
@synthesize  path;
//- (id)init {
//    if (self = [super init]) {
//        path = [[UIBezierPath alloc]init];
//    }
//    return self;
//}
-(void) setObject:(CGPoint) tap1 secondTap:(CGPoint) tap2 scale:(CGFloat) scale {
    self.pos_x = tap1.x;
    self.pos_y = tap1.y;
    self.pos2_x = tap2.x;
    self.pos2_y = tap2.y;
    self.width =(tap2.x - tap1.x) ;
   self.height =(tap2.y - tap1.y)  ;
}
@end
