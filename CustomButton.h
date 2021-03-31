//
//  CustomButton.h
//  Golf
//
//  Created by Thomas Söderberg on 3/27/14.
//
//

#import <UIKit/UIKit.h>
#import "ToolBoxItem.h"
@interface CustomButton : UIButton {
    ToolBoxItem *tool;

}
@property (nonatomic, retain) ToolBoxItem *tool;

@end
