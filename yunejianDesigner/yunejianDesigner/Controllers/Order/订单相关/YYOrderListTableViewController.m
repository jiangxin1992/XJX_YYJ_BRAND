//
//  YYOrderListTableViewController.m
//  YunejianBuyer
//
//  Created by Apple on 16/5/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYOrderListTableViewController.h"

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "YYCustomCellTableViewController.h"

// 自定义视图
#import "YYNoDataView.h"
#import "MBProgressHUD.h"
#import "YYOrderNormalListCell.h"

// 接口
#import "YYOrderApi.h"

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import <MJRefresh.h>

#import "YYUser.h"
#import "YYOrderListModel.h"

#import "AppDelegate.h"

#define kOrderPageSize 5

@interface YYOrderListTableViewController ()<UITableViewDataSource,UITableViewDelegate,YYTableCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopLayer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomLayer;

@property (nonatomic,strong)YYPageInfoModel *currentPageInfo;
@property (strong, nonatomic)NSMutableArray *orderListArray;
@property (strong, nonatomic)NSMutableArray *localNoteArray;
@property (nonatomic,copy) NSString *searchFieldStr;

@property (nonatomic,strong) YYNoDataView *noDataView;

@end

@implementation YYOrderListTableViewController
#pragma mark - --------------生命周期--------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self RequestData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 进入埋点
    [MobClick beginLogPageView:kYYPageOrderListTable];
    if(!self.noDataView.hidden){
        [self headerWithRefreshingAction];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageOrderListTable];
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
    _curentOrderStatus = @"-1";
    _currentPayType = -1;
    _searchFieldStr = @"";
    self.orderListArray = [[NSMutableArray alloc] initWithCapacity:0];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate checkNoticeCount];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveAction) name:kApplicationDidBecomeActive object:nil];
}
- (void)PrepareUI{
    if([YYUser isShowroomToBrand]) {
        _tableViewTopLayer.constant = kStatusBarAndNavigationBarHeight;
        _tableViewBottomLayer.constant = kTabbarHeight;
    }else {
        _tableViewTopLayer.constant = 45;
        _tableViewBottomLayer.constant = 0;
    }

    if(_currentOrderType == 0){
        self.noDataView = (YYNoDataView *)addNoDataView_phone(self.view,[NSString stringWithFormat:@"%@|icon:noorder_icon",NSLocalizedString(@"还没有订单/n您可以在作品中，将款式加入到购物车中，建立订单。",nil) ],nil,nil);
    }else if (_currentOrderType == 1){
        self.noDataView = (YYNoDataView *)addNoDataView_phone(self.view,[NSString stringWithFormat:@"%@|icon:noorder_icon",NSLocalizedString(@"暂无取消订单",nil)],nil,nil);
    }
    _noDataView.hidden = YES;

    [self addHeader];
    [self addFooter];
}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{}

#pragma mark - --------------请求数据----------------------
-(void)RequestData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadOrderListFromServerByPageIndex:1 endRefreshing:NO];
}
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

                                       if(blockEndrefreshing){
                                           [self.tableView.mj_header endRefreshing];
                                           [self.tableView.mj_footer endRefreshing];
                                       }
                                       [ws reloadTableData];

                                       [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];
                                   }];
}
-(void)reloadListItem:(NSInteger)row{
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
#pragma mark - --------------系统代理----------------------
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_orderListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;

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

    return cell;
}

#pragma mark -UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYOrderListItemModel *orderListItemModel = [_orderListArray objectAtIndex:indexPath.row];
    if([_orderListArray count] == (indexPath.row+1)){
        return 211;
    }
    return [YYOrderNormalListCell cellHeight:orderListItemModel];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSObject *obj = [_orderListArray objectAtIndex:indexPath.row];
    if(self.delegate && obj){
        [self.delegate btnClick:indexPath.row section:indexPath.section andParmas:@[@"orderDetail",obj]];
    }
}

#pragma mark - --------------自定义代理/block----------------------
#pragma mark -YYTableCellDelegate
-(void)btnClick:(NSInteger)row section:(NSInteger)section andParmas:(NSArray *)parmas{
    NSObject *obj = [_orderListArray objectAtIndex:row];
    NSString *type = [parmas objectAtIndex:0];

    if(self.delegate && obj && type){
        [self.delegate btnClick:row section:section andParmas:@[type,obj]];
    }
}

#pragma mark - --------------自定义响应----------------------
-(void)applicationDidBecomeActiveAction{
    if(!self.noDataView.hidden){
        YYUser *user = [YYUser currentUser];

        if(!((user.userType == YYUserTypeShowroom || user.userType == YYUserTypeShowroomSub)&&![YYUser isShowroomToBrand])){
            [self headerWithRefreshingAction];
        }else{
            NSLog(@"showroom主页");
        }
    }
}

#pragma mark - --------------自定义方法----------------------
-(void)headerWithRefreshingAction{
    if (![YYCurrentNetworkSpace isNetwork]) {
        [YYToast showToastWithTitle:kNetworkIsOfflineTips andDuration:kAlertToastDuration];
        [self.tableView.mj_header endRefreshing];
        return;
    }else{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate checkNoticeCount];
    }
    [self loadOrderListFromServerByPageIndex:1 endRefreshing:YES];
}
-(void)relaodTableData:(BOOL)newData{
    if(self.currentPageInfo != nil){
        if(newData){
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self loadOrderListFromServerByPageIndex:1 endRefreshing:NO];
        }else{
            [self.tableView reloadData];
        }
    }
}
-(void)reloadTableData{
    if ([self.orderListArray count] <= 0) {
        if(_currentOrderType == 0){
            self.noDataView.titleLabel.text = NSLocalizedString(@"还没有订单",nil);
            self.noDataView.tipLabel.text = NSLocalizedString(@"您可以在作品中，将款式加入到购物车中，建立订单。",nil);
        }else if (_currentOrderType == 1){
            self.noDataView.titleLabel.text = NSLocalizedString(@"暂无取消订单",nil);
            self.noDataView.tipLabel.text = @"";
        }
        self.noDataView.hidden = NO;
    }else{
        self.noDataView.hidden = YES;
    }

    [self.tableView reloadData];
}

- (void)addHeader
{
    WeakSelf(ws);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws headerWithRefreshingAction];
    }];
    self.tableView.mj_header = header;
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
}
- (void)addFooter{
    WeakSelf(ws);
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (![YYCurrentNetworkSpace isNetwork]) {
            [YYToast showToastWithTitle:kNetworkIsOfflineTips andDuration:kAlertToastDuration];
            [ws.tableView.mj_footer endRefreshing];
            return;
        }
        if (!ws.currentPageInfo.isLastPage) {
            [ws loadOrderListFromServerByPageIndex:[ws.currentPageInfo.pageIndex intValue]+1 endRefreshing:YES];
        }else{
            //弹出提示
            [ws.tableView.mj_footer endRefreshing];
        }
    }];
}
#pragma mark - --------------other----------------------

@end
