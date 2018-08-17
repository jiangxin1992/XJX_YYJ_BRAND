//
//  YYStockMessageListViewController.m
//  yunejianDesigner
//
//  Created by Victor on 2018/2/1.
//  Copyright © 2018年 Apple. All rights reserved.
//

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "YYStockMessageListViewController.h"
#import "YYStyleDetailViewController.h"

// 自定义视图
#import "YYNavView.h"
#import "YYStockMessageCell.h"

// 接口
#import "YYMessageApi.h"
#import "YYOpusApi.h"

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYMessageUnreadModel.h"
#import "YYTableViewCellData.h"
#import "YYPageInfoModel.h"
#import "YYSkuMessageListModel.h"
#import <MBProgressHUD.h>
#import <MJRefresh.h>
#import "AppDelegate.h"

@interface YYStockMessageListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) YYNavView *navView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<YYSkuMessageModel *> *dataSourceArray;
@property (nonatomic, strong) YYPageInfoModel *pageInfoModel;
@property (nonatomic, strong) NSArray *cellDataArrays;

@end

@implementation YYStockMessageListViewController

#pragma mark - --------------生命周期--------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self RequestData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self markSkuAsRead];
}

#pragma mark - --------------SomePrepare--------------
- (void)SomePrepare {
    [self PrepareUI];
    [self PrepareData];
}

- (void)PrepareData{
}

- (void)PrepareUI{
    self.view.backgroundColor = _define_white_color;
    self.navView = [[YYNavView alloc] initWithTitle:NSLocalizedString(@"库存消息",nil) WithSuperView: self.view haveStatusView:YES];
    
    UIButton *backBtn = [UIButton getCustomImgBtnWithImageStr:@"goBack_normal" WithSelectedImageStr:nil];
    [self.navView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.width.mas_equalTo(40);
        make.bottom.mas_equalTo(-1);
    }];
}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds) - kStatusBarAndNavigationBarHeight) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[YYStockMessageCell class] forCellReuseIdentifier:NSStringFromClass([YYStockMessageCell class])];
    [self addHeader];
    [self addFooter];
}

#pragma mark - --------------请求数据----------------------
-(void)RequestData{
    [self getSkuMessageListAtPageIndex:1 completed:nil];
}

- (void)getSkuMessageListAtPageIndex:(NSInteger)pageIndex completed:(void (^) (void))compltedBlock {
    [YYMessageApi getSkuMessageListAtPageIndex:@(pageIndex) complete:^(YYRspStatusAndMessage *rspStatusAndMessage, YYSkuMessageListModel *skuMessageListModel, NSError *error) {
        if (!error && rspStatusAndMessage.status == 100) {
            if (!self.dataSourceArray) {
                self.dataSourceArray = [NSMutableArray array];
            }
            self.pageInfoModel = skuMessageListModel.pageInfo;
            if (pageIndex == 1) {
                [self.dataSourceArray removeAllObjects];
            }
            if (skuMessageListModel.result.count > 0) {
                [self.dataSourceArray addObjectsFromArray:skuMessageListModel.result];
            }
            [self buildTableViewDataSource];
            [self.tableView reloadData];
        }
        if (compltedBlock) {
            compltedBlock();
        }
    }];
}

- (void)markSkuAsRead {
    [YYMessageApi markSkuAsRead:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
        if (!error && rspStatusAndMessage.status == 100) {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.messageUnreadModel.skuAmount = @(0);
            if (self.willDisappearBlock) {
                self.willDisappearBlock();
            }
        }
    }];
}

#pragma mark - --------------系统代理----------------------
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellDataArrays.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cellDataArrays[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YYTableViewCellData *data = self.cellDataArrays[indexPath.section][indexPath.row];
    YYSkuMessageModel *skuMessageModel = data.object;
    YYStockMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YYStockMessageCell class])];
    [cell updateUIWithModel:skuMessageModel];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YYTableViewCellData *data = self.cellDataArrays[indexPath.section][indexPath.row];
    return [data tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YYTableViewCellData *data = self.cellDataArrays[indexPath.section][indexPath.row];
    return [data tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YYTableViewCellData *data = self.cellDataArrays[indexPath.section][indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [data tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - --------------自定义代理/block----------------------


#pragma mark - --------------自定义响应----------------------
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - --------------自定义方法----------------------
- (void)addHeader{
    WeakSelf(ws);
    // 添加下拉刷新头部控件
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态就会回调这个Block
        if ([YYCurrentNetworkSpace isNetwork]){
            [ws getSkuMessageListAtPageIndex:1 completed:^{
                [ws.tableView.mj_header endRefreshing];
            }];
        }else{
            [ws.tableView.mj_header endRefreshing];
            [YYToast showToastWithTitle:kNetworkIsOfflineTips andDuration:kAlertToastDuration];
        }
    }];
    self.tableView.mj_header = header;
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
}

- (void)addFooter{
    WeakSelf(ws);
    // 添加上拉刷新尾部控件
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态就会回调这个Block
        
        if (![YYCurrentNetworkSpace isNetwork]) {
            [YYToast showToastWithTitle:kNetworkIsOfflineTips andDuration:kAlertToastDuration];
            [ws.tableView.mj_footer endRefreshing];
            return;
        }
        if (ws.pageInfoModel.isLastPage) {
            [ws.tableView.mj_footer endRefreshing];
        } else {
            [ws getSkuMessageListAtPageIndex:[ws.pageInfoModel.pageIndex integerValue] + 1 completed:^{
                [ws.tableView.mj_footer endRefreshing];
            }];
        }
    }];
}

#pragma mark - --------------other----------------------
- (void)buildTableViewDataSource {
    NSMutableArray *arrays = [NSMutableArray array];
    for (YYSkuMessageModel *skuMessageModel in self.dataSourceArray) {
        YYTableViewCellData *data = [[YYTableViewCellData alloc] init];
        data.reuseIdentifier = NSStringFromClass([YYStockMessageCell class]);
        data.useDynamicRowHeight = YES;
        data.object = skuMessageModel;
        [data setSelectedCellBlock:^(NSIndexPath *indexPath) {
            NSLog(@"%ld", [skuMessageModel.styleId integerValue]);
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate showStyleDetailWithStyleId:[skuMessageModel.styleId integerValue] parentViewController:self];
        }];
        [arrays addObject:@[data]];
    }
    self.cellDataArrays = [NSArray arrayWithArray:arrays];
}

@end
