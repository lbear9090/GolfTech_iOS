#import <Foundation/Foundation.h>

#import "ViewBuilderResult.h"

@interface ViewBuilder : NSObject {
}
@property(nonatomic, assign) BOOL vertical;
@property(nonatomic, assign) CGFloat extent;
@property(nonatomic, assign) CGFloat ortogonal;
+ (ViewBuilder*)verticalBuilderForView:(UIView*)view;
+ (ViewBuilder*)verticalBuilderForFrame:(CGRect)frame;
+ (ViewBuilder*)horizontalBuilderForView:(UIView*)view;
+ (ViewBuilder*)horizontalBuilderForFrame:(CGRect)frame;
- (ViewBuilderResult*)build;
- (void)addCenteredView:(UIView*)view;
- (void)addLeftView:(UIView*)view;
- (void)addSpace:(CGFloat)space;
- (void)addFlexibleSpaceWithFactor:(NSUInteger)factor;
//- (void)buildAndAddToView:(UIView*)view;
- (void)addRightView:(UIButton*)button;
@end
