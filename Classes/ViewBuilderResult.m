#import "ViewBuilderResult.h"

@interface Box ()
@property(nonatomic, assign) Alignment alignment;
@end

@implementation Box

- (id)init {
    self = [super init];
    self.view = ([[UIView class] new]);
    self.view.frame = CGRectMake(-1, -1, -1, -1);
    return self;
}

+ (Box*)boxWithView:(UIView*)aView vertical:(BOOL)vertical alignment:(Alignment)alignment {
    Box* result = [[Box class] new];
    result.view = aView;
    result.frame = aView.bounds;
    result.vertical = vertical;
    result.alignment = alignment;
    return result;
}

+ (Box*)boxWithExtent:(CGFloat)extent ortogonal:(CGFloat)ortogonal vertical:(BOOL)vertical {
    Box* result = [[Box class] new];
    result.vertical = vertical;
    result.frame = vertical ? CGRectMake(0, 0, ortogonal, extent) : CGRectMake(0, 0, extent, ortogonal);
    return result;
}

+ (Box*)boxWithFrame:(CGRect)aFrame {
    Box* result = [[Box class] new];
    result.frame = aFrame;
    return result;
}

- (void)positionAtExtent:(CGFloat)theExtent {
    self.frame = CGRectMake(self.vertical ? 0 : theExtent, self.vertical ? theExtent : 0, self.frame.size.width, self.frame.size.height);
}

- (void)moveExtent:(CGFloat)anExtent {
    self.frame = CGRectMake(_vertical ? self.frame.origin.x : anExtent, _vertical ? anExtent : self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)moveOrtogonal:(CGFloat)anOrtogonal {
    //MLog(@"Is vertical %d",vertical);
    self.frame = CGRectMake(_vertical ? anOrtogonal : self.frame.origin.x, _vertical ? self.frame.origin.y : anOrtogonal, self.frame.size.width, self.frame.size.height);
}

- (void)setFrame:(CGRect)aFrame {
    self->_frame = aFrame;
    if(self.view != nil) {
        self.view.frame = aFrame;
    }
}

- (CGFloat)extent {
    return self.vertical ? self.frame.size.height : self.frame.size.width;
}

- (void)setExtent:(CGFloat)newExtent {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, _vertical ? self.frame.size.width : newExtent, _vertical ? newExtent : self.frame.size.height);
}

- (CGFloat)ortogonal {
    return self.vertical ? self.frame.size.width : self.frame.size.height;
}

//- (NSString*)description {
//	return [NSString stringWithFormat:@"Box(%@)",NSStringFromCGRect(self.view.frame)];
//}

@end


@interface ViewBuilderResult ()
@end

@implementation ViewBuilderResult

- (id)init {
    self = [super init];
    self.boxes = [NSMutableArray array];
    return self;
}

- (void)add:(Box*)box {
    NSAssert1([[box class] isSubclassOfClass:[Box class]], @"Wrong class %@", NSStringFromClass([box class]));
    AssertNotNull(self.boxes);
    [self.boxes addObject:box];
}

- (CGRect)frameAtIndex:(NSUInteger)anIndex {
    return [(self.boxes)[anIndex] frame];
}

- (NSUInteger)flexibleTotalFactor {
    return [[self valueForKeyPath:@"boxes.@sum.factor"] integerValue];
}

@end
