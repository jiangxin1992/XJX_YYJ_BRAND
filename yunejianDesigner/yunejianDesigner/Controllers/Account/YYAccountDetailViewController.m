//
//  YYAccountDetailViewController.m
//  Yunejian
//
//  Created by yyj on 15/7/12.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYAccountDetailViewController.h"

#import "YYSettingViewController.h"
#import "YYModifyPasswordViewController.h"
#import "YYShowroomHomePageViewController.h"
#import "YYModifyNameOrPhoneViewContrller.h"
#import "YYModifyDesignerBrandInfoViewController.h"
#import "YYModifyBuyerStoreBrandInfoViewController.h"
#import "YYSellerListViewController.h"
#import "YYVerifyBrandViewController.h"
#import "YYConnMsgListController.h"
#import "YYConnAddViewController.h"
#import "YYShowroomAgentController.h"

#import "UIImage+Tint.h"
#import "YYShowroomInfoByDesignerModel.h"
#import "UIImage+YYImage.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "AppDelegate.h"
#import "YYUser.h"
#import "YYDesignerModel.h"
#import "YYBrandInfoModel.h"
#import "YYBuyerStoreModel.h"
#import "YYSalesManListModel.h"
#import "YYUserApi.h"
#import "YYRspStatusAndMessage.h"
#import "YYUserInfo.h"
#import "YYSeller.h"
#import "YYAddress.h"
#import "MBProgressHUD.h"
#import "UserDefaultsMacro.h"
#import <MJRefresh.h>
#import "YYConnApi.h"
#import "YYOrderApi.h"
#import "YYUserApi.h"
#import "YYShowroomApi.h"

#import "YYUserInfoCell.h"
#import "YYUserLogoInfoCell.h"
#import "YYTableView.h"
#import "YYUserBrandInfoCell.h"
#import "YYMessageButton.h"
#import "YYGuideHandler.h"
#import "YYShowroomInfoModel.h"
#import "YYBrandHomePageViewController.h"

@interface YYAccountDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,YYUserLogoInfoCellDelegate>

@property (weak, nonatomic) IBOutlet YYTableView *tableView;
@property (weak, nonatomic) IBOutlet YYMessageButton *messageButton;
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;

@property(nonatomic,strong) YYModifyPasswordViewController *modifyPasswordViewController;
@property(nonatomic,strong) YYModifyNameOrPhoneViewContrller *modifyNameOrPhoneViewContrller;
@property(nonatomic,strong) YYSettingViewController *settingViewController;
@property(nonatomic,strong) YYModifyBuyerStoreBrandInfoViewController *modifyBuyerStoreBrandInfoViewController;
@property(nonatomic,strong) YYModifyDesignerBrandInfoViewController *modifyDesignerBrandInfoViewController;
@property(nonatomic,strong) YYSellerListViewController *sellerListViewController;
@property (strong, nonatomic) YYUserInfo *userInfo;
@property (strong, nonatomic) YYShowroomInfoModel *ShowroomModel;
@property(nonatomic,strong) YYBrandInfoModel *currenDesingerBrandInfoModel;
@property(nonatomic,strong) YYBuyerStoreModel *currenBuyerStoreModel;
@property(nonatomic,strong) YYShowroomInfoByDesignerModel *showroomInfoByDesignerModel;

@end

@implementation YYAccountDetailViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self SomePrepare];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_tableView reloadData];
    // 进入埋点
    [MobClick beginLogPageView:kYYPageAccountDetail];

    [self headerWithRefreshingAction];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageAccountDetail];
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}

-(void)PrepareData{
    // 设置导航控制器的代理为self
    self.navigationController.delegate = self;
    YYUser *user = [YYUser currentUser];
    self.userInfo = [[YYUserInfo alloc] init];
    self.userInfo.userId = user.userId;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveAction) name:kApplicationDidBecomeActive object:nil];
}
-(void)PrepareUI{

    [self addHeader];

    if ([YYCurrentNetworkSpace isNetwork]) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UIView *superView = appDelegate.mainViewController.view;
        [MBProgressHUD showHUDAddedTo :superView animated:YES];
        [appDelegate checkNoticeCount];
        [self loadDataFromServer];
    }else{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [userDefaults objectForKey:kUserInfoKey];
        if (data) {
            self.userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [_tableView reloadData];
        }
        
    }
    YYUser *user = [YYUser currentUser];
    if(user.userType == 5||user.userType == 6){
        //Showroom 账号
        [_messageButton initBackButton];
        [_messageButton addTarget:self action:@selector(GoBack:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [_messageButton initButton:@""];
        [self messageCountChanged:nil];
        [_messageButton addTarget:self action:@selector(messageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageCountChanged:) name:UnreadMsgAmountChangeNotification object:nil];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kNetWorkSpaceChangedNotification
                                               object:nil];
}
- (void)reachabilityChanged:(NSNotification *)notification{
    if (![YYCurrentNetworkSpace isNetwork]) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UIView *superView = appDelegate.mainViewController.view;
        [MBProgressHUD hideAllHUDsForView:superView animated:YES];
        [self.tableView reloadData];
    }
}
#pragma mark - msseage
- (void)messageButtonClicked:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate showMessageView:nil parentViewController:self];
}
- (void)messageCountChanged:(NSNotification *)notification{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([YYUser isShowroomToBrand])
    {
        NSInteger msgAmount = [appDelegate.messageUnreadModel.orderAmount integerValue] + [appDelegate.messageUnreadModel.connAmount integerValue];
        if(msgAmount > 0){
            [_messageButton updateButtonNumber:[NSString stringWithFormat:@"%ld",(long)msgAmount]];
        }else{
            [_messageButton updateButtonNumber:@""];
        }
    }else
    {
        NSInteger msgAmount = [appDelegate.messageUnreadModel.orderAmount integerValue] + [appDelegate.messageUnreadModel.connAmount integerValue] + [appDelegate.messageUnreadModel.personalMessageAmount integerValue];
        if(msgAmount > 0 || [appDelegate.messageUnreadModel.newsAmount integerValue] >0){
            if(msgAmount > 0 ){
                [_messageButton updateButtonNumber:[NSString stringWithFormat:@"%ld",(long)msgAmount]];
            }else{
                [_messageButton updateButtonNumber:@"dot"];
            }
        }else{
            [_messageButton updateButtonNumber:@""];
        }
    }
}
#pragma mark 开始进入刷新状态
- (void)addHeader{
    WeakSelf(ws);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws headerWithRefreshingAction];
    }];
    self.tableView.mj_header = header;
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
}
-(void)headerWithRefreshingAction{
    if ([YYCurrentNetworkSpace isNetwork]) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate checkNoticeCount];
    }
    [self loadDataFromServer];
}
- (void)reloadTableView{
    [_tableView reloadData];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView *superView = appDelegate.mainViewController.view;
    
    [MBProgressHUD hideAllHUDsForView:superView animated:YES];
    
    //以下代码，目前只考虑设计师登录的情况，保存信息至本地
    if (_userInfo
        && _userInfo.username
        && _userInfo.brandName) {
        [self saveCurrentUserInfoToDisk];
    }
}
#pragma mark - RequestData
- (void)loadDataFromServer{
    YYUser *user = [YYUser currentUser];
    self.userInfo.status = user.status;//@"305";//
    
    switch (user.userType) {
        case kDesignerType:{
            [self getDesignerInfo];
            [self getDesignerBrandInfo];
            [self getSellList];
            [self getConnBuyerInfo];
            [self getShowroomInfoByDesigner];
        }
            
            break;
        case kBuyerStorUserType:{
            //[self getBuyStoreUserInfo];
            //[self getAddressList];
        }
            break;
        case kSellerType:{
            self.userInfo.username = user.name;
            self.userInfo.email = user.email;
            self.userInfo.userType = kSellerType;
            [self getDesignerBrandInfo];
            [self getShowroomInfoByDesigner];
            //以下代码，目前只考虑设计师登录的情况，保存信息至本地
            [self saveCurrentUserInfoToDisk];
            [self.tableView.mj_header endRefreshingWithCompletionBlock:^{
                [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
            }];
        }
            break;
        case kShowroomType:{
            self.userInfo.username = user.name;
            self.userInfo.email = user.email;
            self.userInfo.userType = kShowroomType;
            [self getShowroomInfo];
        }
            break;
        case kShowroomSubType:{
            self.userInfo.username = user.name;
            self.userInfo.email = user.email;
            self.userInfo.userType = kShowroomSubType;
            [self getShowroomInfo];
        }
            break;
        default:
            break;
    }
    
}
- (void)getShowroomInfoByDesigner{
    WeakSelf(ws);
    [YYShowroomApi getShowroomInfoByDesigner:^(YYRspStatusAndMessage *rspStatusAndMessage,YYShowroomInfoByDesignerModel *showroomInfoByDesignerModel,NSError *error) {
        if(showroomInfoByDesignerModel)
        {
            _showroomInfoByDesignerModel = showroomInfoByDesignerModel;
            dispatch_async(dispatch_get_main_queue(), ^{
                [ws reloadTableView];
            });
        }
    }];
}
- (void)getDesignerInfo{
    WeakSelf(ws);
    [YYUserApi getDesignerBasicInfoWithBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYDesignerModel *designerModel, NSError *error) {
        [ws.tableView.mj_header endRefreshingWithCompletionBlock:^{
            [ws.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
        }];
        if (designerModel) {
            ws.userInfo.username = designerModel.userName;
            ws.userInfo.phone = designerModel.phone;
            ws.userInfo.email = designerModel.email;
            ws.userInfo.userType = kDesignerType;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [ws reloadTableView];
            });
        }
        
    }];
}

- (void)getDesignerBrandInfo{
    WeakSelf(ws);
    [YYUserApi getDesignerBrandInfoWithBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYBrandInfoModel *brandInfoModel, NSError *error) {
        if (brandInfoModel) {
            ws.userInfo.brandName = brandInfoModel.brandName;
            ws.userInfo.brandLogoName = brandInfoModel.logoPath;
            ws.currenDesingerBrandInfoModel = brandInfoModel;
            dispatch_async(dispatch_get_main_queue(), ^{
                [ws reloadTableView];
            });
        }
    }];
}
- (void)getShowroomInfo{
    WeakSelf(ws);
    [YYUserApi getShowroomInfoWithBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYShowroomInfoModel *ShowroomModel, NSError *error) {
        if (ShowroomModel) {
            
            ws.ShowroomModel = ShowroomModel;
            
            ws.userInfo.username = ws.ShowroomModel.showroomInfo.name;
            ws.userInfo.brandName = ws.ShowroomModel.showroomInfo.manager;
            
            ws.userInfo.brandLogoName = ws.ShowroomModel.showroomInfo.logo;
            
            if(ws.sellerListViewController)
            {
                ws.sellerListViewController.ShowroomModel = ws.ShowroomModel;
            }
            //以下代码，目前只考虑设计师登录的情况，保存信息至本地
            [self saveCurrentUserInfoToDisk];
            dispatch_async(dispatch_get_main_queue(), ^{
                [ws reloadTableView];
            });
        }
    }];
}
-(void)getConnBuyerInfo{
    WeakSelf(ws);
    [YYConnApi getConnBuyers:1 pageIndex:1 pageSize:1 andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYConnBuyerListModel *listModel, NSError *error) {
        if(rspStatusAndMessage.status == kCode100){
           // ws.connedNum = [listModel.pageInfo.recordTotalAmount integerValue];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [ws reloadTableView];
        });
    }];
    [YYConnApi getConnBuyers:0 pageIndex:1 pageSize:1 andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYConnBuyerListModel *listModel, NSError *error) {
        if(rspStatusAndMessage.status == kCode100){
            //ws.conningNum = [listModel.pageInfo.recordTotalAmount integerValue];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [ws reloadTableView];
        });
    }];
}

- (void)getBuyStoreUserInfo{
    WeakSelf(ws);
    [YYUserApi getBuyerStorBasicInfoWithBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYBuyerStoreModel *BuyerStoreModel, NSError *error) {
        [ws.tableView.mj_header endRefreshingWithCompletionBlock:^{
            [ws.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
        }];
        if (BuyerStoreModel) {
            ws.currenBuyerStoreModel = BuyerStoreModel;
            
            ws.userInfo.username = BuyerStoreModel.contactName;
            ws.userInfo.phone = BuyerStoreModel.contactPhone;
            ws.userInfo.email = BuyerStoreModel.contactEmail;
            ws.userInfo.userType = kBuyerStorUserType;
            ws.userInfo.brandName = BuyerStoreModel.name;
            ws.userInfo.brandLogoName = BuyerStoreModel.logoPath;
            
            ws.userInfo.nation = BuyerStoreModel.nation;
            ws.userInfo.province = BuyerStoreModel.province;
            ws.userInfo.city = BuyerStoreModel.city;
            ws.userInfo.nationEn = BuyerStoreModel.nationEn;
            ws.userInfo.provinceEn = BuyerStoreModel.provinceEn;
            ws.userInfo.cityEn = BuyerStoreModel.cityEn;
            ws.userInfo.nationId = BuyerStoreModel.nationId;
            ws.userInfo.provinceId = BuyerStoreModel.provinceId;
            ws.userInfo.cityId = BuyerStoreModel.cityId;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [ws reloadTableView];
            });
        }
    }];
}

- (void)getSellList{
    WeakSelf(ws);
    [YYUserApi getSalesManListWithBlockNew:^(YYRspStatusAndMessage *rspStatusAndMessage, YYSalesManListModel *salesManListModel, NSError *error) {
        if (salesManListModel) {
            [salesManListModel getTrueSalesMainList];
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
            for (YYSalesManModel *salesManModel in salesManListModel.result) {
                YYSeller *seller = [[YYSeller alloc] init];
                seller.salesmanId = [salesManModel.userId intValue];
                seller.name = salesManModel.username;
                seller.email = salesManModel.email;
                seller.status = [salesManModel.status intValue];
                [array addObject:seller];
            }
            
            ws.userInfo.sellersArray = [NSArray arrayWithArray:array];
            dispatch_async(dispatch_get_main_queue(), ^{
                [ws reloadTableView];
            });
        }
    }];
}

#pragma mark - YYUserLogoInfoCellDelegate
-(void)handlerBtnClick:(id)target{
    [self logoButtonAction:target];
}

-(void)settingBtnClick:(id)target{
    [self modifyUserInfo:ShowTypeUsername];
}
#pragma mark - SomeAction
-(void)applicationDidBecomeActiveAction{
    YYUser *user = [YYUser currentUser];

    if(!((user.userType == 5 || user.userType ==6)&&![YYUser isShowroomToBrand])){
        [self headerWithRefreshingAction];
    }else{
        NSLog(@"showroom主页");
    }
}
-(void)GoBack:(id)sender {
    if(_cancelButtonClicked)
    {
        _cancelButtonClicked();
    }
}
-(void)showAgentShowroom
{
    if(_showroomInfoByDesignerModel)
    {
        if(_showroomInfoByDesignerModel.status)
        {
            YYShowroomAgentController *agentCTN = [[YYShowroomAgentController alloc] init];
            agentCTN.showroomInfoByDesignerModel = _showroomInfoByDesignerModel;
            [self.navigationController pushViewController:agentCTN animated:YES];
            [agentCTN setCancelButtonClicked:^(){
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }
}
- (void)showDesginerHomePage
{
    YYUser *user = [YYUser currentUser];
    if(user.userType == 5||user.userType == 6)
    {
        //跳转Showroom主页
        YYShowroomHomePageViewController *ShowroomHomePage = [[YYShowroomHomePageViewController alloc] init];
        [self.navigationController pushViewController:ShowroomHomePage animated:YES];
        [ShowroomHomePage setCancelButtonClicked:^(){
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }else
    {
        //跳转我的品牌主页
        WeakSelf(ws);
        YYBrandHomePageViewController *brandHomePageViewController = [[YYBrandHomePageViewController alloc] initWithBlock:^(NSString *type,NSNumber *connectStatus) {
            if([type isEqualToString:@"reload"])
            {
                [_tableView reloadData];
            }
        }];
        brandHomePageViewController.designerId = [user.userId integerValue];
        brandHomePageViewController.previousTitle = NSLocalizedString(@"我的品牌主页",nil);
        brandHomePageViewController.isHomePage = YES;
        [brandHomePageViewController setCancelButtonClicked:^(){
            [ws.navigationController popViewControllerAnimated:YES];
        }];
        [ws.navigationController pushViewController:brandHomePageViewController animated:YES];
    }
    
}

- (IBAction)logoButtonAction:(id)sender{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker=[[UIImagePickerController alloc] init];
        picker.view.backgroundColor = _define_white_color;
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        [self.navigationController presentViewController:picker animated:YES completion:nil];
    }else
    {
        NSLog(@"无法打开相册");
    }
}

- (IBAction)setttingButtonAction:(id)sender{
    WeakSelf(ws);
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    
//    UIView *superView = appDelegate.mainViewController.view;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Account" bundle:[NSBundle mainBundle]];
    YYSettingViewController *settingViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYSettingViewController"];
    self.settingViewController = settingViewController;
    
    [self.navigationController pushViewController:settingViewController animated:YES];
    
//    UIView *showView = settingViewController.view;
//    __weak UIView *weakShowView = showView;
    
    [settingViewController setCancelButtonClicked:^(){
        [ws.navigationController popViewControllerAnimated:YES];
        ws.settingViewController = nil;
        //removeFromSuperviewUseUseAnimateAndDeallocViewController(weakShowView,ws.settingViewController);
    }];
    
    
//    [superView addSubview:showView];
//    [showView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(weakSuperView.mas_top);
//        make.left.equalTo(weakSuperView.mas_left);
//        make.bottom.equalTo(weakSuperView.mas_bottom);
//        make.right.equalTo(weakSuperView.mas_right);
//        
//    }];
//    
//    addAnimateWhenAddSubview(showView);
    [YYGuideHandler markGuide:GuideTypeSettingDot];
}
//缓存当前用户信息
- (void)saveCurrentUserInfoToDisk{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.userInfo] forKey:kUserInfoKey];
    [userDefaults synchronize];
}

-(void) checkUserIdentity{
    if([_userInfo.status integerValue] == kCode300){
        [YYToast showToastWithTitle:NSLocalizedString(@"审核中!",nil) andDuration:kAlertToastDuration];
        return ;
    }
    
    YYVerifyBrandViewController *viewController = [[YYVerifyBrandViewController alloc] init];
    viewController.registerType = kBrandRegisterStep1Type;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)modifyUserInfo:(NSInteger)currentShowType{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Account" bundle:[NSBundle mainBundle]];
    YYModifyNameOrPhoneViewContrller *modifyNameOrPhoneViewContrller = [storyboard instantiateViewControllerWithIdentifier:@"YYModifyNameOrPhoneViewContrller"];
    self.modifyNameOrPhoneViewContrller = modifyNameOrPhoneViewContrller;
    modifyNameOrPhoneViewContrller.userInfo = self.userInfo;
    modifyNameOrPhoneViewContrller.currentShowType = currentShowType;
    [self.navigationController pushViewController:modifyNameOrPhoneViewContrller animated:YES];
    
    WeakSelf(ws);
    //    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //    UIView *superView = appDelegate.mainViewController.view;
    //
    //    __weak UIView *weakSuperView = superView;
    //    UIView *showView = modifyNameOrPhoneViewContrller.view;
    //    __weak UIView *weakShowView = showView;
    [modifyNameOrPhoneViewContrller setCancelButtonClicked:^(){
        [ws.navigationController popViewControllerAnimated:YES];
        ws.modifyNameOrPhoneViewContrller = nil;
        
        //        removeFromSuperviewUseUseAnimateAndDeallocViewController(weakShowView,self.modifyNameOrPhoneViewContrller);
    }];
    
    [modifyNameOrPhoneViewContrller setModifySuccess:^(){
        [ws.navigationController popViewControllerAnimated:YES];
        
        //        removeFromSuperviewUseUseAnimateAndDeallocViewController(weakShowView,self.modifyNameOrPhoneViewContrller);
        [self getDesignerInfo];
        ws.modifyNameOrPhoneViewContrller = nil;
    }];
    
    
    //    [superView addSubview:showView];
    //    [showView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(weakSuperView.mas_top);
    //        make.left.equalTo(weakSuperView.mas_left);
    //        make.bottom.equalTo(weakSuperView.mas_bottom);
    //        make.right.equalTo(weakSuperView.mas_right);
    //
    //    }];
    //    addAnimateWhenAddSubview(showView);
}

-(void)modifyPassword{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Account" bundle:[NSBundle mainBundle]];
    YYModifyPasswordViewController *modifyPasswordViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYModifyPasswordViewController"];
    self.modifyPasswordViewController = modifyPasswordViewController;
    [self.navigationController pushViewController:modifyPasswordViewController animated:YES];
    //    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //    UIView *superView = appDelegate.mainViewController.view;
    //    __weak UIView *weakSuperView = superView;
    //    UIView *showView = modifyPasswordViewController.view;
    //    __weak UIView *weakShowView = showView;
    WeakSelf(ws);
    [modifyPasswordViewController setCancelButtonClicked:^(){
        [ws.navigationController popViewControllerAnimated:YES];
        ws.modifyPasswordViewController = nil;
        //        removeFromSuperviewUseUseAnimateAndDeallocViewController(weakShowView,self.modifyPasswordViewController);
    }];
    
    [modifyPasswordViewController setModifySuccess:^(){
        //        removeFromSuperviewUseUseAnimateAndDeallocViewController(weakShowView,self.modifyPasswordViewController);
        [ws.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNeedLoginNotification object:nil];
        ws.modifyPasswordViewController = nil;
    }];
    
    //
    //    [superView addSubview:showView];
    //    [showView mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //        make.top.equalTo(weakSuperView.mas_top);
    //        make.left.equalTo(weakSuperView.mas_left);
    //        make.bottom.equalTo(weakSuperView.mas_bottom);
    //        make.right.equalTo(weakSuperView.mas_right);
    //
    //    }];
    //
    //    addAnimateWhenAddSubview(showView);
}

-(void)modifyBrandInfo{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Account" bundle:[NSBundle mainBundle]];
    YYModifyDesignerBrandInfoViewController *modifyDesignerBrandInfoViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYModifyDesignerBrandInfoViewController"];
    self.modifyDesignerBrandInfoViewController = modifyDesignerBrandInfoViewController;
    modifyDesignerBrandInfoViewController.currenDesingerBrandInfoModel = self.currenDesingerBrandInfoModel;
    [self.navigationController pushViewController:modifyDesignerBrandInfoViewController animated:YES];
    
    WeakSelf(ws);
    [modifyDesignerBrandInfoViewController setCancelButtonClicked:^(){
        [ws.navigationController popViewControllerAnimated:YES];
        ws.modifyDesignerBrandInfoViewController = nil;
    }];
    
    [modifyDesignerBrandInfoViewController setModifySuccess:^(){
        [ws.navigationController popViewControllerAnimated:YES];
        ws.modifyDesignerBrandInfoViewController = nil;
        [ws getDesignerBrandInfo];
    }];
    
    
}

-(void)showSellerList{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Account" bundle:[NSBundle mainBundle]];
    YYSellerListViewController *sellerListViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYSellerListViewController"];
    self.sellerListViewController = sellerListViewController;
    
    WeakSelf(ws);
    [self.sellerListViewController setCancelButtonClicked:^(){
        [ws.navigationController popViewControllerAnimated:YES];
        ws.sellerListViewController = nil;
    }];
    YYUser *user = [YYUser currentUser];
    if(user.userType == 5)
    {
        sellerListViewController.ShowroomModel = _ShowroomModel;
        //需要更新的时候
        [sellerListViewController setModifySuccess:^(){
            [self getShowroomInfo];
        }];
    }
//    ShowroomModel
    [self.navigationController pushViewController:sellerListViewController animated:YES];
    
}


#pragma mark - UIImagePickerControllerDelegate
//上传头像
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //    获取选择图片
    UIImage *image = [UIImage fixOrientation:info[UIImagePickerControllerEditedImage]];
    if (image) {
        //[_logoButton setImage:image forState:UIControlStateNormal];
        WeakSelf(ws);
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [YYOrderApi uploadImage:image size:2.0f andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSString *imageUrl, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];
            if (imageUrl
                && [imageUrl length] > 0) {
                NSLog(@"imageUrl: %@",imageUrl);
                self.userInfo.brandLogoName = imageUrl;
                YYUser *user = [YYUser currentUser];
                user.logo = imageUrl;
                [user saveUserData];
                [YYUserApi modifyLogoWithUrl:imageUrl andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
//                    成功的时候去回调
                    if(rspStatusAndMessage.status == kCode100){
                        if(_modifySuccess)
                        {
                            _modifySuccess();
                        }
                    }
                }];
                [ws reloadTableView];
            }
            
        }];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    YYUser *user = [YYUser currentUser];    
    switch (user.userType) {
        case kDesignerType:{
            return 6;
        }
            break;
        case kSellerType:{
            return 5;
        }
            break;
        case kShowroomType:{
            return 5;
        }
            break;
        case kShowroomSubType:{
            return 4;
        }
            break;
        default:
            break;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rows = 0;
    YYUser *user = [YYUser currentUser];

    if(section == 0){
        rows = 1;
    }else if (section == 1) {
        rows = 1;
    }else if (section == 2) {
        rows = 1;
    }else if (section == 3) {
        if(user.userType == kDesignerType){
            rows = 4;
        }else if(user.userType == kShowroomType||user.userType == kShowroomSubType){
            rows = 3;
        }else
        {
            rows = 3;
        }
    }else if (section == 4) {
        rows = 1;
    }else if (section == 5) {
        rows = 1;
    }
    
    return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    YYUser *user = [YYUser currentUser];
    
     WeakSelf(ws);
    if(section == 0){
        static NSString *CellIdentifier = @"LogoCell";
        YYUserLogoInfoCell *logoCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        logoCell.usernameLabel.text = self.userInfo.username;
        logoCell.emailLabel.text = self.userInfo.brandName;
        [[logoCell.logoButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
        if(self.userInfo != nil && self.userInfo.brandLogoName != nil){
            sd_downloadWebImageWithRelativePath(NO, self.userInfo.brandLogoName, logoCell.logoButton, kLogoCover, 0);
        }else{
            if(user.logo != nil){
                sd_downloadWebImageWithRelativePath(NO, user.logo, logoCell.logoButton, kLogoCover, 0);
            }else{
                [logoCell.logoButton setImage:[UIImage imageNamed:@"default_icon"] forState:UIControlStateNormal];
            }
        }
        logoCell.delegate =self;
        logoCell.logoButton.layer.masksToBounds = YES;
        logoCell.logoButton.layer.cornerRadius = CGRectGetWidth(logoCell.logoButton.frame)/2;
        logoCell.logoButton.layer.borderWidth = 1;
        logoCell.logoButton.layer.borderColor = [UIColor colorWithHex:kDefaultImageColor].CGColor;
        if ([YYCurrentNetworkSpace isNetwork]) {
             logoCell.logoButton.enabled = YES;
        }else{
             logoCell.logoButton.enabled = NO;
        }
        cell = logoCell;
    }else if(section == 1) {
        if([_userInfo.status integerValue] == kCode100){

            if(user.userType == 5||user.userType == 6)
            {
                static NSString *CellIdentifier = @"UITableViewCell";
                UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if(!cell)
                {
                    cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = [UIColor colorWithHex:@"F8F8F8"];
                return cell;
            }else
            {
                static NSString *CellIdentifier = @"SectionHeader";
                UITableViewCell *headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                headerView.selectionStyle=UITableViewCellSelectionStyleNone;
                if (headerView == nil){
                    [NSException raise:@"SectionHeader == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
                }else{
                    
                }
                headerView.contentView.backgroundColor = [UIColor colorWithHex:@"F8F8F8"];
                
                cell = headerView;
            }
            
            
        }else{
            static NSString *CellIdentifier = @"YYUserBrandInfoCell";
            YYUserBrandInfoCell *userInfoCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            userInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;

            userInfoCell.userInfo = _userInfo;
            [userInfoCell setModifyButtonClicked:^(YYUserInfo *userInfo){
                [ws checkUserIdentity];
            }];
            [userInfoCell updateUI];
            cell = userInfoCell;
        }
    }else{
        static NSString *CellIdentifier = @"DetailCell";
        YYUserInfoCell *userInfoCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        userInfoCell.userInfo = _userInfo;
        userInfoCell.ShowroomModel = _ShowroomModel;
        userInfoCell.showroomInfoByDesignerModel = _showroomInfoByDesignerModel;
        //[userInfoCell setLabelStatus:1.0];
        [userInfoCell hideBottomLine:NO];
        [userInfoCell hideTipLabel:YES];
        if (section == 1) {
            [userInfoCell updateUIWithShowType:ShowTypeBrand];
            [userInfoCell hideBottomLine:YES];
        }else if (section == 2) {
            [userInfoCell hideBottomLine:YES];
            [userInfoCell updateUIWithShowType:ShowTypeHome];
        }else if (section == 3) {
//            userType;//用户类型 0:设计师 1:买手店 2:销售代表 5:Showroom
            if (row == 0) {
                [userInfoCell updateUIWithShowType:ShowTypeEmail];
            }else if (row == 1){
                [userInfoCell updateUIWithShowType:ShowTypePassword];
            }else if (row == 2){
                if(user.userType == 5||user.userType == 6)
                {
                    
                    if(_ShowroomModel)
                    {
                        if(_ShowroomModel.showroomInfo.contractStartTime&&_ShowroomModel.showroomInfo.contractEndTime)
                        {
                            NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
                            //用来得到具体的时差
                            unsigned int unitFlags =  NSCalendarUnitDay;
                            NSDateComponents *d = [cal components:unitFlags fromDate:[NSDate date] toDate:[NSDate dateWithTimeIntervalSince1970:[_ShowroomModel.showroomInfo.contractEndTime longLongValue]/1000] options:0];
                            if(d.day<=15)
                            {
                                [userInfoCell hideTipLabel:NO];
                            }
                        }
                    }
                    [userInfoCell updateUIWithShowType:ShowTypeContractTime];
                    [userInfoCell hideBottomLine:YES];
                }else
                {
                    if(user.userType == 2)
                    {
                        [userInfoCell hideBottomLine:YES];
                    }
                    [userInfoCell updateUIWithShowType:ShowTypeUsername];
                }
            }else if (row == 3){
                [userInfoCell updateUIWithShowType:ShowTypePhone];
                [userInfoCell hideBottomLine:YES];
            }
            
        }else if (section == 4||section == 5) {
            if(user.userType == 5||user.userType == 6)
            {
                if (section == 4)
                {
                    [userInfoCell updateUIWithShowType:ShowTypeSeller];
                }
            }else
            {
                if (section == 4)
                {
                    if(user.userType == 0)
                    {
                        [userInfoCell hideBottomLine:YES];
                    }
                    [userInfoCell updateUIWithShowType:ShowTypeAgentShowroom];
                }else
                {
                    [userInfoCell updateUIWithShowType:ShowTypeSeller];
                }
            }
        }
        [userInfoCell setModifyButtonClicked:^(YYUserInfo *userInfo, ShowType currentShowType){
            
            
            switch (currentShowType) {
                case ShowTypeBrand:{
                    [ws checkUserIdentity];
                }
                    break;
                case ShowTypePassword:{
                    [ws modifyPassword];
                }
                    break;
                case ShowTypeBuyer:{
                }
                    break;
                case ShowTypeUsername:{
                    [ws modifyUserInfo:currentShowType];
                }
                    break;
                case ShowTypeContractTime:{
                    
                }
                    break;
                case ShowTypePhone:{
                    [ws modifyUserInfo:currentShowType];
                }
                    break;
                case ShowTypeSeller:{
                    [ws showSellerList];
                }
                    break;
                case ShowTypeAddress:{
                    
                }
                    break;
                case ShowTypeHome:{
                    [ws showDesginerHomePage];
                }
                    break;
                case ShowTypeAgentShowroom:{
                    [ws showAgentShowroom];
                }
                    break;
                default:
                    break;
            }
            
            NSLog(@"userInfo.email: %@  userInfo.username: %@,currentShowType: %ld",userInfo.email,userInfo.username,currentShowType);
        }];
        cell = userInfoCell;
    }
    
    if (cell == nil){
        [NSException raise:@"DetailCell == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
    }
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section== 0){
        return 207;
    }
    if(indexPath.section== 1){
        if([_userInfo.status integerValue] == kCode100){
            YYUser *user = [YYUser currentUser];
            if(user.userType == 5||user.userType == 6)
            {
                return 1;
            }else
            {
                return 12;
            }
            
        }
        return 89;
    }
    return 54;
}
//
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    static NSString *CellIdentifier = @"SectionHeader";
    UITableViewCell *headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (headerView == nil){
        [NSException raise:@"SectionHeader == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
    }else{

    }

    return headerView;
}
//
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 3 ||section == 4||section == 5){
        return 12;
    }
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    YYUser *user = [YYUser currentUser];
    if(user.userType == 0)
    {
        if(section == 5){
            return 40;
        }
    }else if(user.userType == 2)
    {
        if(section == 4){
            return 40;
        }
    }
    return 0.1;
}

#pragma mark -  Other

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [YYGuideHandler showGuideView:GuideTypeSettingDot parentView:self.view targetView:self.settingBtn];
    
}
@end
