//
//  ToolBoxView.m
//  Golf
//
//  Created by Thomas Söderberg on 3/22/14.
//
//

#import "ToolBoxView.h"
#import "CustomButton.h"
#import "PlaySingleRecordingController.h"
#import "ToolBoxItem.h"
#import "Repository.h"
@implementation ToolBoxView
@synthesize menuOne,menuTwo,menuThree,menuFour;
@synthesize buttonTrash;
@synthesize buttonUndo;
@synthesize delegate;
@synthesize menuView;
@synthesize submenuView;
@synthesize colorArray;
@synthesize dualMode;
@synthesize initFrame;

#pragma mark init
- (id)initWithFrame:(CGRect)frame
{
    self.colorArray = [[NSArray alloc] initWithObjects:
                       [UIColor colorWithRed: 0.035 green:0.608 blue:0.973 alpha:1.0] // Blå
                       ,[UIColor colorWithRed: 0.039 green:0.627 blue:0.035 alpha:1.0] // Grön
                       ,[UIColor colorWithRed:0.984 green:0.953 blue:0.008 alpha:1.0] // Gul
                       ,[UIColor colorWithRed:0.894 green:0.024 blue:0.075 alpha:1.0] // Röd
                       ,[UIColor colorWithRed:1 green: 1 blue:1 alpha:1] // Vit
                       ,nil];
    
    if(!self)change_frame=false;
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // if(!change_frame) {
        initFrame = frame;
        [self setUserInteractionEnabled:YES];
        CGRect toolFrame = CGRectMake(0,0 , 40,  frame.size.height);
        menuView = [[UIView alloc] initWithFrame: toolFrame];
        menuView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        [self setAutoresizesSubviews:NO];
        [self addSubview:menuView];
        menu_visible = false;
        CGRect submenuFrame = CGRectMake(40,
                                         50 ,
                                         220,
                                         100);
        submenuView = [[UIView alloc] initWithFrame: submenuFrame];
        [submenuView setHidden:true];
        [submenuView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
        [self addSubMenuButtons];
        [self addSubview:submenuView];


        CGFloat startY = 13, intervalY = 45, yPosition = 0;

        menuOne = [CustomButton buttonWithType:UIButtonTypeCustom];
        [menuOne addTarget:self
                    action:@selector(showMenu1:)
          forControlEvents:UIControlEventTouchUpInside];
        ToolBoxItem *menuOneTool = [ToolBoxItem alloc];
        [menuOne setTool:menuOneTool];
        [menuOne.tool setState:(ToolState)[Repository getMenu1Symbol]];
        
        [menuOne.tool setColor:self.colorArray[[Repository getMenu1Color]]];
        [menuOne setTag:1];
        menuOne.frame = CGRectMake(0, yPosition+=startY, 40.0, 40.0);
        [menuView addSubview:menuOne];


        menuTwo = [CustomButton buttonWithType:UIButtonTypeCustom];
        [menuTwo addTarget:self
                    action:@selector(showMenu1:)
          forControlEvents:UIControlEventTouchUpInside];
        ToolBoxItem *menuTwoTool = [ToolBoxItem alloc];
        [menuTwo setTool:menuTwoTool];
        [menuTwo.tool setState:(ToolState)[Repository getMenu2Symbol]];
        [menuTwo.tool setColor:self.colorArray[[Repository getMenu2Color]]];
        //[menuTwo.tool setColor:[UIColor colorWithRed: 0.039 green:0.627 blue:0.035 alpha:1.0]];
        [menuTwo setTag:2];
        menuTwo.frame = CGRectMake(0, yPosition+=intervalY, 40.0, 40.0);
        [menuView addSubview:menuTwo];
        
        
        menuThree = [CustomButton buttonWithType:UIButtonTypeCustom];
        [menuThree addTarget:self
                      action:@selector(showMenu1:)
            forControlEvents:UIControlEventTouchUpInside];
        [menuThree setTag:3];
        ToolBoxItem *menuThreeTool = [ToolBoxItem alloc];
        [menuThree setTool:menuThreeTool];
        //[menuThree.tool setColor:[UIColor colorWithRed:0.984 green:0.953 blue:0.008 alpha:1.0]];
        [menuThree.tool setColor:self.colorArray[[Repository getMenu3Color]]];
        [menuThree.tool setState:(ToolState)[Repository getMenu3Symbol]];
        menuThree.frame = CGRectMake(0, yPosition+=intervalY, 40.0, 40.0);
        [menuView addSubview:menuThree];


        menuFour = [CustomButton buttonWithType:UIButtonTypeCustom];
        [menuFour addTarget:self
                     action:@selector(showMenu1:)
           forControlEvents:UIControlEventTouchUpInside];
        [menuFour setTag:4];
        ToolBoxItem *menuFourTool = [ToolBoxItem alloc];
        [menuFour setTool:menuFourTool];
        [menuFour.tool setState:(ToolState)[Repository getMenu4Symbol]];
        //[menuFour.tool setColor:[UIColor colorWithRed:0.984 green:0.953 blue:0.008 alpha:1.0]];
        [menuFour.tool setColor:self.colorArray[[Repository getMenu4Color]]];
        
        menuFour.frame = CGRectMake(0, yPosition+=intervalY, 40.0, 40.0);
        [menuView addSubview:menuFour];


        //Trashbutton
        buttonTrash =[UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *trash = [UIImage imageNamed:@"trash.png"];
        UIImage *trash_highlighted = [UIImage imageNamed:@"trash_highlighted.png"];
        UIImage *undo = [UIImage imageNamed:@"undo.png"];
        UIImage *undo_highlighted = [UIImage imageNamed:@"undo_highlighted.png"];
        [buttonTrash setImage:trash  forState:UIControlStateNormal];
        [buttonTrash addTarget:self
                        action:@selector(eraseAll:)
              forControlEvents:UIControlEventTouchUpInside];
        [buttonTrash setImage:trash_highlighted forState:UIControlStateHighlighted];
        [buttonTrash setImage:trash forState:UIControlStateDisabled];

   
        buttonUndo =[UIButton buttonWithType:UIButtonTypeCustom];
        [buttonUndo addTarget:self
                       action:@selector(undoTool:)
             forControlEvents:UIControlEventTouchUpInside];
        
        [buttonUndo setImage:undo  forState:UIControlStateNormal];
        [buttonUndo setImage:undo_highlighted forState:UIControlStateHighlighted];
        [buttonUndo setImage:undo forState:UIControlStateDisabled];
        buttonUndo.frame = CGRectMake(self.frame.size.width - 35, self.frame.size.height - 90, 30.0, 30.0);
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        float screen_height =      screenRect.size.height;
         float frame_height =      self.frame.size.height;
        if(frame_height > screen_height ) frame_height = screen_height;
        if(self.dualMode || self.initFrame.origin.x > 300) {
            buttonTrash.frame = CGRectMake(self.frame.size.width - 35, frame_height - 40, 30.0, 30.0);
            buttonUndo.frame = CGRectMake(self.frame.size.width - 35, frame_height - 90, 30.0, 30.0);
            

        } else {
            buttonTrash.frame = CGRectMake(self.frame.size.width - 35, self.frame.size.height - 40, 30.0, 30.0);
            buttonUndo.frame = CGRectMake(self.frame.size.width - 35, self.frame.size.height - 90, 30.0, 30.0);
            

        }
        
        [menuView addSubview:buttonTrash];
        [menuView addSubview:buttonUndo];
        //  }
        
        
    }
    
    change_frame = true;
    return self;
}


#pragma mark submenu
- (void)addSubMenuButtons {
    CustomButton *circle = [CustomButton buttonWithType:UIButtonTypeCustom];
    
    [circle addTarget:self
               action:@selector(submenuAction:)
     forControlEvents:UIControlEventTouchUpInside];
    ToolBoxItem *circleTool = [ToolBoxItem alloc];
    [circle setTool:circleTool];
    [circle.tool setState:CIRCLE];
    [circle.tool setColor:[UIColor colorWithWhite:0 alpha:1]];
    circle.frame = CGRectMake(5, 2.0, 40.0, 40.0);
    
    CustomButton *line = [CustomButton buttonWithType:UIButtonTypeCustom];
    [line addTarget:self
             action:@selector(submenuAction:)
   forControlEvents:UIControlEventTouchUpInside];
    ToolBoxItem *lineTool = [ToolBoxItem alloc];
    [line setTool:lineTool];
    [line.tool setState:LINE];
    [line.tool setColor:[UIColor colorWithWhite:0 alpha:1]];
    line.frame = CGRectMake(47, 2.0, 40.0, 40.0);
    
    CustomButton *rectangle = [CustomButton buttonWithType:UIButtonTypeCustom];
    [rectangle addTarget:self
                  action:@selector(submenuAction:)
        forControlEvents:UIControlEventTouchUpInside];
    ToolBoxItem *rectangleTool = [ToolBoxItem alloc];
    [rectangle setTool:rectangleTool];
    [rectangle.tool setState:RECTANGLE];
    [rectangle.tool setColor:[UIColor colorWithWhite:0 alpha:1]];
    rectangle.frame = CGRectMake(89, 2.0, 40.0, 40.0);
    
    CustomButton *freeHand = [CustomButton buttonWithType:UIButtonTypeCustom];
    [freeHand addTarget:self
                 action:@selector(submenuAction:)
       forControlEvents:UIControlEventTouchUpInside];
    ToolBoxItem *freeHandTool = [ToolBoxItem alloc];
    [freeHand setTool:freeHandTool];
    [freeHand.tool setState:FREE];
    [freeHand.tool setColor:[UIColor colorWithWhite:0 alpha:1]];
    freeHand.frame = CGRectMake(131, 2.0, 40.0, 40.0);
    
    CustomButton *color_blue = [CustomButton buttonWithType:UIButtonTypeCustom];
    [color_blue addTarget:self
                   action:@selector(submenuAction:)
         forControlEvents:UIControlEventTouchUpInside];
    ToolBoxItem *blueTool = [ToolBoxItem alloc];
    [color_blue setTool:blueTool];
    [color_blue.tool setState:COLOR_BLUE];
    color_blue.frame = CGRectMake(5, 50, 40.0, 40.0);
    
    CustomButton *color_red = [CustomButton buttonWithType:UIButtonTypeCustom];
    [color_red addTarget:self
                  action:@selector(submenuAction:)
        forControlEvents:UIControlEventTouchUpInside];
    ToolBoxItem *redTool = [ToolBoxItem alloc];
    [color_red setTool:redTool];
    [color_red.tool setState:COLOR_RED];
    color_red.frame = CGRectMake(47, 50.0, 40.0, 40.0);
    
    CustomButton *color_green = [CustomButton buttonWithType:UIButtonTypeCustom];
    [color_green addTarget:self
                    action:@selector(submenuAction:)
          forControlEvents:UIControlEventTouchUpInside];
    ToolBoxItem *greenTool = [ToolBoxItem alloc];
    [color_green setTool:greenTool];
    [color_green.tool setState:COLOR_GREEN];
    color_green.frame = CGRectMake(89, 50.0, 40.0, 40.0);
    
    CustomButton *color_yellow = [CustomButton buttonWithType:UIButtonTypeCustom];
    [color_yellow addTarget:self
                     action:@selector(submenuAction:)
           forControlEvents:UIControlEventTouchUpInside];
    ToolBoxItem *yellowTool = [ToolBoxItem alloc];
    [color_yellow setTool:yellowTool];
    [color_yellow.tool setState:COLOR_YELLOW];
    color_yellow.frame = CGRectMake(131, 50.0, 40.0, 40.0);

    CustomButton *color_white = [CustomButton buttonWithType:UIButtonTypeCustom];
    [color_white addTarget:self
                     action:@selector(submenuAction:)
           forControlEvents:UIControlEventTouchUpInside];
    ToolBoxItem *whiteTool = [ToolBoxItem alloc];
    [color_white setTool:whiteTool];
    [color_white.tool setState:COLOR_WHITE];
    color_white.frame = CGRectMake(173, 50.0, 40.0, 40.0);
    
    
    
    [submenuView addSubview:circle];
    [submenuView addSubview:line];
    [submenuView addSubview:rectangle];
    [submenuView addSubview:freeHand];
    
    [submenuView addSubview:color_blue];
    [submenuView addSubview:color_red];
    [submenuView addSubview:color_yellow];
    [submenuView addSubview:color_green];
     [submenuView addSubview:color_white];
    
    
}
- (void)changeMenuTool:(CustomButton *)btnPressed menuButon:(CustomButton *)menuBtn {
    NSInteger color_arr = 99;
    if(btnPressed.tool.state < 6) {
        menuBtn.tool.state = btnPressed.tool.state;
    }else {
        // Color changed
        
        if(btnPressed.tool.state == COLOR_BLUE) {
            color_arr = 0;
            menuBtn.tool.color = [UIColor colorWithRed: 0.035 green:0.608 blue: 0.973 alpha:1];
        }else if(btnPressed.tool.state == COLOR_GREEN) {
            menuBtn.tool.color = [UIColor colorWithRed: 0.039 green: 0.627 blue: 0.035 alpha:1];
            color_arr = 1;
        }else if (btnPressed.tool.state == COLOR_RED) {
            
            menuBtn.tool.color = [UIColor colorWithRed: 0.894 green: 0.024 blue: 0.075 alpha:1];
            color_arr = 3;
        }else if (btnPressed.tool.state == COLOR_YELLOW) {
            color_arr = 2;
            menuBtn.tool.color = [UIColor colorWithRed:0.984 green: 0.953 blue:0.008 alpha:1];
            
        }else if (btnPressed.tool.state == COLOR_WHITE) {
            color_arr = 4;
            menuBtn.tool.color = [UIColor colorWithRed:1 green: 1 blue:1 alpha:1];
            
        }
        
        
        
    }
    
    if(menuBtn.tag == 1) {
        if(color_arr !=99)[Repository setMenu1Color:color_arr];
        [Repository setMenu1Symbol:menuBtn.tool.state];
    } else if(menuBtn.tag == 2) {
        if(color_arr !=99)[Repository setMenu2Color:color_arr];
        [Repository setMenu2Symbol:menuBtn.tool.state];
    } else if(menuBtn.tag == 3) {
        if(color_arr !=99)[Repository setMenu3Color:color_arr];
        [Repository setMenu3Symbol:menuBtn.tool.state];
    } else if(menuBtn.tag == 4) {
        if(color_arr !=99)[Repository setMenu4Color:color_arr];
        [Repository setMenu4Symbol:menuBtn.tool.state];
    }
    
    [[self delegate] currentTool:menuBtn.tool];
    [menuBtn setNeedsDisplay];
}

- (void) submenuAction:(id)sender {
    CustomButton *btn = (CustomButton *) sender;
    if(menuOne.selected) {
        [self changeMenuTool:btn menuButon:menuOne];
        
    } else if (menuTwo.selected) {
        [self changeMenuTool:btn menuButon:menuTwo];
    } else if (menuThree.selected) {
        [self changeMenuTool:btn menuButon:menuThree];
    }else if (menuFour.selected) {
        [self changeMenuTool:btn menuButon:menuFour];
    }
    [self showExtendedMenu:NO yPos:0];
    
}


- (void)showExtendedMenu:(BOOL)visible yPos:(CGFloat) y {
    if(visible) {
        
        if(dualMode) {
            CGRect newFrame = CGRectMake(initFrame.origin.x -220 , self.frame.origin.y,
                                         240,self.frame.size.height);
            self.frame = newFrame;

            [submenuView setFrame:CGRectMake(0, y - 20, submenuView.frame.size.width, submenuView.frame.size.height)];
                         [menuView setFrame:CGRectMake(220,0 , 40,  self.frame.size.height)];
        } else {
            CGRect newFrame = CGRectMake(initFrame.origin.x , self.frame.origin.y,
                                         240,self.frame.size.height);
            self.frame = newFrame;
            [submenuView setFrame:CGRectMake(submenuView.frame.origin.x, y - 20, submenuView.frame.size.width, submenuView.frame.size.height)];
        }
        
        [submenuView setHidden:false];
        change_frame = false;
    } else {
        CGRect newFrame = CGRectMake(initFrame.origin.x ,
                                     self.frame.origin.y,
                                     40,
                                     self.frame.size.height);
                         [menuView setFrame:CGRectMake(0,0 , 40,  self.frame.size.height)];
        [submenuView setHidden:true];
        self.frame= newFrame;
        change_frame = false;
    }
}

#pragma mark menu
- (void)unselectAllMenuButtons {
    [menuOne setSelected:false];
    [menuTwo setSelected:false];
    [menuThree setSelected:false];
    [menuFour setSelected:false];
    
}
- (void)unselectNotActiveButtons:(NSInteger) tagId {
    if (tagId == 1) {
        [menuTwo setSelected:false];
        [menuThree setSelected:false];
        [menuFour setSelected:false];
    } else if (tagId == 2) {
        [menuOne setSelected:false];
        [menuThree setSelected:false];
        [menuFour setSelected:false];
    } else if (tagId == 3) {
        [menuOne setSelected:false];
        [menuTwo setSelected:false];
        [menuFour setSelected:false];
    }else if (tagId == 4) {
        [menuOne setSelected:false];
        [menuTwo setSelected:false];
        [menuThree setSelected:false];
    }
}
- (void) undoTool:(id)sender {
    [[self delegate] undoLatest];
}
- (void) eraseAll:(id)sender {
    [[self delegate] eraseAll];
}
- (void) showMenu1:(id)sender {
    CustomButton *btn = (CustomButton *) sender;
    [self unselectNotActiveButtons:btn.tag];
    bool show_menu = !menu_visible && btn.selected;
    ToolBoxItem *tool = [ToolBoxItem alloc];
    if(show_menu){
        menu_visible = true;
        change_frame = true;
        [self showExtendedMenu:menu_visible yPos:btn.frame.origin.y + 10];
        
    } else if (btn.selected){
        [btn setSelected:!btn.selected];
        menu_visible = false;
        change_frame = true;
        [self showExtendedMenu:menu_visible yPos:btn.frame.origin.y + 10];
        
    } else {
        [self showExtendedMenu:false yPos:btn.frame.origin.y + 10];
        menu_visible = false;
        
        [btn setSelected:!btn.selected];
        
    }
    if(btn.selected) {
        // Send event to superview
        tool.state = btn.tool.state;
        tool.color = btn.tool.color;
    } else {
        tool.state = NONE;
    }
    [[self delegate] currentTool:tool];
    
    
    // change_frame = true;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
