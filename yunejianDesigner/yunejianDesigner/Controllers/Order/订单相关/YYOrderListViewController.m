//
//  YYOrderListViewController.m
//  Yunejian
//
//  Created by Apple on 15/8/17.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYOrderListViewController.h"

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "YYOrderDetailViewController.h"
#import "YYOrderListTableViewController.h"
#import "YYCustomCellTableViewController.h"
#import "YYPackingListViewController.h"

// 自定义视图
#import "YYOrderNormalListCell.h"
#import "MBProgressHUD.h"
#import "YYMessageButton.h"
#import "YYYellowPanelManage.h"
#import "YYMenuPopView.h"
#import "TitlePagerView.h"

// 接口
#import "YYOrderApi.h"

// 分类
#import "UIImage+Tint.h"

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import <MJRefresh.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>

#import "YYUser.h"
#import "YYOrderListModel.h"
#import "YYMessageUnreadModel.h"
#import "YYOrderListItemModel.h"
#import "YYPackingListDetailModel.h"

#import "AppDelegate.h"

#define kOrderPageSize 5

@interface YYOrderListViewController ()<UITableViewDataSource,UITableViewDelegate,YYTableCellDelegate,UITextFieldDelegate,TitlePagerViewDelegate,ViewPagerDataSource, ViewPagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (nonatomic,assign)BOOL isSearchView;
@property (nonatomic,copy) NSString *searchFieldStr;

@property (weak, nonatomic) IBOutlet UIView *tabBarView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchViewTopLayoutConstraint;

@property (weak, nonatomic) IBOutlet YYMessageButton *messageButton;
@property (weak, nonatomic) IBOutlet UIButton *pullDownMenu;
@property(nonatomic,strong) NSArray *menuBtnsData;
@property(nonatomic,strong) NSArray *menuBtnsIconData;

@property (weak, nonatomic) IBOutlet UIButton *tabBtn;
@property(nonatomic,strong) NSArray *tabBtnsData;

@property (nonatomic,strong)YYPageInfoModel *currentPageInfo;
@property (strong, nonatomic)NSMutableArray *orderListArray;

@property (strong, nonatomic)NSMutableArray *localNoteArray;
@property (strong, nonatomic)NSMutableArray *searchNoteArray;//搜索历史记录

@property(nonatomic,assign) NSInteger currentOrderType;//订单类型，0，正常（默认值）；1，已取消 
@property(nonatomic,assign) int currentPayType;//0 1
@property(nonatomic,assign) NSString *curentOrderStatus;// 0 4-9
@property (nonatomic,strong) UIView *noDataView;


@property(strong,nonatomic) YYOrderListTableViewController *normalOrderListTableVC;
@property(strong,nonatomic) YYOrderListTableViewController *cancelOrderListTableVC;

@property(nonatomic,assign) BOOL detailViewBackFlag;//详情页返回

@end

@implementation YYOrderListViewController
#pragma mark - --------------生命周期--------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.detailViewBackFlag){
        self.detailViewBackFlag = NO;
    }else{
        [self reloadCurrentTableData:YES];
    }
    // 进入埋点
    [MobClick beginLogPageView:kYYPageOrderList];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageOrderList];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - --------------SomePrepare--------------
- (void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
- (void)PrepareData{
    _searchFieldStr = @"";
    self.orderListArray = [[NSMutableArray alloc] initWithCapacity:0];
    _menuBtnsData = @[NSLocalizedString(@"全部",nil)
                      ,NSLocalizedString(@"已下单",nil)
                      ,NSLocalizedString(@"已确认",nil)//5,6
                      ,NSLocalizedString(@"已生产",nil)
                      ,NSLocalizedString(@"发货中",nil)
                      ,NSLocalizedString(@"已发货",nil)
                      ,NSLocalizedString(@"已收货",nil)
                      ,NSLocalizedString(@"部分货款已收",nil)
                      ,NSLocalizedString(@"100%货款已收",nil)];

    _menuBtnsIconData = @[@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
    _tabBtnsData = @[NSLocalizedString(@"所有订单",nil)
                     ,NSLocalizedString(@"已取消",nil)];
    _currentOrderType = 0;//默认正常的，1是已经取消的
    _curentOrderStatus = @"-1";
    _currentPayType = -1;
    self.manualLoadData = YES;
    self.currentIndex = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageCountChanged:) name:UnreadMsgAmountChangeNotification object:nil];
}
- (void)PrepareUI{

    self.searchField.delegate = self;
    self.dataSource = self;
    self.delegate = self;

    self.tableView.hidden = YES;

    if(IsPhone6_gt){
        self.searchField.font = [UIFont systemFontOfSize:14.0f];
    }else{
        self.searchField.font = [UIFont systemFontOfSize:12.0f];
    }

    [self.pullDownMenu addTarget:self action:@selector(showMenuUI:) forControlEvents:UIControlEventTouchUpInside];

    [self scrollEnabled:NO];
    [self reloadData];
}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{
    [self initMessageButton];
    [self createNoDataView];
}
-(void)initMessageButton{
    [_messageButton initButton:@""];
    [self messageCountChanged:nil];
    [_messageButton addTarget:self action:@selector(messageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)createNoDataView{
    if(!_noDataView){
        self.noDataView = addNoDataView_phone(self.view, [NSString stringWithFormat:@"%@|icon:noorder_icon",NSLocalizedString(@"暂无相关订单哦~",nil)],nil,nil);
        _noDataView.hidden = YES;
    }
}
#pragma mark - --------------请求数据----------------------
- (void)loadOrderListFromServerByPageIndex:(int)pageIndex endRefreshing:(BOOL)endrefreshing{
    WeakSelf(ws);

    __block BOOL blockEndrefreshing = endrefreshing;
    NSString *trueCurrentOrderType = _currentOrderType==1?@"10,11":_curentOrderStatus;
    [YYOrderApi getOrderInfoListWithPayType:_currentPayType
                                orderStatus:trueCurrentOrderType
                                   queryStr:_searchFieldStr
                                  pageIndex:pageIndex
                                   pageSize:kOrderPageSize
                                   andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYOrderListModel *orderListModel, NSError *error){
                                       if (rspStatusAndMessage.status == YYReqStatusCode100) {
                                           if (pageIndex == 1) {
                                               [ws.orderListArray removeAllObjects];
                                           }
                                           ws.currentPageInfo = orderListModel.pageInfo;

                                           if (orderListModel && orderListModel.result
                                               && [orderListModel.result count] > 0){
                                               [ws.orderListArray addObjectsFromArray:orderListModel.result];

                                           }
                                       }

                                       [ws addSearchNote];
                                       if(blockEndrefreshing){
                                           [self.tableView.mj_header endRefreshing];
                                           [self.tableView.mj_footer endRefreshing];
                                       }
                                       [ws reloadTableData];

                                       [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];
                                   }];
}

-(void)loadOrderListItem:(NSIndexPath *)indexPath{
    if(self.tableView.hidden){
        YYOrderListTableViewController *tableViewController = (YYOrderListTableViewController *)[self viewControllerAtIndex:_currentOrderType];
        if(tableViewController != nil){
            [tableViewController reloadListItem:indexPath.row];
        }
    }else{
        NSInteger row=indexPath.row;
        __block YYOrderListItemModel *blockorderListItemModel = [_orderListArray objectAtIndex:row];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        WeakSelf(ws);
        [YYOrderApi getOrderInfoListItemWithOrderCode:blockorderListItemModel.orderCode andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYOrderListItemModel *orderListItemModel, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];
            if(rspStatusAndMessage.status == YYReqStatusCode100 && [blockorderListItemModel.orderCode isEqualToString:orderListItemModel.orderCode]){
                [ws.orderListArray replaceObjectAtIndex:row withObject:orderListItemModel];
                [ws reloadTableData];
            }
        }];
    }
}
#pragma mark - --------------Setter----------------------
- (void)setCurrentIndex:(NSInteger)index {
    _currentOrderType = index;
    if(_currentOrderType != 0){
        _pullDownMenu.enabled = NO;
    }else{
        _pullDownMenu.enabled = YES;
    }

    NSString *btnTxt = [_tabBtnsData objectAtIndex:_currentOrderType];
    [self.tabBtn setTitle:btnTxt forState:UIControlStateNormal];
    [self.tabBtn setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    CGSize seriesNameTextSize =[btnTxt sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    CGSize imageSize = [UIImage imageNamed:@"down"].size;
    float labelWidth = seriesNameTextSize.width;
    float imageWith = imageSize.width;
    self.tabBtn.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth, 0, -labelWidth);
    self.tabBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWith-5, 0, imageWith+5);
    [self reloadCurrentTableData:YES];
}
#pragma mark - --------------系统代理----------------------
#pragma mark -UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.isSearchView){
        return [_searchNoteArray count];
    }else{
        return [_orderListArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if(self.isSearchView){
        static NSString *CellIdentifier = @"YYOrderListSearchNoteCell";
        UITableViewCell *noteCell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(noteCell == nil){
            noteCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        UIImageView *flagImg = [noteCell.contentView viewWithTag:10002];
        UIImage *img = [[UIImage imageNamed:@"searchflag_img"] imageWithTintColor:[UIColor colorWithHex:@"919191"] ];
        flagImg.image = img;
        NSArray *obj = [_searchNoteArray objectAtIndex:indexPath.row];
        UILabel *titleLabel = [noteCell.contentView viewWithTag:10001];
        titleLabel.text = [obj objectAtIndex:0];
        if(indexPath.row % 2 == 0){
            noteCell.contentView.backgroundColor = [UIColor whiteColor];
        }else{
            noteCell.contentView.backgroundColor = [UIColor colorWithHex:@"f8f8f8"];
        }
        UIButton *deleteBtn = [noteCell.contentView viewWithTag:10003];
        deleteBtn.alpha = 1000+indexPath.row;
        [deleteBtn addTarget:self action:@selector(deleteSearchNote:) forControlEvents:UIControlEventTouchUpInside];
        cell = noteCell;
    }else{
        static NSString *CellIdentifier = @"YYOrderNormalListCell";
        YYOrderNormalListCell *tempCell =  [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!tempCell){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OrderDetail" bundle:[NSBundle mainBundle]];
            YYCustomCellTableViewController *customCellTableViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYCustomCellTableViewController"];
            tempCell = [customCellTableViewController.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }

        YYOrderListItemModel *orderListItemModel = [_orderListArray objectAtIndex:indexPath.row];
        tempCell.currentOrderListItemModel = orderListItemModel;
        [tempCell updateUI];
        tempCell.delegate = self;
        tempCell.indexPath = indexPath;

        cell = tempCell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.isSearchView){
        return 50;
    }else{
        YYOrderListItemModel *orderListItemModel = [_orderListArray objectAtIndex:indexPath.row];
        if([_orderListArray count] == (indexPath.row+1)){
            return 211;
        }
        return [YYOrderNormalListCell cellHeight:orderListItemModel];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.isSearchView){
        NSArray *obj = [_searchNoteArray objectAtIndex:indexPath.row];
        self.searchFieldStr =  [obj objectAtIndex:0];
        self.searchField.text = self.searchFieldStr;
        _isSearchView = NO;
        [self loadOrderListFromServerByPageIndex:1 endRefreshing:NO];
    }else{
        YYOrderListItemModel *orderListItemModel = [_orderListArray objectAtIndex:indexPath.row];
        [self showOrderDetailViewWithListItemModel:orderListItemModel indexPath:indexPath];
    }
}

#pragma mark -ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return 1;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    if (index == 0) {
        return [self createNormalTableVC];
    } else {
        return [self createCancelTableVC];
    }
}

- (UIViewController *)createNormalTableVC {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OrderDetail" bundle:[NSBundle mainBundle]];
    self.normalOrderListTableVC = [storyboard instantiateViewControllerWithIdentifier:@"YYOrderListTableViewController"];
    self.normalOrderListTableVC.currentOrderType = 0;
    self.normalOrderListTableVC.delegate = self;
    return self.normalOrderListTableVC;
}

- (UIViewController *)createCancelTableVC {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OrderDetail" bundle:[NSBundle mainBundle]];
    self.cancelOrderListTableVC = [storyboard instantiateViewControllerWithIdentifier:@"YYOrderListTableViewController"];
    self.cancelOrderListTableVC.currentOrderType =1;
    self.cancelOrderListTableVC.delegate = self;
    return self.cancelOrderListTableVC;
}
#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(self.tableView.hidden == NO){
        return;
    }
    CGFloat contentOffsetX = scrollView.contentOffset.x;

    if (self.currentOrderType != 0 && contentOffsetX <= SCREEN_WIDTH * 3) {
        contentOffsetX += SCREEN_WIDTH * self.currentOrderType;
    }
}
#pragma mark -UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:_searchField];

}

-(void) textFieldDidBeginEditing:(UITextField *)textField{
    _isSearchView = YES;
    [self reloadTableData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:_searchField];
}

- (void)textFieldDidChange:(NSNotification *)note{
    NSString *toBeString = _searchField.text;
    NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage; // 键盘输入模式
    NSString *str = @"";
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [_searchField markedTextRange];
        //高亮部分
        UITextPosition *position = [_searchField positionFromPosition:selectedRange.start offset:0];
        //已输入的文字进行字数统计和限制
        if (!position) {
            str = toBeString;
        }else{
            return ;
        }
    }
    else{
        str = toBeString;
    }
    if(![str isEqualToString:@""]){
        _searchFieldStr = str;
        _isSearchView = YES;

        _localNoteArray = [NSKeyedUnarchiver unarchiveObjectWithFile:getOrderSearchNoteStorePath()];
        _searchNoteArray = [[NSMutableArray alloc] init];
        for (NSArray *note in _localNoteArray) {
            if([note[0] containsString:str]){
                [_searchNoteArray addObject:note];
            }
        }
        [self reloadTableData];
    }else{
        _searchFieldStr = @"";
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(![_searchFieldStr isEqualToString:@""]){
        _isSearchView = NO;
        [_searchField resignFirstResponder];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self loadOrderListFromServerByPageIndex:1 endRefreshing:NO ];
        return YES;
    }
    return NO;
}
#pragma mark - --------------自定义代理/block----------------------
#pragma mark -YYTableCellDelegate
-(void)btnClick:(NSInteger)row section:(NSInteger)section andParmas:(NSArray *)parmas{
    NSString *type = [parmas objectAtIndex:0];
    NSObject *obj = nil;
    if(self.tableView.hidden){
        obj = [parmas objectAtIndex:1];
    }else{
        obj =[_orderListArray objectAtIndex:row];
    }
    if ([obj isKindOfClass:[YYOrderListItemModel class]]) {
        YYOrderListItemModel *orderListItemModel = (YYOrderListItemModel *)obj;

        if([type isEqualToString:@"paylog"]){

            //添加收款记录
            [self addPaylogRecordWithListItemModel:orderListItemModel];

        }else if([type isEqualToString:@"status"]){

            //协商完毕|已收货|完成发货
            NSIndexPath *indexPath =  [NSIndexPath indexPathForRow:row inSection:section];
            [self updateTransStatusWithListItemModel:orderListItemModel indexPath:indexPath];

        }else if([type isEqualToString:@"delete"]){

            //删除订单
            [self deleteOrderWithListItemModel:orderListItemModel];

        }else if([type isEqualToString:@"reBuildOrder"]){

            //重新建立订单
            [self reBuildOrderWithListItemModel:orderListItemModel];

        }else if([type isEqualToString:@"cancelReqClose"]){

            //撤销申请
            NSIndexPath *indexPath =  [NSIndexPath indexPathForRow:row inSection:section];
            [self cancelReqCloseWithListItemModel:orderListItemModel indexPath:indexPath];

        }else if([type isEqualToString:@"refuseReqClose"]){

            //我方交易继续
            NSIndexPath *indexPath =  [NSIndexPath indexPathForRow:row inSection:section];
            [self refuseReqCloseWithListItemModel:orderListItemModel indexPath:indexPath];

        }else if([type isEqualToString:@"agreeReqClose"]){

            //同意关闭交易
            NSIndexPath *indexPath =  [NSIndexPath indexPathForRow:row inSection:section];
            [self agreeReqCloseWithListItemModel:orderListItemModel indexPath:indexPath];

        }else if ([type isEqualToString:@"modifyOrder"]){

            //修改订单
            NSIndexPath *indexPath =  [NSIndexPath indexPathForRow:row inSection:section];
            [self modifyOrderWithListItemModel:orderListItemModel indexPath:indexPath];

        }else if([type isEqualToString:@"cancelOrder"]){

            //取消订单
            NSIndexPath *indexPath =  [NSIndexPath indexPathForRow:row inSection:section];
            [self cancelOrderWithListItemModel:orderListItemModel indexPath:indexPath];

        }else if([type isEqualToString:@"confirmOrder"]){

            //确认订单
            NSIndexPath *indexPath =  [NSIndexPath indexPathForRow:row inSection:section];
            [self confirmOrderWithListItemModel:orderListItemModel indexPath:indexPath];

        }else if([type isEqualToString:@"refuseOrder"]){

            //拒绝确认订单
            NSIndexPath *indexPath =  [NSIndexPath indexPathForRow:row inSection:section];
            [self refuseOrderWithListItemModel:orderListItemModel indexPath:indexPath];

        }else if([type isEqualToString:@"orderDetail"]){

            //进入订单详情
            NSIndexPath *indexPath =  [NSIndexPath indexPathForRow:row inSection:section];
            [self showOrderDetailViewWithListItemModel:orderListItemModel indexPath:indexPath];

        }else if([type isEqualToString:@"buyerInfo"]){

            //进入买手详情页
            [self showBuyerInfoViewWithListItemModel:orderListItemModel];

        }else if([type isEqualToString:@"delivery"]){

            //发货
            NSIndexPath *indexPath =  [NSIndexPath indexPathForRow:row inSection:section];
            [self deliverWithListItemModel:orderListItemModel WithIndexPath:indexPath];

        }else if([type isEqualToString:@"confirm_delivery"]){

            //确认收货
            NSIndexPath *indexPath =  [NSIndexPath indexPathForRow:row inSection:section];
            [self confirmDeliveryStatusWithListItemModel:orderListItemModel indexPath:indexPath];

        }else if([type isEqualToString:@"delivery_tip"]){
            //请等待对方签收包裹
            [YYToast showToastWithTitle:NSLocalizedString(@"请等待对方签收包裹", nil) andDuration:kAlertToastDuration];
        }
    }
}
#pragma mark -YYTableCellDelegate-Method
//发货
-(void)deliverWithListItemModel:(YYOrderListItemModel *)orderListItemModel WithIndexPath:(NSIndexPath *)indexPath{

    WeakSelf(ws);
    YYPackingListViewController *createPackingListViewController = [[YYPackingListViewController alloc] init];
    createPackingListViewController.orderCode = orderListItemModel.orderCode;
    createPackingListViewController.packageId = orderListItemModel.packageId;
    createPackingListViewController.indexPath = indexPath;
    if(orderListItemModel.packageId){
        createPackingListViewController.packingListType = YYPackingListTypeDetail;
    }else{
        createPackingListViewController.packingListType = YYPackingListTypeCreate;
    }
    [createPackingListViewController setCancelButtonClicked:^{
        [ws.navigationController popViewControllerAnimated:YES];
    }];

    __weak YYPackingListViewController *tmpCreatePackingListViewController = createPackingListViewController;
    [createPackingListViewController setModifySuccess:^{
        [ws.navigationController popViewControllerAnimated:NO];
        //发货成功啦！咱们去对应的订单详情页吧

        [ws showOrderDetailViewWithListItemModel:orderListItemModel indexPath:tmpCreatePackingListViewController.indexPath];
    }];
    [self.navigationController pushViewController:createPackingListViewController animated:YES];

}
//确认订单
-(void)confirmOrderWithListItemModel:(YYOrderListItemModel *)orderListItemModel indexPath:(NSIndexPath *)indexPath{
    NSLog(@"confirmOrder");
    WeakSelf(ws);
    CMAlertView *alertView = [[CMAlertView alloc] initWithTitle:NSLocalizedString(@"确认此订单？", nil) message:NSLocalizedString(@"确认后将无法修改订单，是否确认该订单？",nil) needwarn:NO delegate:nil cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:@[NSLocalizedString(@"确认",nil)]];
    [alertView setAlertViewBlock:^(NSInteger selectedIndex){
        if (selectedIndex == 1) {
            [YYOrderApi confirmOrderByOrderCode:orderListItemModel.orderCode andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
                if(rspStatusAndMessage.status == YYReqStatusCode100){
                    [ws loadOrderListItem:indexPath];
                    [YYToast showToastWithTitle:NSLocalizedString(@"订单已确认", nil) andDuration:kAlertToastDuration];
                }
            }];
        }
    }];
    [alertView show];
}
//拒绝确认订单
-(void)refuseOrderWithListItemModel:(YYOrderListItemModel *)orderListItemModel indexPath:(NSIndexPath *)indexPath{
    NSLog(@"refuseOrder");
    WeakSelf(ws);
    CMAlertView *alertView = [[CMAlertView alloc] initRefuseOrderReasonWithTitle:NSLocalizedString(@"请填写拒绝原因", nil) message:nil otherButtonTitles:@[NSLocalizedString(@"提交",nil)]];
    [alertView setAlertViewSubmitBlock:^(NSString *reson) {
        NSLog(@"准备提交");
        [YYOrderApi refuseOrderByOrderCode:orderListItemModel.orderCode reason:reson andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
            if(rspStatusAndMessage.status == YYReqStatusCode100){
                [ws loadOrderListItem:indexPath];
                [YYToast showToastWithTitle:NSLocalizedString(@"已提交", nil) andDuration:kAlertToastDuration];
            }
        }];
    }];
    [alertView show];
}
//添加收款记录
-(void)addPaylogRecordWithListItemModel:(YYOrderListItemModel *)orderListItemModel{
    WeakSelf(ws);
    if([orderListItemModel.payNote floatValue] != 100.f){

        BOOL isNeedRefund = NO;
        if([orderListItemModel.payNote floatValue] > 100.f){
            isNeedRefund = YES;
        }
        
        self.detailViewBackFlag = YES;
        [[YYYellowPanelManage instance] showOrderAddMoneyLogPanel:@"Order" andIdentifier:@"YYOrderAddMoneyLogController" orderCode:orderListItemModel.orderCode totalMoney:[orderListItemModel.finalTotalPrice doubleValue] moneyType:[orderListItemModel.curType integerValue] isNeedRefund:isNeedRefund parentView:self andCallBack:^(NSString *orderCode, NSNumber *totalPercent) {

            orderListItemModel.payNote = totalPercent;
            if(ws.tableView.hidden){
                [ws reloadCurrentTableData:NO];
            }else{
                [ws.tableView reloadData];
            }

        }];
    }
}
//协商完毕|已发货|已收货
-(void)updateTransStatusWithListItemModel:(YYOrderListItemModel *)orderListItemModel indexPath:(NSIndexPath *)indexPath{
    WeakSelf(ws);
    NSInteger tranStatus = getOrderTransStatus(orderListItemModel.designerTransStatus, orderListItemModel.buyerTransStatus);
    NSInteger nextTransStatus = getOrderNextStatus(tranStatus,[orderListItemModel.connectStatus integerValue]);
    NSString *oprateStr = getOrderStatusBtnName(nextTransStatus,[orderListItemModel.connectStatus integerValue]);
    NSString *alertStr = getOrderStatusAlertTip(nextTransStatus);
    NSArray *alertInfo = [alertStr componentsSeparatedByString:@"|"];
    NSString *title = [alertInfo objectAtIndex:0];
    NSString *message = (([alertInfo count]> 1)?[alertInfo objectAtIndex:1]:nil);

    if(!message){
        message = title;
        title = nil;
    }
    self.detailViewBackFlag = YES;

    CMAlertView *alertView = [[CMAlertView alloc] initWithTitle:title message:message needwarn:NO delegate:nil cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:@[[NSString stringWithFormat:@"%@|000000",oprateStr]]];
    [alertView setAlertViewBlock:^(NSInteger selectedIndex){
        if (selectedIndex == 1) {
            [YYOrderApi updateTransStatus:orderListItemModel.orderCode statusCode:nextTransStatus force:NO andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
                if(rspStatusAndMessage.status == YYReqStatusCode100){
                    [ws loadOrderListItem:indexPath];
                }
            }];
        }
    }];
    [alertView show];
}
//确认收货
-(void)confirmDeliveryStatusWithListItemModel:(YYOrderListItemModel *)orderListItemModel indexPath:(NSIndexPath *)indexPath{

    WeakSelf(ws);

    self.detailViewBackFlag = YES;

    NSString *oprateStr = getOrderStatusBtnName(YYOrderCode_RECEIVED,[orderListItemModel.connectStatus integerValue]);

    CMAlertView *alertView = [[CMAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"%@吗？",nil),oprateStr] message:nil needwarn:NO delegate:nil cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:@[[NSString stringWithFormat:@"%@|000000",oprateStr]]];
    [alertView setAlertViewBlock:^(NSInteger selectedIndex){
        if (selectedIndex == 1) {
            [YYOrderApi designerConfirmReceiveOrderByOrderCode:orderListItemModel.orderCode andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
                if(rspStatusAndMessage.status == YYReqStatusCode100){
                    [ws loadOrderListItem:indexPath];
                }else{
                    [YYToast showToastWithView:ws.view title:rspStatusAndMessage.message andDuration:kAlertToastDuration];
                }
            }];
        }
    }];
    [alertView show];
}
//删除订单
-(void)deleteOrderWithListItemModel:(YYOrderListItemModel *)orderListItemModel{
    WeakSelf(ws);
    CMAlertView *alertView = [[CMAlertView alloc] initWithTitle:NSLocalizedString(@"确定要删除订单吗？",nil) message:nil needwarn:NO delegate:nil cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:@[NSLocalizedString(@"删除订单",nil)]];
    [alertView setAlertViewBlock:^(NSInteger selectedIndex){
        if (selectedIndex == 1) {
            [YYOrderApi updateOrderWithOrderCode:orderListItemModel.orderCode opType:3 andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
                if (rspStatusAndMessage.status == YYReqStatusCode100) {
                    [YYToast showToastWithTitle:NSLocalizedString(@"删除订单成功",nil) andDuration:kAlertToastDuration];
                    if(ws.tableView.hidden){
                        [ws reloadCurrentTableData:YES];
                    }else{
                        [ws loadOrderListFromServerByPageIndex:1 endRefreshing:NO];
                    }
                }
            }];
        }
    }];
    [alertView show];
}
//重新建立订单
-(void)reBuildOrderWithListItemModel:(YYOrderListItemModel *)orderListItemModel{
    [YYOrderApi getOrderByOrderCode:orderListItemModel.orderCode isForReBuildOrder:YES andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYOrderInfoModel *orderInfoModel, NSError *error) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (rspStatusAndMessage.status == YYReqStatusCode100) {
            orderInfoModel.orderCode = nil;
            orderInfoModel.billCreatePersonName = nil;
            orderInfoModel.billCreatePersonId = nil;
            orderInfoModel.billCreatePersonType = nil;
            orderInfoModel.occasion = nil;
            orderInfoModel.designerOrderStatus = [[NSNumber alloc] initWithInt:YYOrderCode_NEGOTIATION];
            orderInfoModel.buyerOrderStatus = [[NSNumber alloc] initWithInt:YYOrderCode_NEGOTIATION];
            orderInfoModel.orderConnStatus = @(YYOrderConnStatusUnconfirmed);
            orderInfoModel.orderCreateTime = nil;
            [appDelegate showBuildOrderViewController:orderInfoModel parent:self isCreatOrder:YES isReBuildOrder:YES isAppendOrder:NO isFromCardDetail:YES modifySuccess:^(){
                [[NSNotificationCenter defaultCenter] postNotificationName:kShowOrderListNotification object:nil];
            }];
        }else{
            [YYToast showToastWithView:appDelegate.mainViewController.view title:rspStatusAndMessage.message andDuration:kAlertToastDuration];
        }
    }];
}
//撤销申请
-(void)cancelReqCloseWithListItemModel:(YYOrderListItemModel *)orderListItemModel indexPath:(NSIndexPath *)indexPath{
    WeakSelf(ws);
    self.detailViewBackFlag = YES;
    CMAlertView *alertView = [[CMAlertView alloc] initWithTitle:NSLocalizedString(@"是否确认撤销“取消订单”申请？",nil) message:nil needwarn:NO delegate:nil cancelButtonTitle:NSLocalizedString(@"否",nil) otherButtonTitles:@[NSLocalizedString(@"是",nil)]];
    [alertView setAlertViewBlock:^(NSInteger selectedIndex){
        if (selectedIndex == 1) {
            [YYOrderApi revokeOrderCloseRequest:orderListItemModel.orderCode andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
                if(rspStatusAndMessage.status == YYReqStatusCode100){
                    [ws loadOrderListItem:indexPath];
                }
                [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
            }];
        }
    }];
    [alertView show];
}
//我方交易继续
-(void)refuseReqCloseWithListItemModel:(YYOrderListItemModel *)orderListItemModel indexPath:(NSIndexPath *)indexPath{
    WeakSelf(ws);
    self.detailViewBackFlag = YES;
    CMAlertView *alertView = [[CMAlertView alloc] initWithTitle:NSLocalizedString(@"确认拒绝已取消申请",nil) message:nil needwarn:NO delegate:nil cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:@[NSLocalizedString(@"确认",nil)]];
    [alertView setAlertViewBlock:^(NSInteger selectedIndex){
        if (selectedIndex == 1) {
            [YYOrderApi dealOrderCloseRequest:orderListItemModel.orderCode isAgree:@"false" andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
                if(rspStatusAndMessage.status == YYReqStatusCode100){
                    [ws loadOrderListItem:indexPath];
                }
                [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
            }];
        }
    }];
    [alertView show];
}
//同意关闭交易
-(void)agreeReqCloseWithListItemModel:(YYOrderListItemModel *)orderListItemModel indexPath:(NSIndexPath *)indexPath{
    WeakSelf(ws);
    self.detailViewBackFlag = YES;
    CMAlertView *alertView = [[CMAlertView alloc] initWithTitle: NSLocalizedString(@"确认同意已取消申请" ,nil) message:nil needwarn:NO delegate:nil cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:@[NSLocalizedString(@"确认",nil)]];
    [alertView setAlertViewBlock:^(NSInteger selectedIndex){
        if (selectedIndex == 1) {
            [YYOrderApi dealOrderCloseRequest:orderListItemModel.orderCode isAgree:@"true" andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
                if(rspStatusAndMessage.status == YYReqStatusCode100){
                    [ws loadOrderListItem:indexPath];
                }
                [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
            }];
        }
    }];
    [alertView show];
}

//修改订单
-(void)modifyOrderWithListItemModel:(YYOrderListItemModel *)orderListItemModel indexPath:(NSIndexPath *)indexPath{
    WeakSelf(ws);
    self.detailViewBackFlag = YES;
    [YYOrderApi getOrderByOrderCode:orderListItemModel.orderCode isForReBuildOrder:NO andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYOrderInfoModel *orderInfoModel, NSError *error) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (rspStatusAndMessage.status == YYReqStatusCode100) {
            orderInfoModel.orderConnStatus = orderListItemModel.connectStatus;
            [appDelegate showBuildOrderViewController:orderInfoModel parent:self isCreatOrder:NO isReBuildOrder:NO isAppendOrder:NO isFromCardDetail:YES modifySuccess:^(){
                [ws loadOrderListItem:indexPath];
            }];
        }else{
            [YYToast showToastWithView:appDelegate.mainViewController.view title:rspStatusAndMessage.message andDuration:kAlertToastDuration];
        }
    }];
}
//取消订单
-(void)cancelOrderWithListItemModel:(YYOrderListItemModel *)orderListItemModel indexPath:(NSIndexPath *)indexPath{
    WeakSelf(ws);
    CMAlertView *alertView =nil;
    if([orderListItemModel.isAppend integerValue] == 1){
        alertView = [[CMAlertView alloc] initWithTitle:NSLocalizedString(@"取消此订单？",nil) message:NSLocalizedString(@"这是一个追单订单，操作取消订单后，该追单与原始订单解除绑定。",nil) needwarn:NO delegate:nil cancelButtonTitle:NSLocalizedString(@"保留订单",nil) otherButtonTitles:@[NSLocalizedString(@"取消订单_short",nil)]];

    }else{
        alertView = [[CMAlertView alloc] initWithTitle:NSLocalizedString(@"取消此订单？",nil) message:NSLocalizedString(@"订单取消后，可在“已取消”的订单中找到该订单",nil) needwarn:NO delegate:nil cancelButtonTitle:NSLocalizedString(@"保留订单",nil) otherButtonTitles:@[NSLocalizedString(@"取消订单_short",nil)]];
    }
    [alertView setAlertViewBlock:^(NSInteger selectedIndex){
        if (selectedIndex == 1) {

            [YYOrderApi updateOrderWithOrderCode:orderListItemModel.orderCode opType:1 andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
                if(rspStatusAndMessage.status == YYReqStatusCode100){
                    [ws loadOrderListItem:indexPath];
                    [YYToast showToastWithView:ws.view title:NSLocalizedString(@"取消订单成功",nil)  andDuration:kAlertToastDuration];
                }
            }];
        }
    }];

    [alertView show];
}
//进入订单详情
-(void)showOrderDetailViewWithListItemModel:(YYOrderListItemModel *)orderListItemModel indexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OrderDetail" bundle:[NSBundle mainBundle]];
    YYOrderDetailViewController *orderDetailViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYOrderDetailViewController"];
    NSString *orderCode = orderListItemModel.orderCode;
    orderDetailViewController.currentOrderCode = orderCode;
    orderDetailViewController.currentOrderLogo = orderListItemModel.brandLogo;
    orderDetailViewController.currentOrderConnStatus = [orderListItemModel.connectStatus integerValue];
    WeakSelf(ws);
    __block NSIndexPath *blockindexPath = indexPath;
    [orderDetailViewController setCancelButtonClicked:^(){
        ws.detailViewBackFlag = YES;
        [ws loadOrderListItem:blockindexPath];
    }];
    [self.navigationController pushViewController:orderDetailViewController animated:YES];

}
//进入买手详情页
-(void)showBuyerInfoViewWithListItemModel:(YYOrderListItemModel*)orderListItemModel{
    if([orderListItemModel.buyerId integerValue]){

        WeakSelf(ws);
        AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appdelegate showBuyerInfoViewController:orderListItemModel.buyerId WithBuyerName:orderListItemModel.buyerName parentViewController:self WithReqSuccessBlock:^{
            ws.detailViewBackFlag = YES;//让他回来不要reload
        } WithHomePageCancelBlock:^{
            [ws.navigationController popViewControllerAnimated:YES];
        } WithModifySuccessBlock:nil];

    }
}
#pragma mark -TitlePagerViewDelegate
- (void)didTouchBWTitle:(NSUInteger)index {

    if (self.currentOrderType == index) {
        return;
    }
    self.currentIndex = index;
    [self reloadCurrentTableData:YES];
}
#pragma mark - --------------自定义响应----------------------
-(void)showMenuUI:(id)sender{
    UIViewController *parent = [UIApplication sharedApplication].keyWindow.rootViewController;
    NSInteger menuUIWidth = 134;
    NSInteger menuUIHeight = 400;
    CGPoint p = [_pullDownMenu convertPoint:CGPointMake(0, 0) toView:parent.view];
    WeakSelf(ws);

    [YYMenuPopView addPellTableViewSelectWithWindowFrame:CGRectMake(SCREEN_WIDTH-menuUIWidth-12, p.y+CGRectGetHeight(_pullDownMenu.frame), menuUIWidth, menuUIHeight) selectData:_menuBtnsData images:_menuBtnsIconData action:^(NSInteger index) {
        if(index > -1)
            [ws menuBtnHandler:index+1];
    } animated:YES arrowImage:YES  arrowPositionInfo:nil];
}


- (IBAction)showTabUI:(id)sender {
    UIViewController *parent = [UIApplication sharedApplication].keyWindow.rootViewController;
    NSInteger menuUIWidth = 142;
    NSInteger menuUIHeight = 95;
    CGPoint p = [_tabBtn convertPoint:CGPointMake(0, 0) toView:parent.view];
    WeakSelf(ws);
    _curentOrderStatus = @"-1";
    _currentPayType = -1;
    _searchFieldStr = @"";

    [self.tabBtn setImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];

    [YYMenuPopView addPellTableViewSelectWithWindowFrame:CGRectMake( p.x + (CGRectGetWidth(_tabBtn.frame)-menuUIWidth)/2, p.y+CGRectGetHeight(_tabBtn.frame), menuUIWidth, menuUIHeight) selectData:_tabBtnsData images:@[@"",@"",@""] action:^(NSInteger index) {
        if(index > -1){
            ws.currentIndex = index;
        }else{
            [ws.tabBtn setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];

        }
    } animated:YES arrowImage:YES arrowPositionInfo:@[@(menuUIWidth/2)]];
}
- (IBAction)showSearchView:(id)sender {
    if (_searchView.hidden == YES) {
        _searchView.hidden = NO;
        _searchField.text = nil;
        _searchFieldStr = @"";
        _curentOrderStatus = @"-1";
        _currentPayType = -1;
        _searchView.alpha = 0.0;
        //_searchView.transform = CGAffineTransformMakeScale(1.00f, 0.01f);
        _searchViewTopLayoutConstraint.constant = -44;
        [_searchView layoutIfNeeded];
        self.tableView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _searchView.alpha = 1.0;
            //_searchView.transform = CGAffineTransformMakeScale(1.00f, 1.00f);
            _searchViewTopLayoutConstraint.constant = 0;
            [_searchView layoutIfNeeded];
        } completion:^(BOOL finished) {
            [_searchField becomeFirstResponder];
            self.isSearchView = YES;
            self.tableView.hidden = NO;
            self.noDataView.hidden = YES;
            _searchNoteArray = [NSKeyedUnarchiver unarchiveObjectWithFile:getOrderSearchNoteStorePath()];
            [self.tableView reloadData];
        }];
    }
}
- (IBAction)hideSearchView:(id)sender {
    if ( _searchView.hidden == NO) {
        _searchFieldStr = @"";
        _searchView.alpha = 1.0;
        _searchViewTopLayoutConstraint.constant = 0;
        [_searchView layoutIfNeeded];
        [UIView animateWithDuration:0.3 animations:^{
            //_searchView.transform = CGAffineTransformMakeScale(1.00f, 0.01f);
            _searchViewTopLayoutConstraint.constant = -44;
            _searchView.alpha = 0.0;
            [_searchView layoutIfNeeded];
        } completion:^(BOOL finished) {
            _searchView.hidden = YES;
            [_searchField resignFirstResponder];
            self.isSearchView = NO;
            self.searchNoteArray = nil;
            self.tableView.hidden = YES;
            [self.orderListArray removeAllObjects];
            self.noDataView.hidden = YES;
            //[self loadOrderListFromServerByPageIndex:1 endRefreshing:NO ];
        }];
    }
}
- (void)messageButtonClicked:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate showMessageView:nil parentViewController:self];
}
- (void)messageCountChanged:(NSNotification *)notification{

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.messageUnreadModel setUnreadMessageAmount:_messageButton];
    
}

#pragma mark - --------------自定义方法----------------------
-(void)menuBtnHandler:(NSInteger)index{
    NSInteger type = index;
    _curentOrderStatus = @"-1";
    _currentPayType = -1;
    if(type == 1){//
        _curentOrderStatus = @"-1";
    }else if(type == 2){
        _curentOrderStatus = @"4";
    }else if(type == 3){
        _curentOrderStatus = @"5,6";
    }else if(type == 4){
        _curentOrderStatus = @"7";
    }else if(type == 5){
        _curentOrderStatus = @"15";
    }else if(type == 6){
        _curentOrderStatus = @"8";
    }else if(type == 7){
        _curentOrderStatus = @"9";
    }else if(type == 8){
        _currentPayType = 0;
    }else if(type == 9){
        _currentPayType = 1;
    }
    UIImage *iconImage = nil;
    if(type != 1){
        iconImage = [[UIImage imageNamed:@"filter_icon"] imageWithTintColor:[UIColor colorWithHex:@"ed6498"]];
        [_pullDownMenu setImage:iconImage forState:UIControlStateNormal];
    }else{
        iconImage = [UIImage imageNamed:@"filter_icon"];
        [_pullDownMenu setImage:iconImage forState:UIControlStateNormal];

    }
    [self reloadCurrentTableData:YES];
}
-(void)addSearchNote{
    if(![NSString isNilOrEmpty:self.searchFieldStr]){
        if(self.localNoteArray ==nil){
            self.localNoteArray = [[NSMutableArray alloc] init];
        }

        BOOL isContains = YES;
        for (NSArray *note in self.localNoteArray) {
            if([note[0] isEqualToString:self.searchFieldStr]){
                isContains = NO;
                break;
            }
        }
        if(isContains){
            if([self.localNoteArray count] > 20){
                [self.localNoteArray removeObjectAtIndex:0];
            }
            [self.localNoteArray addObject:@[self.searchFieldStr,@"ordercode"]];
        }

        BOOL iskeyedarchiver= [NSKeyedArchiver archiveRootObject:self.localNoteArray toFile:getOrderSearchNoteStorePath()];
        if(iskeyedarchiver){
            NSLog(@"archive success ");
        }
    }
}

-(void)deleteSearchNote:(id)sender{
    UIButton *btn = sender;
    NSInteger row = btn.alpha - 1000;
    NSString *date = [[_searchNoteArray objectAtIndex:row] objectAtIndex:0];
    for (NSArray *note in self.localNoteArray) {
        if([note[0] isEqualToString:date]){
            [self.localNoteArray removeObject:note];
            break;
        }
    }
    BOOL iskeyedarchiver= [NSKeyedArchiver archiveRootObject:self.localNoteArray toFile:getOrderSearchNoteStorePath()];
    if(iskeyedarchiver){
        NSLog(@"archive success ");
        [_searchNoteArray removeObjectAtIndex:row];
        [self.tableView reloadData];
    }
}
-(void)changeTabIndex:(NSInteger)index{
    if(_currentOrderType != index){
        self.currentIndex = index;
        [self reloadCurrentTableData:YES];
    }
}

-(void)reloadCurrentTableData:(BOOL)newData{
    YYOrderListTableViewController *tableViewController = (YYOrderListTableViewController *)[self viewControllerAtIndex:0];
    if(tableViewController != nil){
        tableViewController.currentOrderType = (int)_currentOrderType;
        tableViewController.curentOrderStatus= _curentOrderStatus;
        tableViewController.currentPayType=_currentPayType;
        [tableViewController relaodTableData:newData];
    }
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
-(void)reloadTableData{
    if(self.isSearchView){
        self.noDataView.hidden = YES;
    }else{
        if ([self.orderListArray count] <= 0) {
            self.noDataView.hidden = NO;
        }else{
            self.noDataView.hidden = YES;
        }
    }
    [self.tableView reloadData];

}


#pragma mark - --------------other----------------------


@end
