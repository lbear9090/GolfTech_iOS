#import <objc/runtime.h>
#import "UIViewController+GPSAdditions.h"

@implementation UIViewController (GPSAdditions)

+ (void)load {
    if(!getenv("GPS_LOG_VIEWS"))
        return;
    //MLog(@"Turned on UIViewController#viewDidAppear logging");

    // Swap the implementations of -[UIViewController viewDidAppear:] and -[UIViewController viewDidAppearOther:].
    // When the -viewDidAppear: message is sent to an UIViewController instance, -viewDidAppearOther: will
    // be called instead. Calling [self viewDidAppearOther:] thus calls the original method.
    {
        Method originalMethod = class_getInstanceMethod(self, @selector(viewDidAppear:));
        Method replacedMethod = class_getInstanceMethod(self, @selector(viewDidAppearOther:));
        method_exchangeImplementations(originalMethod, replacedMethod);
    }

    {
        Method originalMethod = class_getInstanceMethod(self, @selector(viewWillAppear:));
        Method replacedMethod = class_getInstanceMethod(self, @selector(viewWillAppearOther:));
        method_exchangeImplementations(originalMethod, replacedMethod);
    }

    {
        Method originalMethod = class_getInstanceMethod(self, @selector(viewDidDisappear:));
        Method replacedMethod = class_getInstanceMethod(self, @selector(viewDidDisappearOther:));
        method_exchangeImplementations(originalMethod, replacedMethod);
    }

    {
        Method originalMethod = class_getInstanceMethod(self, @selector(viewWillDisappear:));
        Method replacedMethod = class_getInstanceMethod(self, @selector(viewWillDisappearOther:));
        method_exchangeImplementations(originalMethod, replacedMethod);
    }

    {
        Method originalMethod = class_getInstanceMethod(self, @selector(didReceiveMemoryWarning));
        Method replacedMethod = class_getInstanceMethod(self, @selector(didReceiveMemoryWarningOther));
        method_exchangeImplementations(originalMethod, replacedMethod);
    }

    {
        Method originalMethod = class_getInstanceMethod(self, @selector(viewDidLoad));
        Method replacedMethod = class_getInstanceMethod(self, @selector(viewDidLoadOther));
        method_exchangeImplementations(originalMethod, replacedMethod);
    }

    {
        Method originalMethod = class_getInstanceMethod(self, @selector(loadView));
        Method replacedMethod = class_getInstanceMethod(self, @selector(loadViewOther));
        method_exchangeImplementations(originalMethod, replacedMethod);
    }
}

- (void)loadViewOther {
    //MLog(@"%@#loadView %p",NSStringFromClass([self class]), self);
    [self loadViewOther];
}

- (void)viewDidLoadOther {
    //MLog(@"%@#viewDidLoad %p",NSStringFromClass([self class]), self);
    [self viewDidLoadOther];
}

- (void)didReceiveMemoryWarningOther {
    //MLog(@"%@#didReceiveMemoryWarning %p window %p super %p",NSStringFromClass([self class]), self, self.isViewLoaded ? (__bridge void *)(self.view.window) : (void *)0xdeadbeef, self.isViewLoaded ? (__bridge void *)(self.view.superview) : (void *)0xdeadbeef);
    [self didReceiveMemoryWarningOther];
}

- (void)viewDidAppearOther:(BOOL)animated {
    //MLog(@"%@#viewDidAppear %p",NSStringFromClass([self class]), self);
    [self viewDidAppearOther:animated]; // actually calling viewDidAppear
}

- (void)viewWillAppearOther:(BOOL)animated {
    //MLog(@"%@#viewWillAppear %p",NSStringFromClass([self class]), self);
    [self viewWillAppearOther:animated]; // actually calling viewWillAppear
}

- (void)viewWillDisappearOther:(BOOL)animated {
    //MLog(@"%@#viewWillAppear %p",NSStringFromClass([self class]), self);
    [self viewWillDisappearOther:animated]; // actually calling viewWillDisppear
}

- (void)viewDidDisappearOther:(BOOL)animated {
    //MLog(@"%@#viewDidDisappear: %p",NSStringFromClass([self class]), self);
    [self viewDidDisappearOther:animated]; // actually calling viewDidDisappear
}

@end
