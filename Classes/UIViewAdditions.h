#import <Foundation/Foundation.h>

@interface UIView (GPSUIViewAdditions)
- (void)logSubviews;
- (NSArray*)subviewsWithClassName:(NSString*)className;

+ (void)logViewHiearchies __unused;

- (void)markBounds:(UIView*)subview withColor:(NSString*)colorName __unused;
- (UIView*)findFirstResonder;
- (NSArray*)findSubViewsOfClass:(NSString*)className;
@end

static inline UIColor* UIColorFromRGB(int rgbValue) __unused {
    return [UIColor colorWithRed:((float) ((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float) ((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float) (rgbValue & 0xFF)) / 255.0 alpha:1.0];
}

static inline CGFloat CGPointDot(CGPoint a, CGPoint b) __unused {
    return a.x * b.x + a.y * b.y;
}

static inline CGFloat CGPointLen(CGPoint a) {
    return sqrtf(a.x * a.x + a.y * a.y);
}

static inline CGPoint CGPointSub(CGPoint a, CGPoint b) {
    CGPoint c = {a.x - b.x, a.y - b.y};
    return c;
}

static inline CGFloat CGPointDist(CGPoint a, CGPoint b) __unused {
    CGPoint c = CGPointSub(a, b);
    return CGPointLen(c);
}

static inline CGPoint CGPointNorm(CGPoint a) __unused {
    CGFloat m = sqrtf(a.x * a.x + a.y * a.y);
    CGPoint c;
    c.x = a.x / m;
    c.y = a.y / m;
    return c;
}

static CGFloat RoundPointToHalf(CGFloat x) {
    return roundf(x * 2.0f) / 2.0f;
}

static inline CGPoint RoundToHalfPoints(CGPoint point) {
    return CGPointMake(RoundPointToHalf(point.x), RoundPointToHalf(point.y));
}

static inline CGPoint PointAtCenter(CGRect rect) {
    return RoundToHalfPoints(CGPointMake((rect.origin.x + rect.size.width / 2.0), rect.origin.y + rect.size.height / 2.0));
}

CGRect AlignedRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height);
CGRect* CreateVerticallyDivideFrames(CGRect frame, int spacing, int count, ...) __unused;
CGRect* CreateHoritonzallyDivideFrames(CGRect frame, int spacing, int count, ...) __unused;
CGRect ShrinkedRect(CGRect f, int s) __unused;
CGRect RectMovedRight(CGRect f, int x) __unused;
void StackVerticallyCentered(UIView* target, CGFloat padding, CGFloat spacing, ...);


