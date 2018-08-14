//
//  YYPackageListViewController.m
//  yunejianDesigner
//
//  Created by yyj on 2018/6/28.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "YYPackageListViewController.h"

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "YYPackageDetailViewController.h"

// 自定义视图
#import "YYNavView.h"
#import "MBProgressHUD.h"
#import "YYPackageListCell.h"

// 接口
#import "YYOrderApi.h"

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import <MJRefresh.h>

#import "YYPackageListModel.h"

#define kPackageListPageSize 20

@interface YYPackageListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) YYNavView *navView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YYPageInfoModel *currentPageInfo;
@property (nonatomic, strong) NSMutableArray *packageListArray;

@end

@implementation YYPackageListViewController

#pragma mark - --------------生命周期--------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self RequestData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 进入埋点
    [MobClick beginLogPageView:kYYPagePackageList];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPagePackageList];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - --------------SomePrepare--------------
- (void)SomePrepare {
    [self PrepareData];
    [self PrepareUI];
}
- (void)PrepareData {
    _packageListArray = [[NSMutableArray alloc] initWithCapacity:0];
}
- (void)PrepareUI {
    self.view.backgroundColor = _define_white_color;

    _navView = [[YYNavView alloc] initWithTitle:NSLocalizedString(@"查看包裹进度",nil) WithSuperView:self.view haveStatusView:YES];

    UIButton *backBtn = [UIButton getCustomImgBtnWithImageStr:@"goBack_normal" WithSelectedImageStr:nil];
    [_navView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.width.mas_equalTo(40);
        make.bottom.mas_equalTo(-1);
    }];
}

#pragma mark - --------------UIConfig----------------------
- (void)UIConfig {
    [self createTableView];
}
-(void)createTableView{
    WeakSelf(ws);
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ws.navView.mas_bottom).with.offset(0);
        make.left.right.bottom.mas_equalTo(0);
    }];

    [self addHeader];
    [self addFooter];
}
- (void)addHeader{
    WeakSelf(ws);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (![YYCurrentNetworkSpace isNetwork]) {
            [YYToast showToastWithTitle:kNetworkIsOfflineTips andDuration:kAlertToastDuration];
            [ws.tableView.mj_header endRefreshing];
            return;
        }
        [ws loadPackageListFromServerByPageIndex:1 endRefreshing:YES];
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
            [ws loadPackageListFromServerByPageIndex:[ws.currentPageInfo.pageIndex intValue]+1 endRefreshing:YES];
        }else{
            //弹出提示
            [ws.tableView.mj_footer endRefreshing];
        }
    }];
}
#pragma mark - --------------请求数据----------------------
- (void)RequestData {
    //获取列表数据
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadPackageListFromServerByPageIndex:1 endRefreshing:YES];
}
- (void)loadPackageListFromServerByPageIndex:(int)pageIndex endRefreshing:(BOOL)endrefreshing{
    WeakSelf(ws);
    __block BOOL blockEndrefreshing = endrefreshing;
    [YYOrderApi getPackagesListByOrderCode:_orderCode pageIndex:pageIndex pageSize:kPackageListPageSize andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYPackageListModel *packageListModel, NSError *error) {

        [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];

        if (rspStatusAndMessage.status == YYReqStatusCode100) {
            if (pageIndex == 1) {
                [ws.packageListArray removeAllObjects];
            }
            ws.currentPageInfo = packageListModel.pageInfo;

            if (packageListModel && packageListModel.result
                && [packageListModel.result count] > 0){
                [ws.packageListArray addObjectsFromArray:packageListModel.result];

            }
        }

        if(blockEndrefreshing){
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        [ws.tableView reloadData];

    }];
}
#pragma mark - --------------系统代理----------------------
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_packageListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    数据还未获取时候
    if(!_packageListArray.count)
    {
        static NSString *cellid = @"UITableViewCell";
        UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellid];
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }

    static NSString *cellid = @"YYPackageListCell";
    YYPackageListCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellid];
    if(!cell)
    {
        cell = [[YYPackageListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.indexPath = indexPath;
    cell.packageModel = _packageListArray[indexPath.row];
    cell.packageName = [[NSString alloc] initWithFormat:NSLocalizedString(@"包裹 %ld",nil),_packageListArray.count - indexPath.row];
    [cell updateUI];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WeakSelf(ws);
    YYPackageModel *packageModel = _packageListArray[indexPath.row];
    YYPackageDetailViewController *packageDetailView = [[YYPackageDetailViewController alloc] init];
    packageDetailView.indexPath = indexPath;
    packageDetailView.packageModel = packageModel;
    packageDetailView.packageName = [[NSString alloc] initWithFormat:NSLocalizedString(@"包裹 %ld",nil),_packageListArray.count - indexPath.row];
    [packageDetailView setCancelButtonClicked:^{
        [ws.navigationController popViewControllerAnimated:YES];
    }];
    [self.navigationController pushViewController:packageDetailView animated:YES];
}

#pragma mark - --------------自定义代理/block----------------------


#pragma mark - --------------自定义响应----------------------
-(void)goBack:(id)sender {
    if(_cancelButtonClicked){
        _cancelButtonClicked();
    }
}

#pragma mark - --------------自定义方法----------------------


#pragma mark - --------------other----------------------

@end
