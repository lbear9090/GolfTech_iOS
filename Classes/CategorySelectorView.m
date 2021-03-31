#import "CategorySelectorView.h"
#import "ViewBuilder.h"
#import "Category.h"
#import "UIImageAdditions.h"
#import "TechniqueListController.h"
#import "UILabelAdditions.h"
#import "UIColorAdditions.h"

static const int UnselectedTextColorHex = 0xd5d5d5;
static const int SelectedTextColorHex = 0xFFFFFF;
#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
@implementation CategorySelectorView {
    UIScrollView* _scrollView;
    NSUInteger _selectedIndex;
    NSMutableArray* _buttons;
    NSMutableArray* _labels;
    Boolean isIPAD ;
}

- (id)init {
    self = [super initWithFrame:CGRectZero];
    isIPAD = IPAD;
    _scrollView = [UIScrollView new];
    [self addSubview:_scrollView];

    _buttons = [NSMutableArray array];
    _labels = [NSMutableArray array];
    NSArray* categories = _repository.findCategories;
    for(NSUInteger i = 0; i < categories.count; i++) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(categorySelected:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:button];
        button.selected = _selectedIndex == i;
        [_buttons addObject:button];

        UILabel* label = [UILabel labelWithBoldText:[[categories[i] title] uppercaseString] fontSize:14 textColor:[UIColor colorWithRGBHex:UnselectedTextColorHex] backgroundColor:[UIColor clearColor] toView:button];
        label.textAlignment = NSTextAlignmentCenter;
        [_labels addObject:label];
    }
    [self selectIndex:0];

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    NSArray* categories = self.repository.findCategories;

    CGSize imageSize = [UIImage checkedImageNamed:[categories[0] imageName]].size;

    CGFloat spaceBetweenButtons = 8;
    CGFloat buttonsVisible = 2.5;
    if(isIPAD) {
        buttonsVisible = 2.5;
    }
    CGFloat buttonWidth = roundf((self.bounds.size.width - floorf(buttonsVisible) * spaceBetweenButtons) / buttonsVisible);
    
    
    UIEdgeInsets noInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _scrollView.frame = self.bounds;
    _scrollView.contentSize = CGSizeMake(buttonWidth * categories.count + spaceBetweenButtons * (categories.count - 1) , imageSize.height);
    _scrollView.contentInset = noInset;
    _scrollView.scrollIndicatorInsets = noInset;

    ViewBuilder* builder = [ViewBuilder horizontalBuilderForFrame:CGRectOffset(self.bounds, 0, spaceBetweenButtons)];
    for(NSUInteger i = 0; i < categories.count; i++) {
        Category* category = categories[i];
        UIButton* button = _buttons[i];
        button.tag = i;
        [button setBackgroundImage:[UIImage checkedImageNamed:category.imageName] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage checkedImageNamed:[NSString stringWithFormat:@"%@ vald", category.imageName]] forState:UIControlStateSelected];
        [button sizeToFit];
        if(!fequalf(button.frame.size.width, buttonWidth)) {
            MLog(@"Warning: image '%@' has width %.0f, should be %.0f", category.imageName, button.frame.size.width, buttonWidth);
        }
        button.frame = CGRectMake(0, 0, buttonWidth, button.frame.size.height);

        if(i > 0)
            [builder addSpace:spaceBetweenButtons];
        [builder addLeftView:button];
    }
    [builder build];

    for(NSUInteger i = 0; i < categories.count; i++) {
        UILabel* label = _labels[i];
        ViewBuilder* buttonBuilder = [ViewBuilder verticalBuilderForView:_buttons[i]];
        [buttonBuilder addFlexibleSpaceWithFactor:1];
        [buttonBuilder addSpace:16];
        [buttonBuilder addSpace:1];
        ViewBuilderResult* buttonResult = [buttonBuilder build];
        [label sizeToFit];
        label.frame = ([buttonResult frameAtIndex:1]);
    }
}

- (void)categorySelected:(UIButton*)button {
    [self selectIndex:button.tag];
}

- (void)selectIndex:(NSInteger)index {
    [_buttons[_selectedIndex] setSelected:NO];
    [_labels[_selectedIndex] setTextColor:[UIColor colorWithRGBHex:UnselectedTextColorHex]];
    [_labels[index] setTextColor:[UIColor colorWithRGBHex:SelectedTextColorHex]];

    _selectedIndex = (NSUInteger) index;
    [_buttons[index] setSelected:YES];

    [self setNeedsDisplay];
    [self.delegate didSelectCategory:self.repository.findCategories[_selectedIndex]];
}

@end