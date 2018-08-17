//
//  YYOrderModifyLogListController.m
//  Yunejian
//
//  Created by Apple on 15/10/29.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "YYOrderModifyLogListController.h"

#import "YYOrderModifyListCell.h"
#import "YYNavigationBarViewController.h"
#import "YYOrderApi.h"
#import "YYRspStatusAndMessage.h"
#import <MJRefresh.h>
#import "MBProgressHUD.h"

@interface YYOrderModifyLogListController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)YYPageInfoModel *currentPageInfo;
@property (strong, nonatomic) NSMutableArray *logListArray;
@end

@implementation YYOrderModifyLogListController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YYNavigationBarViewController *navigationBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNavigationBarViewController"];
    navigationBarViewController.previousTitle = @"";
    
    NSString *title = NSLocalizedString(@"订单修改记录",nil);
    navigationBarViewController.nowTitle = title;
    
    [_containerView addSubview:navigationBarViewController.view];
    __weak UIView *_weakContainerView = _containerView;
    [navigationBarViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_weakContainerView.mas_top);
        make.left.equalTo(_weakContainerView.mas_left);
        make.bottom.equalTo(_weakContainerView.mas_bottom);
        make.right.equalTo(_weakContainerView.mas_right);
        
    }];
    
    WeakSelf(ws);
    
    __block YYNavigationBarViewController *blockVc = navigationBarViewController;
    
    [navigationBarViewController setNavigationButtonClicked:^(NavigationButtonType buttonType){
        if (buttonType == NavigationButtonTypeGoBack) {
            [ws.navigationController popViewControllerAnimated:YES];
            blockVc = nil;
        }
    }];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0,0 );
    
    [self addHeader];
    [self addFooter];
    [ws loadModifyLogListWithpageIndex:1];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 进入埋点
    [MobClick beginLogPageView:kYYPageOrderModifyLog];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageOrderModifyLog];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1+(_logListArray?[_logListArray count]:0);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        static NSString* reuseIdentifier = @"YYOrderModifyListCell";
        YYOrderModifyListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *piceValue = [NSString stringWithFormat:@"%.2f",[_currentYYOrderInfoModel.finalTotalPrice floatValue]];
        cell.infoLabel.text = replaceMoneyFlag([NSString stringWithFormat:NSLocalizedString(@"总计：%i 款 %i 件     总价：￥ %@",nil),_stylesAndTotalPriceModel.totalStyles,_stylesAndTotalPriceModel.totalCount,piceValue],[_currentYYOrderInfoModel.curType integerValue]);
        cell.orderCodeLabel.text =  [NSString stringWithFormat:NSLocalizedString(@"订单号：%@     建单时间：%@",nil),_currentYYOrderInfoModel.orderCode,getShowDateByFormatAndTimeInterval(@"yyyy-MM-dd",[_currentYYOrderInfoModel.orderCreateTime stringValue])];
        cell.buyerLabel.text = [NSString stringWithFormat:@"%@ %@ %@",_currentYYOrderInfoModel.brandName,@"",@""];
        cell.currentOrderLogo = (_currentOrderLogo?_currentOrderLogo:@"");
        [cell updateUI];
        return cell;
    }else{
        static NSString *CellIdentifier = @"OrderModifyItemCell";
        UITableViewCell *cell1 = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *timerLabel = (UILabel *)[cell1.contentView viewWithTag:90009];
        UILabel *titleLabel = (UILabel *)[cell1.contentView viewWithTag:90008];
        YYOrderOperateLogModel *logModel = [self.logListArray objectAtIndexedSubscript:(indexPath.row-1)];
        timerLabel.text = getShowDateByFormatAndTimeInterval(@"yyyy-MM-dd HH:mm",[logModel.createTime stringValue]);
        [titleLabel setAdjustsFontSizeToFitWidth:YES];
        titleLabel.text = [self getOprateStr:logModel];
        return cell1;
    }
    
}

-(NSString *)getOprateStr:(YYOrderOperateLogModel *)logModel{
    //    0->新建订单
    //    1->修改订单
    //    2->取消订单
    //    3->更新订单状态（标记签合同等）
    //    4->恢复订单
    //    5->删除状态
    //    6->离线订单已上传
    //    7->订单关闭请求
    //    8->撤销订单关闭请求
    //    9->关闭订单
    //    10->同意了关闭订单
    //    11->拒绝了关闭订单
    NSInteger type = [logModel.operateType integerValue];
    NSInteger createType = [logModel.createType integerValue];
    NSString *createName =  logModel.createName;
    NSInteger status = [logModel.status integerValue];
    
    switch (type) {
        case 0:
            return [NSString stringWithFormat:@"%@  %@",createName,NSLocalizedString(@"新建订单",nil)];
        case 1:
            return [NSString stringWithFormat:@"%@  %@",createName,NSLocalizedString(@"修改订单",nil)];
        case 2:
            return [NSString stringWithFormat:@"%@  %@",createName,NSLocalizedString(@"取消订单",nil)];
        case 3:
            return [NSString stringWithFormat:@"%@  %@“%@”",createName,NSLocalizedString(@"标记了订单状态为",nil),getOrderStatusName_detail(status,NO)];
        case 5:
            return [NSString stringWithFormat:@"%@  %@",createName,NSLocalizedString(@"删除状态",nil)];
        case 6:
            return [NSString stringWithFormat:@"%@  %@",createName,NSLocalizedString(@"离线订单已上传",nil)];
        case 7:
            return [NSString stringWithFormat:@"%@  %@",createName,NSLocalizedString(@"取消订单请求",nil)];
        case 8:
            return [NSString stringWithFormat:@"%@  %@",createName,NSLocalizedString(@"撤销取消订单请求",nil)];
        case 9:
            return NSLocalizedString(@"双方取消了订单",nil);
        case 10:
            return NSLocalizedString(@"双方取消了订单",nil);
        case 11:
            if(createType == 0){
                return NSLocalizedString(@"买手店方取消了订单",nil);
            }else{
                return NSLocalizedString(@"品牌方取消了订单",nil);
            }
        default:
            break;
    }
    return @"";
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 129;
    }
    return 55;
}

//请求买家地址列表
-(void)loadModifyLogListWithpageIndex:(NSInteger )pageIndex{
    WeakSelf(ws);
    NSString *orderCode = _currentYYOrderInfoModel.orderCode;
    NSInteger pageSize = 10;
    if([orderCode isEqualToString:@""]){
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [YYOrderApi getsingleOrderInfoDynamicsList:orderCode pageIndex:pageIndex pageSize:pageSize andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYOrderOperateLogListModel *orderListModel, NSError *error) {
        if(rspStatusAndMessage.status == kCode100){
            ws.currentPageInfo = orderListModel.pageInfo;
            if(ws.currentPageInfo.isFirstPage){
                ws.logListArray =  [[NSMutableArray alloc] init];//;
            }
            [ws.logListArray addObjectsFromArray:orderListModel.result];
            dispatch_async(dispatch_get_main_queue(), ^{
                [ws.tableView reloadData];
            });
        }
        [ws.tableView.mj_header endRefreshing];
        [ws.tableView.mj_footer endRefreshing];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}
#pragma MJRefresh.h
- (void)addHeader{
    WeakSelf(ws);
    // 添加下拉刷新头部控件
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态就会回调这个Block
        [ws loadModifyLogListWithpageIndex:1];
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
            //[YYToast showToastWithTitle:kNetworkIsOfflineTips andDuration:kAlertToastDuration];
            [ws.tableView.mj_footer endRefreshing];
            return;
        }

        if ([ws.logListArray count] > 0
            && ws.currentPageInfo
            && !ws.currentPageInfo.isLastPage) {
            [ws loadModifyLogListWithpageIndex:[ws.currentPageInfo.pageIndex intValue]+1];
        }else{
            [ws.tableView.mj_footer endRefreshing];
        }
    }];
}
@end
