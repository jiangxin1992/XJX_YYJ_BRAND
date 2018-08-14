//
//  YYIntroductionViewController.m
//  Yunejian
//
//  Created by Apple on 15/10/15.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "YYIntroductionViewController.h"

@interface YYIntroductionViewController ()
@property (nonatomic, strong) NSArray *backgroundViews;
@property (nonatomic, strong) NSArray *scrollViewPages;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) NSInteger centerPageIndex;
@property (nonatomic) CGRect viewFrame;
@end

@implementation YYIntroductionViewController

#pragma mark - --------------生命周期--------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self RequestData];
}

#pragma mark - --------------SomePrepare--------------
- (void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
- (void)PrepareData{}
- (void)PrepareUI{
    self.viewFrame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    if(SYSTEM_VERSION_LESS_THAN(@"8.0")){
        self.viewFrame = CGRectMake(0, 0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds));

    }
    [self addBackgroundViews];

    self.pagingScrollView = [[UIScrollView alloc] initWithFrame:self.viewFrame];
    self.pagingScrollView.delegate = self;
    self.pagingScrollView.pagingEnabled = YES;
    self.pagingScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.pagingScrollView];

    self.pageControl = [[UIPageControl alloc] initWithFrame: [self frameOfPageControl]];
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    [self.view addSubview:self.pageControl];

    if (!self.enterButton) {
        self.enterButton = [[UIButton alloc] init];
    }

    [self.enterButton addTarget:self action:@selector(enter:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.enterButton];

    [self reloadPages];
    self.pageControl.frame = [self frameOfPageControl];
    self.enterButton.frame = [self frameOfEnterButton];
}
- (id)initWithCoverImageNames:(NSArray *)coverNames backgroundImageNames:(NSArray *)bgNames {
    if (self = [super init]) {
        [self initSelfWithCoverNames:coverNames backgroundImageNames:bgNames];
    }
    return self;
}

- (id)initWithCoverImageNames:(NSArray *)coverNames backgroundImageNames:(NSArray *)bgNames button:(UIButton *)button {
    if (self = [super init]) {
        [self initSelfWithCoverNames:coverNames backgroundImageNames:bgNames];
        self.enterButton = button;
    }
    return self;
}

- (void)initSelfWithCoverNames:(NSArray *)coverNames backgroundImageNames:(NSArray *)bgNames
{
    self.coverImageNames = coverNames;
    self.backgroundImageNames = bgNames;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 进入埋点
    [MobClick beginLogPageView:kYYPageIntroduction];
    self.pageControl.frame = [self frameOfPageControl];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageIntroduction];
}

- (BOOL)prefersStatusBarHidden{
    return YES; // 返回NO表示要显示，返回YES将hiden
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{}

#pragma mark - --------------请求数据----------------------
-(void)RequestData{}

#pragma mark - --------------系统代理----------------------

#pragma mark - --------------自定义代理/block----------------------

#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / self.viewFrame.size.width;
    CGFloat alpha = 1 - ((scrollView.contentOffset.x - index * self.viewFrame.size.width) / self.viewFrame.size.width);
    if ([self.backgroundViews count] > index) {
        UIView *v = [self.backgroundViews objectAtIndex:index];
        if (v) {
            [v setAlpha:alpha];
        }
    }
    self.pageControl.currentPage = scrollView.contentOffset.x / (scrollView.contentSize.width / [self numberOfPagesInPagingScrollView]);
    [self pagingScrollViewDidChangePages:scrollView];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView.panGestureRecognizer translationInView:scrollView.superview].x < 0) {
        if (![self hasNext:self.pageControl]) {
        }
    }
}

#pragma mark -UIScrollView & UIPageControl DataSource
- (NSInteger)numberOfPagesInPagingScrollView
{
    return [[self coverImageNames] count];
}

- (void)pagingScrollViewDidChangePages:(UIScrollView *)pagingScrollView {
    if ([self isLast:self.pageControl]) {
        if (self.pageControl.alpha == 1) {
            self.enterButton.alpha = 0;
            
            [UIView animateWithDuration:0.4 animations:^{
                self.enterButton.alpha = 1;
                self.pageControl.alpha = 0.99;
            }];
        }
    } else {
        if (self.pageControl.alpha == 0.99) {
            [UIView animateWithDuration:0.4 animations:^{
                self.enterButton.alpha = 0;
                self.pageControl.alpha = 1;
            }];
        }
    }
    self.pageControl.frame = [self frameOfPageControl];
}

#pragma mark - --------------自定义响应----------------------
- (void)enter:(id)object
{
    self.enterButton.enabled = NO;
    self.didSelectedEnter();
}

#pragma mark - --------------自定义方法----------------------
- (void)addBackgroundViews
{
    CGRect frame = self.viewFrame;
    NSMutableArray *tmpArray = [NSMutableArray new];
    [[[[self backgroundImageNames] reverseObjectEnumerator] allObjects] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:obj]];
        imageView.frame = frame;
        imageView.tag = idx + 1;
        [tmpArray addObject:imageView];
        [self.view addSubview:imageView];
    }];

    self.backgroundViews = [[tmpArray reverseObjectEnumerator] allObjects];
}

- (void)reloadPages
{
    self.pageControl.numberOfPages = [[self coverImageNames] count];
    self.pagingScrollView.contentSize = [self contentSizeOfScrollView];

    __block CGFloat x = 0;
    [[self scrollViewPages] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        obj.frame = CGRectOffset(obj.frame, x, 0);
        [self.pagingScrollView addSubview:obj];

        x += obj.frame.size.width;
    }];
    
    if (self.pageControl.numberOfPages == 1) {
        self.enterButton.alpha = 1;
        self.pageControl.alpha = 0;
    }
    
    if (self.pagingScrollView.contentSize.width == self.pagingScrollView.frame.size.width) {
        self.pagingScrollView.contentSize = CGSizeMake(self.pagingScrollView.contentSize.width + 1, self.pagingScrollView.contentSize.height);
    }
}

- (CGRect)frameOfPageControl
{
    CGSize size = CGSizeMake(300, 30);
    float btnMaxY = CGRectGetMaxY(self.enterButton.frame);
    float contentHeight = CGRectGetHeight(self.viewFrame);
    float pageY = 0;
    if((contentHeight - btnMaxY) > (size.height +20)){
        pageY = contentHeight - (size.height +20);
    }else{
        pageY = contentHeight - size.height;
    }

    return CGRectMake(self.viewFrame.size.width / 2 - size.width / 2,pageY, size.width, size.height);
}

- (CGRect)frameOfEnterButton
{
    CGSize size = self.enterButton.bounds.size;
    float btnY = self.enterButton.frame.origin.y;
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        float posYRate = self.viewFrame.size.width/375.0;
        float imageHeight = 667*posYRate;
        btnY = 517*posYRate  - MAX(0,(imageHeight- self.viewFrame.size.height)/2);
        float posWRate = 600.0/750.0;
        size = CGSizeMake(self.viewFrame.size.width*posWRate, 55*posYRate);
        if(kIPhoneX){
            btnY += (size.height + 18);
        }
    }
    return CGRectMake(self.viewFrame.size.width / 2 - size.width / 2, btnY, size.width, size.height);
}

- (BOOL)hasNext:(UIPageControl*)pageControl
{
    return pageControl.numberOfPages > pageControl.currentPage + 1;
}

- (BOOL)isLast:(UIPageControl*)pageControl
{
    return pageControl.numberOfPages == pageControl.currentPage + 1;
}

- (BOOL)hasEnterButtonInView:(UIView*)page
{
    __block BOOL result = NO;
    [page.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (obj && obj == self.enterButton) {
            result = YES;
        }
    }];
    return result;
}

- (UIImageView*)scrollViewPage:(NSString*)imageName
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    CGSize size = {self.viewFrame.size.width, self.viewFrame.size.height};
    imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, size.width, size.height);
    return imageView;
}

- (NSArray*)scrollViewPages
{
    if ([self numberOfPagesInPagingScrollView] == 0) {
        return nil;
    }

    if (_scrollViewPages) {
        return _scrollViewPages;
    }

    NSMutableArray *tmpArray = [NSMutableArray new];
    [self.coverImageNames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

        UIImageView *v = [self scrollViewPage:obj];
        [tmpArray addObject:v];

    }];

    _scrollViewPages = tmpArray;

    return _scrollViewPages;
}

- (CGSize)contentSizeOfScrollView
{
    UIView *view = [[self scrollViewPages] firstObject];
    return CGSizeMake(view.frame.size.width * self.scrollViewPages.count, view.frame.size.height);
}

#pragma mark - --------------other----------------------

@end
