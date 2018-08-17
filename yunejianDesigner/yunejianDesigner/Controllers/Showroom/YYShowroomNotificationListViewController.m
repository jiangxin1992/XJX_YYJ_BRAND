//
//  YYShowroomNotificationListViewController.m
//  yunejianDesigner
//
//  Created by yyj on 2018/3/8.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "YYShowroomNotificationListViewController.h"

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "YYShowroomOrderingCheckViewController.h"

// 自定义视图
#import "YYNavView.h"
#import "MBProgressHUD.h"
#import "YYShowroomNotificationListCell.h"
#import "YYNoDataView.h"

// 接口
#import "YYShowroomApi.h"

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import <MJRefresh.h>

#import "YYShowroomOrderingListModel.h"

@interface YYShowroomNotificationListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YYPageInfoModel *currentPageInfo;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) YYNavView *navView;
@property (nonatomic, strong) YYNoDataView *noDataView;
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) YYShowroomOrderingListModel *showroomOrderingListModel;

@end

@implementation YYShowroomNotificationListViewController
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
- (void)PrepareData{
    self.dataArray = [[NSMutableArray alloc] init];
}
- (void)PrepareUI{

    self.view.backgroundColor = [UIColor colorWithHex:@"f8f8f8"];

    _navView = [[YYNavView alloc] initWithTitle:NSLocalizedString(@"订货会列表",nil) WithSuperView:self.view haveStatusView:YES];

    UIButton *backBtn = [UIButton getCustomImgBtnWithImageStr:@"goBack_normal" WithSelectedImageStr:nil];
    [_navView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(GoBack:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.width.mas_equalTo(40);
        make.bottom.mas_equalTo(-1);
    }];

    _containerView = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"f8f8f8"]];
    [self.view addSubview:_containerView];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(_navView.mas_bottom).with.offset(0);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop).with.offset(0);
    }];
}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{
    [self CreateTableView];
    [self CreateNoDataView];
}
-(void)CreateTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_containerView addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_containerView);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithHex:@"f8f8f8"];
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0,0,0,15)];

    [self addHeader];
    [self addFooter];
}
-(void)CreateNoDataView{
    _noDataView = (YYNoDataView *)addNoDataView_phone(_containerView,[NSString stringWithFormat:@"%@|icon:notxt_icon",NSLocalizedString(@"暂无被指定的订货会/n请微信搜索“yunejianhelper”或扫码联系小助手发布订货会。", nil)],@"000000",@"weixincode_img");
    [_containerView addSubview:_noDataView];
    [_noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_navView.mas_bottom).with.offset(0);
        make.width.mas_equalTo(self.view);
        make.centerX.mas_equalTo(self.view);
    }];
    _noDataView.hidden = YES;

}
- (void)addHeader{
    WeakSelf(ws);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (![YYCurrentNetworkSpace isNetwork]) {
            [YYToast showToastWithTitle:kNetworkIsOfflineTips andDuration:kAlertToastDuration];
            [ws.tableView.mj_header endRefreshing];
            return;
        }
        [ws loadListFromServerByPageIndex:1 endRefreshing:YES];
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
            [ws loadListFromServerByPageIndex:[ws.currentPageInfo.pageIndex intValue]+1 endRefreshing:YES];
        }else{
            //弹出提示
            [ws.tableView.mj_footer endRefreshing];
        }
    }];
}
#pragma mark - --------------请求数据----------------------
-(void)RequestData{
    //清空订货会消息红点
    [self clearOrderingMsg];

    //获取列表数据
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_tableView.mj_header beginRefreshing];
}
-(void)clearOrderingMsg{
    //清空订货会消息红点
    if(_hasOrderingMsg){
        [YYShowroomApi clearOrderingMsgWithBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
            
        }];
    }
}
- (void)loadListFromServerByPageIndex:(int)pageIndex endRefreshing:(BOOL)endrefreshing{
    WeakSelf(ws);

    __block BOOL blockEndrefreshing = endrefreshing;
    [YYShowroomApi getOrderingListWithPageIndex:pageIndex pageSize:kPageSize andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYShowroomOrderingListModel *showroomOrderingListModel, NSError *error) {
        if (rspStatusAndMessage.status == YYReqStatusCode100) {
            if (pageIndex == 1) {
                [ws.dataArray removeAllObjects];
            }
            ws.currentPageInfo = showroomOrderingListModel.pageInfo;

            if (showroomOrderingListModel && showroomOrderingListModel.result
                && [showroomOrderingListModel.result count] > 0){
                [ws.dataArray addObjectsFromArray:showroomOrderingListModel.result];
            }
            //如果没有数据
            if (pageIndex == 1 && _noDataView) {
                if(ws.dataArray.count){
                    self.noDataView.hidden = YES;
                    self.view.backgroundColor = [UIColor colorWithHex:@"f8f8f8"];
                    self.tableView.backgroundColor = [UIColor colorWithHex:@"f8f8f8"];
                    self.containerView.backgroundColor = [UIColor colorWithHex:@"f8f8f8"];
                }else{
                    self.noDataView.hidden = NO;
                    self.view.backgroundColor = _define_white_color;
                    self.tableView.backgroundColor = _define_white_color;
                    self.containerView.backgroundColor = _define_white_color;
                }
            }
        }

        if(blockEndrefreshing){
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        [ws.tableView reloadData];

        [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];
    }];
}

#pragma mark - --------------系统代理----------------------
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    数据还未获取时候
    if(!_dataArray.count)
    {
        static NSString *cellid=@"null_data_cell";
        UITableViewCell *cell=[_tableView dequeueReusableCellWithIdentifier:cellid];
        if(!cell)
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }

    WeakSelf(ws);
    static NSString *cellid=@"YYShowroomNotificationListCell";
    YYShowroomNotificationListCell *cell=[_tableView dequeueReusableCellWithIdentifier:cellid];
    if(!cell)
    {
        cell=[[YYShowroomNotificationListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid WithBlock:^(NSString *type,NSNumber *orderingID) {
            if([type isEqualToString:@"enter_ordering_detail"]){
                //点击此区域进入订货会详情页
                [ws enterOrderingDetailView:orderingID];
            }else if([type isEqualToString:@"enter_ordering_checkview"]){
                //点击此区域进入审核页
                [ws enterOrderingCheckView:orderingID];
            }
        }];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.logisticsModel = _dataArray[indexPath.row];
    return cell;
}
#pragma mark -UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 144;
}

#pragma mark - --------------自定义代理/block----------------------


#pragma mark - --------------自定义响应----------------------
-(void)GoBack:(id)sender {
    if(_cancelButtonClicked)
    {
        _cancelButtonClicked();
    }
}

#pragma mark - --------------自定义方法----------------------
//点击此区域进入审核页
-(void)enterOrderingCheckView:(NSNumber *)orderingID{
    WeakSelf(ws);
    YYShowroomOrderingCheckViewController *showroomOrderingCheckViewController = [[YYShowroomOrderingCheckViewController alloc] init];
    [showroomOrderingCheckViewController setCancelButtonClicked:^(){
        [ws.navigationController popViewControllerAnimated:YES];
    }];
    [showroomOrderingCheckViewController setBlock:^(NSString *type, NSNumber *appointmentId) {
        if([type isEqualToString:@"user_operation"]){
            [ws userOperation:appointmentId];
        }
    }];
    showroomOrderingCheckViewController.appointmentId = orderingID;
    [self.navigationController pushViewController:showroomOrderingCheckViewController animated:YES];
}
-(void)userOperation:(NSNumber *)appointmentId{
    if(_dataArray){
        for (YYShowroomOrderingModel *showroomOrderingModel in _dataArray) {
            if([showroomOrderingModel.id integerValue] == [appointmentId integerValue]){
                NSInteger peopleToBeVerified = [showroomOrderingModel.peopleToBeVerified integerValue];
                if(peopleToBeVerified){
                    peopleToBeVerified--;
                    showroomOrderingModel.peopleToBeVerified = @(peopleToBeVerified);
                    [_tableView reloadData];
                }
            }
        }
    }
}
//点击此区域进入订货会详情页
-(void)enterOrderingDetailView:(NSNumber *)orderingID{
    NSString *weburl = [self getOrderingWebUrl:orderingID];
    if(weburl){
        clickWebUrl_phone(weburl);
    }
}
-(NSString *)getOrderingWebUrl:(NSNumber *)orderingID{
    NSString *weburl = nil;
    NSString *_kLastYYServerURL = [[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL];
    //字条串是否包含有某字符串
    if ([_kLastYYServerURL containsString:@"show.ycofoundation.com"]) {
        //展示
        weburl = [[NSString alloc] initWithFormat:@"http://mshow.ycosystem.com/orderMeet/detail?id=%ld",(long)[orderingID integerValue]];
    }else if ([_kLastYYServerURL containsString:@"test.ycosystem.com"]){
        //测试
        weburl = [[NSString alloc] initWithFormat:@"http://mt.ycosystem.com/orderMeet/detail?id=%ld",(long)[orderingID integerValue]];
    }else if ([_kLastYYServerURL containsString:@"ycosystem.com"]){
        //生产
        weburl = [[NSString alloc] initWithFormat:@"http://m.ycosystem.com/orderMeet/detail?id=%ld",(long)[orderingID integerValue]];
    }
    if(weburl && [LanguageManager isEnglishLanguage]){
        weburl = [[NSString alloc] initWithFormat:@"%@&lang=en",weburl];
    }
    return weburl;
}
#pragma mark - --------------other----------------------

@end
