//
//  YYShowroomOrderingCheckViewController.m
//  yunejianDesigner
//
//  Created by yyj on 2018/3/12.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "YYShowroomOrderingCheckViewController.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图
#import "YYNavView.h"
#import "MBProgressHUD.h"
#import "YYNoDataView.h"
#import "YYMenuPopView.h"
#import "YYShowroomOrderingCheckCell.h"

// 接口
#import "YYShowroomApi.h"

// 分类
#import "UIImage+Tint.h"

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import <MJRefresh.h>

#import "YYShowroomOrderingCheckListModel.h"

@interface YYShowroomOrderingCheckViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YYPageInfoModel *currentPageInfo;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property(nonatomic,strong) NSArray *menuBtnsData;
@property(nonatomic,strong) NSArray *menuBtnsIconData;

@property (nonatomic, strong) YYNavView *navView;
@property (nonatomic, strong) UIButton *pullDownMenu;
@property (nonatomic, strong) YYNoDataView *noDataView;
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) NSString *status;

@end

@implementation YYShowroomOrderingCheckViewController

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
    self.menuBtnsData = @[NSLocalizedString(@"全部",nil)
                      ,NSLocalizedString(@"待审核",nil)
                      ,NSLocalizedString(@"已通过",nil)
                      ,NSLocalizedString(@"已拒绝",nil)
                      ,NSLocalizedString(@"已取消",nil)
                      ,NSLocalizedString(@"已失效",nil)];

    self.menuBtnsIconData = @[@"",@"",@"",@"",@"",@""];
    self.status = nil;
}
- (void)PrepareUI{
    self.view.backgroundColor = [UIColor colorWithHex:@"f8f8f8"];

    _navView = [[YYNavView alloc] initWithTitle:NSLocalizedString(@"预约审核",nil) WithSuperView:self.view haveStatusView:YES];

    UIButton *backBtn = [UIButton getCustomImgBtnWithImageStr:@"goBack_normal" WithSelectedImageStr:nil];
    [_navView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(GoBack:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.width.mas_equalTo(40);
        make.bottom.mas_equalTo(-1);
    }];

    _pullDownMenu = [UIButton getCustomImgBtnWithImageStr:@"filter_icon" WithSelectedImageStr:nil];
    [_navView addSubview:_pullDownMenu];
    [_pullDownMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(0);
        make.width.mas_equalTo(50);
        make.bottom.mas_equalTo(-1);
    }];
    [_pullDownMenu addTarget:self action:@selector(showMenuUI:) forControlEvents:UIControlEventTouchUpInside];

    _containerView = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"f8f8f8"]];
    [self.view addSubview:_containerView];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(_navView.mas_bottom).with.offset(0);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop).with.offset(0);
    }];
}
-(void)showMenuUI:(id)sender{
    UIViewController *parent = [UIApplication sharedApplication].keyWindow.rootViewController;
    NSInteger menuUIWidth = 134;
    NSInteger menuUIHeight = 237;
    CGPoint p = [_pullDownMenu convertPoint:CGPointMake(0, 0) toView:parent.view];
    WeakSelf(ws);

    [YYMenuPopView addPellTableViewSelectWithWindowFrame:CGRectMake(SCREEN_WIDTH-menuUIWidth-12, p.y+CGRectGetHeight(_pullDownMenu.frame), menuUIWidth, menuUIHeight) selectData:_menuBtnsData images:_menuBtnsIconData action:^(NSInteger index) {
        if(index > -1){
            [ws menuBtnHandler:index+1];
        }
    } animated:YES arrowImage:YES  arrowPositionInfo:nil];
}
-(void)menuBtnHandler:(NSInteger)index{
    NSInteger type = index;
    if(type == 1){
        //全部
        self.status = nil;
    }else if(type == 2){
        //待审核
        self.status = @"TO_BE_VERIFIED";
    }else if(type == 3){
        //已通过
        self.status = @"VERIFIED";
    }else if(type == 4){
        //已拒绝
        self.status = @"REJECTED";
    }else if(type == 5){
        //已取消
        self.status = @"CANCELLED";
    }else if(type == 6){
        //已失效
        self.status = @"INVALIDATED";
    }
    UIImage *iconImage = nil;
    if(type != 1){
        iconImage = [[UIImage imageNamed:@"filter_icon"] imageWithTintColor:[UIColor colorWithHex:@"ed6498"]];
        [_pullDownMenu setImage:iconImage forState:UIControlStateNormal];
    }else{
        iconImage = [UIImage imageNamed:@"filter_icon"];
        [_pullDownMenu setImage:iconImage forState:UIControlStateNormal];

    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadListFromServerByPageIndex:1 endRefreshing:NO];
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

    [self addHeader];
    [self addFooter];
}
-(void)CreateNoDataView{
    _noDataView = (YYNoDataView *)addNoDataView_phone(_containerView,[NSString stringWithFormat:@"%@|icon:notxt_icon",NSLocalizedString(@"未筛选到相关预约", nil)],@"919191",@"no_ordering_icon");
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
- (void)loadListFromServerByPageIndex:(int)pageIndex endRefreshing:(BOOL)endrefreshing{
    WeakSelf(ws);

    __block BOOL blockEndrefreshing = endrefreshing;
    [YYShowroomApi getOrderingCheckListWithAppointmentId:_appointmentId status:_status PageIndex:pageIndex pageSize:kPageSize andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYShowroomOrderingCheckListModel *showroomOrderingCheckListModel, NSError *error) {
        if (rspStatusAndMessage.status == YYReqStatusCode100) {
            if (pageIndex == 1) {
                [ws.dataArray removeAllObjects];
            }
            ws.currentPageInfo = showroomOrderingCheckListModel.pageInfo;

            if (showroomOrderingCheckListModel && showroomOrderingCheckListModel.result
                && [showroomOrderingCheckListModel.result count] > 0){
                [ws.dataArray addObjectsFromArray:showroomOrderingCheckListModel.result];
            }
            //如果没有数据
            if (pageIndex == 1 && _noDataView) {
                if(ws.dataArray.count){
                    ws.noDataView.hidden = YES;
                    ws.view.backgroundColor = [UIColor colorWithHex:@"f8f8f8"];
                    ws.tableView.backgroundColor = [UIColor colorWithHex:@"f8f8f8"];
                    ws.containerView.backgroundColor = [UIColor colorWithHex:@"f8f8f8"];
                }else{
                    ws.noDataView.hidden = NO;
                    if(ws.status){
                        ws.noDataView.titleLabel.text = NSLocalizedString(@"未筛选到相关预约", nil);
                    }else{
                        ws.noDataView.titleLabel.text = NSLocalizedString(@"暂无买手预约订货会", nil);
                    }
                    ws.view.backgroundColor = _define_white_color;
                    ws.tableView.backgroundColor = _define_white_color;
                    ws.containerView.backgroundColor = _define_white_color;
                }
            }
        }

        if(blockEndrefreshing){
            [ws.tableView.mj_header endRefreshing];
            [ws.tableView.mj_footer endRefreshing];
        }
        [ws.tableView reloadData];

        [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];
    }];
}
#pragma mark - --------------请求数据----------------------
-(void)RequestData{
    //获取列表数据
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_tableView.mj_header beginRefreshing];
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
    static NSString *cellid=@"YYShowroomOrderingCheckCell";
    YYShowroomOrderingCheckCell *cell=[_tableView dequeueReusableCellWithIdentifier:cellid];
    if(!cell)
    {
        cell=[[YYShowroomOrderingCheckCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid WithBlock:^(NSString *type,YYShowroomOrderingCheckModel *showroomOrderingCheckModel) {
            if([type isEqualToString:@"refuse"]){
                //拒绝
                [ws refuseOrderCheckByCheckModel:showroomOrderingCheckModel];

            }else if([type isEqualToString:@"agree"]){
                //通过
                [ws agreeOrderCheckByCheckModel:showroomOrderingCheckModel];
            }
        }];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.showroomOrderingCheckModel = _dataArray[indexPath.row];
    return cell;
}
#pragma mark -UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_dataArray.count){
        YYShowroomOrderingCheckModel *showroomOrderingCheckModel = _dataArray[indexPath.row];
        if([showroomOrderingCheckModel getEnumStatus] == YYOrderingCheckStatus_TO_BE_VERIFIED){
            //待审核
            return 232;
        }else{
            return 181.5;
        }
    }
    return 0;
}

#pragma mark - --------------自定义代理/block----------------------


#pragma mark - --------------自定义响应----------------------
-(void)GoBack:(id)sender {
    if(_cancelButtonClicked)
    {
        _cancelButtonClicked();
    }
}
-(void)userOperation{
    if(_block){
        _block(@"user_operation",_appointmentId);
    }
}
//拒绝
-(void)refuseOrderCheckByCheckModel:(YYShowroomOrderingCheckModel *)showroomOrderingCheckModel{
    WeakSelf(ws);
    NSString *ids = [[NSString alloc] initWithFormat:@"%ld",[showroomOrderingCheckModel.id integerValue]];
    [YYShowroomApi refuseOrderingApplicationWithIds:ids andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
        if(rspStatusAndMessage.status == YYReqStatusCode100){
            showroomOrderingCheckModel.status = @"REJECTED";
            [ws.tableView reloadData];
            [ws userOperation];
        }else{
            [YYToast showToastWithView:self.view title:rspStatusAndMessage.message andDuration:kAlertToastDuration];
        }
    }];
}
//通过
-(void)agreeOrderCheckByCheckModel:(YYShowroomOrderingCheckModel *)showroomOrderingCheckModel{
    WeakSelf(ws);
    NSString *ids = [[NSString alloc] initWithFormat:@"%ld",[showroomOrderingCheckModel.id integerValue]];
    [YYShowroomApi agreeOrderingApplicationWithIds:ids andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
        if(rspStatusAndMessage.status == YYReqStatusCode100){
            showroomOrderingCheckModel.status = @"VERIFIED";
            [ws.tableView reloadData];
            [ws userOperation];
        }else{
            [YYToast showToastWithView:self.view title:rspStatusAndMessage.message andDuration:kAlertToastDuration];
        }
    }];
}
#pragma mark - --------------自定义方法----------------------


#pragma mark - --------------other----------------------

@end
