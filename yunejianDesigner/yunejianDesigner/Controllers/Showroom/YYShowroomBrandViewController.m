//
//  YYShowroomBrandViewController.m
//  yunejianDesigner
//
//  Created by yyj on 2017/3/10.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YYShowroomBrandViewController.h"

#import "YYOpusViewController.h"
#import "YYOrderListViewController.h"

#import "YYShowroomBrandTabBar.h"

#import "YYShowroomApi.h"
#import "UserDefaultsMacro.h"
#import "AppDelegate.h"
#import "YYStylesAndTotalPriceModel.h"

#import "MBProgressHUD.h"

#define showroomHomeTabbarHeight 58

@interface YYShowroomBrandViewController ()

@property (nonatomic,strong) YYOpusViewController *opusCtn;
@property (nonatomic,strong) YYOrderListViewController *orderCtn;

@property (nonatomic,strong) YYShowroomBrandTabBar *tabBarView;

@end

@implementation YYShowroomBrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.隐藏系统自带的标签栏
    [self SomePrepare];
    //2.添加一个自定义的view3.添加按钮(标签)
    [self createTabbar];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 进入埋点
    [MobClick beginLogPageView:kYYPageShowroomBrand];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageShowroomBrand];
}

- (void)setBrandId:(NSNumber *)brandId{
    _brandId = brandId;
    [self RequestData];
}

#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}

-(void)PrepareData{
    //1.隐藏系统自带的标签栏
    self.tabBar.hidden = YES;
}
-(void)PrepareUI{
    self.view.backgroundColor = _define_white_color;
    UIStoryboard *opusStoryboard = [UIStoryboard storyboardWithName:@"Opus" bundle:[NSBundle mainBundle]];
    _opusCtn = [opusStoryboard instantiateViewControllerWithIdentifier:@"YYOpusViewController"];
    
    UIStoryboard *orderStoryboard = [UIStoryboard storyboardWithName:@"OrderDetail" bundle:[NSBundle mainBundle]];
    _orderCtn = [orderStoryboard instantiateViewControllerWithIdentifier:@"YYOrderListViewController"];
}
#pragma mark - UIConfig
-(void)createTabbar{
    //     对_tabbar进行初始化，并进行ui布局
    _tabBarView = [[YYShowroomBrandTabBar alloc] initWithSuperView:self.view WithBlock:^(NSInteger type) {
        if(type>=0)
        {
            self.selectedIndex = type;
        }else
        {
            [self backHomePage];
        }
    }];
}
-(void)createViewControllersWithStatus:(YYRspStatusAndMessage *)rspStatusAndMessage
{
    //     创建数组并初始化
    NSMutableArray *vcs = [[NSMutableArray alloc]init];
    for (int i = 0; i<2; i++) {
        UIViewController *vc = nil;
        if(rspStatusAndMessage.status == YYReqStatusCode100){
            vc =i==0?_opusCtn:_orderCtn;
        }else{
            vc=[[UIViewController alloc] init];
        }
        vc.view.backgroundColor=_define_white_color;
        [vcs addObject:vc];
    }
    //    将数组中的视图添加到当前的tabbarController中去
    self.viewControllers = vcs;
    self.selectedIndex=0;
    
    if(rspStatusAndMessage.status != YYReqStatusCode100)
    {
        [YYToast showToastWithView:self.view title:rspStatusAndMessage.message andDuration:kAlertToastDuration];
    }else
    {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:[[NSString alloc] initWithFormat:@"%ld",[_brandId integerValue]] forKey:kTempBrandID];
        [userDefaults synchronize];
    }
}
#pragma mark - RequestData
-(void)RequestData
{
    [YYShowroomApi showroomToBrandWithBrandID:_brandId andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYUserModel *userModel, NSError *error) {
        
        [self createViewControllersWithStatus:rspStatusAndMessage];
        
    }];
}
#pragma mark - SomeAction
-(void)backHomePage
{
    if(_cancelButtonClicked)
    {
        AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        YYStylesAndTotalPriceModel *stylesAndTotalPriceModel = getLocalShoppingCartStyleCount(appdelegate.cartDesignerIdArray);
        if(stylesAndTotalPriceModel.totalStyles)
        {
            WeakSelf(ws);
            CMAlertView *alertView = [[CMAlertView alloc] initWithTitle:NSLocalizedString(@"确定返回Showroom？",nil) message:NSLocalizedString(@"返回后，此品牌购物车内的款式将被清空",nil) needwarn:NO delegate:nil cancelButtonTitle:NSLocalizedString(@"暂不返回_no",nil) otherButtonTitles:@[NSLocalizedString(@"返回主页_yes",nil)] otherBtnBackColor:@"000000"];
            alertView.specialParentView = self.view;
            [alertView setAlertViewBlock:^(NSInteger selectedIndex){
                if (selectedIndex == 1) {
                    [ws backAction];
                }
            }];
            [alertView show];
        }else
        {
            [self backAction];
        }
    }
}
-(void)backAction
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [YYShowroomApi brandToShowroomBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYUserModel *userModel, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(rspStatusAndMessage.status == YYReqStatusCode100){
            //清除购物车
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate clearBuyCar];
            if(_cancelButtonClicked)
            {
                _cancelButtonClicked();
            }
        }else{

            [YYToast showToastWithView:self.view title:rspStatusAndMessage.message andDuration:kAlertToastDuration];
        }
    }];
}
#pragma mark - other

- (BOOL)prefersStatusBarHidden{
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
