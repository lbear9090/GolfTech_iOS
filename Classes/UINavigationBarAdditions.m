#import <objc/runtime.h>
#import "UINavigationBarAdditions.h"
#import "UIImageAdditions.h"

@implementation UINavigationBar (UINavigationBarAdditions)

+ (void)load_disabled {
    @autoreleasepool {
        static BOOL loaded = NO;
        if(self != [UINavigationBar class] || loaded)
            return;
        loaded = YES;
        Trace();
        // Swap the implementations of -[UINavigationBar drawRect:] and -[UINavigationBar drawRectOther:].
        // When the -drawRect: message is sent to an UINavigationBar instance, -drawRectOther: will
        // be called instead. Calling [self drawRectOther:event] thus calls the original method.
        Method originalMethod = class_getInstanceMethod(self, @selector(drawRect:));
        Method replacedMethod = class_getInstanceMethod(self, @selector(drawRectOther:));
        method_exchangeImplementations(originalMethod, replacedMethod);
    }
}

// swizzled with UINavigationBar#drawRect:
- (void)drawRectOther:(CGRect)rect {
    [self drawRectOther:rect]; // actually calling drawRect:
    if(![NSStringFromClass([self class]) isEqual:@"UINavigationBar"])
        return;  // don't mess with the Movie Players bar
    //    UIImage *background = [UIImage checkedImageNamed:@"bluebar.png"];
    //    [background drawAtPoint:CGPointMake(0, 0)];
    UIImage* img = [UIImage checkedImageNamed:@"navbarlogo.png.png"];
    CGFloat x = floorf((self.frame.size.width - img.size.width) / 2);
    CGFloat y = floorf((self.frame.size.height - img.size.height) / 2) + 1;
    [img drawAtPoint:CGPointMake(x, y)];
}

@end
