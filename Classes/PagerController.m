#import "PagerController.h"
#import "ViewBuilder.h"

@implementation PagerController {
    NSArray* _pages;
    NSMutableArray* _viewControllers;
    UIScrollView* _scroll;
    UIPageControl* _pager;
    int _currentPage;
}

- (id)initWithChildControllers:(NSArray*)pages {
    self = [super initWithNibName:nil bundle:nil];
    _pages = pages;
    _viewControllers = [NSMutableArray array];
    _currentPage = 0;
    return self;
}

+ (UIViewController*)pagerControllerWithPages:(NSArray*)pages {
    return [[self alloc] initWithChildControllers:pages];
}

- (void)loadView {
    [super loadView];

    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    _scroll = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _scroll.pagingEnabled = YES;
    _scroll.backgroundColor = [UIColor clearColor];
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.delegate = self;
    [self.view addSubview:_scroll];

    for(UIViewController* page in _pages) {
        [self addChildViewController:page];
        [_viewControllers addObject:page];
        [_scroll addSubview:page.view];
    }

    _pager = [UIPageControl new];
    _pager.numberOfPages = _viewControllers.count;
    _pager.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_pager];
    [_pager addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventValueChanged];
    [_pager sizeToFit];
}

- (void)pageAction:(UIPageControl*)control {
    [self moveToPage:_pager.currentPage];
}

- (void)moveToPage:(NSUInteger)page {
    _scroll.contentOffset = CGPointMake(_scroll.frame.size.width * page, 0);
    [self scrollViewDidScroll:_scroll];
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    double page = floor((scrollView.contentOffset.x - pageWidth / 2.0) / pageWidth) + 1.0;
    //[self moveToPage:lround(page)];
    if(fequal(_currentPage, page))
        return;
    _currentPage = (int) page;
    UIViewController* previousViewController = _viewControllers[(NSUInteger) _pager.currentPage];
    _pager.currentPage = (NSInteger) page;
    [previousViewController viewWillDisappear:YES];
    [self.currentViewController viewWillAppear:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [previousViewController viewDidDisappear:YES];
        [self.currentViewController viewDidAppear:YES];
    });
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    ViewBuilder* contentBuilder = [ViewBuilder verticalBuilderForView:self.view];
    [contentBuilder addSpace:0];
    [contentBuilder addFlexibleSpaceWithFactor:1];
    [contentBuilder addSpace:0];
    [contentBuilder addCenteredView:_pager];
    ViewBuilderResult* contentResults = [contentBuilder build];
    _scroll.frame = [contentResults frameAtIndex:1];
    _scroll.contentSize = CGSizeMake(_scroll.bounds.size.width * _viewControllers.count, _scroll.bounds.size.height);
    _pager.frame = [contentResults frameAtIndex:3];

    CGRect graphFrame = _scroll.bounds;
    for(NSUInteger i = 0; i < [_viewControllers count]; i++) {
        UIView* graphView = [_viewControllers[i] view];
        CGFloat pageStart = i * graphFrame.size.width;
        graphView.frame = CGRectMake(pageStart, graphFrame.origin.y, graphFrame.size.width, graphFrame.size.height);
    }
    [self.currentViewController viewWillAppear:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.currentViewController viewDidAppear:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.currentViewController viewWillDisappear:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.currentViewController viewDidDisappear:YES];
}

- (id)currentViewController {
    return _viewControllers[(NSUInteger) _pager.currentPage];
}

@end