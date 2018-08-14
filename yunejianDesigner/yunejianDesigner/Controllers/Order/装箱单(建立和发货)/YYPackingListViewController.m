//
//  YYPackingListViewController.m
//  yunejianDesigner
//
//  Created by yyj on 2018/6/13.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "YYPackingListViewController.h"

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "YYDeliverViewController.h"

// 自定义视图
#import "YYNavView.h"
#import "YYMenuPopView.h"
#import "MBProgressHUD.h"
#import "YYStepViewCell.h"
#import "YYPickingListInfoCell.h"
#import "YYPickingListNullCell.h"
#import "YYPickingListStyleCell.h"
#import "YYPickingListStyleEditCell.h"

// 接口
#import "YYOrderApi.h"

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "MLInputDodger.h"

#import "YYPackingListDetailModel.h"

#import "regular.h"

@interface YYPackingListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) YYNavView *navView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) UIButton *menuBtn;

@property (nonatomic, strong) YYPackingListDetailModel *packingListDetailModel;

@end

@implementation YYPackingListViewController

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
    [MobClick beginLogPageView:kYYPagePackingList];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPagePackingList];
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

    self.view.shiftHeightAsDodgeViewForMLInputDodger = 44.0f+5.0f;
    [self.view registerAsDodgeViewForMLInputDodger];

    [self createOrUpdateNavView];

    UIButton *backBtn = [UIButton getCustomImgBtnWithImageStr:@"goBack_normal" WithSelectedImageStr:nil];
    [_navView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.width.mas_equalTo(40);
        make.bottom.mas_equalTo(-1);
    }];
    
    [self createOrUpdateMenuBtn];
}
#pragma mark - --------------UIConfig----------------------
- (void)UIConfig {
    [self createOrUpdateSubmitBtn];
    [self createTableView];
}
-(void)createOrUpdateMenuBtn{
    if(_packingListType == YYPackingListTypeDetail){
        if(!_menuBtn){
            _menuBtn = [UIButton getCustomImgBtnWithImageStr:@"download_menu" WithSelectedImageStr:nil];
            [_navView addSubview:_menuBtn];
            [_menuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(0);
                make.width.mas_equalTo(70);
                make.right.mas_equalTo(-17);
            }];
            [_menuBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
            [_menuBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_menuBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            _menuBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [_menuBtn addTarget:self action:@selector(showMenuUI:) forControlEvents:UIControlEventTouchUpInside];
        }
        _menuBtn.hidden = NO;
    }else{
        if(_menuBtn){
            _menuBtn.hidden = YES;
        }
    }
}
-(void)createOrUpdateSubmitBtn{

    NSString *titleStr = nil;
    if(_packingListType == YYPackingListTypeCreate){
        titleStr = NSLocalizedString(@"保存装箱单",nil);
    }else if(_packingListType == YYPackingListTypeModify){
        titleStr = NSLocalizedString(@"保存装箱单",nil);
    }else if(_packingListType == YYPackingListTypeDetail){
        titleStr = NSLocalizedString(@"发货",nil);
    }
    if(!_submitBtn){
        _submitBtn = [UIButton getCustomTitleBtnWithAlignment:0 WithFont:15.f WithSpacing:0 WithNormalTitle:titleStr WithNormalColor:_define_white_color WithSelectedTitle:titleStr WithSelectedColor:_define_white_color];
        [self.view addSubview:_submitBtn];
        [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop).with.offset(0);
            make.height.mas_equalTo(55.f);
        }];
        [_submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    }

    if(_packingListType == YYPackingListTypeCreate || _packingListType == YYPackingListTypeModify){
        NSInteger totalSentAmount = [self getTotalSentAmount];
        if(totalSentAmount){
            _submitBtn.selected = NO;
            _submitBtn.backgroundColor = _define_black_color;
        }else{
            _submitBtn.selected = YES;
            _submitBtn.backgroundColor = [UIColor colorWithHex:@"d3d3d3"];
        }
    }else if(_packingListType == YYPackingListTypeDetail){
        _submitBtn.selected = NO;
        _submitBtn.backgroundColor = _define_black_color;
    }

    [_submitBtn setTitle:titleStr forState:UIControlStateNormal];
    [_submitBtn setTitle:titleStr forState:UIControlStateSelected];

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
-(void)createOrUpdateNavView{
    NSString *titleStr = nil;
    if(_packingListType == YYPackingListTypeCreate){
        titleStr = NSLocalizedString(@"建立装箱单",nil);
    }else if(_packingListType == YYPackingListTypeModify){
        titleStr = NSLocalizedString(@"修改装箱单",nil);
    }else if(_packingListType == YYPackingListTypeDetail){
        titleStr = NSLocalizedString(@"装箱单详情",nil);
    }
    if(!_navView){
        _navView = [[YYNavView alloc] initWithTitle:titleStr WithSuperView:self.view haveStatusView:YES];
    }else{
        _navView.navTitle = titleStr;
    }
}
#pragma mark - --------------请求数据----------------------
//仅在刚进入时候调用
- (void)RequestData {
    if(_packingListType == YYPackingListTypeCreate){
        [self getPackingListDetailToStatus:YYPackingListTypeCreate];
    }else if(_packingListType == YYPackingListTypeModify){
        //...nothing
    }else if(_packingListType == YYPackingListTypeDetail){
        [self getParcelDetail];
    }
}
//获取订单商品详情
- (void)getPackingListDetailToStatus:(YYPackingListType)packingListType{
    WeakSelf(ws);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [YYOrderApi getPackingListDetailByOrderCode:_orderCode andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYPackingListDetailModel *packingListDetailModel, NSError *error) {
        if(rspStatusAndMessage.status == YYReqStatusCode100){
            [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];
            ws.packingListDetailModel = packingListDetailModel;
            ws.packingListType = packingListType;//只有数据获取到了才给改状态
            [ws updateUI];
        }else{
            [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];
            [YYToast showToastWithView:self.view title:rspStatusAndMessage.message andDuration:kAlertToastDuration];
        }
    }];
}
//获取单个包裹单详情
-(void)getParcelDetail{
    WeakSelf(ws);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [YYOrderApi getParcelDetailByPackageId:_packageId andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYPackingListDetailModel *packingListDetailModel, NSError *error) {
        if(rspStatusAndMessage.status == YYReqStatusCode100){
            [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];
            ws.packingListDetailModel = packingListDetailModel;
            ws.packingListType = YYPackingListTypeDetail;//只有数据获取到了才给改状态
            [ws updateUI];
        }else{
            [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];
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
        return 82;
    }else if(indexPath.row/2 == 1){
        return [YYPickingListInfoCell cellHeight];
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
        YYStepViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YYStepViewCell class])];
        if (!cell) {
            cell = [[YYStepViewCell alloc] initWithStepStyle:StepStyleFourStep reuseIdentifier:NSStringFromClass([YYStepViewCell class])];
            cell.firtTitle = NSLocalizedString(@"建立装箱单_short",nil);
            cell.secondTitle = NSLocalizedString(@"待发货",nil);
            cell.thirdTitle = NSLocalizedString(@"在途中",nil);
            cell.fourthTitle = NSLocalizedString(@"已收货",nil);
        }
        if(_packingListType == YYPackingListTypeCreate){
            cell.currentStep = 0;
        }else if(_packingListType == YYPackingListTypeModify){
            cell.currentStep = 0;
        }else if(_packingListType == YYPackingListTypeDetail){
            cell.currentStep = 1;
        }
        [cell updateUI];
        return cell;
    }else if(indexPath.row/2 == 1){
        static NSString *cellid = @"YYPickingListInfoCell";
        YYPickingListInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellid];
        if(!cell){
            cell = [[YYPickingListInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.packingListDetailModel = _packingListDetailModel;
        [cell updateUI];
        return cell;
    }

    if(_packingListType == YYPackingListTypeDetail){
        static NSString *cellid = @"YYPickingListStyleCell";
        YYPickingListStyleCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellid];
        if(!cell){
            cell = [[YYPickingListStyleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid styleType:YYPickingListStyleTypeNormal];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        YYPackingListStyleModel *packingListStyleModel = _packingListDetailModel.styleColors[(indexPath.row - 4)/2];
        cell.packingListStyleModel = packingListStyleModel;
        [cell updateUI];
        return cell;
    }else{
        WeakSelf(ws);
        static NSString *cellid = @"YYPickingListStyleEditCell";
        YYPickingListStyleEditCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellid];
        if(!cell){
            cell = [[YYPickingListStyleEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid WithBlock:^(NSString *type) {
                if([type isEqualToString:@"update_submit_status"]){
                    //更新submit按钮状态
                    [ws createOrUpdateSubmitBtn];
                }
            }];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        YYPackingListStyleModel *packingListStyleModel = _packingListDetailModel.styleColors[(indexPath.row - 4)/2];
        cell.packingListStyleModel = packingListStyleModel;
        [cell updateUI];
        return cell;
    }
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
-(void)showMenuUI:(id)sender{
    NSArray *menuData = @[NSLocalizedString(@"修改",nil)];
    NSArray *menuIconData = @[@"download_update"];
    NSInteger menuUIHeight = 46 * menuData.count;

    NSInteger menuUIWidth = 110;

    CGPoint p = [self.menuBtn convertPoint:CGPointMake(CGRectGetWidth(self.menuBtn.frame), CGRectGetHeight(self.menuBtn.frame)) toView:self.view];
    WeakSelf(ws);
    [YYMenuPopView addPellTableViewSelectWithWindowFrame:CGRectMake(p.x-menuUIWidth+5, p.y, menuUIWidth, menuUIHeight) selectData:menuData images:menuIconData textAlignment:NSTextAlignmentLeft action:^(NSInteger index) {
        if(index > -1)
            [ws menuBtnHandler:index];
    } animated:YES arrowImage:YES  arrowPositionInfo:nil];
}
//修改装箱单
-(void)menuBtnHandler:(NSInteger)index{
    if(_packingListDetailModel){
        if(index == 0){
            //修改装箱单
            [self modifyPackingList];
        }
    }
}
//修改装箱单
-(void)modifyPackingList{
    [self getPackingListDetailToStatus:YYPackingListTypeModify];
}
//submit
-(void)submitAction:(UIButton *)sender{
    if(!sender.selected){
        if(_packingListType == YYPackingListTypeCreate || _packingListType == YYPackingListTypeModify){
            //保存
            [self savePackingList];
        }else if(_packingListType == YYPackingListTypeDetail){
            //发货
            [self gotoDeliverView];
        }
    }
}
//跳转发货页
-(void)gotoDeliverView{
    WeakSelf(ws);
    YYDeliverViewController *deliverViewController = [[YYDeliverViewController alloc] init];
    [deliverViewController setCancelButtonClicked:^{
        [ws.navigationController popViewControllerAnimated:YES];
    }];
    [deliverViewController setModifySuccess:^{
        [ws.navigationController popViewControllerAnimated:NO];
        if(ws.modifySuccess){
            ws.modifySuccess();
        }
    }];
    deliverViewController.packingListDetailModel = _packingListDetailModel;
    [self.navigationController pushViewController:deliverViewController animated:YES];
}
//保存装箱单
-(void)savePackingList{
    WeakSelf(ws);
    //仅修改和新建可操作
    if(_packingListType == YYPackingListTypeCreate || _packingListType == YYPackingListTypeModify){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [YYOrderApi savePackingListByDetailModel:_packingListDetailModel andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,NSNumber *packageId,NSError *error) {
            if(rspStatusAndMessage.status == YYReqStatusCode100){

                ws.packageId = packageId;
                [ws getParcelDetail];

            }else{
                [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];
                [YYToast showToastWithView:self.view title:rspStatusAndMessage.message andDuration:kAlertToastDuration];
            }
        }];
    }
}
-(void)goBack:(id)sender {
    if(_cancelButtonClicked){
        _cancelButtonClicked();
    }
}

#pragma mark - --------------自定义方法----------------------
-(void)updateUI{
    if(_packingListDetailModel){

        [regular dismissKeyborad];

        //更新标题、submit、menu按钮
        [self createOrUpdateNavView];
        [self createOrUpdateSubmitBtn];
        [self createOrUpdateMenuBtn];

        [_tableView reloadData];

    }
}
//算一遍到底有多少的sentAmount
-(NSInteger)getTotalSentAmount{
    NSInteger totalSentAmount = 0;
    if(_packingListDetailModel){
        for (YYPackingListStyleModel *packingListStyleModel in _packingListDetailModel.styleColors) {
            for (YYPackingListSizeModel *packingListSizeModel in packingListStyleModel.color.sizes) {
                totalSentAmount += [packingListSizeModel.sentAmount integerValue];
            }
        }
    }
    return totalSentAmount;
}
#pragma mark - --------------other----------------------

@end
