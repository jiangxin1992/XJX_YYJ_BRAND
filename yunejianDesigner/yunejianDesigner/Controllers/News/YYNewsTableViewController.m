//
//  YYNewsTableViewController.m
//  YunejianBuyer
//
//  Created by Apple on 16/9/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYNewsTableViewController.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图
#import "MBProgressHUD.h"
#import "YYNewsTableViewCell.h"

// 接口
#import "YYUserApi.h"

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import <MJRefresh.h>

@interface YYNewsTableViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopLayout;
@property (strong, nonatomic) YYPageInfoModel *currentPageInfo;
@property (strong, nonatomic) NSMutableArray *listArray;

@end

@implementation YYNewsTableViewController
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
    _listArray = [[NSMutableArray alloc] initWithCapacity:8];
}
- (void)PrepareUI{
    if(kIPhoneX){
        _tableViewTopLayout.constant = 45 + 44;
    }else{
        _tableViewTopLayout.constant = 65;
    }
    [self.tableView registerNib:[UINib nibWithNibName:@"YYNewsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"YYNewsTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self addHeader];
    [self addFooter];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{}

#pragma mark - --------------请求数据----------------------
-(void)RequestData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadListFromServerByPageIndex:1 endRefreshing:NO];
}
- (void)loadListFromServerByPageIndex:(int)pageIndex endRefreshing:(BOOL)endrefreshing{
    WeakSelf(ws);
    if (![YYCurrentNetworkSpace isNetwork]) {
        [_listArray removeAllObjects];

        if(endrefreshing){
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        [ws reloadTableData];
        [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];
        return;
    }
    __block BOOL blockEndrefreshing = endrefreshing;
    if(true){
        [YYUserApi getNewsList:_index pageIndex:pageIndex pageSize:8  andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYNewsListModel *listModel, NSError *error) {
            if (rspStatusAndMessage.status == kCode100) {
                if(pageIndex == 1) {
                    [ws.listArray removeAllObjects];
                }
                ws.currentPageInfo = listModel.pageInfo;

                if (listModel && listModel.result
                    && [listModel.result count] > 0){
                    [ws.listArray addObjectsFromArray:listModel.result];

                }
            }

            if(blockEndrefreshing){
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            }
            [ws reloadTableData];
            //
            [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];
        }];
    }else{

        if(blockEndrefreshing){
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        [ws reloadTableData];

        [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];

    }
}

#pragma mark - --------------系统代理----------------------
#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if([_listArray count] > 0){
        return [_listArray count];
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([_listArray count] > 0){
        YYNewsInfoModel *infoModel = [_listArray objectAtIndex:indexPath.row];
        YYNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYNewsTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.infoModel = infoModel;
        [cell updateUI];
        return cell;
    }else{
        return nil;
    }
}

#pragma mark -UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([_listArray count] > 0){
        return 99;
    }else{
        return 0;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YYNewsInfoModel *infoModel = [_listArray objectAtIndex:indexPath.row];

    if(self.delegate && infoModel.detailURL){
        [self.delegate btnClick:indexPath.row section:indexPath.section andParmas:@[@"detail",infoModel.detailURL]];
    }
}

#pragma mark - --------------自定义代理/block----------------------


#pragma mark - --------------自定义响应----------------------


#pragma mark - --------------自定义方法----------------------
-(void)relaodTableData:(BOOL)newData{
    if(self.currentPageInfo != nil){
        if(newData){
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self loadListFromServerByPageIndex:1 endRefreshing:NO];
        }else{
            [self.tableView reloadData];
        }
    }
}

-(void)reloadTableData{
    [self.tableView reloadData];
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

#pragma mark - --------------other----------------------

@end
