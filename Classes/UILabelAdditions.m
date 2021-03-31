#import "UILabelAdditions.h"

@implementation UILabel (GPSUILabelAdditions)

+ (UILabel*)labelWithBoldText:(NSString*)text fontSize:(CGFloat)fontSize textColor:(UIColor*)textColor backgroundColor:(UIColor*)backgroundColor toView:(UIView*)view {
    return [self labelWithText:text font:[UIFont boldSystemFontOfSize:fontSize] textColor:textColor backgroundColor:backgroundColor toView:view];
}

+ (UILabel*)labelWithText:(NSString*)text fontSize:(CGFloat)fontSize textColor:(UIColor*)textColor backgroundColor:(UIColor*)backgroundColor toView:(UIView*)view {
    return [self labelWithText:text font:[UIFont systemFontOfSize:fontSize] textColor:textColor backgroundColor:backgroundColor toView:view];
}

+ (UILabel*)labelWithText:(NSString*)text font:(UIFont*)font textColor:(UIColor*)textColor backgroundColor:(UIColor*)backgroundColor toView:(UIView*)view {
    UILabel* result = [[UILabel class] new];
    result.font = font;
    result.backgroundColor = backgroundColor;
    result.textColor = textColor;
    result.text = @" ";
    [result sizeToFit];
    result.text = text;
    if(text != nil && [text length] > 0)
        [result sizeToFit];
    [view addSubview:result];
    return result;
}

@end
