#import <UIKit/UIKit.h>

#define SUPPORTS_UNDOCUMENTED_API 0
// source from http://github.com/ars/uicolor-utilities

@interface UIColor (UIColor_Expanded)
+ (UIColor *)colorWithRGBHex:(UInt32)hex;

+ (UIColor *)colorWithRGBHex:(UInt32)hex alpha:(float)alpha;
@end

