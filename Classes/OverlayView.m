//
//  OverlayView.m
//  Golf
//
//  Created by Thomas Söderberg on 3/17/14.
//
//

#import "OverlayView.h"
#import "OverlayObject.h"
@implementation OverlayView
@synthesize overlayObjects,dualMode;
- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        overlayObjects = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    for (OverlayObject *object in overlayObjects) {
       
         
        CGRect borderRect = CGRectMake(object.pos_x, object.pos_y, object.width, object.height);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGColorRef cg_color = [object.tool.color CGColor];
         const CGFloat *_components = CGColorGetComponents(cg_color);
        CGContextSetStrokeColor(context,_components);
        CGContextSetRGBFillColor(context, 255, 124, 189, 0.0);
        CGContextSetLineWidth(context, 2.0);
        if(object.tool.state == CIRCLE) {
            
            
            int widtha = abs(object.width);
            int heighta = abs(object.height);
            int size = fmax(widtha,heighta);

            if(object.width < 0) {
                borderRect.size.width = 0-size;
            } else {
                 borderRect.size.width = size;
            }
            if(object.height < 0) {
                borderRect.size.height = 0-size;
            } else {
                borderRect.size.height = size;
            }

            CGContextFillEllipseInRect (context, borderRect);
            CGContextStrokeEllipseInRect(context, borderRect);
            CGContextFillPath(context);
        } else if (object.tool.state == RECTANGLE) {
            CGContextFillRect(context, borderRect);
            CGContextStrokeRect(context, borderRect);
        } else if (object.tool.state == LINE) {
            CGContextMoveToPoint(context, object.pos_x,object.pos_y);
            CGContextAddLineToPoint(context,object.pos2_x,object.pos2_y);
            CGContextStrokePath(context);
        } else if(object.tool.state == FREE) {
            [object.path setLineWidth:2.0];
            [object.path fill];
            [object.path stroke];
       
        }
    }
    
}
- (void)undoLatest {
    [overlayObjects removeLastObject];
    [self setNeedsDisplay];
}

- (void)eraseAll {
    [overlayObjects removeAllObjects];
    [self setNeedsDisplay];
}

@end
