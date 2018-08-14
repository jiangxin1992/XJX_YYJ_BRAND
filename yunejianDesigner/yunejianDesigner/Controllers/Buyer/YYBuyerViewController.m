//
//  YYBuyerViewController.m
//  yunejianDesigner
//
//  Created by Apple on 16/6/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYBuyerViewController.h"
#import "YYTopBarShoppingCarButton.h"
#import "YYPageInfoModel.h"
#import "AppDelegate.h"
#import "YYUser.h"
#import "YYMessageButton.h"
#import "YYOrderApi.h"
#import "YYConnApi.h"
#import "YYBrandSeriesListViewController.h"
#import "YYBuyerInviteViewController.h"
#import "UserDefaultsMacro.h"
#import "TitlePagerView.h"
#import "YYBuyerTableViewController.h"
#import "YYUserApi.h"
#import "YYConnBuyerModel.h"
#import "YYMessageUnreadModel.h"

@interface YYBuyerViewController ()<ViewPagerDataSource, ViewPagerDelegate, TitlePagerViewDelegate,YYTableCellDelegate>
@property (weak, nonatomic) IBOutlet UIView *msgBtnContainer;
@property (nonatomic,strong) YYMessageButton *messageButton;
@property(nonatomic,strong) YYStylesAndTotalPriceModel *stylesAndTotalPriceModel;//总数
@property (strong, nonatomic) TitlePagerView *pagingTitleView;
@property (nonatomic, assign) NSInteger currentIndex;
@property(strong,nonatomic) YYBuyerTableViewController *connedBuyerTableVC;
@property(strong,nonatomic) YYBuyerTableViewController *conningBuyerTableVC;
@end

@implementation YYBuyerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _messageButton = [[YYMessageButton alloc] init];
    [_messageButton initButton:@""];
    [self messageCountChanged:nil];
    [_msgBtnContainer addSubview:_messageButton];
    [_messageButton addTarget:self action:@selector(messageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageCountChanged:) name:UnreadMsgAmountChangeNotification object:nil];
    __weak UIView *weakContainerView = _msgBtnContainer;
    [_messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakContainerView.mas_bottom);
        make.left.equalTo(weakContainerView.mas_left);
        make.top.equalTo(weakContainerView.mas_top);
        make.right.equalTo(weakContainerView.mas_right);
    }];
    
    if (!_pagingTitleView) {
        self.pagingTitleView = [[TitlePagerView alloc] init];
        self.pagingTitleView.frame = CGRectMake(37, 4, SCREEN_WIDTH-37-37, 40);
        self.pagingTitleView.font = [UIFont systemFontOfSize:14];
        NSArray *titleArray = @[NSLocalizedString(@"合作买手店",nil),NSLocalizedString(@"已经邀请_short",nil)];
        float titleViewWidth = [TitlePagerView calculateTitleWidth:titleArray withFont:self.pagingTitleView.font];
        self.pagingTitleView.width = titleViewWidth;
        float titleViewOffsetX = (SCREEN_WIDTH-37-37 - titleViewWidth)/2;
        self.pagingTitleView.x = 37 +MAX(0, titleViewOffsetX);
        [self.pagingTitleView addObjects:titleArray];
        self.pagingTitleView.delegate = self;
    }
    self.pagingTitleView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.pagingTitleView];
    self.dataSource = self;
    self.delegate = self;

    self.manualLoadData = YES;
    self.currentIndex = 0;
    [self reloadData];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    YYBuyerTableViewController *tableViewController = (YYBuyerTableViewController *)[self viewControllerAtIndex:_currentIndex];
    if(tableViewController != nil){
        [tableViewController reloadBrandData];
    }
    // 进入埋点
    [MobClick beginLogPageView:kYYPageBuyer];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageBuyer];
}

- (void)messageCountChanged:(NSNotification *)notification{

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.messageUnreadModel setUnreadMessageAmount:_messageButton];

}

- (void)messageButtonClicked:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate showMessageView:nil parentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)shoppingCarClicked:(id)sender{
}

- (IBAction)addBrandHandler:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Buyer" bundle:[NSBundle mainBundle]];
    YYBuyerInviteViewController *inviteBuyerViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYBuyerInviteViewController"];
    [self.navigationController pushViewController:inviteBuyerViewController animated:YES];
    
}

#pragma YYTableCellDelegate
-(void)btnClick:(NSInteger)row section:(NSInteger)section andParmas:(NSArray *)parmas{
    if(parmas == nil )
        return;
    NSString *type = [parmas objectAtIndex:0];
    if([type isEqualToString:@"brandInfo"] ){

        YYConnBuyerModel * infoModel = [parmas objectAtIndex:1];

        WeakSelf(ws);
        AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appdelegate showBuyerInfoViewController:infoModel.buyerId WithBuyerName:infoModel.buyerName parentViewController:self WithReqSuccessBlock:nil WithHomePageCancelBlock:^{
            [ws.navigationController popViewControllerAnimated:YES];
            YYBuyerTableViewController *tableViewController = (YYBuyerTableViewController *)[ws viewControllerAtIndex:_currentIndex];
            if(tableViewController != nil){
                [tableViewController reloadBrandData];
            }
        } WithModifySuccessBlock:nil];
        
    }else if([type isEqualToString:@"addBrand"]){
        WeakSelf(ws);
        [YYUserApi getUserStatus:-1 andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSInteger status, NSError *error) {
            if(rspStatusAndMessage.status == YYReqStatusCode100){
                if(status == YYUserStatusOk){
                    [ws addBrandHandler:nil];
                }else{
                    [YYToast showToastWithView:ws.view title:NSLocalizedString(@"您还没有通过品牌身份认证，不能添加合作买手店",nil) andDuration:kAlertToastDuration];
                }
            }else{
                [YYToast showToastWithView:ws.view title:rspStatusAndMessage.message andDuration:kAlertToastDuration];
            }
        }];
    }
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return 2;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    if (index == 0) {
        return [self createConnedTableVC];
    } else if (index == 1) {
        return [self createConningTableVC];
    } else {
        return nil;
    }
}

- (UIViewController *)createConnedTableVC {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Buyer" bundle:[NSBundle mainBundle]];
    self.connedBuyerTableVC = [storyboard instantiateViewControllerWithIdentifier:@"YYBuyerTableViewController"];
    self.connedBuyerTableVC.currentListType = 1;
    self.connedBuyerTableVC.delegate = self;
    return self.connedBuyerTableVC;
}

- (UIViewController *)createConningTableVC {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Buyer" bundle:[NSBundle mainBundle]];
    self.conningBuyerTableVC = [storyboard instantiateViewControllerWithIdentifier:@"YYBuyerTableViewController"];
    self.conningBuyerTableVC.currentListType = 0;
    self.conningBuyerTableVC.delegate = self;
    return self.conningBuyerTableVC;
}



- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index {
    self.currentIndex = index;
}


#pragma TitlePagerViewDelegate
- (void)didTouchBWTitle:(NSUInteger)index {
    
    UIPageViewControllerNavigationDirection direction;
    
    if (self.currentIndex == index) {
        return;
    }
    
    if (index > self.currentIndex) {
        direction = UIPageViewControllerNavigationDirectionForward;
    } else {
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
    
    UIViewController *viewController = [self viewControllerAtIndex:index];
    
    if (viewController) {
        __weak typeof(self) weakself = self;
        [self.pageViewController setViewControllers:@[viewController] direction:direction animated:YES completion:^(BOOL finished) {
            weakself.currentIndex = index;
        }];
    }
}

- (void)setCurrentIndex:(NSInteger)index {
    _currentIndex = index;
    [self.pagingTitleView adjustTitleViewByIndex:index];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    
    if (self.currentIndex != 0 && contentOffsetX <= SCREEN_WIDTH * 2) {
        contentOffsetX += SCREEN_WIDTH * self.currentIndex;
    }
    
    [self.pagingTitleView updatePageIndicatorPosition:contentOffsetX];
}

- (void)scrollEnabled:(BOOL)enabled {
    self.scrollingLocked = !enabled;
    
    for (UIScrollView *view in self.pageViewController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            view.scrollEnabled = enabled;
            view.bounces = enabled;
        }
    }
}

@end
