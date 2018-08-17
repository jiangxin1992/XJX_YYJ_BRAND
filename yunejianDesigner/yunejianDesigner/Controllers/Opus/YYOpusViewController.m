//
//  YYOpusViewController.m
//  Yunejian
//
//  Created by yyj on 15/7/9.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYOpusViewController.h"
#import "YYOpusApi.h"
#import "YYUser.h"
#import "SDWebImageManager.h"
#import <MJRefresh.h>
#import "YYTopBarShoppingCarButton.h"
#import "NSManagedObject+helper.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "UIImage+YYImage.h"
#import "YYCartDetailViewController.h"
#import "YYSeriesCollectionViewCell.h"
#import "YYYellowPanelManage.h"
#import "YYUserApi.h"
#import "YYBrandInfoModel.h"
#import "YYMessageButton.h"
#import "UserDefaultsMacro.h"
#import "YYGuideHandler.h"
#import "YYStylesAndTotalPriceModel.h"
#import "YYScanFunctionModel.h"
#import "YYMessageUnreadModel.h"
#import "YYQRCode.h"

@interface YYOpusViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,YYSeriesCollectionViewCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionBottomLayer;
@property (weak, nonatomic) IBOutlet YYTopBarShoppingCarButton *topBarShoppingCarButton;

@property (nonatomic,strong)NSMutableArray *online_opusSeriesArray;
@property (nonatomic,strong)YYPageInfoModel *currentPageInfo;

@property(nonatomic,strong) YYStylesAndTotalPriceModel *stylesAndTotalPriceModel;//总数

@property (nonatomic,strong) UIView *noDataView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet YYMessageButton *messageButton;

@end

@implementation YYOpusViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    if([YYUser isShowroomToBrand])
    {
        _collectionBottomLayer.constant = 58;
    }else
    {
        _collectionBottomLayer.constant = 0;
    }
    [_messageButton initButton:@""];
    [self messageCountChanged:nil];
    [_messageButton addTarget:self action:@selector(messageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageCountChanged:) name:UnreadMsgAmountChangeNotification object:nil];

    self.topBarShoppingCarButton.isRight = NO;
    [self.topBarShoppingCarButton initButton];
    _titleLabel.text = @"";
    self.online_opusSeriesArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self addHeader];
    [self addFooter];
    
    self.collectionView.alwaysBounceVertical = YES;
    self.noDataView = addNoDataView_phone(self.view,[NSString stringWithFormat:@"%@|icon:noopus_icon",NSLocalizedString(@"还未创建作品/n请登录YCO SYSTEM网页版，进行创建。",nil) ],nil,nil);
    self.noDataView.hidden = YES;
    
    if ([YYCurrentNetworkSpace isNetwork]) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UIView *superView = appDelegate.window.rootViewController.view;
        [MBProgressHUD showHUDAddedTo:superView animated:YES];
     }
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate checkNoticeCount];
    [self getDesignerBrandInfo];
    [self loadDataByPageIndex:1];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveAction) name:kApplicationDidBecomeActive object:nil];
}
-(void)applicationDidBecomeActiveAction{
    if(!self.noDataView.hidden){
        YYUser *user = [YYUser currentUser];

        if(!((user.userType == 5 || user.userType ==6)&&![YYUser isShowroomToBrand])){
            [self headerWithRefreshingAction];
        }else{
            NSLog(@"showroom主页");
        }
    }
}
//在视图出现的时候更新购物车数据
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateShoppingCar];

    // 进入埋点
    [MobClick beginLogPageView:kYYPageOpus];

    if(!self.noDataView.hidden){
        [self headerWithRefreshingAction];
    }
}
- (void)viewDidAppear:(BOOL)animated {
    YYSeriesCollectionViewCell *viewcell = (YYSeriesCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if(viewcell){
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

        [YYGuideHandler showGuideView:GuideTypeOpusSetting parentView:appDelegate.mainViewController.view targetView:viewcell.startBtn];
    }else{
        if(animated == YES){
            [self performSelector:@selector(viewDidAppear:) withObject:nil afterDelay:1.0f];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageOpus];
}

#pragma msseage
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
            [_messageButton updateButtonNumber:[NSString stringWithFormat:@"%ld",msgAmount]];
        }else{
            [_messageButton updateButtonNumber:@""];
        }
    }else
    {
        NSInteger msgAmount = [appDelegate.messageUnreadModel.orderAmount integerValue] + [appDelegate.messageUnreadModel.connAmount integerValue] + [appDelegate.messageUnreadModel.personalMessageAmount integerValue] + [appDelegate.messageUnreadModel.skuAmount integerValue];
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
#pragma mark - 扫码
- (IBAction)sweepYardButtonClicked:(id)sender {
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
                //扫码款式类型处理
                [self sweepYardStyleTypeAction:scanModel code:code];
            }
        }else{
            [code toast:NSLocalizedString(@"您没有查看此款式的权限",nil) collback:^(YYQRCodeController *code) {
                [code scanningAgain];
            }];
        }
    }];

    [self.navigationController pushViewController:QRCode animated:YES];
}

-(void)sweepYardStyleTypeAction:(YYScanFunctionModel *)scanModel code:(YYQRCodeController *)code{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [YYOpusApi getStyleInfoByStyleId:[scanModel.id longLongValue] orderCode:nil andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYStyleInfoModel *styleInfoModel, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(rspStatusAndMessage){
            if (rspStatusAndMessage.status == kCode100) {
                [code dismissController];
                //表示有权限访问，跳转款式详情页
                if(styleInfoModel){
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    YYInventoryBoardModel *infoModel = [styleInfoModel transformToInventoryBoardModel];
                    [appDelegate showStyleInfoViewController:infoModel parentViewController:self IsShowroomToScan:NO];
                }
            }else{
                [code toast:NSLocalizedString(@"您没有查看此款式的权限",nil) collback:^(YYQRCodeController *code) {
                    [code scanningAgain];
                }];
            }
        }else{
            [code toast:kNetworkIsOfflineTips collback:^(YYQRCodeController *code) {
                [code scanningAgain];
            }];
        }
    }];
}
- (void)getDesignerBrandInfo{
    WeakSelf(ws);
    [YYUserApi getDesignerBrandInfoWithBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYBrandInfoModel *brandInfoModel, NSError *error) {
        if (brandInfoModel) {
            ws.titleLabel.text = brandInfoModel.brandName;
        }
    }];
}


- (void)updateShoppingCar{
    WeakSelf(ws);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            ws.stylesAndTotalPriceModel = getLocalShoppingCartStyleCount(appdelegate.cartDesignerIdArray);
            [ws.topBarShoppingCarButton updateButtonNumber:[NSString stringWithFormat:@"%i", self.stylesAndTotalPriceModel.totalStyles]];
        });
    });
}
- (IBAction)shoppingCarClicked:(id)sender{
    
    if (self.stylesAndTotalPriceModel.totalStyles <= 0) {
        [YYToast showToastWithTitle:NSLocalizedString(@"购物车暂无数据",nil) andDuration:kAlertToastDuration];
        return;
    }
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Order" bundle:[NSBundle mainBundle]];
    YYCartDetailViewController *cartVC = [storyboard instantiateViewControllerWithIdentifier:@"YYCartDetailViewController"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cartVC];
    nav.navigationBar.hidden = YES;
    
    WeakSelf(ws);
    [cartVC setGoBackButtonClicked:^(){
        [ws dismissViewControllerAnimated:YES completion:^{
            //刷新购物车图标数据
            [ws updateShoppingCar];
        }];
    }];
    
    [cartVC setToOrderList:^(){
        [ws dismissViewControllerAnimated:NO completion:^{
            //进入订单列表界面
            [[NSNotificationCenter defaultCenter] postNotificationName:kShowOrderListNotification object:nil];
        }];
    }];
    
    [self presentViewController:nav animated:YES completion:nil];
}

//刷新界面
- (void)reloadCollectionViewData{
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    
    [self.collectionView reloadData];
    
    if ([self.online_opusSeriesArray count] == 0) {
        self.noDataView.hidden = NO;
    }else{
        self.noDataView.hidden = YES;
    }
}

- (void)loadDataByPageIndex:(int)pageIndex{

    if (![YYCurrentNetworkSpace isNetwork]) {
        [self reloadCollectionViewData];
        [YYToast showToastWithTitle:kNetworkIsOfflineTips andDuration:kAlertToastDuration];
        return;
    }
    
    YYUser *user = [YYUser currentUser];
    WeakSelf(ws);

    [YYOpusApi getSeriesListWithId:[user.userId intValue] pageIndex:pageIndex pageSize:kPageSize withDraft:@"true" andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYOpusSeriesListModel *opusSeriesListModel, NSError *error) {
        BOOL checkGuide = NO;
        if (rspStatusAndMessage.status == kCode100
            && opusSeriesListModel.result
            && [opusSeriesListModel.result count] > 0) {
            
            if (pageIndex == 1) {
                [_online_opusSeriesArray removeAllObjects];
            }
            if(ws.currentPageInfo == nil){
                checkGuide = YES;
            }
            ws.currentPageInfo = opusSeriesListModel.pageInfo;
            [ws.online_opusSeriesArray addObjectsFromArray:opusSeriesListModel.result];
           
        
        }
        [ws reloadCollectionViewData];
        if(checkGuide){
            [ws viewDidAppear:YES];
        }
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UIView *superView = appDelegate.window.rootViewController.view;
        
        [MBProgressHUD hideAllHUDsForView:superView animated:YES];
        
        if (rspStatusAndMessage.status != kCode100) {
            [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
        }
    }];
}



- (void)addHeader{
    WeakSelf(ws);
    // 添加下拉刷新头部控件
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态就会回调这个Block
        [ws headerWithRefreshingAction];
    }];
    self.collectionView.mj_header = header;
    self.collectionView.mj_header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
}
-(void)headerWithRefreshingAction{
    if (![YYCurrentNetworkSpace isNetwork]) {
        [YYToast showToastWithTitle:kNetworkIsOfflineTips andDuration:kAlertToastDuration];
        [self.collectionView.mj_header endRefreshing];
        return;
    }else{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate checkNoticeCount];
    }
    [self loadDataByPageIndex:1];
}
- (void)addFooter{
    WeakSelf(ws);
    // 添加上拉刷新尾部控件
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态就会回调这个Block

        if (![YYCurrentNetworkSpace isNetwork]) {
            [YYToast showToastWithTitle:kNetworkIsOfflineTips andDuration:kAlertToastDuration];
            [ws.collectionView.mj_footer endRefreshing];
            return;
        }

        if ([ws.online_opusSeriesArray count] > 0
            && ws.currentPageInfo
            && !ws.currentPageInfo.isLastPage) {
            [ws loadDataByPageIndex:[ws.currentPageInfo.pageIndex intValue]+1];
        }else{
            [ws.collectionView.mj_footer endRefreshing];
        }
    }];
}




#pragma mark -  UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
    
    layout.sectionInset = UIEdgeInsetsMake(15, 12, 15, 12);
    
    if ([_online_opusSeriesArray count] > 0) {
        return [_online_opusSeriesArray count];
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger cellWidth = (SCREEN_WIDTH-24-10)/2;
    return CGSizeMake(cellWidth, [YYSeriesCollectionViewCell cellHeight:cellWidth]);
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* reuseIdentifier = @"YYSeriesCollectionViewCell";
    YYSeriesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSString *imageRelativePath = nil;
    NSString *title = nil;
    NSString *beginDate = @"";
    NSString *endDate = @"";

    NSString *order = nil;
    NSString *styleAmount = nil;
    int supplyStatus = -1;
    NSInteger authType= 0;
    NSInteger status = -1;
    NSNumber *whiteAuthCount = nil;
    NSComparisonResult compareResult = NSOrderedDescending;
    
    if (indexPath.row < [_online_opusSeriesArray count]) {

            YYOpusSeriesModel *opusSeriesModel = [_online_opusSeriesArray objectAtIndex:indexPath.row];
            imageRelativePath = opusSeriesModel.albumImg;
            title = opusSeriesModel.name;
            beginDate = getShowDateByFormatAndTimeInterval(@"yy/MM/dd",[opusSeriesModel.supplyStartTime stringValue]);
            endDate = getShowDateByFormatAndTimeInterval(@"yy/MM/dd",[opusSeriesModel.supplyEndTime stringValue]);
            order = [NSString stringWithFormat:NSLocalizedString(@"最晚下单：%@",nil), [NSString isNilOrEmpty:opusSeriesModel.orderDueTime] ? NSLocalizedString(@"随时可以下单", nil) : getShowDateByFormatAndTimeInterval(@"yy/MM/dd", opusSeriesModel.orderDueTime)];
            styleAmount =  [NSString stringWithFormat:NSLocalizedString(@"%i 款",nil),[opusSeriesModel.styleAmount intValue]];
            
            supplyStatus = [opusSeriesModel.supplyStatus intValue];
            compareResult = [NSString isNilOrEmpty:opusSeriesModel.orderDueTime] ? NSOrderedDescending : compareNowDate(opusSeriesModel.orderDueTime);
            authType = [opusSeriesModel.authType integerValue];
            status = [opusSeriesModel.status integerValue];
            whiteAuthCount = opusSeriesModel.whiteAuthCount;
    }
    
    cell.imageRelativePath = imageRelativePath;
    cell.title = title;
    cell.order = order;
    cell.styleAmount = styleAmount;
    cell.authType = authType;
    cell.status = status;
    cell.whiteAuthCount = whiteAuthCount;
    cell.supplyStatus = supplyStatus;
    cell.compareResult = compareResult;
    cell.indexPath = indexPath;
    cell.delegate = self;
    [cell updateUI];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    YYOpusSeriesModel *opusSeriesModel = nil;
    if ([_online_opusSeriesArray count] > indexPath.row ) {
         opusSeriesModel = [_online_opusSeriesArray objectAtIndex:indexPath.row];
    }
    if(opusSeriesModel){
        AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appdelegate showSeriesInfoViewController:opusSeriesModel.designerId seriesId:opusSeriesModel.id parentViewController:self];
    }
}

#pragma mark - YYSeriesCollectionViewCellDelegate

-(void)operateHandler:(NSInteger)section androw:(NSInteger)row type:(NSString *)type{
    WeakSelf(ws);
    if([type isEqualToString:@"refresh"]){//更新下载进度
        [self.collectionView reloadData];
    }else if([type isEqualToString:@"updateAuthType"]){//更新权限更改
        if ([_online_opusSeriesArray count] > row ) {
            YYOpusSeriesModel *opusSeriesModel = [_online_opusSeriesArray objectAtIndex:row];
            __block YYOpusSeriesModel *blockopusSeriesModel = opusSeriesModel;

            if(section == kAuthTypeDefined){
                if(opusSeriesModel.id && opusSeriesModel.authType){
                [[YYYellowPanelManage instance] showOpusSettingDefinedViewWidthParentView:self info:@[opusSeriesModel.id,opusSeriesModel.authType] andCallBack:^(NSArray *value) {
                    NSString *authTypeInfo = [value objectAtIndex:0];
                    NSArray *authTypeInfoArr = [authTypeInfo componentsSeparatedByString:@"|"];
                    if([authTypeInfoArr count] == 2){
                        NSInteger authType = [[authTypeInfoArr objectAtIndex:0] integerValue];
                        NSString *buyerIds = [authTypeInfoArr objectAtIndex:1];
                        __block NSInteger whiteAuthCount = [[buyerIds componentsSeparatedByString:@","] count];
                        [YYOpusApi updateSeriesAuthType:[blockopusSeriesModel.id integerValue] authType:authType buyerIds:buyerIds andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
                            if(rspStatusAndMessage.status == kCode100){
                                blockopusSeriesModel.authType = [[NSNumber alloc] initWithInteger:authType];
                                blockopusSeriesModel.whiteAuthCount= [[NSNumber alloc] initWithInteger:whiteAuthCount];
                                [ws.collectionView reloadData];
                                [YYToast showToastWithTitle:NSLocalizedString(@"修改成功",nil) andDuration:kAlertToastDuration];
                            }
                        }];
                    }
                }];
                }
                return;
            }
            [YYOpusApi updateSeriesAuthType:[opusSeriesModel.id integerValue] authType:section buyerIds:@"" andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
                if(rspStatusAndMessage.status == kCode100){
                    blockopusSeriesModel.authType = [[NSNumber alloc] initWithInteger:section];
                    [ws.collectionView reloadData];
                    [YYToast showToastWithTitle:NSLocalizedString(@"修改成功",nil) andDuration:kAlertToastDuration];
                }
            }];
            
        }
//        else if ([_cache_opusSeriesArray count] > row){
//            [YYToast showToastWithTitle:kNetworkIsOfflineTips andDuration:kAlertToastDuration];
//        }
    }else if([type isEqualToString:@"updatePubStatus"]){
        YYOpusSeriesModel *opusSeriesModel = [_online_opusSeriesArray objectAtIndex:row];
        __block YYOpusSeriesModel *blockopusSeriesModel = opusSeriesModel;
        [[YYYellowPanelManage instance] showOpusSettingpanelWidthParentView:nil seriesId:[opusSeriesModel.id integerValue] andCallBack:^(NSArray *value) {
            NSString *authType = nil;
            NSString *buyerIds = @"";
            NSString *authTypeInfo = [value objectAtIndex:0];
            NSArray *authTypeInfoArr = [authTypeInfo componentsSeparatedByString:@"|"];
            if([authTypeInfoArr count] == 2){
                authType = [authTypeInfoArr objectAtIndex:0];
                buyerIds = [authTypeInfoArr objectAtIndex:1];
            }else{
                authType = authTypeInfo ;
            }
            __block NSInteger blockType = [authType integerValue];
            __block NSInteger whiteAuthCount = [[buyerIds componentsSeparatedByString:@","] count];
            [YYOpusApi updateSeriesPubStatus:[blockopusSeriesModel.id integerValue] status:0 authType:authType buyerIds:buyerIds andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
                if(rspStatusAndMessage.status == kCode100){
                    blockopusSeriesModel.authType = [[NSNumber alloc] initWithInteger:blockType];
                    blockopusSeriesModel.status = [[NSNumber alloc] initWithInt:0];
                    blockopusSeriesModel.whiteAuthCount= [[NSNumber alloc] initWithInteger:whiteAuthCount];
                    [ws.collectionView reloadData];
                    [YYToast showToastWithTitle:NSLocalizedString(@"修改成功",nil) andDuration:kAlertToastDuration];
                }
            }];
        }];
    }
}

-(UIView *)getview{
    return self.view;
}

@end
