//
//  ToolBoxItem.h
//  Golf
//
//  Created by Thomas Söderberg on 3/30/14.
//
//

#import <Foundation/Foundation.h>

@interface ToolBoxItem : NSObject
typedef enum toolType
{
    NONE = 0,
    CIRCLE = 1,
    RECTANGLE = 2,
    LINE = 3,
    FREE = 4,
    ANGLE = 5,
    COLOR_RED = 6,
    COLOR_YELLOW = 7,
    COLOR_BLUE = 8,
    COLOR_GREEN = 9,
    COLOR_WHITE = 10
} ToolState;
@property(nonatomic, copy) UIColor *color;
@property(nonatomic) enum toolType state;

@end
