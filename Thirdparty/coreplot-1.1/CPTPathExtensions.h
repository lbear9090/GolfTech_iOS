#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

/// @file

#ifdef __cplusplus
extern "C" {
#endif

CGPathRef CreateRoundedRectPath(CGRect rect, CGFloat cornerRadius);
void AddRoundedRectPath(CGContextRef context, CGRect rect, CGFloat cornerRadius);

#ifdef __cplusplus
}
#endif
