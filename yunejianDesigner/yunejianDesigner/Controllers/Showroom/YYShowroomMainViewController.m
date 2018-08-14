//
//  YYShowroomMainViewController.m
//  yunejianDesigner
//
//  Created by yyj on 2017/3/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YYShowroomMainViewController.h"

#import "YYAccountDetailViewController.h"
#import "YYShowroomBrandViewController.h"
#import "YYShowroomNotificationListViewController.h"

#import <MessageUI/MFMailComposeViewController.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import "YYShowroomBrandListCell.h"
#import "YYShowroomBrandHeadView.h"
#import "YYCircleSearchView.h"
#import "YYShowroomMainNoDataView.h"
#import "YYNavView.h"

#import "AppDelegate.h"
#import "YYUser.h"
#import "YYStyleInfoModel.h"
#import "YYShowroomBrandListModel.h"
#import "YYShowroomBrandModel.h"
#import "YYShowroomBrandTool.h"
#import "YYShowroomApi.h"
#import "MBProgressHUD.h"
#import <MJRefresh.h>
#import "YYUserApi.h"
#import "regular.h"

#import "YYHttpHeaderManager.h"
#import "YYRequestHelp.h"

#import "YYQRCode.h"
#import "YYScanFunctionModel.h"
#import "YYOpusApi.h"
#import "ChineseToPinyin.h"

@interface YYShowroomMainViewController ()<UIImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate>
//列表
@property (strong ,nonatomic) UITableView *tableView;
@property (strong ,nonatomic) YYShowroomBrandListModel *ShowroomBrandListModel;
//用于存放索引
@property (strong ,nonatomic) NSArray *arrayChar;
//用于存放分类好的数据
@property (strong ,nonatomic) NSMutableDictionary *dictPinyinAndChinese;
@property (strong ,nonatomic) YYCircleSearchView *searchView;
//tablehead
@property (strong ,nonatomic) YYShowroomBrandHeadView *tableHeadview;
@property (strong ,nonatomic) UIView *footerView;
@property (strong ,nonatomic) YYShowroomMainNoDataView *noDataView;
@property (strong ,nonatomic) UIImageView *mengban;
@property (strong ,nonatomic) UIImageView *zbar;
//导航栏上的  调用出来用来改变他的透明度
@property (assign ,nonatomic) CGFloat alpha;
@property (nonatomic ,strong) UIImageView *barImageView;
@property (nonatomic ,strong) YYNavView *NavView;

@property (nonatomic, strong) YYUser *currentUser;

@property (nonatomic ,strong) UIView *notRedView;
@property (nonatomic ,assign) NSInteger permissionStatus;//-1 未获取 0没有权限 1有权限
@property (nonatomic ,assign) BOOL hasOrderingMsg;

@end

@implementation YYShowroomMainViewController
#pragma mark - --------------生命周期--------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self RequestData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(_searchView)
    {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }else
    {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    // 进入埋点
    [MobClick beginLogPageView:kYYPageShowroomMain];

    if(_alpha<1.0f){
        _barImageView.alpha = 0;
        _NavView.alpha = 0;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(_alpha<1.0f){
        _barImageView.alpha = 0;
        _NavView.alpha = 0;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    // 退出埋点
    [MobClick endLogPageView:kYYPageShowroomMain];
}

#pragma mark - --------------SomePrepare--------------
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}

-(void)PrepareData{
    //清除购物车
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate clearBuyCar];
    // 初始化
    _dictPinyinAndChinese = [[NSMutableDictionary alloc] init];
    self.arrayChar = [YYShowroomBrandTool getCharArr];

    self.currentUser = [YYUser currentUser];
    if(_currentUser.userType == YYUserTypeShowroom){
        //showroom权限
        self.permissionStatus = 1;
    }else{
        //非showroom权限 一般默认为showroom_sub权限
        self.permissionStatus = -1;
    }
    self.hasOrderingMsg = NO;
}

#pragma mark - --------------系统代理----------------------
#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    _alpha = (double)(scrollView.contentOffset.y / ((324.0f/750.0f)*SCREEN_WIDTH-64-44)) -1.0f;
    _barImageView.alpha = _alpha;
    _NavView.alpha = _alpha;
    // NSLog(@"contentOffset=%lf _alpha=%lf",scrollView.contentOffset.y,_alpha);
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(_alpha<1.0f){
        [UIView beginAnimations:@"anmationName_dismiss" context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelegate:self];
        _barImageView.alpha = 0;
        _NavView.alpha = 0;
        [UIView commitAnimations];
    }
}
/**
 *  滚动完毕就会调用（如果是人为拖拽scrollView导致滚动完毕，才会调用这个方法）
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(_alpha<1.0f){
        [UIView beginAnimations:@"anmationName_dismiss" context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelegate:self];
        _barImageView.alpha = 0;
        _NavView.alpha = 0;
        [UIView commitAnimations];
    }
}

#pragma mark - TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _arrayChar.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *strKey = [_arrayChar objectAtIndex:section];
    NSInteger _count=[(NSMutableArray *)[_dictPinyinAndChinese objectForKey:strKey] count];
    return _count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![YYCurrentNetworkSpace isNetwork]) {
        [YYToast showToastWithView:self.view title:kNetworkIsOfflineTips andDuration:kAlertToastDuration];
    }else{
        //跳转Showroom主页
        YYShowroomBrandModel *brandModel = [[_dictPinyinAndChinese objectForKey:[_arrayChar objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        YYShowroomBrandViewController *brandCTN = [[YYShowroomBrandViewController alloc] init];
        brandCTN.brandId = brandModel.brandId;
        [brandCTN setCancelButtonClicked:^(){
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [self.navigationController pushViewController:brandCTN animated:YES];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView getCustomViewWithColor:_define_white_color];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.01);
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_ShowroomBrandListModel)
    {
        if(_ShowroomBrandListModel.brandList.count)
        {
            return 80;
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_ShowroomBrandListModel)
    {
        if(_ShowroomBrandListModel.brandList.count)
        {
            static NSString *cellid=@"YYShowroomBrandListCell";
            YYShowroomBrandListCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
            if(!cell)
            {
                cell=[[YYShowroomBrandListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.brandModel =[[_dictPinyinAndChinese objectForKey:[_arrayChar objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];

            [cell bottomIsHide:NO];

            return cell;
        }
    }

    static NSString *cellid=@"UITableViewCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if(!cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - --------------自定义代理/block----------------------


#pragma mark - --------------自定义响应----------------------
-(void)searchAction{
    [self ShowSearchView];
}
-(void)notificationAction{
    if(_permissionStatus == 1){
        WeakSelf(ws);
        YYShowroomNotificationListViewController *notificationList = [[YYShowroomNotificationListViewController alloc] init];
        [notificationList setCancelButtonClicked:^(){
            [ws.navigationController popViewControllerAnimated:YES];
            [ws getHasOrderingMsg];
        }];
        notificationList.hasOrderingMsg = _hasOrderingMsg;
        [self.navigationController pushViewController:notificationList animated:YES];
    }else{
        [YYToast showToastWithTitle:NSLocalizedString(@"您没有权限查看活动审核内容",nil) andDuration:kAlertToastDuration];
    }
}

#pragma mark - 扫码
-(void)sweepYardButtonClicked{
    YYQRCodeController *QRCode = [YYQRCodeController QRCodeSuccessMessageBlock:^(YYQRCodeController *code, NSString *messageString) {
        NSData *JSONData = [messageString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
        //扫码回调
        YYScanFunctionModel *scanModel = [[YYScanFunctionModel alloc] init];
        scanModel.env = responseJSON[@"env"];// @"TEST";
        scanModel.type = responseJSON[@"type"];// @"STYLE";
        scanModel.id = responseJSON[@"id"]; // @"2690";
                                            //判断环境
        if([scanModel isRightEnvironment]){
            if([scanModel.type isEqualToString:@"STYLE"]){
                //查看是否有权限访问styleId对应下的款式
                [self hasPermissionToVisitStyleWithScanModel:scanModel code:code];
            }
        }else{
            [code toast:NSLocalizedString(@"您没有查看此款式的权限",nil) collback:^(YYQRCodeController *code) {
                [code scanningAgain];
            }];
        }
    }];

    [self presentViewController:QRCode animated:YES completion:nil];
}

#pragma mark - ***************
-(void)saveWeixinPic
{
    if(_zbar.image)
    {
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];

        if (author == kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied){
            [self presentViewController:alertTitleCancel_Simple(NSLocalizedString(@"请在设备的“设置-隐私-照片”中允许访问照片",nil), ^{
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]])
                {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            }) animated:YES completion:nil];
        }else
        {
            UIImageWriteToSavedPhotosAlbum(_zbar.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            [_mengban removeFromSuperview];
        }
    }
}

-(void)closeAction
{
    [_mengban removeFromSuperview];
}

#pragma mark - SomeAction

-(void)pushPersonView
{
    UIStoryboard *accountStoryboard = [UIStoryboard storyboardWithName:@"Account" bundle:[NSBundle mainBundle]];

    YYAccountDetailViewController *accountDetailViewController = [accountStoryboard instantiateViewControllerWithIdentifier:@"YYAccountDetailViewController"];
    [accountDetailViewController setCancelButtonClicked:^(){
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [accountDetailViewController setModifySuccess:^(){
        [self RequestData];
    }];
    [self.navigationController pushViewController:accountDetailViewController animated:YES];
}

-(void)copyWeixinName{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];

    pasteboard.string = @"yunejianhelper";

    [YYToast showToastWithTitle:NSLocalizedString(@"成功复制微信号",nil) andDuration:kAlertToastDuration];
    [_mengban removeFromSuperview];
}

#pragma mark - --------------自定义方法----------------------
-(void)initPinyinAndChinese
{
    [_dictPinyinAndChinese removeAllObjects];

    for (int i = 0; i < 26; i++) {
        NSMutableArray *arr=[[NSMutableArray alloc] init];
        NSString *str = [NSString stringWithFormat:@"%c", 'A' + i];
        [_dictPinyinAndChinese setObject:arr forKey:str];
    }
    [_dictPinyinAndChinese setObject:[[NSMutableArray alloc] init] forKey:@"#"];
}

-(void)updateData{
    [self initPinyinAndChinese];
    //    [_ShowroomBrandListModel getTestModel];
    for (YYShowroomBrandModel *model in _ShowroomBrandListModel.brandList) {

        NSString *pinyin = [[ChineseToPinyin pinyinFromChiniseString:model.brandName] uppercaseString];

        NSString *charFirst = [pinyin substringToIndex:1];
        //从字典中招关于G的键值对
        NSMutableArray *charArray  = [_dictPinyinAndChinese objectForKey:charFirst];
        //没有找到
        if (charArray) {
            [charArray addObject:model];

        }else
        {
            NSMutableArray *subArray = [_dictPinyinAndChinese objectForKey:@"#"];
            //“关羽”
            [subArray addObject:model];
        }
    }
}

-(void)ShowSearchView{
    if(!_searchView){
        _searchView=[[YYCircleSearchView alloc] initWithQueryStr:@"" WithBlock:^(NSString *type,NSString *queryStr, YYShowroomBrandModel *ShowroomBrandModel) {
            if([type isEqualToString:@"back"])
            {
                [self.navigationController setNavigationBarHidden:NO animated:NO];
                [_searchView removeFromSuperview];
                _searchView=nil;
                if(_alpha<1.0f){
                    _barImageView.alpha = 0;
                    _NavView.alpha = 0;
                }else{
                    _barImageView.alpha = 1;
                    _NavView.alpha = 1;
                }

            }else if([type isEqualToString:@"search"])
            {
                YYShowroomBrandViewController *brandCTN = [[YYShowroomBrandViewController alloc] init];
                brandCTN.brandId = ShowroomBrandModel.brandId;
                [brandCTN setCancelButtonClicked:^(){
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [self.navigationController pushViewController:brandCTN animated:YES];
            }
        }];
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    _barImageView.alpha = 0;
    _NavView.alpha = 0;
    _searchView.ShowroomBrandListModel = _ShowroomBrandListModel;
    [self.view addSubview:_searchView];
}

#pragma mark - 扫码
//查看是否有权限访问styleId对应下的款式
-(void)hasPermissionToVisitStyleWithScanModel:(YYScanFunctionModel *)scanModel code:(YYQRCodeController *)code{
    [YYShowroomApi hasPermissionToVisitStyleWithStyleId:[scanModel.id longLongValue] andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,BOOL hasPermission,NSNumber *brandId,NSError *error) {
        if(rspStatusAndMessage){
            if(hasPermission){
                //showroom切换到品牌角色
                [self showroomToBrandWithBrandID:brandId WithScanModel:scanModel code:code];
            }else{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [code toast:NSLocalizedString(@"您没有查看此款式的权限",nil) collback:^(YYQRCodeController *code) {
                    [code scanningAgain];
                }];
            }
        }else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [code toast:kNetworkIsOfflineTips collback:^(YYQRCodeController *code) {
                [code scanningAgain];
            }];
        }
    }];
}

//showroom切换到品牌角色
-(void)showroomToBrandWithBrandID:(NSNumber *)brandId WithScanModel:(YYScanFunctionModel *)scanModel code:(YYQRCodeController *)code{
    [YYShowroomApi showroomToBrandWithBrandID:brandId andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYUserModel *userModel, NSError *error) {
        if (rspStatusAndMessage.status == YYReqStatusCode100) {
            //表示切换角色成功,并进行扫码款式类型处理
            [self sweepYardStyleTypeAction:scanModel code:code];
        }else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
}
//并进行扫码款式类型处理
-(void)sweepYardStyleTypeAction:(YYScanFunctionModel *)scanModel code:(YYQRCodeController *)code{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [YYOpusApi getStyleInfoByStyleId:[scanModel.id longLongValue] orderCode:nil andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYStyleInfoModel *styleInfoModel, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(rspStatusAndMessage){
            if (rspStatusAndMessage.status == YYReqStatusCode100) {
                [code dismissController];
                //表示有权限访问，跳转款式详情页
                if(styleInfoModel){
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    YYStyleOneColorModel *infoModel = [styleInfoModel transformToStyleOneColorModel];
                    [appDelegate showStyleInfoViewController:infoModel parentViewController:self IsShowroomToScan:YES];
                }else{
                    //清除brand的角色，切换到showroom角色
                    [YYUser removeTempUser];
                }
            }else{
                [code toast:NSLocalizedString(@"您没有查看此款式的权限",nil) collback:^(YYQRCodeController *code) {
                    [code scanningAgain];
                }];
                //清除brand的角色，切换到showroom角色
                [YYUser removeTempUser];
            }
        }else{
            [code toast:kNetworkIsOfflineTips collback:^(YYQRCodeController *code) {
                [code scanningAgain];
            }];
            //清除brand的角色，切换到showroom角色
            [YYUser removeTempUser];
        }
    }];
}


#pragma mark - 保存图片
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    if(error != NULL){

        [YYToast showToastWithTitle:NSLocalizedString(@"保存图片失败",nil) andDuration:kAlertToastDuration];
    }else{

        [YYToast showToastWithTitle:NSLocalizedString(@"保存图片成功",nil) andDuration:kAlertToastDuration];
    }
}

#pragma mark - RequestData
-(void)RequestData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    WeakSelf(ws);
    [YYShowroomApi getShowroomBrandListWithBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,YYShowroomBrandListModel *brandListModel,NSError *error) {
        if(rspStatusAndMessage.status == YYReqStatusCode100){
            ws.ShowroomBrandListModel = brandListModel;
            [ws updateData];
            [self CreateOrUpdateTableHeadView];
            [self CreteTableFooterView];
            [self CreateOrMoveNoDataView];
            [ws.tableView reloadData];

            _NavView.navTitle = ws.ShowroomBrandListModel.name;

            if(_currentUser.userType == YYUserTypeShowroom){
                //showroom权限
                [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];
                //获取红星
                [ws getHasOrderingMsg];
            }else{
                //非showroom权限 一般默认为showroom_sub权限
                [ws updatePermission];
            }
        }else{
            [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];
            //获取红星
            [ws getHasOrderingMsg];
            [YYToast showToastWithView:ws.view title:rspStatusAndMessage.message andDuration:kAlertToastDuration];
        }
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
}
-(void)updatePermission{
    WeakSelf(ws);
    [YYShowroomApi hasPermissionToVisitOrderingWithBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, BOOL hasPermission, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];
        if(rspStatusAndMessage.status == YYReqStatusCode100){
            if(hasPermission){
                ws.permissionStatus = 1;
                //获取红星
                [ws getHasOrderingMsg];
            }else{
                ws.permissionStatus = 0;
            }
        }else{
            ws.permissionStatus = -1;
        }
    }];
}
-(void)getHasOrderingMsg{
    WeakSelf(ws);
    if(_permissionStatus == 1){
        [YYShowroomApi hasOrderingMsgWithBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, BOOL hasMsg, NSError *error) {
            if(rspStatusAndMessage.status == YYReqStatusCode100){
                ws.hasOrderingMsg = hasMsg;
            }else{
                ws.hasOrderingMsg = NO;
            }
        }];
    }
}
-(void)setHasOrderingMsg:(BOOL)hasOrderingMsg{
    _hasOrderingMsg = hasOrderingMsg;
    if(_notRedView){
        _notRedView.hidden = !_hasOrderingMsg;
    }
}
#pragma mark *显示微信二维码
-(void)ShowWechat2Dbarcode
{
    //显示二维码
    _mengban=[UIImageView getImgWithImageStr:@"System_Transparent_Mask"];
    _mengban.contentMode=UIViewContentModeScaleToFill;
    [self.view.window addSubview:_mengban];
    [_mengban addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAction)]];
    _mengban.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

    UIView *bottomView=[UIView getCustomViewWithColor:_define_black_color];
    [_mengban addSubview:bottomView];
    bottomView.userInteractionEnabled = YES;
    [bottomView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(NULLACTION)]];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_mengban);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
    }];

    UIView *backView=[UIView getCustomViewWithColor:_define_white_color];
    [bottomView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(4, 4, 4, 4));
    }];

    UILabel *titleLabel = [UILabel getLabelWithAlignment:1 WithTitle:NSLocalizedString(@"联系 YCO 小助手",nil) WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [backView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(17);
    }];

    UIView *line = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"d3d3d3"]];
    [backView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).with.offset(14);
        make.centerX.mas_equalTo(backView);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(47);
        make.right.mas_equalTo(-47);
    }];

    _zbar=[UIImageView getImgWithImageStr:@"weixincode_img"];
    [backView addSubview:_zbar];
    [_zbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom).with.offset(18);
        make.centerX.mas_equalTo(backView);
        make.height.width.mas_equalTo(123);
    }];

    UILabel *namelabel=[UILabel getLabelWithAlignment:1 WithTitle:[[NSString alloc] initWithFormat:NSLocalizedString(@"微信号：%@",nil),@"yunejianhelper"] WithFont:13.0f WithTextColor:[UIColor colorWithHex:kDefaultTitleColor_phone] WithSpacing:0];
    [backView addSubview:namelabel];
    [namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_zbar.mas_bottom).with.offset(8);
        make.centerX.mas_equalTo(backView);
    }];

    __block UIView *lastView=nil;
    NSArray *titleArr=@[NSLocalizedString(@"保存二维码",nil),NSLocalizedString(@"复制微信号",nil)];
    [titleArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {

        UIButton *actionbtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:14.0f WithSpacing:0 WithNormalTitle:obj WithNormalColor:idx==0?_define_white_color:_define_black_color WithSelectedTitle:nil WithSelectedColor:nil];
        [backView addSubview:actionbtn];
        actionbtn.backgroundColor=idx==0?_define_black_color:_define_white_color;
        setBorder(actionbtn);
        if(!idx){
            //保存二维码
            [actionbtn addTarget:self action:@selector(saveWeixinPic) forControlEvents:UIControlEventTouchUpInside];
        }else
        {
            //复制微信号
            [actionbtn addTarget:self action:@selector(copyWeixinName) forControlEvents:UIControlEventTouchUpInside];
        }
        [actionbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(47);
            make.right.mas_equalTo(-47);
            make.height.mas_equalTo(38);
            if(lastView)
            {
                make.top.mas_equalTo(lastView.mas_bottom).with.offset(8);
                make.bottom.mas_equalTo(-15);
            }else{
                make.top.mas_equalTo(namelabel.mas_bottom).with.offset(13);
            }
        }];

        lastView=actionbtn;
    }];
}

#pragma mark - --------------UI----------------------
#pragma mark - UIConfig
-(void)PrepareUI{
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.view.backgroundColor = _define_white_color;
    
    _NavView = [[YYNavView alloc] initWithTitle:@""];
    self.navigationItem.titleView = _NavView;
    
    UIButton *searchButton = [UIButton getCustomImgBtnWithImageStr:@"search_Showroom_icon" WithSelectedImageStr:nil];
    [searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setAdjustsImageWhenHighlighted:NO];
    searchButton.opaque = NO;
    searchButton.frame = CGRectMake(0, 0, 34, 44);

    UIButton *notificationButton = [UIButton getCustomImgBtnWithImageStr:@"not_Showroom_icon" WithSelectedImageStr:nil];
    [notificationButton addTarget:self action:@selector(notificationAction) forControlEvents:UIControlEventTouchUpInside];
    [notificationButton setAdjustsImageWhenHighlighted:NO];
    notificationButton.opaque = NO;
    notificationButton.frame = CGRectMake(0, 0, 34, 44);

    _notRedView = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"EF4E31"]];
    [notificationButton addSubview:_notRedView];
    [_notRedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.height.mas_equalTo(8);
    }];
    _notRedView.layer.masksToBounds = YES;
    _notRedView.layer.cornerRadius = 4.0f;
    _notRedView.hidden = YES;

    self.navigationItem.rightBarButtonItems = @[
                                                [[UIBarButtonItem alloc] initWithCustomView:searchButton]
                                                ,[[UIBarButtonItem alloc] initWithCustomView:notificationButton]
                                                ];

    UIButton *sweepYardButton = [UIButton getCustomImgBtnWithImageStr:@"scan_showroom_icon" WithSelectedImageStr:nil];
    [sweepYardButton addTarget:self action:@selector(sweepYardButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [sweepYardButton setAdjustsImageWhenHighlighted:NO];
    sweepYardButton.opaque = NO;
    sweepYardButton.frame = CGRectMake(0, 0, 34, 44);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sweepYardButton];
    
    _alpha = 0.0;
    _barImageView = [self.navigationController.navigationBar.subviews firstObject];
    _barImageView.backgroundColor = _define_white_color;
    _barImageView.alpha = _alpha;
    _NavView.alpha = _alpha;

}

-(void)UIConfig{
    [self CreateTableView];
    [self addHeader];
}

-(void)CreateTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    [self.view addSubview:_tableView];
    //    消除分割线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = _define_white_color;
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexColor = [UIColor colorWithHex:@"d3d3d3"];

    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        if(kIPhoneX){
            make.top.mas_equalTo(self.mas_topLayoutGuideBottom).with.offset(-45);
        }else{
            make.top.mas_equalTo(self.mas_topLayoutGuideBottom).with.offset(-65);
        }
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop).with.offset(0);
    }];
}
-(void)addHeader{
    WeakSelf(ws);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws RequestData];
    }];
    self.tableView.mj_header = header;
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
}

-(void)CreateOrUpdateTableHeadView{
    if(!_tableHeadview){
        _tableHeadview = [[YYShowroomBrandHeadView alloc] initWithBlock:^(NSString *type) {
            if([type isEqualToString:@"headclick"]){
                //跳转个人信息页面
                [self pushPersonView];
            }else if([type isEqualToString:@"search"]){
                //搜索品牌
                [self ShowSearchView];
            }
        }];

        CGFloat height = ((324.0f/750.0f)*SCREEN_WIDTH)+74-(kIPhoneX?45:65);
        _tableHeadview.frame=CGRectMake(0, 0, SCREEN_WIDTH, height);
        _tableView.tableHeaderView = _tableHeadview;
    }
    if(!_ShowroomBrandListModel.brandList.count){
        [_tableHeadview bottomIsHide:YES];
    }else{
        [_tableHeadview bottomIsHide:NO];
    }
    _tableHeadview.ShowroomBrandListModel = _ShowroomBrandListModel;
}

-(void)CreteTableFooterView
{
    if(!_footerView)
    {
        _footerView = [UIView getCustomViewWithColor:nil];
        _footerView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 80);
        _tableView.tableFooterView = _footerView;
    }
}


-(void)CreateOrMoveNoDataView
{
    if(!_noDataView)
    {
        _noDataView = [[YYShowroomMainNoDataView alloc] initWithSuperView:_tableView Block:^(NSString *type) {
            if([type isEqualToString:@"showhelp"])
            {
                [self ShowWechat2Dbarcode];
            }
        }];
    }
    if(_ShowroomBrandListModel.brandList.count)
    {
        _noDataView.hidden = YES;
    }else{
        _noDataView.hidden = NO;
    }
}

#pragma mark - --------------other----------------------

- (BOOL)prefersStatusBarHidden{
    return NO;
}
@end
