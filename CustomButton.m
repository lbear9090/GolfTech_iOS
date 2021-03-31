//
//  CustomButton.m
//  Golf
//
//  Created by Thomas Söderberg on 3/27/14.
//
//

#import "CustomButton.h"


@implementation CustomButton
@synthesize tool;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [self setNeedsDisplay];
    [super setHighlighted:highlighted];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGRect borderRect = CGRectMake(self.frame.size.width * 0.2, self.frame.size.height * 0.2, self.frame.size.width * 0.6,  self.frame.size.height *0.6);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    UIColor *topColor = [UIColor clearColor];
    UIColor *bottomColor = [UIColor colorWithRed:0.91f green:0.55f blue:0.00f alpha:0.00f];
    UIColor *innerGlow = [UIColor colorWithWhite:1.0 alpha:0.5];
    
    // Gradient Declarations
    NSArray *gradientColors = (@[
                                 (id)topColor.CGColor,
                                 (id)bottomColor.CGColor
                                 ]);
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)(gradientColors), NULL);
    
    NSArray *highlightedGradientColors = (@[
                                            (id)innerGlow.CGColor,
                                            (id)topColor.CGColor,
                                            (id)innerGlow.CGColor
                                            ]);
    
    CGGradientRef highlightedGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)(highlightedGradientColors), NULL);
    CGGradientRef background = self.highlighted? highlightedGradient : gradient;
    
    // Draw gradient within the path
    CGContextDrawLinearGradient(context, background, CGPointMake(0, 0), CGPointMake(self.frame.size.width, self.frame.size.height), 0);
    
    //tool.color

    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1);
    CGContextSetRGBFillColor(context, 255, 124, 189, 0.0);
    CGContextSetLineWidth(context, self.selected ? 4.0f : 0.8f);
    
    CGColorRef colorRef = [tool.color CGColor];
    int _countComponents = CGColorGetNumberOfComponents(colorRef);
    if (_countComponents == 4) {
        const CGFloat *_components = CGColorGetComponents(colorRef);
        CGFloat red     = _components[0];
        CGFloat green = _components[1];
        CGFloat blue   = _components[2];
        CGContextSetRGBStrokeColor(context, red, green, blue, 1);
    }

    if(tool.state == CIRCLE) {
        CGContextFillEllipseInRect (context, borderRect);
        CGContextStrokeEllipseInRect(context, borderRect);
        CGContextFillPath(context);
    } else if(tool.state == LINE) {
        CGContextMoveToPoint(context, self.frame.size.width * 0.2,self.frame.size.height * 0.2);
        CGContextAddLineToPoint(context, self.frame.size.width *0.8, self.frame.size.height * 0.8);
        CGContextStrokePath(context);
    } else if(tool.state == RECTANGLE) {
       // CGRect rectangle = CGRectMake(0, 100, 320, 100);
        
        CGContextFillRect(context, borderRect);
        CGContextStrokeRect(context, borderRect);
    } else if (tool.state == FREE) {
        CGMutablePathRef freePath = CGPathCreateMutable();
          CGPathMoveToPoint(freePath, nil,  self.frame.size.width * 0.2,  self.frame.size.height * 0.2);
          CGPathAddCurveToPoint(freePath, nil, self.frame.size.width * 0.8, self.frame.size.height * 0.5,
                                self.frame.size.width * 0.2, self.frame.size.height *0.5, self.frame.size.width * 0.8, self.frame.size.height * 0.8);
         CGContextAddPath(context, freePath);
            CGContextStrokePath(context);
        CGPathRelease(freePath);
       
    }else if(tool.state == COLOR_RED) {
        CGContextSetRGBFillColor(context, 0.894, 0.024, 0.075, 1.0);
        CGContextSetRGBStrokeColor(context, 0.894, 0.024, 0.075, 1.0);
        CGContextFillEllipseInRect (context, borderRect);
        CGContextStrokeEllipseInRect(context, borderRect);
        CGContextFillPath(context);
    } else if(tool.state == COLOR_YELLOW) {
        CGContextSetRGBFillColor(context, 0.984, 0.953, 0.008, 1.0);
 CGContextSetRGBStrokeColor(context, 0.984, 0.953, 0.008, 1.0);
        CGContextFillEllipseInRect (context, borderRect);
        CGContextStrokeEllipseInRect(context, borderRect);
        CGContextFillPath(context);
    } else if(tool.state == COLOR_BLUE) {
      
        CGContextSetRGBStrokeColor(context,  0.035, 0.608, 0.973, 1.0);
        CGContextSetRGBFillColor(context, 0.035, 0.608, 0.973, 1.0);
     
        CGContextFillEllipseInRect (context, borderRect);
        CGContextStrokeEllipseInRect(context, borderRect);
        CGContextFillPath(context);
    } else if(tool.state == COLOR_GREEN) {
        CGContextSetRGBFillColor(context, 0.039, 0.627, 0.035, 1.0);
        CGContextSetRGBStrokeColor(context,  0.039, 0.627, 0.035, 1.0);
         //CGContextSetRGBFillColor(context, 0.0, 255.0, 0.0, 1.0);
        CGContextFillEllipseInRect (context, borderRect);
        CGContextStrokeEllipseInRect(context, borderRect);
        CGContextFillPath(context);
    } else if(tool.state == COLOR_WHITE) {
        CGContextSetRGBFillColor(context, 1, 1, 1, 1.0);
        CGContextSetRGBStrokeColor(context,  1, 1, 1, 1.0);
        //CGContextSetRGBFillColor(context, 0.0, 255.0, 0.0, 1.0);
        CGContextFillEllipseInRect (context, borderRect);
        CGContextStrokeEllipseInRect(context, borderRect);
        CGContextFillPath(context);
    }

    
    // Cleanup
    CGGradientRelease(gradient);
    CGGradientRelease(highlightedGradient);
    CGColorSpaceRelease(colorSpace);
}


@end
