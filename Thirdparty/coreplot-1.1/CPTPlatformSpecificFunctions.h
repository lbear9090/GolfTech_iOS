#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

/// @file

#ifdef __cplusplus
extern "C" {
#endif

/// @name Graphics Context Save Stack
/// @{
void CPTPushCGContext(CGContextRef context);
void CPTPopCGContext(void);

/// @}

/// @name Graphics Context
/// @{
CGContextRef CPTGetCurrentContext(void);

/// @}

#ifdef __cplusplus
}
#endif
