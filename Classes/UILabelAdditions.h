#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UILabel (GPSUILabelAdditions)

+ (UILabel*)labelWithBoldText:(NSString*)text fontSize:(CGFloat)fontSize textColor:(UIColor*)textColor backgroundColor:(UIColor*)backgroundColor toView:(UIView*)view;

+ (UILabel*)labelWithText:(NSString*)text fontSize:(CGFloat)fontSize textColor:(UIColor*)textColor backgroundColor:(UIColor*)backgroundColor toView:(UIView*)view;

+ (UILabel*)labelWithText:(NSString*)text font:(UIFont*)font textColor:(UIColor*)textColor backgroundColor:(UIColor*)backgroundColor toView:(UIView*)view;
@end
