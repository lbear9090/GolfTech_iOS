//
//  CustomCircleButton.m
//  Golf
//
//  Created by Thomas Söderberg on 3/30/14.
//
//

#import "CustomCircleButton.h"

@implementation CustomCircleButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
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
    
    
    
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, self.selected? 1.0 : 0.5);
    CGContextSetRGBFillColor(context, 255, 124, 189, 0.0);
    CGContextSetLineWidth(context, 2.0);
    CGContextFillEllipseInRect (context, borderRect);
    CGContextStrokeEllipseInRect(context, borderRect);
    CGContextFillPath(context);
    // Cleanup
    CGGradientRelease(gradient);
    CGGradientRelease(highlightedGradient);
    CGColorSpaceRelease(colorSpace);
}


@end
