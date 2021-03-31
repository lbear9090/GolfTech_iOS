#import <QuartzCore/QuartzCore.h>
#import "UIViewAdditions.h"

void print(NSString* string);
void logSubviews(int depth, UIView* view);

@interface SquareMark : UIView
@property(nonatomic, assign) SEL colorSel;
@end

@implementation SquareMark

+ (id)markWithFrame:(CGRect)frame color:(NSString*)colorName {
    SquareMark* result = [[self alloc] initWithFrame:frame];
    result.opaque = false;
    result.userInteractionEnabled = false;
    result.colorSel = NSSelectorFromString([NSString stringWithFormat:@"%@Color", colorName]);
    return result;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    //MLog(@"Drawing");
    [[UIColor performSelector:self.colorSel] setStroke];
    CGContextRef ctxt = UIGraphicsGetCurrentContext();
    CGContextSetAlpha(ctxt, 0.5);
    UIRectFrame(rect);
}

@end

@implementation UIView (GPSUIViewAdditions)

void print(NSString* string) {
    printf("%s", [string UTF8String]);
}

void indent(int depth) {
    for(int i = 0; i < depth * 4; i++) {
        printf(" ");
    }
}

void logSubviews(int depth, UIView* view) {
    indent(depth);
    NSString *extra = @"";
    if([view respondsToSelector:(@selector(currentTitle))])
        extra = [(id)view currentTitle];
    print([NSString stringWithFormat:@"%@ frame:%@ clips:%d key:%p radius:%.1f tag:%d %p %@\n", NSStringFromClass([view class]), NSStringFromCGRect([view frame]), view.clipsToBounds, [view respondsToSelector:@selector(keyWindow)] ? [(id) view keyWindow] : nil, view.layer.cornerRadius, view.tag, view, extra]);
    for(UIView* x in view.subviews) {
        logSubviews(depth + 1, x);
    }
}

#pragma mark public methods

- (void)logSubviews {
    print([NSString stringWithFormat:@"-- UIView hierarchy for %@\n", NSStringFromClass([self class])]);
    logSubviews(0, self);
    print(@"-- UIView hierarchy end\n");
}

- (void)logSubviewsFromRoot {
    if(self.superview != nil) {
        [self.superview logSubviewsFromRoot];
        return;
    }
    [self logSubviews];
}

+ (void)logViewHiearchies __unused {
    for(UIWindow* window in [UIApplication sharedApplication].windows) {
        [window logSubviews];
    }
}

- (void)markBounds:(UIView*)subview withColor:(NSString*)colorName __unused {
    SquareMark* mark = [SquareMark markWithFrame:subview.frame color:colorName];
    [self addSubview:mark];
}

- (NSArray*)subviewsWithClassName:(NSString*)className {
    NSMutableArray* result = [NSMutableArray array];
    for(UIView* v in [self subviews]) {
        if([NSStringFromClass([v class]) isEqual:className]) {
            [result addObject:v];
        }
        [result addObjectsFromArray:[v subviewsWithClassName:className]];
    }
    return result;
}

#pragma mark private methods

- (UIView*)findFirstResonder {
    if(self.isFirstResponder) {
        return self;
    }

    for(UIView* subView in self.subviews) {
        UIView* firstResponder = [subView findFirstResonder];

        if(firstResponder != nil) {
            return firstResponder;
        }
    }

    return nil;
}

- (void)findSubViewsOfClass:(NSString*)className result:(NSMutableArray*)result {
    for(UIView* child in self.subviews) {
        if([NSStringFromClass(child.class) isEqual:className])
            [result addObject:child];
        [child findSubViewsOfClass:className result:result];
    }
}

- (NSArray*)findSubViewsOfClass:(NSString*)className {
    NSMutableArray* result = [NSMutableArray new];
    [self findSubViewsOfClass:className result:result];
    return result;
}

@end

CGRect AlignedRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height) {
    return CGRectMake(roundf(x), roundf(y), roundf(width), roundf(height));
}

CGRect* CreateVerticallyDivideFrames(CGRect frame, int spacing, int count, ...) __unused {
    va_list argp;
    va_start(argp, count);

    CGRect* result = malloc(sizeof(frame) * count);
    CGFloat remaining = frame.size.height - spacing * (count - 1);
    CGFloat offset = 0;
    for(int i = 0; i < count; i++) {
        CGFloat extent = va_arg(argp, double);
        CGFloat height = remaining * extent;
        result[i] = AlignedRectMake(frame.origin.x, frame.origin.y + offset, height, frame.size.height);
        offset += (height + spacing);
    }
    va_end(argp);
    return result;
}

CGRect* CreateHoritonzallyDivideFrames(CGRect frame, int spacing, int count, ...) __unused {
    va_list argp;
    va_start(argp, count);

    CGRect* result = malloc(sizeof(frame) * count);
    CGFloat remaining = frame.size.width - spacing * (count - 1);
    CGFloat offset = 0;
    for(int i = 0; i < count; i++) {
        CGFloat extent = va_arg(argp, double);
        CGFloat width = remaining * extent;
        result[i] = AlignedRectMake(frame.origin.x + offset, frame.origin.y, width, frame.size.height);
        offset += (width + spacing);
    }
    va_end(argp);
    return result;
}

CGRect __unused ShrinkedRect(CGRect f, int s) {
    return CGRectMake(f.origin.x + s, f.origin.y + s, f.size.width - s * 2, f.size.height - s * 2);
}

CGRect __unused RectMovedRight(CGRect f, int x) {
    return CGRectMake(f.origin.x + x, f.origin.y, f.size.width, f.size.height);
}

CGRect RectSetY(CGRect frame, CGFloat y) {
    return CGRectMake(frame.origin.x, y, frame.size.width, frame.size.height);
}

void StackVerticallyCentered(UIView* target, CGFloat padding, CGFloat spacing, ...) {
    va_list argp;
    va_start(argp, spacing);

    UIView* view;
    CGFloat currentY = padding;
    while((view = va_arg(argp, UIView *))) {
        view.center = target.center;
        view.frame = RectSetY(view.frame, currentY);
        currentY += view.frame.size.height + spacing;
    }
    va_end(argp);
}


