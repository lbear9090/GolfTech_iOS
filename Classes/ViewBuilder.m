#import "ViewBuilder.h"
#import "NSNumberExtensions.h"

@interface ViewBuilder ()
@property(nonatomic, strong) ViewBuilderResult* result;
@property(nonatomic, strong) NSNumber* extentValue;
@property(nonatomic, strong) NSNumber* ortogonalValue;
@property(nonatomic, assign) CGPoint origin;
@end

@implementation ViewBuilder

- (id)init {
    self = [super init];
    self.result = ([[ViewBuilderResult class] new]);
    return self;
}

+ (ViewBuilder*)verticalBuilder {
    ViewBuilder* result = [[ViewBuilder class] new];
    result.vertical = YES;
    return result;
}

+ (ViewBuilder*)verticalBuilderForFrame:(CGRect)frame {
    ViewBuilder* result = [[ViewBuilder class] new];
    result.vertical = YES;
    result.extent = frame.size.height;
    result.ortogonal = frame.size.width;
    result.origin = frame.origin;
    return result;
}

+ (ViewBuilder*)verticalBuilderForView:(UIView*)view {
    return [self verticalBuilderForFrame:view.bounds];
}

+ (ViewBuilder*)horizontalBuilder {
    ViewBuilder* result = [[ViewBuilder class] new];
    result.vertical = NO;
    return result;
}

+ (ViewBuilder*)horizontalBuilderForFrame:(CGRect)frame {
    ViewBuilder* result = [[ViewBuilder class] new];
    result.vertical = NO;
    result.ortogonal = frame.size.height;
    result.extent = frame.size.width;
    result.origin = frame.origin;
    return result;
}

+ (ViewBuilder*)horizontalBuilderForView:(UIView*)view {
    return [self horizontalBuilderForFrame:view.bounds];
}

- (void)expandFlexibles {
    if(self.extentValue == nil)
        return;
    if(self.result.extent > self.extent) {
        //MLog(@"More content (%f) than allowed by extent (%f)",self.result.extent, self.extent);
    }
    NSUInteger totalFactor = self.result.flexibleTotalFactor;
    CGFloat step = (self.extent - self.result.extent) / totalFactor;
    CGFloat currentExtent = 0;
    for(Box* box in self.result.boxes) {
        if(box.factor > 0) {
            box.extent = box.factor * step;
        }
        [box moveExtent:currentExtent];
        currentExtent += box.extent;
    }
}

- (void)alignBoxes {
    for(Box* box in self.result.boxes) {
        switch(box.alignment) {
            case left:
                break;
            case center:
                NSAssert(self.ortogonalValue != nil, @"Center alignment requires ortogonal value");
                [box moveOrtogonal:(self.ortogonal - box.ortogonal) / 2.0];
                break;
            case right:
                NSAssert(self.ortogonalValue != nil, @"Right alignment requires ortogonal value");
                [box moveOrtogonal:self.ortogonal - box.ortogonal];
                break;
        }
    }
}

- (void)adjustForOrigin {
    for(Box* box in self.result.boxes) {
        box.frame = CGRectMake(box.frame.origin.x + self.origin.x, box.frame.origin.y + self.origin.y, box.frame.size.width, box.frame.size.height);
    }
}

- (ViewBuilderResult*)build {
    CGFloat currentExtent = 0, maxOrtogonal = 0;
    for(Box* box in self.result.boxes) {
        [box positionAtExtent:currentExtent];
        currentExtent += box.extent;
        maxOrtogonal = maxOrtogonal > box.ortogonal ? maxOrtogonal : box.ortogonal;
    }

    self.result.extent = currentExtent;
    self.result.ortogonal = maxOrtogonal;
    [self expandFlexibles];
    [self alignBoxes];
    [self adjustForOrigin];
    return self.result;
}

- (void)addCenteredView:(UIView*)view {
    AssertNotNull(self.result);
    [self.result add:[Box boxWithView:view vertical:self.vertical alignment:center]];
}

- (void)addLeftView:(UIView*)view {
    AssertNotNull(self.result);
    [self.result add:[Box boxWithView:view vertical:self.vertical alignment:left]];
}

- (void)addRightView:(UIView*)view {
    AssertNotNull(self.result);
    [self.result add:[Box boxWithView:view vertical:self.vertical alignment:right]];
}

- (void)addSpace:(CGFloat)space {
    [self.result add:[Box boxWithExtent:space ortogonal:self.ortogonal vertical:self.vertical]];
}

- (void)addFlexibleSpaceWithFactor:(NSUInteger)factor {
    Box* box = [Box boxWithExtent:0 ortogonal:self.ortogonal vertical:self.vertical];
    box.factor = factor;
    [self.result add:box];
}

- (CGFloat)extent {
    AssertNotNull(self.extentValue);
    return [self.extentValue cgFloatValue];
}

- (void)setExtent:(CGFloat)extent {
    self.extentValue = [NSNumber numberWithCGFloat:extent];
}

- (CGFloat)ortogonal {
    if(self.ortogonalValue == nil)
        return 0;
    return [self.ortogonalValue cgFloatValue];
}

- (void)setOrtogonal:(CGFloat)ortogonal {
    self.ortogonalValue = [NSNumber numberWithCGFloat:ortogonal];
}

@end
