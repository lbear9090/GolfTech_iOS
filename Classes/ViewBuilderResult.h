#import <Foundation/Foundation.h>

typedef enum AlignmentType {left, center, right} Alignment;

@interface Box : NSObject {
}
@property(nonatomic, strong) UIView* view;
@property(nonatomic, assign) CGRect frame;
@property(nonatomic, assign) NSUInteger factor;
@property(nonatomic, assign) BOOL vertical;
@property(nonatomic, assign) CGFloat extent;
@property(nonatomic, readonly) CGFloat ortogonal;
@property(nonatomic, readonly) Alignment alignment;
+ (Box*)boxWithView:(UIView*)aView vertical:(BOOL)vertical alignment:(Alignment)alignment;
+ (Box*)boxWithExtent:(CGFloat)extent ortogonal:(CGFloat)ortogonal vertical:(BOOL)vertical;
- (void)positionAtExtent:(CGFloat)theExtent;
- (void)moveExtent:(CGFloat)anExtent;
- (void)moveOrtogonal:(CGFloat)anOrtogonal;
@end


@interface ViewBuilderResult : NSObject {
}
@property(nonatomic, strong) NSMutableArray* boxes;
@property(nonatomic, readonly) NSUInteger boxCount;
@property(nonatomic, assign) CGFloat extent;
@property(nonatomic, assign) CGFloat ortogonal;
@property(nonatomic, readonly) NSUInteger flexibleTotalFactor;
- (void)add:(Box*)box;
- (CGRect)frameAtIndex:(NSUInteger)index;
@end
