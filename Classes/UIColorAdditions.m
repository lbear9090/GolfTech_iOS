#import "UIColorAdditions.h"

/*
 Thanks to Poltras, Millenomi, Eridius, Nownot, WhatAHam, jberry,
 and everyone else who helped out but whose name is inadvertantly omitted
 */

/*
 Current outstanding request list:
 - PolarBearFarm - color descriptions ([UIColor warmGrayWithHintOfBlueTouchOfRedAndSplashOfYellowColor])
 - Crayola color set
 - Eridius - UIColor needs a method that takes 2 colors and gives a third complementary one
 - Consider UIMutableColor that can be adjusted (brighter, cooler, warmer, thicker-alpha, etc)
 */

#if SUPPORTS_UNDOCUMENTED_API
// UIColor_Undocumented
// Undocumented methods of UIColor
@interface UIColor (UIColor_Undocumented)
- (NSString *)styleString;
@end
#endif // SUPPORTS_UNDOCUMENTED_API

@interface UIColor (UIColor_Expanded_Support)
@end

#pragma mark -

@implementation UIColor (UIColor_Expanded)

#pragma mark Arithmetic operations

#pragma mark String utilities

#pragma mark Class methods

+ (UIColor*)colorWithRGBHex:(UInt32)hex {
    return [self colorWithRGBHex:hex alpha:1.0f];
}

+ (UIColor *)colorWithRGBHex:(UInt32)hex alpha:(float)alpha {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;

    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:alpha];
}

#pragma mark UIColor_Expanded initialization

@end

#pragma mark -

@implementation UIColor (UIColor_Expanded_Support)

@end