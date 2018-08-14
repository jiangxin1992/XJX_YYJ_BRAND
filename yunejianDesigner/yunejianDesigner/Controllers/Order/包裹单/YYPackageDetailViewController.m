//
//  YYPackageDetailViewController.m
//  yunejianDesigner
//
//  Created by yyj on 2018/6/28.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "YYPackageDetailViewController.h"

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "YYParcelExceptionDetailViewController.h"

// 自定义视图
#import "YYNavView.h"
#import "MBProgressHUD.h"
#import "YYLogisticsDetailView.h"
#import "YYPackageLogisticsInfoCell.h"
#import "YYPackageAddressInfoCell.h"
#import "YYPickingListNullCell.h"
#import "YYPickingListStyleCell.h"

// 接口
#import "YYOrderApi.h"

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYPackageModel.h"
#import "YYPackingListStyleModel.h"
#import "YYPackingListDetailModel.h"

#import "regular.h"

@interface YYPackageDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) YYNavView *navView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YYLogisticsDetailView *logisticsDetailView;

@property (nonatomic, strong) YYPackingListDetailModel *packingListDetailModel;

@end

@implementation YYPackageDetailViewController

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
    [MobClick beginLogPageView:kYYPagePackageDetail];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPagePackageDetail];
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

}
- (void)PrepareUI {
    self.view.backgroundColor = _define_white_color;

    _navView = [[YYNavView alloc] initWithTitle:_packageName WithSuperView:self.view haveStatusView:YES];

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
}

#pragma mark - --------------请求数据----------------------
- (void)RequestData {
    [self getParcelDetail];
}
//获取单个包裹单详情
-(void)getParcelDetail{
    WeakSelf(ws);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [YYOrderApi getParcelDetailByPackageId:_packageModel.packageId andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYPackingListDetailModel *packingListDetailModel, NSError *error) {
        [hud hideAnimated:YES];
        if(rspStatusAndMessage.status == YYReqStatusCode100){
            ws.packingListDetailModel = packingListDetailModel;
            [ws updateUI];
        }else{
            [YYToast showToastWithView:self.view title:rspStatusAndMessage.message andDuration:kAlertToastDuration];
        }
    }];

}
#pragma mark - --------------系统代理----------------------
#pragma mark - TableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!_packingListDetailModel){
        //数据还未加载出来
        return 0;
    }

    if(indexPath.row%2 == 1){
        if(indexPath.row < 4 + _packingListDetailModel.styleColors.count*2 - 1){
            return [YYPickingListNullCell cellHeight];
        }else{
            return 1;
        }
    }else if(indexPath.row/2 == 0){
        if([_packingListDetailModel.express.message isEqualToString:@"ok"] && ![NSArray isNilOrEmpty:_packingListDetailModel.express.data]){
            return UITableViewAutomaticDimension;
        }else{
            return 100;
        }
    }else if(indexPath.row/2 == 1){
        return UITableViewAutomaticDimension;
    }
    YYPackingListStyleModel *packingListStyleModel = _packingListDetailModel.styleColors[(indexPath.row - 4)/2];
    if(packingListStyleModel.color.sizes.count){
        return 151 + 70 + (packingListStyleModel.color.sizes.count - 1)*50;
    }else{
        return 151 + 70;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!_packingListDetailModel){
        //数据还未加载出来
        return 0;
    }
    return 4 + _packingListDetailModel.styleColors.count*2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeakSelf(ws);
    if(!_packingListDetailModel){
        static NSString *cellid = @"cellid";
        UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellid];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    
    if(indexPath.row%2 == 1){
        static NSString *cellid = @"YYPickingListNullCell";
        YYPickingListNullCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellid];
        if(!cell){
            cell = [[YYPickingListNullCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }else if(indexPath.row/2 == 0){
        static NSString *cellid = @"YYPackageLogisticsInfoCell";
        YYPackageLogisticsInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellid];
        if(!cell){
            cell = [[YYPackageLogisticsInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid WithBlock:^(NSString *type) {
                if([type isEqualToString:@"checkError"]){
                    [ws checkError];
                }else if([type isEqualToString:@"checkLogisticsInfo"]){
                    [ws checkLogisticsInfo];
                }
            }];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.packingListDetailModel = _packingListDetailModel;
        [cell updateUI];
        return cell;
    }else if(indexPath.row/2 == 1){
        static NSString *cellid = @"YYPackageAddressInfoCell";
        YYPackageAddressInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellid];
        if(!cell){
            cell = [[YYPackageAddressInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.packingListDetailModel = _packingListDetailModel;
        [cell updateUI];
        return cell;
    }

    static NSString *cellid = @"YYPickingListStyleCell";
    YYPickingListStyleCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellid];
    if(!cell){
        YYPickingListStyleType styleType = YYPickingListStyleTypePackage;
        if([_packageModel.status isEqualToString:@"RECEIVED"]){
            // 已收货
            styleType = YYPickingListStyleTypePackageError;
        }
        cell = [[YYPickingListStyleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid styleType:styleType];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    YYPackingListStyleModel *packingListStyleModel = _packingListDetailModel.styleColors[(indexPath.row - 4)/2];
    cell.packingListStyleModel = packingListStyleModel;
    [cell updateUI];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [regular dismissKeyborad];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [regular dismissKeyborad];
}

#pragma mark - --------------自定义代理/block----------------------


#pragma mark - --------------自定义响应----------------------
-(void)goBack:(id)sender {
    if(_cancelButtonClicked){
        _cancelButtonClicked();
    }
}

#pragma mark - --------------自定义方法----------------------
-(void)updateUI{
    if(_packingListDetailModel){

        [regular dismissKeyborad];

        [_tableView reloadData];

    }
}
//查看异常反馈
-(void)checkError{

    WeakSelf(ws);
    YYParcelExceptionDetailViewController *parcelExceptionDetailView = [[YYParcelExceptionDetailViewController alloc] init];
    parcelExceptionDetailView.packageId = _packingListDetailModel.packageId;
    [parcelExceptionDetailView setCancelButtonClicked:^{
        [ws.navigationController popViewControllerAnimated:YES];
    }];
    [self.navigationController pushViewController:parcelExceptionDetailView animated:YES];
    
}
//查看物流信息
-(void)checkLogisticsInfo{

    WeakSelf(ws);
    if(!_logisticsDetailView){
        _logisticsDetailView = [[YYLogisticsDetailView alloc] init];
        [self.view addSubview:_logisticsDetailView];
        [_logisticsDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(ws.view);
        }];
        [_logisticsDetailView setCancelButtonClicked:^{
            ws.logisticsDetailView.hidden = YES;
        }];
    }
    _logisticsDetailView.hidden = NO;
    _logisticsDetailView.packingListDetailModel = _packingListDetailModel;
    [_logisticsDetailView updateUI];

}
#pragma mark - --------------other----------------------

@end
