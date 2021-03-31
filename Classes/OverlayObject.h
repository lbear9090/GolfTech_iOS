//
//  Circle.h
//  Golf
//
//  Created by Thomas Söderberg on 3/18/14.
//
//

#import <Foundation/Foundation.h>
#import "Rectangle.h"
#import "ToolBoxItem.h"
@interface OverlayObject : NSObject
@property(nonatomic) int pos_x;
@property(nonatomic) int pos_y;
@property(nonatomic) int pos2_x;
@property(nonatomic) int pos2_y;
@property(nonatomic) int width;
@property(nonatomic) int height;
@property(nonatomic,retain) ToolBoxItem *tool;
@property(nonatomic, retain) Rectangle *selectedArea;
@property(nonatomic) BOOL *selected;
@property(nonatomic, retain) UIBezierPath* path;
-(void) setObject:(CGPoint) tap1 secondTap:(CGPoint) tap2 scale:(CGFloat) scale;
@end

