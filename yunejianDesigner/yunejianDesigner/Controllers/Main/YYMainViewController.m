//
//  YYMainViewController.m
//  Yunejian
//
//  Created by yyj on 15/7/5.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYMainViewController.h"

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "YYLeftMenuViewController.h"
#import "YYAccountDetailViewController.h"
#import "YYOrderListViewController.h"
#import "YYBuyerViewController.h"
#import "YYOpusViewController.h"

// 自定义视图

// 接口

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "YYMessageUnreadModel.h"
#import "AppDelegate.h"
#import "JPUSHService.h"
#import "YYGuideHandler.h"
#import "UserDefaultsMacro.h"

@interface YYMainViewController ()

@property(nonatomic,strong) YYLeftMenuViewController *leftMenuViewController;

@property(nonatomic,strong) YYOpusViewController *opusViewController;
@property(nonatomic,strong) YYOrderListViewController *orderListViewController;
@property(nonatomic,strong) YYBuyerViewController *buyerViewController;
@property(nonatomic,strong) YYAccountDetailViewController *accountDetailViewController;

@property(nonatomic,strong) UIView *currentRightView;
@property (weak, nonatomic) IBOutlet UIView *rightContainerView;

@property(nonatomic,assign) BOOL isUploadingOrderNow;

@end

@implementation YYMainViewController

#pragma mark - --------------生命周期--------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 进入埋点
    [MobClick beginLogPageView:kYYPageMain];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageMain];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    WeakSelf(ws);
    NSLog(@"prepareForSegue.....");
    [self addAllChildViewContrllers];

    id destinationViewController = [segue destinationViewController];
    if ([destinationViewController isKindOfClass:[YYLeftMenuViewController class]]) {
        NSLog(@"prepareForSegue.....YYLeftMenuViewController ");
        YYLeftMenuViewController *leftMenuViewController = (YYLeftMenuViewController *)destinationViewController;
        self.leftMenuViewController = leftMenuViewController;

        if (leftMenuViewController) {
            [leftMenuViewController setLeftMenuButtonClicked:^(LeftMenuButtonType buttonIndex){

                NSLog(@"prepareForSegue.....YYLeftMenuViewController %li ",(long)buttonIndex);
                [ws leftMenuButtonClicked:buttonIndex];

            }];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - --------------SomePrepare--------------
- (void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
- (void)PrepareData{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showOrderListNotification:)
                                                 name:kShowOrderListNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showAccountNotification:)
                                                 name:kShowAccountNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkDidSetup:)
                                                 name:kJPFNetworkDidSetupNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkDidClose:)
                                                 name:kJPFNetworkDidCloseNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkDidRegister:)
                                                 name:kJPFNetworkDidRegisterNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkDidLogin:)
                                                 name:kJPFNetworkDidLoginNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkDidReceiveMessage:)
                                                 name:kJPFNetworkDidReceiveMessageNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(serviceError:)
                                                 name:kJPFServiceErrorNotification
                                               object:nil];
}

- (void)networkDidSetup:(NSNotification *)notification {
    NSLog(@"已连接");
}

- (void)networkDidClose:(NSNotification *)notification {
    NSLog(@"未连接");
}

- (void)networkDidRegister:(NSNotification *)notification {
    NSLog(@"%@", [notification userInfo]);
    NSLog(@"已注册");
}

- (void)networkDidLogin:(NSNotification *)notification {
    NSLog(@"已登录");

    if ([JPUSHService registrationID]) {
        NSLog(@"get RegistrationID");
    }
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *title = [userInfo valueForKey:@"title"];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extra = [userInfo valueForKey:@"extras"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];

    NSString *currentContent = [NSString
                                stringWithFormat:
                                @"收到自定义消息:%@\ntitle:%@\ncontent:%@\nextra:%@\n",
                                [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                               dateStyle:NSDateFormatterNoStyle
                                                               timeStyle:NSDateFormatterMediumStyle],
                                title, content, [self logDic:extra]];
    NSLog(@"%@", currentContent);
    NSInteger msgType = [[extra objectForKey:@"msgType"] integerValue];
    NSInteger isowner = [[extra objectForKey:@"isowner"] integerValue];
    if (msgType == 4 && isowner == 0) {//私信
        NSInteger unreadPersonalMsgAmount = [[extra objectForKey:@"unreadCount"] integerValue];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.messageUnreadModel.personalMessageAmount = @(unreadPersonalMsgAmount);
        [[NSNotificationCenter defaultCenter] postNotificationName:UnreadMsgAmountChangeNotification object:nil userInfo:nil];

    }
}
// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}
- (void)serviceError:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *error = [userInfo valueForKey:@"error"];
    NSLog(@"%@", error);
}
- (void)showOrderListNotification:(NSNotification *)note{
    [self.navigationController popToViewController:self animated:NO];
    [self leftMenuButtonClicked:LeftMenuButtonTypeOrder];
    [self.leftMenuViewController setButtonSelectedByButtonIndex:LeftMenuButtonTypeOrder];
    WeakSelf(ws);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(ws.orderListViewController){
            [ws.orderListViewController changeTabIndex:0];
        }
    });
}
- (void)showAccountNotification:(NSNotification *)note{
    [self.navigationController popToViewController:self animated:NO];
    [self leftMenuButtonClicked:LeftMenuButtonTypeAccount];
    [self.leftMenuViewController setButtonSelectedByButtonIndex:LeftMenuButtonTypeAccount];
    WeakSelf(ws);
    //后续扩展类型
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(ws.accountDetailViewController){
            [ws.accountDetailViewController checkUserIdentity];
        }
    });
}
- (void)PrepareUI{}

#pragma mark - --------------UIConfig----------------------
//-(void)UIConfig{}
- (void)addAllChildViewContrllers{

    if (self.childViewControllers
        && [self.childViewControllers count] > 0) {
        return;
    }

    UIStoryboard *opusStoryboard = [UIStoryboard storyboardWithName:@"Opus" bundle:[NSBundle mainBundle]];
    YYOpusViewController *opusViewController = [opusStoryboard instantiateViewControllerWithIdentifier:@"YYOpusViewController"];
    self.opusViewController = opusViewController;
    [self addChildViewController:opusViewController];


    UIStoryboard *orderStoryboard = [UIStoryboard storyboardWithName:@"OrderDetail" bundle:[NSBundle mainBundle]];

    YYOrderListViewController *orderListViewController = [orderStoryboard instantiateViewControllerWithIdentifier:@"YYOrderListViewController"];
    self.orderListViewController = orderListViewController;
    [self addChildViewController:orderListViewController];


    UIStoryboard *accountStoryboard = [UIStoryboard storyboardWithName:@"Account" bundle:[NSBundle mainBundle]];

    YYAccountDetailViewController *accountDetailViewController = [accountStoryboard instantiateViewControllerWithIdentifier:@"YYAccountDetailViewController"];
    self.accountDetailViewController = accountDetailViewController;
    [self addChildViewController:accountDetailViewController];


    UIStoryboard *brandStoryboard = [UIStoryboard storyboardWithName:@"Buyer" bundle:[NSBundle mainBundle]];
    YYBuyerViewController *buyerViewController = [brandStoryboard instantiateViewControllerWithIdentifier:@"YYBuyerViewController"];
    self.buyerViewController = buyerViewController;
    [self addChildViewController:buyerViewController];

}

//#pragma mark - --------------请求数据----------------------
//-(void)RequestData{}

#pragma mark - --------------系统代理----------------------


#pragma mark - --------------自定义代理/block----------------------


#pragma mark - --------------自定义响应----------------------
- (void)leftMenuButtonClicked:(LeftMenuButtonType)buttonIndex{

    if (_currentRightView
        && buttonIndex != LeftMenuButtonTypeSetting) {
        [_currentRightView removeFromSuperview];
    }

    __weak  UIView *_weakRightContainerView = _rightContainerView;

    switch (buttonIndex) {
        case LeftMenuButtonTypeOpus:{
            [_rightContainerView addSubview:_opusViewController.view];
            [_opusViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_weakRightContainerView.mas_top);
                make.left.equalTo(_weakRightContainerView.mas_left);
                make.bottom.equalTo(_weakRightContainerView.mas_bottom);
                make.right.equalTo(_weakRightContainerView.mas_right);

            }];
            self.currentRightView = _opusViewController.view;
        }
            break;
        case LeftMenuButtonTypeOrder:{

            [_rightContainerView addSubview:_orderListViewController.view];
            [_orderListViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_weakRightContainerView.mas_top);
                make.left.equalTo(_weakRightContainerView.mas_left);
                make.bottom.equalTo(_weakRightContainerView.mas_bottom);
                make.right.equalTo(_weakRightContainerView.mas_right);
            }];

            self.currentRightView = _orderListViewController.view;

        }
            break;
        case LeftMenuButtonTypeAccount:{
            [YYGuideHandler markGuide:GuideTypeTabMe];

            [_rightContainerView addSubview:_accountDetailViewController.view];
            [_accountDetailViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_weakRightContainerView.mas_top);
                make.left.equalTo(_weakRightContainerView.mas_left);
                make.bottom.equalTo(_weakRightContainerView.mas_bottom);
                make.right.equalTo(_weakRightContainerView.mas_right);

            }];
            self.currentRightView = _accountDetailViewController.view;
        }
            break;
        case LeftMenuButtonTypeBuyer:{
            [_rightContainerView addSubview:_buyerViewController.view];
            [_buyerViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_weakRightContainerView.mas_top);
                make.left.equalTo(_weakRightContainerView.mas_left);
                make.bottom.equalTo(_weakRightContainerView.mas_bottom);
                make.right.equalTo(_weakRightContainerView.mas_right);

            }];
            self.currentRightView = _buyerViewController.view;
        }
            break;
        default:
            break;
    }
    NSLog(@"prepareForSegue.....YYLeftMenuViewController %li ",(long)buttonIndex);
}

#pragma mark - --------------自定义方法----------------------

#pragma mark - --------------other----------------------

@end
