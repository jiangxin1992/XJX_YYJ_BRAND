//
//  YYDeliverViewController.m
//  yunejianDesigner
//
//  Created by yyj on 2018/6/19.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "YYDeliverViewController.h"

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "YYChooseLogisticsViewController.h"
#import "YYChooseWarehouseViewController.h"
#import "YYDeliverModifyAddressViewController.h"

// 自定义视图
#import "YYNavView.h"
#import "MBProgressHUD.h"
#import "YYStepViewCell.h"
#import "YYDeliverCustomCell.h"
#import "YYPickingListNullCell.h"
#import "YYDeliverAddressInfoCell.h"

// 接口
#import "YYOrderApi.h"

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYQRCode.h"

#import "YYDeliverModel.h"
#import "YYWarehouseModel.h"
#import "YYExpressCompanyModel.h"
#import "YYPackingListDetailModel.h"

#import "regular.h"
#import "YYVerifyTool.h"

@interface YYDeliverViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) YYNavView *navView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *submitBtn;

@property (strong, nonatomic) NSNumber *buyerStockEnabled;//此单的买手店库存是否已经开通 bool

@property (nonatomic, strong) YYDeliverModel *deliverModel;

@end

@implementation YYDeliverViewController

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
    [MobClick beginLogPageView:kYYPageDeliver];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageDeliver];
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
    _deliverModel = [[YYDeliverModel alloc] initWithPackingListDetailModel:_packingListDetailModel];//_deliverModel初始化
    _buyerStockEnabled = _packingListDetailModel.buyerStockEnabled;
}
- (void)PrepareUI {
    self.view.backgroundColor = _define_white_color;

    _navView = [[YYNavView alloc] initWithTitle:NSLocalizedString(@"发货",nil) WithSuperView:self.view haveStatusView:YES];

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
    [self createOrUpdateSubmitBtn];
    [self createTableView];
}
-(void)createOrUpdateSubmitBtn{

    if(!_submitBtn){
        _submitBtn = [UIButton getCustomTitleBtnWithAlignment:0 WithFont:15.f WithSpacing:0 WithNormalTitle:NSLocalizedString(@"确认发货",nil) WithNormalColor:_define_white_color WithSelectedTitle:NSLocalizedString(@"确认发货",nil) WithSelectedColor:_define_white_color];
        [self.view addSubview:_submitBtn];
        [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop).with.offset(0);
            make.height.mas_equalTo(55.f);
        }];
        [_submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    }

    if([_deliverModel canDeliverWithBuyerStockEnabled:[_buyerStockEnabled boolValue]]){
        _submitBtn.selected = NO;
        _submitBtn.backgroundColor = _define_black_color;
    }else{
        _submitBtn.selected = YES;
        _submitBtn.backgroundColor = [UIColor colorWithHex:@"d3d3d3"];
    }
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
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(ws.submitBtn.mas_top).with.offset(0);
    }];
}

#pragma mark - --------------请求数据----------------------
- (void)RequestData {

}

#pragma mark - --------------系统代理----------------------
#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return 82;
    }else if(indexPath.row == 1){
        return [YYPickingListNullCell cellHeight];
    }else if(indexPath.row == 2){
        BOOL isValidAddress = [_deliverModel isValidAddressWithBuyerStockEnabled:[_buyerStockEnabled boolValue]];
        if(isValidAddress){
            return UITableViewAutomaticDimension;
        }
    }
    return 55;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeakSelf(ws);

    if(indexPath.row == 0){
        YYStepViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YYStepViewCell class])];
        if (!cell) {
            cell = [[YYStepViewCell alloc] initWithStepStyle:StepStyleFourStep reuseIdentifier:NSStringFromClass([YYStepViewCell class])];
            cell.firtTitle = NSLocalizedString(@"建立装箱单_short",nil);
            cell.secondTitle = NSLocalizedString(@"待发货",nil);
            cell.thirdTitle = NSLocalizedString(@"在途中",nil);
            cell.fourthTitle = NSLocalizedString(@"已收货",nil);
            cell.currentStep = 1;
        }
        [cell updateUI];
        return cell;

    }else if(indexPath.row == 1){
        static NSString *cellid = @"YYPickingListNullCell";
        YYPickingListNullCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellid];
        if(!cell){
            cell = [[YYPickingListNullCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }else if(indexPath.row == 2){
        BOOL isValidAddress = [_deliverModel isValidAddressWithBuyerStockEnabled:[_buyerStockEnabled boolValue]];
        if(isValidAddress){
            static NSString *cellid = @"YYDeliverAddressInfoCell";
            YYDeliverAddressInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellid];
            if(!cell){
                cell = [[YYDeliverAddressInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.deliverModel = _deliverModel;
            [cell updateUI];
            return cell;
        }
    }
    
    static NSString *cellid = @"YYDeliverCustomCell";
    YYDeliverCustomCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellid];
    if(!cell){
        cell = [[YYDeliverCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid WithBlock:^(NSString *type, NSString *value) {
            if([type isEqualToString:@"scan"]){
                [ws sweepYardButtonClicked];
            }else if([type isEqualToString:@"logisticsCode"]){
                ws.deliverModel.logisticsCode = value;
                [ws updateUI];
            }
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.deliverModel = _deliverModel;
    cell.buyerStockEnabled = _buyerStockEnabled;
    if(indexPath.row == 2){
        cell.deliverCellType = YYDeliverCellTypeReceiverAddress;
    }else if(indexPath.row == 3){
        cell.deliverCellType = YYDeliverCellTypeLogisticsName;
    }else if(indexPath.row == 4){
        cell.deliverCellType = YYDeliverCellTypeLogisticsCode;
    }
    [cell updateUI];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 2){
        //编辑收件地址/选择仓库地址
        [self chooseReceiverAddress];

    }else if(indexPath.row == 3){
        //选择物流公司
        [self chooseLogistics];
    }else{
        [regular dismissKeyborad];
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [regular dismissKeyborad];
}

#pragma mark - --------------自定义代理/block----------------------

#pragma mark - --------------自定义响应----------------------
//submit
-(void)submitAction:(UIButton *)sender{
    if(!sender.selected){
        //确认发货
        NSData *jsonData = [[_deliverModel toDictionary] mj_JSONData];

        WeakSelf(ws);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [YYOrderApi saveDeliverPackageByJsonData:jsonData andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
            if(rspStatusAndMessage.status == YYReqStatusCode100){
                [hud hideAnimated:YES];
                [YYToast showToastWithTitle:NSLocalizedString(@"发货成功！",nil) andDuration:kAlertToastDuration];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //返回到入口页面，再进入或刷新订单详情页
                        if(ws.modifySuccess){
                            ws.modifySuccess();
                        }
                    });
                });

            }else{
                [hud hideAnimated:YES];
                [YYToast showToastWithView:self.view title:rspStatusAndMessage.message andDuration:kAlertToastDuration];
            }
        }];
    }
}
/**
请选择收件地址/请编辑收件地址
 */
-(void)chooseReceiverAddress{
    if([_buyerStockEnabled boolValue]){
//        跳转去仓库
        [self gotoChooseWarehouseView];
    }else{
//        请编辑收件地址
        [self gotoDeliverModifyAddressView];
    }
}
/**
 请编辑收件地址
 */
-(void)gotoDeliverModifyAddressView{
    WeakSelf(ws);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Account" bundle:[NSBundle mainBundle]];
    YYDeliverModifyAddressViewController *deliverModifyAddressViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYDeliverModifyAddressViewController"];
    deliverModifyAddressViewController.deliverModel = _deliverModel;
    [deliverModifyAddressViewController setCancelButtonClicked:^{
        [ws.navigationController popViewControllerAnimated:YES];
    }];
    [deliverModifyAddressViewController setModifySuccess:^{
        [ws updateUI];
        [ws.navigationController popViewControllerAnimated:YES];
    }];
    [self.navigationController pushViewController:deliverModifyAddressViewController animated:YES];
}
/**
 跳转去仓库
 */
-(void)gotoChooseWarehouseView{
    WeakSelf(ws);
    YYChooseWarehouseViewController *chooseWarehouseViewController = [[YYChooseWarehouseViewController alloc] init];
    chooseWarehouseViewController.buyerId = _packingListDetailModel.buyerId;
    [chooseWarehouseViewController setCancelButtonClicked:^{
        [ws.navigationController popViewControllerAnimated:YES];
    }];
    [chooseWarehouseViewController setChooseWarehouseSelectBlock:^(YYWarehouseModel *warehouseModel) {
        ws.deliverModel.receiverAddress = warehouseModel.address;
        ws.deliverModel.warehouseId = warehouseModel.id;
        ws.deliverModel.warehouseName = warehouseModel.name;
        ws.deliverModel.receiverPhone = warehouseModel.phone;
        ws.deliverModel.receiver = warehouseModel.receiver;
        [ws updateUI];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.navigationController pushViewController:chooseWarehouseViewController animated:YES];
}
//选择物流公司
-(void)chooseLogistics{
    WeakSelf(ws);
    YYChooseLogisticsViewController *chooseLogisticsViewController = [[YYChooseLogisticsViewController alloc] init];
    [chooseLogisticsViewController setCancelButtonClicked:^{
        [ws.navigationController popViewControllerAnimated:YES];
    }];
    [chooseLogisticsViewController setChooseLogisticsSelectBlock:^(YYExpressCompanyModel *expressCompanyModel) {
        ws.deliverModel.logisticsName = expressCompanyModel.name;
        [ws updateUI];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.navigationController pushViewController:chooseLogisticsViewController animated:YES];
}
//扫码物流编号
-(void)sweepYardButtonClicked{
    WeakSelf(ws);
    YYQRCodeController *QRCode = [YYQRCodeController QRCodeSuccessMessageBlock:^(YYQRCodeController *code, NSString *messageString) {

        if([YYVerifyTool inputShouldLetterOrNum:messageString]){
            ws.deliverModel.logisticsCode = messageString;
            [ws updateUI];
            [code dismissController];
        }else{
            [code toast:NSLocalizedString(@"抱歉，您扫描内容不正确！",nil) collback:^(YYQRCodeController *code) {
                [code scanningAgain];
            }];
        }
    }];

    [self presentViewController:QRCode animated:YES completion:nil];
}
-(void)goBack:(id)sender {
    if(_cancelButtonClicked){
        _cancelButtonClicked();
    }
}
#pragma mark - --------------自定义方法----------------------
-(void)updateUI{
    //主要是submit按钮
    [self createOrUpdateSubmitBtn];

    [_tableView reloadData];
}

#pragma mark - --------------other----------------------

@end
