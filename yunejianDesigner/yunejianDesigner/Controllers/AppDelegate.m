//
//  AppDelegate.m
//  Yunejian
//
//  Created by yyj on 15/7/3.
//  Copyright (c) 2015年 yyj. All rights reserved.
//
//
//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                  佛祖镇楼                  BUG辟易
//          佛曰:
//                  写字楼里写字间，写字间里程序员；
//                  程序人员写程序，又拿程序换酒钱。
//                  酒醒只在网上坐，酒醉还来网下眠；
//                  酒醉酒醒日复日，网上网下年复年。
//                  但愿老死电脑间，不愿鞠躬老板前；
//                  奔驰宝马贵者趣，公交自行程序员。
//                  别人笑我忒疯癫，我笑自己命太贱；
//                  不见满街漂亮妹，哪个归得程序员？

#import "AppDelegate.h"

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "YYOrderModifyViewController.h"
#import "YYBuyerHomePageViewController.h"
#import "YYBrandSeriesViewController.h"
#import "YYShoppingViewController.h"
#import "YYShowroomMainViewController.h"
#import "YYStyleDetailViewController.h"
#import "YYGroupMessageViewController.h"
#import "YYIntroductionViewController.h"
#import "YYVerifyBrandViewController.h"

// 自定义视图
#import "YYYellowPanelManage.h"

// 接口
#import "YYUserApi.h"
#import "YYServerURLApi.h"
#import "YYBurideApi.h"
#import "YYShowroomApi.h"
#import "YYOrderApi.h"
#import "YYOpusApi.h"

// 分类
#import "UINavigationController+YRBackGesture.h"

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "JpushHandler.h"
#import <SDImageCache.h>
#import <Bugly/Bugly.h>
#import <UMMobClick/MobClick.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import <MBProgressHUD.h>

#import "YYUser.h"
#import "YYUserModel.h"
#import "YYSubShowroomUserPowerModel.h"
#import "YYOrderInfoModel.h"
#import "YYStyleInfoModel.h"
#import "YYOpusSeriesModel.h"
#import "YYOrderStyleModel.h"
#import "YYOrderSeriesModel.h"
#import "YYOpusStyleModel.h"
#import "YYInventoryBoardModel.h"
#import "YYBrandSeriesToCartTempModel.h"

#import "YYUpdateAppStore.h"
#import "YYUrlLinksHandler.h"
#import "UserDefaultsMacro.h"
#import "YYRspStatusAndMessage.h"

static NSString * const isFirstOpenApp = @"isFirstOpenApp";

@interface AppDelegate ()

/** 是否需要强制更新 */
@property (nonatomic,assign) BOOL isNeedUpdate;
/** 开始网络监控 */
@property (nonatomic, assign) BOOL isStartNetworkSpace;
/** delegate持有的加购页面*/
@property (nonatomic, strong) YYShoppingViewController *shoppingViewController;


@end

@implementation AppDelegate
#pragma mark - --------------生命周期--------------
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 网络监控
    [self AFNReachability];
    _isStartNetworkSpace = true;
    while (_isStartNetworkSpace) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }

    [UITableView appearance].estimatedRowHeight = 0;
    [UITableView appearance].estimatedSectionHeaderHeight = 0;
    [UITableView appearance].estimatedSectionFooterHeight = 0;

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *_isFirstOpenApp = [userDefault objectForKey:isFirstOpenApp];
    if([NSString isNilOrEmpty:_isFirstOpenApp]){
        [userDefault setObject:@"not_first_open" forKey:isFirstOpenApp];
        [userDefault synchronize];

        NSString *langCode = [LanguageManager currentLanguageCode];
        if ([langCode containsString:@"zh"]) {
            //        中文
            [LanguageManager saveLanguageByIndex:1];
        } else {
            //        非中文 默认为英文
            [LanguageManager saveLanguageByIndex:0];
        }
    }

    // 初始化bugly
    [Bugly startWithAppId:@"1c0eb0defb"];
    // 初始化友盟埋点
    [self initUmeng];

    //本地购物车数据
    NSString *string = [userDefault objectForKey:KUserCartBrandKey];
    if (string && string.length>0) {
        _cartDesignerIdArray = [[NSMutableArray alloc] initWithArray:[string componentsSeparatedByString:@","]];//;
    }else{
        _cartDesignerIdArray = [[NSMutableArray alloc] init];
    }
    //修改订单临时数据
    self.currentYYOrderInfoModel = [[YYOrderInfoModel alloc] init];
    //动态获取链接的服务器地址(版本更新的时候调用)
    _inRunLoop = true;
    [self loadServerInfo];
    while (_inRunLoop) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }

    [self addObserverForKeyboard];
    [self addObserverForNeedLogin];

    //jpush
    [JpushHandler setupJpush:launchOptions];

    [YYUser removeTempUser];

    //跳转界面控制
    //引导页只在（第一次安装，版本号变化的时候）才出现
    NSString *versionStr = kYYCurrentVersion;
    NSString *lastShowVersionStr = [[NSUserDefaults standardUserDefaults] objectForKey:lastIntroductionVersin];
    if ([NSString isNilOrEmpty:lastShowVersionStr] || ![lastShowVersionStr isEqualToString:versionStr]) {
        //更新本地
        [[NSUserDefaults standardUserDefaults] setObject:versionStr forKey:lastIntroductionVersin];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self enterIntroPage];
    }else{
        [self autoLogin];
    }
    if(_isNeedUpdate){
        [YYUpdateAppStore checkVersion];
    }
    return YES;
}

-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    [self clearLocalFile];
}
#pragma mark -urllinks
//iOS9以下
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //必写
    if(![self handlerUniversalLink:url]){
        //[UIApplication.sharedApplication openURL:url];
    }
    return YES;
}
//iOS9+
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(nonnull NSDictionary *)options
{
    //必写
    if(![self handlerUniversalLink:url]){
        //[UIApplication.sharedApplication openURL:url];
    }
    return YES;
}
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
{
    //如果使用了Universal link ，此方法必写
    if(true || userActivity.activityType == NSUserActivityTypeBrowsingWeb){
        NSURL *webpageURL = userActivity.webpageURL;
        if(![self handlerUniversalLink:webpageURL]){
            //[UIApplication.sharedApplication openURL:webpageURL];
        }
    }
    return YES;
}
#pragma mark -jpush
- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
    //[rootViewController addNotificationCount];

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
    [JPUSHService handleRemoteNotification:userInfo];
    //    后台运行 applicationState = UIApplicationStateBackground
    //    点击横条 applicationState = UIApplicationStateInactive
    //    app打开的情况下 applicationState = UIApplicationStateActive
    if(application.applicationState==UIApplicationStateInactive)
    {
        if(userInfo)
        {
            if([userInfo objectForKey:@"cat"])
            {
                NSInteger cat = [[userInfo objectForKey:@"cat"] integerValue];
                if(cat == 0){
                    [JpushHandler handleUserInfo:userInfo];
                }
            }else if ([userInfo objectForKey:@"styleId"]) {
                if ([[userInfo objectForKey:@"styleId"] integerValue] > 0) {
                    [JpushHandler handleUserInfo:userInfo];
                }
            }
        }
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}
#pragma mark -thread
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"SvTimerSample Will resign Avtive!");
    if(_myThread != nil){
        [_myThread cancel];

    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [self checkNoticeCount];
    [[NSNotificationCenter defaultCenter] postNotificationName:kApplicationDidBecomeActive object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//#pragma mark - --------------SomePrepare--------------

#pragma mark - --------------请求数据----------------------
//自动登录
-(void)autoLogin{
    YYUser *user = [YYUser currentUser];
    if (user && user.email && [user.email length] && user.password && [user.password length]) {
        if (![YYCurrentNetworkSpace isNetwork]) {
            //没有网络，但应用登录过，则直接进去
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
            [self enterMainIndexPage];
            if(![YYCurrentNetworkSpace isNetwork]){
                [YYToast showToastWithTitle:kNetworkIsOfflineTips andDuration:kAlertToastDuration];
            }
        }else{
            _inRunLoop = true;

            [self loginByEmail:user.email password:user.password verificationCode:nil];
            // 新增一条日活记录
            [YYBurideApi addStatDaily];
            while (_inRunLoop) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
        }
    }else{
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
        [self enterLoginPage];
    }
}

- (void)loginByEmail:(NSString *)email password:(NSString *)password verificationCode:(NSString *)verificationCode{
    WeakSelf(ws);

    verificationCode = verificationCode&&[verificationCode length]?verificationCode:nil;

    [YYUserApi loginWithUsername:email password:md5(password) verificationCode:verificationCode andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYUserModel *userModel, NSError *error) {
        ws.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
        if (rspStatusAndMessage.status == kCode100 || rspStatusAndMessage.status == kCode1000){

            YYUser *user = [YYUser currentUser];
            [user saveUserWithEmail:email username:userModel.name password:password userType:[userModel.type intValue] userId:userModel.id logo:userModel.logo status:[userModel.authStatus stringValue] brandId:[[NSString alloc] initWithFormat:@"%ld",(long)[userModel.brandId integerValue]]];

            //进入首页
            [ws enterMainIndexPage];
            if( [user.status integerValue] == kCode305){
                NSString *expireDate = getShowDateByFormatAndTimeInterval(@"yyyy/MM/dd HH:mm",userModel.expireDate);
                [[YYYellowPanelManage instance] showYellowUserCheckAlertPanel:@"Main" andIdentifier:@"YYUserCheckAlertViewController" title:expireDate msg:[NSString stringWithFormat:NSLocalizedString(@"请于 %@ 前完成品牌验证，|未验证的账号将被锁定",nil),expireDate] iconStr:userModel.logo  btnStr:NSLocalizedString(@"去验证",nil) align:NSTextAlignmentCenter closeBtn:YES funArray:nil andCallBack:^(NSArray *value) {
                    YYVerifyBrandViewController *viewController = [[YYVerifyBrandViewController alloc] init];
                    viewController.registerType = kBrandRegisterStep1Type;
                    [ws.mainViewController pushViewController:viewController animated:YES];
                }];
            }

            [LanguageManager setLanguageToServer];

            // 获取subshowroom的权限列表, 首先是判断showroom子账号
            if (user.userType == kShowroomSubType) {
                [YYShowroomApi selectSubShowroomPowerUserId:[NSNumber numberWithInteger:[user.userId integerValue]] andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSArray *powerArray, NSError *error) {
                    YYSubShowroomUserPowerModel *subShowroom = [YYSubShowroomUserPowerModel shareModel];
                    for (NSNumber *i in powerArray) {
                        if ([i intValue] == 1) {
                            subShowroom.isBrandAction = YES;
                        }
                    }

                }];
            }

        }else{
            //进入登录
            YYUser *user = [YYUser currentUser];
            if (user && user.email && [user.email length] && user.password && [user.password length]){
                [ws enterMainIndexPage];
            }else{
                [ws enterLoginPage];
            }
        }
        _inRunLoop = NO;
    }];
}

-(void)loadServerInfo{
    NSString *localServerURL = [[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL];
    __block NSString * lockLocalServerURL = localServerURL;

    if (YYDEBUG == 0 && [YYCurrentNetworkSpace isNetwork]) {
        [YYServerURLApi getAppServerURLWidth:^(NSString *serverURL,BOOL isNeedUpdate, NSError *error) {
            if(serverURL == nil){
                if(lockLocalServerURL == nil){
                    [[NSUserDefaults standardUserDefaults] setObject:kYYServerURL forKey:kLastYYServerURL];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:serverURL forKey:kLastYYServerURL];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            _isNeedUpdate = isNeedUpdate;
            _inRunLoop = NO;

        }];
        [[NSUserDefaults standardUserDefaults] setObject:kYYCurrentVersion forKey:kLastServerVersin];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        if(YYDEBUG || lockLocalServerURL == nil){
            [[NSUserDefaults standardUserDefaults] setObject:kYYServerURL forKey:kLastYYServerURL];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        _inRunLoop = NO;
    }
}

-(void)checkNoticeCount{
    YYUser *user = [YYUser currentUser];
    if (![YYCurrentNetworkSpace isNetwork] || self.mainViewController == nil || !user.email) {
        return;
    }
    NSString *type = @"";
    [YYOrderApi getUnreadNotifyMsgAmount:type andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYMessageUnreadModel *messageUnreadModel, NSError *error) {
        if (rspStatusAndMessage.status == kCode100) {
            self.messageUnreadModel = messageUnreadModel;
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:UnreadMsgAmountChangeNotification object:nil userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:UnreadInventoryNotifyMsgAmount object:nil userInfo:nil];
            });
        }
    }];
}

#pragma mark - --------------跳转视图----------------------
//进入产品介绍
-(void)enterIntroPage{
    NSArray *coverImageNames = nil;
    if(kIPhoneX){
        if([LanguageManager isEnglishLanguage]){
            coverImageNames = @[@"introImage1_en_x", @"introImage2_en_x", @"introImage3_en_x", @"introImage4_en_x", @"introImage5_en_x"];
        }else{
            coverImageNames = @[@"introImage1_x", @"introImage2_x", @"introImage3_x", @"introImage4_x", @"introImage5_x"];
        }
    }else{
        if([LanguageManager isEnglishLanguage]){
            coverImageNames = @[@"introImage1_en", @"introImage2_en", @"introImage3_en", @"introImage4_en", @"introImage5_en"];
        }else{
            coverImageNames = @[@"introImage1", @"introImage2", @"introImage3", @"introImage4", @"introImage5"];
        }
    }
    YYIntroductionViewController *introductionView = [[YYIntroductionViewController alloc] initWithCoverImageNames:coverImageNames backgroundImageNames:nil button:nil];
    introductionView.view.backgroundColor = [UIColor whiteColor];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
    self.window.rootViewController =introductionView;
    [self.window makeKeyAndVisible];
    WeakSelf(ws);
    introductionView.didSelectedEnter = ^() {
        [ws autoLogin];
    };
}

//进入登录
- (void)enterLoginPage{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"Login_NavigationController"];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.leftMenuIndex = 0;
    appDelegate.window.rootViewController = loginViewController;
    [self.window makeKeyAndVisible];
    CATransition *animation = [CATransition animation];
    animation.duration = 1.0f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fillMode = kCAFillModeForwards;
    animation.endProgress = 1.0;
    animation.removedOnCompletion = YES;
    animation.type = kCATransitionFade;
    [appDelegate.window.layer addAnimation:animation forKey:@"animation"];
}
//进入首页
- (void)enterMainIndexPage{
    YYUser *user = [YYUser currentUser];
    if(user.userType == 5||user.userType == 6)
    {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _mainViewController = [[UINavigationController alloc] initWithRootViewController:[[YYShowroomMainViewController alloc] init]];
        appDelegate.window.rootViewController = _mainViewController;
        [self.window makeKeyAndVisible];

        CATransition *animation = [CATransition animation];
        animation.duration = 1.0f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.fillMode = kCAFillModeForwards;
        animation.endProgress = 1.0;
        animation.removedOnCompletion = YES;
        animation.type = kCATransitionFade;
        [appDelegate.window.layer addAnimation:animation forKey:@"animation"];

    }else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        _mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"Main_NavigationController"];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [_mainViewController setEnableBackGesture:true];//开启手势
        appDelegate.window.rootViewController = _mainViewController;
        [self.window makeKeyAndVisible];
        //[appDelegate.window addSubview: mainViewController.view];
        //[appDelegate.window makeKeyAndVisible];
        CATransition *animation = [CATransition animation];
        animation.duration = 1.0f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.fillMode = kCAFillModeForwards;
        animation.endProgress = 1.0;
        animation.removedOnCompletion = YES;
        animation.type = kCATransitionFade;
        [appDelegate.window.layer addAnimation:animation forKey:@"animation"];

        [self checkNoticeCount];
        if(self.openURLInfo != nil){
            NSArray *urlInfoArr = [self.openURLInfo componentsSeparatedByString:@"?"];
            NSString *actionType = [urlInfoArr objectAtIndex:0];
            NSString *query = [urlInfoArr objectAtIndex:1];
            [YYUrlLinksHandler handleUserInfo:actionType query:query];
            self.openURLInfo = nil;
        }
    }
}
-(void)showBuildOrderViewController:(YYOrderInfoModel *)orderInfoModel parent:(UIViewController *)parentViewController isCreatOrder:(Boolean)isCreatOrder isReBuildOrder:(Boolean)isReBuildOrder isAppendOrder:(Boolean)isAppendOrder isFromCardDetail:(BOOL )isFromCardDetail modifySuccess:(ModifySuccess)modifySuccess{

    // 先得到type信息
    [YYUserApi getSalesManListWithBlockNew:^(YYRspStatusAndMessage *rspStatusAndMessage, YYSalesManListModel *salesManListModel, NSError *error) {

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OrderDetail" bundle:[NSBundle mainBundle]];
        YYOrderModifyViewController *orderModifyViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYOrderModifyViewController"];

        orderModifyViewController.currentYYOrderInfoModel = orderInfoModel;
        orderModifyViewController.isCreatOrder = isCreatOrder;
        orderModifyViewController.isReBuildOrder = isReBuildOrder;
        orderModifyViewController.isAppendOrder =  isAppendOrder;
        orderModifyViewController.salesManListModel = salesManListModel;

        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:orderModifyViewController];
        nav.navigationBar.hidden = YES;
        __block YYOrderModifyViewController * blockOrderModifyViewController = orderModifyViewController;
        __block UIViewController * blockParentViewController = parentViewController;
        [orderModifyViewController setCloseButtonClicked:^(){
            [blockParentViewController dismissViewControllerAnimated:YES completion:^{
                blockOrderModifyViewController= nil;
            }];
        }];
        __block ModifySuccess blockModifySuccess = modifySuccess;
        [orderModifyViewController setModifySuccess:^(){
            [blockParentViewController dismissViewControllerAnimated:YES completion:^{
                blockOrderModifyViewController= nil;
                if(blockModifySuccess){
                    blockModifySuccess();
                }
            }];
        }];
        if(!isFromCardDetail){
            [orderModifyViewController setUpdateBlock:^(){
                if(blockModifySuccess){
                    blockModifySuccess();
                }
            }];
        }

        [parentViewController presentViewController:nav animated:YES completion:nil];
    }];
}

-(void)showBuyerInfoViewController:(NSNumber *)buyerId WithBuyerName:(NSString *)buyerName parentViewController:(UIViewController *)viewController WithReqSuccessBlock:(void(^)())reqSuccessblock WithHomePageCancelBlock:(CancelButtonClicked )cancelblock WithModifySuccessBlock:(ModifySuccess )modifySuccessblock{

    [YYUserApi getUserStatus:[buyerId integerValue] andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSInteger status, NSError *error) {
        if(rspStatusAndMessage.status == kCode100){
            if(status != kUserStatusStop && status >-1){

                YYBuyerHomePageViewController *connInfoController = [[YYBuyerHomePageViewController alloc] init];
                connInfoController.buyerId = [buyerId integerValue];
                connInfoController.previousTitle = buyerName;
                [viewController.navigationController pushViewController:connInfoController animated:YES];
                if(reqSuccessblock){
                    reqSuccessblock();
                }
                [connInfoController setCancelButtonClicked:^(){
                    if(cancelblock){
                        cancelblock();
                    }
                }];
                [connInfoController setModifySuccess:^{
                    if(modifySuccessblock){
                        modifySuccessblock();
                    }
                }];

            }else{
                [YYToast showToastWithView:viewController.view title:NSLocalizedString(@"此买手店账号已停用",nil) andDuration:kAlertToastDuration];
            }
        }else{
            [YYToast showToastWithView:viewController.view title:rspStatusAndMessage.message andDuration:kAlertToastDuration];
        }
    }];
}

/**
 进入系列详情

 @param designerId ...
 @param seriesId ...
 @param viewController ...
 */
-(void)showSeriesInfoViewController:(NSNumber*)designerId seriesId:(NSNumber*)seriesId parentViewController:(UIViewController*)viewController{

    //初始化或更新(brandName和brandLogo)购物车信息
    [self initOrUpdateShoppingCarInfo:designerId];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Brand" bundle:[NSBundle mainBundle]];
    YYBrandSeriesViewController *seriesViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYBrandSeriesViewController"];
    seriesViewController.designerId = [designerId integerValue];
    seriesViewController.seriesId = [seriesId integerValue];
    [viewController.navigationController pushViewController:seriesViewController animated:YES];
}

- (void)showStyleInfoViewController:(YYOrderInfoModel *)infoModel oneInfoModel:(YYOrderOneInfoModel *)oneInfoModel orderStyleModel:(YYOrderStyleModel *)styleModel parentViewController:(UIViewController*)viewController{

    //初始化或更新(brandName和brandLogo)购物车信息
    [self initOrUpdateShoppingCarInfo:infoModel.designerId];

    YYOpusSeriesModel *opusSeriesModel = [[YYOpusSeriesModel alloc] init];
    opusSeriesModel.designerId = infoModel.designerId;
    opusSeriesModel.albumImg = styleModel.albumImg;
    YYOrderSeriesModel *seriesModel = [infoModel.seriesMap objectForKey:[styleModel.seriesId stringValue]];
    if(seriesModel != nil){
        opusSeriesModel.supplyStatus = seriesModel.supplyStatus;
        opusSeriesModel.orderAmountMin = seriesModel.orderAmountMin;
        opusSeriesModel.name = styleModel.name;
        opusSeriesModel.id = styleModel.seriesId;
    }

    YYOpusStyleModel *opusStyleModel = [[YYOpusStyleModel alloc] init];
    opusStyleModel.albumImg = styleModel.albumImg;
    opusStyleModel.modifyTime = (NSNumber <Optional>*)[styleModel.styleModifyTime stringValue];
    opusStyleModel.name = styleModel.name;
    opusStyleModel.id = styleModel.styleId;
    opusStyleModel.seriesId = styleModel.seriesId;
    opusStyleModel.styleCode = styleModel.styleCode;
    opusStyleModel.tradePrice = styleModel.originalPrice;
    opusStyleModel.retailPrice = styleModel.retailPrice;
    opusStyleModel.dateRange = oneInfoModel.dateRange;

    NSMutableArray * onlineOpusStyleArray = [[NSMutableArray alloc] initWithCapacity:0];
    [onlineOpusStyleArray addObject:opusStyleModel];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Opus" bundle:[NSBundle mainBundle]];
    YYStyleDetailViewController *styleDetailViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYStyleDetailViewController"];
    styleDetailViewController.onlineOrOfflineOpusStyleArray = onlineOpusStyleArray;
    styleDetailViewController.opusSeriesModel = opusSeriesModel;
    styleDetailViewController.currentIndex = 1;
    styleDetailViewController.isModityCart = YES;
    styleDetailViewController.totalPages = 1;
    [viewController.navigationController pushViewController:styleDetailViewController animated:YES];
}
- (void)showStyleInfoViewController:(YYInventoryBoardModel *)infoModel parentViewController:(UIViewController*)viewController IsShowroomToScan:(BOOL)isShowroomToScan{

    //初始化或更新(brandName和brandLogo)购物车信息
    [self initOrUpdateShoppingCarInfo:infoModel.designerId];

    YYOpusSeriesModel *opusSeriesModel = [[YYOpusSeriesModel alloc] init];
    opusSeriesModel.designerId = infoModel.designerId;
    opusSeriesModel.name = infoModel.seriesName;
    opusSeriesModel.id = infoModel.seriesId;
    opusSeriesModel.orderAmountMin = infoModel.orderAmountMin;
    opusSeriesModel.supplyStatus = infoModel.supplyStatus;
    opusSeriesModel.status = infoModel.seriesStatus;

    YYOpusStyleModel *opusStyleModel = [[YYOpusStyleModel alloc] init];
    opusStyleModel.albumImg = infoModel.albumImg;
    opusStyleModel.name = infoModel.styleName;
    opusStyleModel.id = infoModel.styleId;
    opusStyleModel.styleCode = infoModel.styleCode;

    NSMutableArray * onlineOpusStyleArray = [[NSMutableArray alloc] initWithCapacity:0];
    [onlineOpusStyleArray addObject:opusStyleModel];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Opus" bundle:[NSBundle mainBundle]];
    YYStyleDetailViewController *styleDetailViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYStyleDetailViewController"];
    styleDetailViewController.onlineOrOfflineOpusStyleArray = onlineOpusStyleArray;
    styleDetailViewController.opusSeriesModel = opusSeriesModel;
    styleDetailViewController.currentIndex = 1;
    styleDetailViewController.isModityCart = YES;
    styleDetailViewController.totalPages = 1;
    styleDetailViewController.isShowroomToScan = isShowroomToScan;
    styleDetailViewController.isToScan = YES;
    [viewController.navigationController pushViewController:styleDetailViewController animated:YES];
}

//styleInfoModel YYStyleInfoModel  StyleDetail YYOrderStyleModel //seriesModel YYOpusSeriesModel  YYOrderSeriesModel Series
- (void)showShoppingView:(BOOL )isModifyOrder styleInfoModel:(id )styleInfoModel seriesModel:(id)seriesModel opusStyleModel:(YYOpusStyleModel *)opusStyleModel parentView:(UIView *)parentView fromBrandSeriesView:(BOOL )isFromSeries WithBlock:(void (^)(YYBrandSeriesToCartTempModel *brandSeriesToCardTempModel))block{
    YYStyleInfoModel *tempStyleInfoModel = nil;
    YYOpusSeriesModel *tempOpusSeriesModel = nil;
    if ([styleInfoModel isKindOfClass:[YYStyleInfoModel class]]) {
        tempStyleInfoModel = styleInfoModel;
    }else  if([styleInfoModel isKindOfClass:[YYOrderStyleModel class]]){
        YYStyleInfoModel *convertStyleInfoModel = [[YYStyleInfoModel alloc] init];
        YYOrderStyleModel *orderStyleModel = styleInfoModel;
        //尺寸部份
        NSArray *sizeArray = orderStyleModel.sizeNameList;
        if (sizeArray && [sizeArray count] > 0) {
            NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:0];
            for (YYSizeModel *orderSizeDetailModel in sizeArray) {
                YYSizeModel *sizeModel = [[YYSizeModel alloc] init];
                sizeModel.id = orderSizeDetailModel.id;
                sizeModel.value = orderSizeDetailModel.value;
                [mutableArray addObject:sizeModel];
            }
            convertStyleInfoModel.size = (NSArray<YYSizeModel> *)mutableArray;
        }
        //颜色部份
        NSArray *colorArray = orderStyleModel.colors;
        if (colorArray && [colorArray count] > 0) {
            NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:0];
            for (YYOrderOneColorModel *orderOneColorModel in colorArray) {
                YYColorModel *colorModel = [[YYColorModel alloc] init];
                colorModel.id = orderOneColorModel.colorId;
                colorModel.value = orderOneColorModel.value;
                colorModel.name = orderOneColorModel.name;
                colorModel.styleCode = orderOneColorModel.styleCode;
                colorModel.imgs = orderOneColorModel.imgs;
                colorModel.tradePrice = orderOneColorModel.originalPrice;
                colorModel.isSelect = orderOneColorModel.isColorSelect;
                
                NSMutableArray *sizeStocks = [NSMutableArray array];
                for (YYSizeModel *orderSizeDetailModel in sizeArray) {
                    for (YYOrderSizeModel *sizeModel in orderOneColorModel.sizes) {
                        if ([orderSizeDetailModel.id isEqualToNumber:sizeModel.sizeId]) {
                            [sizeStocks addObject:sizeModel.stock ? sizeModel.stock : @(0)];
                        }
                    }
                }
                colorModel.sizeStocks = sizeStocks;
                
                [mutableArray addObject:colorModel];
            }
            convertStyleInfoModel.colorImages = (NSArray<YYColorModel> *)mutableArray;
        }
        //款式详情部份
        YYStyleInfoDetailModel *styleInfoDetailModel = [[YYStyleInfoDetailModel alloc] init];
        styleInfoDetailModel.albumImg = orderStyleModel.albumImg;
        styleInfoDetailModel.styleCode = orderStyleModel.styleCode;
        styleInfoDetailModel.name = orderStyleModel.name;
        styleInfoDetailModel.orderAmountMin = orderStyleModel.orderAmountMin;
        styleInfoDetailModel.id = orderStyleModel.styleId;
        styleInfoDetailModel.finalPrice = orderStyleModel.finalPrice;
        styleInfoDetailModel.tradePrice = orderStyleModel.originalPrice;
        styleInfoDetailModel.retailPrice = orderStyleModel.retailPrice;
        styleInfoDetailModel.modifyTime = orderStyleModel.styleModifyTime;
        styleInfoDetailModel.curType= orderStyleModel.curType;
        styleInfoDetailModel.seriesId = orderStyleModel.seriesId;
        styleInfoDetailModel.supportAdd = orderStyleModel.supportAdd;
        
        convertStyleInfoModel.dateRange = orderStyleModel.tmpDateRange;
        convertStyleInfoModel.style = styleInfoDetailModel;
        convertStyleInfoModel.stockEnabled = [orderStyleModel.stockEnabled boolValue];
        tempStyleInfoModel = convertStyleInfoModel;
    }

    // YYOpusSeriesModel  Series
    if ([seriesModel isKindOfClass:[YYOpusSeriesModel class]]) {
        tempOpusSeriesModel = seriesModel;
    }else
        if([seriesModel isKindOfClass:[YYOrderSeriesModel class]]){
            YYOrderSeriesModel *orderSeriesModel = seriesModel;
            YYOpusSeriesModel *opusSeriesModel = [[YYOpusSeriesModel alloc] init];
            opusSeriesModel.id = orderSeriesModel.seriesId;
            opusSeriesModel.name = orderSeriesModel.name;
            opusSeriesModel.orderAmountMin = orderSeriesModel.orderAmountMin;
            opusSeriesModel.supplyStatus = orderSeriesModel.supplyStatus;
            tempOpusSeriesModel = opusSeriesModel;
        }

    if ((!tempStyleInfoModel || !tempOpusSeriesModel) && opusStyleModel == nil) {
        //数据不全，给出提示
        return;
    }

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Order" bundle:[NSBundle mainBundle]];
    YYShoppingViewController *finalVC = [storyboard instantiateViewControllerWithIdentifier:@"YYShoppingViewController"];
    //处理数据
    finalVC.isModifyOrder = isModifyOrder;
    finalVC.opusStyleModel = opusStyleModel;
    finalVC.isFromSeries = isFromSeries;
    finalVC.styleInfoModel = tempStyleInfoModel;
    finalVC.opusSeriesModel = tempOpusSeriesModel;

    [finalVC setSeriesChooseBlock:^(YYBrandSeriesToCartTempModel *brandSeriesToCardTempModel) {
        if(block){
            block(brandSeriesToCardTempModel);
        }
    }];

    /**---------展示view的时候，同时持有controller------**/
    self.shoppingViewController = finalVC;

    UIView *_shoppingView = finalVC.view;
    [parentView addSubview:_shoppingView];
    //修改试图的大小，范围
    __weak UIView *_weakSelfView = parentView;
    [_shoppingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_weakSelfView.mas_top);
        make.left.equalTo(_weakSelfView.mas_left);
        make.bottom.equalTo(_weakSelfView.mas_bottom);
        make.right.equalTo(_weakSelfView.mas_right);
    }];
    addAnimateWhenAddSubview(_shoppingView);
}

- (void)showMessageView:(NSArray*)info parentViewController:(UIViewController*)viewController{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YYGroupMessageViewController *groupMessageViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYGroupMessageViewController"];
    [groupMessageViewController setCancelButtonClicked:^(){
        [self checkNoticeCount];
    }];
    [viewController.navigationController pushViewController:groupMessageViewController animated:YES];
}

- (void)showStyleDetailWithStyleId:(NSInteger)styleId parentViewController:(UIViewController*)viewController {
    [MBProgressHUD showHUDAddedTo:viewController.view animated:YES];
    [YYOpusApi getStyleInfoByStyleId:styleId orderCode:nil andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYStyleInfoModel *styleInfoModel, NSError *error) {
        [MBProgressHUD hideHUDForView:viewController.view animated:YES];
        if (!error) {
            if (rspStatusAndMessage.status == kCode100) {
                YYOpusSeriesModel *seriesModel = [styleInfoModel transformToOpusSeriesModel];
                YYOpusStyleModel *styleModel = [styleInfoModel transformToOpusStyleModel];
                NSMutableArray * onlineOpusStyleArray = [NSMutableArray array];
                [onlineOpusStyleArray addObject:styleModel];
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Opus" bundle:[NSBundle mainBundle]];
                YYStyleDetailViewController *styleDetailViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYStyleDetailViewController"];
                styleDetailViewController.onlineOrOfflineOpusStyleArray = onlineOpusStyleArray;
                styleDetailViewController.opusSeriesModel = seriesModel;
                styleDetailViewController.currentIndex = 1;
                styleDetailViewController.isModityCart = YES;
                styleDetailViewController.totalPages = 1;
                [viewController.navigationController pushViewController:styleDetailViewController animated:YES];
            }else {
                [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
            }
        }
    }];
}

#pragma mark - --------------自定义方法----------------------
- (void)delegateTempDataClear{
    [self.messageUnreadModel cleanUnreadMessageAmount];
}
-(BOOL)handlerUniversalLink:(NSURL *)url{
    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];

    NSString *host = components.host;
    if([host isEqualToString:@"link.ycosystem.com"]){
        NSArray *pathComponents = [components.path pathComponents];
        if([pathComponents count] ==4){
            if([pathComponents[0] isEqualToString:@"/"] && [pathComponents[1] isEqualToString:@"ycobrand"] && [pathComponents[2] isEqualToString:@"detail"] ){
                //something
                [YYUrlLinksHandler handleUserInfo:pathComponents[3] query:components.query];
            }
            return YES;
        }
        return YES;
    }
    return NO;
}

- (void)reloadRootViewController:(NSInteger)index{
    YYUser *user = [YYUser currentUser];
    if(user.userType == 5||user.userType == 6)
    {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _mainViewController = [[UINavigationController alloc] initWithRootViewController:[[YYShowroomMainViewController alloc] init]];
        appDelegate.window.rootViewController = _mainViewController;
        [self.window makeKeyAndVisible];
    }else{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        _mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"Main_NavigationController"];
        appDelegate.window.rootViewController = _mainViewController;
        [self.window makeKeyAndVisible];
    }
}

- (void)clearBuyCar{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    for(NSString *designerId in appDelegate.cartDesignerIdArray) {
        [userDefault removeObjectForKey:[NSString stringWithFormat:@"%@_%@",KUserCartKey,designerId]];
        [userDefault removeObjectForKey:[NSString stringWithFormat:@"%@_%@",KUserCartMoneyTypeKey,designerId]];
    }
    appDelegate.cartDesignerIdArray = [[NSMutableArray alloc] init];
    [userDefault removeObjectForKey:KUserCartBrandKey];
    [userDefault synchronize];

    appDelegate.cartModel = nil;
    appDelegate.seriesArray = [[NSMutableArray alloc] init];

    //更新购物车按钮数量
    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateShoppingCarNotification object:nil];
}
/**
 初始化或更新(brandName和brandLogo)购物车信息
 */
- (void)initOrUpdateShoppingCarInfo:(NSNumber *)designerId{
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if([appdelegate.cartDesignerIdArray containsObject:[designerId stringValue]]){
        NSString *jsonString = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@",KUserCartKey,[designerId stringValue]]];
        appdelegate.cartModel = [[YYOrderInfoModel alloc] initWithString:jsonString error:nil];
        if (appdelegate.cartModel.groups.count != 0) {
            appdelegate.seriesArray = [appdelegate valueForKeyPath:@"cartModel.groups"];
        }
    }else{
        appdelegate.cartModel = [[YYOrderInfoModel alloc] init];
        appdelegate.seriesArray = [[NSMutableArray alloc] init];
        appdelegate.cartModel.designerId = designerId;
    }
    YYUser *user = [YYUser currentUser];
    appdelegate.cartModel.brandName = [NSString isNilOrEmpty:user.name]?@"":user.name;
    appdelegate.cartModel.brandLogo = [NSString isNilOrEmpty:user.logo]?@"":user.logo;
}

-(void)clearLocalFile{
    NSString *cacheDir = yyjDocumentsDirectory();
    NSString *usersListFile = getUsersStorePath();
    NSString *searchNoteListFile = getOrderSearchNoteStorePath();
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:usersListFile error:nil];
    [fileManager removeItemAtPath:searchNoteListFile error:nil];
    [fileManager removeItemAtPath:cacheDir error:nil];

    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    [[SDImageCache sharedImageCache] clearMemory];//可有可无
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
    NSString *str = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];

    return str;
}

- (void)addObserverForNeedLogin{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(needLogin:)
                                                 name:kNeedLoginNotification
                                               object:nil];
}

- (void)needLogin:(NSNotification *)note{
    YYUser *user = [YYUser currentUser];
    [user loginOut];
    [self enterLoginPage];
}

- (void)addObserverForKeyboard{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

//键盘隐藏
- (void)keyboardWillShow:(NSNotification *)note
{
    //获取键盘高度
    NSDictionary *info = [note userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;

    if (SYSTEM_VERSION_LESS_THAN(@"8.0")){
        self.keyBoardHeight = keyboardSize.width;
    }else{
        self.keyBoardHeight = keyboardSize.height;
    }

    self.keyBoardIsShowNow = YES;
}

- (void)keyboardWillHide:(NSNotification *)note
{
    self.keyBoardIsShowNow = NO;
}

//集成友盟统计
- (void)initUmeng{
    UMConfigInstance.appKey = @"596f3d4e65b6d65a80001914";
    //配置以上参数后调用此方法初始化SDK！
    [MobClick startWithConfigure:UMConfigInstance];
    // 设置verson为版本号
    [MobClick setAppVersion:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
}

// 创建网络监听
//使用AFN框架来检测网络状态的改变
-(void)AFNReachability
{
    //1.创建网络监听管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];

    //2.监听网络状态的改变
    /*
     AFNetworkReachabilityStatusUnknown     = 未知
     AFNetworkReachabilityStatusNotReachable   = 没有网络
     AFNetworkReachabilityStatusReachableViaWWAN = 手机网络
     AFNetworkReachabilityStatusReachableViaWiFi = WIFI
     */

    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(reachabilityChanged:)
    //                                                 name:kRealReachabilityChangedNotification
    //                                               object:nil];

    //这里可以添加一些自己的逻辑
    YYCurrentNetworkSpace *networkSpace = [YYCurrentNetworkSpace shareModel];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                // "未知"
                networkSpace.currentNetwork = kYYNetworkUnknow;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                //"没有网络"
                networkSpace.currentNetwork = kYYNetworkNotReachable;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                //"移动网络"
                networkSpace.currentNetwork = kYYNetworkWWAN;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                //"WIFI"
                networkSpace.currentNetwork = kYYNetworkWifi;
                break;

            default:
                break;
        }
        _isStartNetworkSpace = false;
        NSNotification *notification =[NSNotification notificationWithName:kNetWorkSpaceChangedNotification object:nil];
        // 通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }];

    //3.开始监听
    [manager startMonitoring];
}
#pragma mark - --------------other----------------------


@end
