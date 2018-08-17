//
//  YYOrderMessageViewController.m
//  Yunejian
//
//  Created by Apple on 15/10/26.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "YYOrderMessageViewController.h"

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "YYNavigationBarViewController.h"
#import "YYOrderDetailViewController.h"

// 自定义视图
#import "MBProgressHUD.h"
#import "YYOrderMessageViewCell.h"

// 接口
#import "YYOrderApi.h"

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import <MJRefresh.h>

#import "YYRspStatusAndMessage.h"
#import "AppDelegate.h"

@interface YYOrderMessageViewController ()<UITableViewDataSource,UITableViewDelegate,YYTableCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) YYPageInfoModel *currentPageInfo;
@property (strong, nonatomic) NSMutableArray *msgListArray;
@property (strong, nonatomic) NSMutableArray *msgGroupTitleArray;
@property (strong, nonatomic) NSMutableArray *msgGroupDataArray;

@property (nonatomic,strong) UIView *noDataView;

@end

@implementation YYOrderMessageViewController
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
    [MobClick beginLogPageView:kYYPageOrderMessage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageOrderMessage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - --------------SomePrepare--------------
- (void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
- (void)PrepareData{}
- (void)PrepareUI{
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addHeader];
    [self addFooter];
}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{
    [self CreateNavView];
    [self CreateNoDataView];
}
-(void)CreateNavView{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YYNavigationBarViewController *navigationBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNavigationBarViewController"];
    navigationBarViewController.previousTitle = @"";

    NSString *title = NSLocalizedString(@"订单消息",nil);
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
            if(ws.markAsReadHandler){
                ws.markAsReadHandler();
            }
            [ws.navigationController popViewControllerAnimated:YES];
            blockVc = nil;
        }
    }];
}
-(void)CreateNoDataView{
    self.noDataView = addNoDataView_phone(self.view,[NSString stringWithFormat:@"%@|icon:nomsg_icon",NSLocalizedString(@"暂无订单消息",nil)],nil,nil);
    _noDataView.hidden = YES;
}

#pragma mark - --------------请求数据----------------------
-(void)RequestData{
    [self loadMsgListWithpageIndex:1];
}

#pragma mark - --------------系统代理----------------------
#pragma mark -UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_msgListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    YYOrderMessageInfoModel* infoModel = [_msgListArray objectAtIndex:indexPath.row];
    static NSString* reuseIdentifier = @"YYOrderMessageViewCell";
    YYOrderMessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.msgInfoModel = infoModel;
    cell.delegate = self;
    [cell updateUI];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    YYOrderMessageInfoModel* _msgInfoModel = [_msgListArray objectAtIndex:indexPath.row];

    CGFloat cellHeight = 160.0f;

    BOOL btnIsHide = YES;
    BOOL isCount = NO;
    CGFloat orderRejectedReasonHeight = 0.0f;

    if(_msgInfoModel.msgContent && ![NSString isNilOrEmpty:_msgInfoModel.msgContent.op]){
        if([_msgInfoModel.msgContent.op isEqualToString:@"need_confirm"]){
            if([_msgInfoModel.dealStatus integerValue] == -1){
                if(_msgInfoModel.orderTransStatus && [_msgInfoModel.orderTransStatus integerValue] != 4){
                    //双方都已确认
                    btnIsHide = YES;
                }else{
                    //我待确认(对方已确认)
                    btnIsHide = NO;
                }
            }else if([_msgInfoModel.dealStatus integerValue] == 1){
                //我已确认
                btnIsHide = YES;
            }if([_msgInfoModel.dealStatus integerValue] == 2){
                //我已拒绝
                btnIsHide = YES;
            }
        }else if([_msgInfoModel.msgContent.op isEqualToString:@"order_rejected"]){
            //对方已拒绝
            btnIsHide = YES;
            if(![NSString isNilOrEmpty:_msgInfoModel.msgContent.reason]){
                NSString *reason = [[NSString alloc] initWithFormat:@"拒绝理由：%@",_msgInfoModel.msgContent.reason];
                orderRejectedReasonHeight = getHeightWithWidth(SCREEN_WIDTH - 17 * 2, reason, [UIFont systemFontOfSize:12.0f]);
            }
        }
    }else{
        if(_msgInfoModel.isPlainMsg == NO){
            if([_msgInfoModel.dealStatus integerValue] == -1){
                btnIsHide = NO;
            }else{
                btnIsHide = YES;
            }
        }else{
            btnIsHide = YES;
            if([_msgInfoModel.autoCloseHoursRemains integerValue] > 0){
                isCount = YES;
            }
        }
    }

    if(!btnIsHide || isCount){
        cellHeight += 30;
    }

    if(orderRejectedReasonHeight > 0){
        cellHeight += orderRejectedReasonHeight + 10;
    }
    return cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YYOrderMessageInfoModel* infoModel = [_msgListArray objectAtIndex:indexPath.row];
    if(infoModel.msgContent == nil){
        return;
    }
    NSString *orderCode = infoModel.msgContent.orderCode;
    WeakSelf(ws);

    if(infoModel.msgContent && ![NSString isNilOrEmpty:infoModel.msgContent.op]){
        BOOL canGoToOrderDetailView = NO;
        if([infoModel.msgContent.op isEqualToString:@"need_confirm"]){
            if([infoModel.dealStatus integerValue] == -1){
                if(infoModel.orderTransStatus && [infoModel.orderTransStatus integerValue] != 4){
                    //双方都已确认
                    canGoToOrderDetailView = YES;
                }else{
                    //我待确认(对方已确认)
                    canGoToOrderDetailView = YES;
                }
            }else if([infoModel.dealStatus integerValue] == 1){
                //我已确认
                canGoToOrderDetailView = YES;
            }if([infoModel.dealStatus integerValue] == 2){
                //我已拒绝
                canGoToOrderDetailView = YES;
            }
        }else if([infoModel.msgContent.op isEqualToString:@"order_rejected"]){
            //对方已拒绝
            canGoToOrderDetailView = YES;
        }

        if(canGoToOrderDetailView){
            if(infoModel.isPlainMsg == NO){
                if(infoModel.msgContent){
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OrderDetail" bundle:[NSBundle mainBundle]];
                    YYOrderDetailViewController *orderDetailViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYOrderDetailViewController"];
                    orderDetailViewController.currentOrderCode = infoModel.msgContent.orderCode;
                    orderDetailViewController.currentOrderLogo =  infoModel.msgContent.designerBrandLogo;
                    orderDetailViewController.currentOrderConnStatus = kOrderStatusNUll;
                    [self.navigationController pushViewController:orderDetailViewController animated:YES];
                }
            }else{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OrderDetail" bundle:[NSBundle mainBundle]];
                YYOrderDetailViewController *orderDetailViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYOrderDetailViewController"];
                orderDetailViewController.currentOrderCode = infoModel.msgContent.orderCode;
                orderDetailViewController.currentOrderLogo =  infoModel.msgContent.designerBrandLogo;
                orderDetailViewController.currentOrderConnStatus = kOrderStatusNUll;
                [self.navigationController pushViewController:orderDetailViewController animated:YES];
            }
        }

    }else{
        [YYOrderApi getOrderTransStatus:orderCode andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYOrderTransStatusModel *transStatusModel, NSError *error) {
            if(rspStatusAndMessage.status == kCode100){
                NSInteger transStatus = getOrderTransStatus(transStatusModel.designerTransStatus, transStatusModel.buyerTransStatus);
                if (transStatusModel == nil || transStatus == kOrderCode_DELETED) {
                    [YYToast showToastWithView:self.view title:NSLocalizedString(@"此订单已被删除",nil) andDuration:kAlertToastDuration];
                    return;
                }else{
                    [ws pushOrderDetailWithOrderInfo:infoModel];
                }
            }
        }];
    }
}
-(void)pushOrderDetailWithOrderInfo:(YYOrderMessageInfoModel *)infoModel{
    if(infoModel.isPlainMsg == NO){
        if([infoModel.dealStatus integerValue]== 1 && infoModel.msgContent){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OrderDetail" bundle:[NSBundle mainBundle]];
            YYOrderDetailViewController *orderDetailViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYOrderDetailViewController"];
            orderDetailViewController.currentOrderCode = infoModel.msgContent.orderCode;
            orderDetailViewController.currentOrderLogo =  infoModel.msgContent.designerBrandLogo;
            orderDetailViewController.currentOrderConnStatus = kOrderStatusNUll;
            [self.navigationController pushViewController:orderDetailViewController animated:YES];
        }else{
            [YYToast showToastWithView:self.view title:NSLocalizedString(@"对不起，您没有权限查看订单",nil) andDuration:kAlertToastDuration];//“
        }
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OrderDetail" bundle:[NSBundle mainBundle]];
        YYOrderDetailViewController *orderDetailViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYOrderDetailViewController"];
        orderDetailViewController.currentOrderCode = infoModel.msgContent.orderCode;
        orderDetailViewController.currentOrderLogo =  infoModel.msgContent.designerBrandLogo;
        orderDetailViewController.currentOrderConnStatus = kOrderStatusNUll;
        [self.navigationController pushViewController:orderDetailViewController animated:YES];
    }
}
#pragma mark - --------------自定义代理/block----------------------
#pragma mark -YYTableCellDelegate
-(void)btnClick:(NSInteger)row section:(NSInteger)section andParmas:(NSArray *)parmas{
    NSString *type = [parmas objectAtIndex:0];
    if([type isEqualToString:@"reload"]){
        [_tableView reloadData];
    }
}

#pragma mark - --------------自定义响应----------------------


#pragma mark - --------------自定义方法----------------------
-(void)setMsgListGroupArray{
    _msgGroupTitleArray = [[NSMutableArray alloc] init];
    _msgGroupDataArray = [[NSMutableArray alloc] init];
    double dateTimer = 0;
    for (YYOrderMessageInfoModel* infoModel in self.msgListArray) {
        dateTimer = floor([infoModel.sendTime doubleValue]/86400000);
        dateTimer = dateTimer*86400000;
        NSString *key = [NSString stringWithFormat:@"%f",dateTimer];
        if(![_msgGroupTitleArray containsObject:key]){
            [_msgGroupTitleArray addObject:key];
        }
        NSInteger index = [_msgGroupTitleArray indexOfObject:key];
        if(index >= [_msgGroupDataArray count]){
            _msgGroupDataArray[index] = [[NSMutableArray alloc] init];
        }
        [_msgGroupDataArray[index] addObject:infoModel];

    }
    if([self.msgListArray count]){
        _noDataView.hidden = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }else{
        _noDataView.hidden = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
}

//请求买家地址列表
-(void)loadMsgListWithpageIndex:(NSInteger)pageIndex{
    WeakSelf(ws);
    NSString *type = @"1";

    NSInteger pageSize = 10;

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [YYOrderApi getNotifyMsgList:type pageIndex:pageIndex pageSize:pageSize andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYOrderMessageInfoListModel *msgListModel, NSError *error) {
        if(rspStatusAndMessage.status == kCode100){
            ws.currentPageInfo = msgListModel.pageInfo;
            if(ws.currentPageInfo.isFirstPage){
                ws.msgListArray =  [[NSMutableArray alloc] init];//;
            }
            [ws.msgListArray addObjectsFromArray:msgListModel.result];
            //[ws setMsgListGroupArray];
            if([ws.msgListArray count]){
                ws.noDataView.hidden = YES;
            }else{
                ws.noDataView.hidden = NO;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [ws.tableView reloadData];
            });
        }
        [ws.tableView.mj_header endRefreshing];
        [ws.tableView.mj_footer endRefreshing];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    }];
}
- (void)addHeader{
    WeakSelf(ws);
    // 添加下拉刷新头部控件
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态就会回调这个Block
        [ws loadMsgListWithpageIndex:1];
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
            [ws.tableView.mj_footer endRefreshing];
            return;
        }

        if ([ws.msgListArray count] > 0
            && ws.currentPageInfo
            && !ws.currentPageInfo.isLastPage) {
            [ws loadMsgListWithpageIndex:[ws.currentPageInfo.pageIndex intValue]+1];
        }else{
            [ws.tableView.mj_footer endRefreshing];
        }
    }];
}

+(void)markAsRead{
    [YYOrderApi markAsRead:1 andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {

    }];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDelegate.messageUnreadModel.orderAmount integerValue] > 0){
        appDelegate.messageUnreadModel.orderAmount = @(0);
        [[NSNotificationCenter defaultCenter] postNotificationName:UnreadMsgAmountChangeNotification object:nil userInfo:nil];
    }
}

#pragma mark - --------------other----------------------


@end
