//
//  ToolBoxView.h
//  Golf
//
//  Created by Thomas Söderberg on 3/22/14.
//
//

#import <UIKit/UIKit.h>
#import "ToolBoxItem.h"
#import "CustomButton.h"
@protocol ToolBoxProtocol
- (void)currentTool:(ToolBoxItem*)tool ;
- (void)eraseAll;
- (void)undoLatest;
@end

@interface ToolBoxView : UIView
{
    id <ToolBoxProtocol> delegate;
}

@property(nonatomic, strong) CustomButton* menuOne;
@property(nonatomic, strong) CustomButton* menuTwo;
@property(nonatomic, strong) CustomButton* menuThree;
@property(nonatomic, strong) CustomButton* menuFour;
//@property(nonatomic, strong) CustomButton* menuFour;
@property(nonatomic, strong) UIButton* buttonTrash;
@property(nonatomic, strong) UIView *menuView;
@property(nonatomic, strong) UIView *submenuView;
@property(nonatomic, strong) UIButton* buttonUndo;
@property(nonatomic, strong) NSArray *colorArray;


@property(nonatomic) BOOL dualMode;
@property(nonatomic) CGRect initFrame;
@property (retain) id delegate;
- (void)unselectNotActiveButtons:(NSInteger) tagId;
- (void)unselectAllMenuButtons;
- (void)showExtendedMenu:(BOOL)visible yPos:(CGFloat) y;
@end
bool change_frame;
bool menu_visible;
