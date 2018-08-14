//
//  YYOriginalOrderDetailViewController.m
//  yunejianDesigner
//
//  Created by yyj on 2018/7/5.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "YYOriginalOrderDetailViewController.h"

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "YYCustomCellTableViewController.h"

// 自定义视图
#import "YYNavView.h"
#import "YYSelecteDateView.h"
#import "YYNewStyleDetailCell.h"
#import "YYOrderDetailSectionHead.h"

// 接口

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYOrderInfoModel.h"
#import "YYOrderTransStatusModel.h"

@interface YYOriginalOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) YYNavView *navView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation YYOriginalOrderDetailViewController

#pragma mark - --------------生命周期--------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 进入埋点
    [MobClick beginLogPageView:kYYPageOriginalOrderDetail];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageOriginalOrderDetail];
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

    _navView = [[YYNavView alloc] initWithTitle:NSLocalizedString(@"初始订单",nil) WithSuperView:self.view haveStatusView:YES];

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

#pragma mark - --------------系统代理----------------------
#pragma mark -UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_currentYYOrderInfoModel
        && _currentYYOrderInfoModel.groups
        && [_currentYYOrderInfoModel.groups count] > 0) {
        return [_currentYYOrderInfoModel.groups count];
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    int rows = 0;
    if (_currentYYOrderInfoModel
        && _currentYYOrderInfoModel.groups
        && [_currentYYOrderInfoModel.groups count] > 0) {
        YYOrderOneInfoModel *orderOneInfoModel = _currentYYOrderInfoModel.groups[section];
        if (orderOneInfoModel.styles
            && [orderOneInfoModel.styles count] > 0) {
            rows = (int)[orderOneInfoModel.styles count];
        }
    }
    return rows;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (!_currentYYOrderInfoModel){
        return 0;
    }

    NSInteger styleBuyedSizeCount = 0;
    NSInteger styleTotalNum = 0;
    YYOrderOneInfoModel *orderOneInfoModel =  [_currentYYOrderInfoModel.groups objectAtIndex:indexPath.section];
    if (orderOneInfoModel && indexPath.row < [orderOneInfoModel.styles count]) {
        YYOrderStyleModel *styleModel = [orderOneInfoModel.styles objectAtIndex:indexPath.row];
        if (styleModel.colors
            && [styleModel.colors count] > 0) {
            for (int i=0; i<[styleModel.colors count]; i++) {
                YYOrderOneColorModel *orderOneColorModel = [styleModel.colors objectAtIndex:i];

                BOOL isColorSelect = [orderOneColorModel.isColorSelect boolValue];

                //isModifyNow 0 没有修改
                if(isColorSelect){
                    styleBuyedSizeCount += 1;
                }else{
                    //判断amount是不是大于0
                    for (YYOrderSizeModel *sizeModel in orderOneColorModel.sizes) {
                        if([sizeModel.amount integerValue] > 0){
                            styleBuyedSizeCount ++;
                        }
                    }
                }

                for (YYOrderSizeModel *sizeModel in orderOneColorModel.sizes) {
                    if([sizeModel.amount integerValue] > 0){
                        styleTotalNum += [sizeModel.amount integerValue];
                    }
                }
            }
        }
        BOOL showMinAmount = (styleTotalNum < [styleModel.orderAmountMin integerValue]);
        return [YYNewStyleDetailCell CellHeight:styleBuyedSizeCount showHelpFlag:showMinAmount showTopHeader:[orderOneInfoModel isInStock]];
    }
    return [YYNewStyleDetailCell CellHeight:styleBuyedSizeCount showHelpFlag:NO showTopHeader:[orderOneInfoModel isInStock]];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(!_currentYYOrderInfoModel){
        return nil;
    }
    YYOrderOneInfoModel *orderOneInfoModel = [_currentYYOrderInfoModel.groups objectAtIndex:section];
    if (![orderOneInfoModel isInStock]) {
        static NSString *CellIdentifier = @"YYOrderDetailSectionHead";

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OrderDetail" bundle:[NSBundle mainBundle]];
        YYCustomCellTableViewController *customCellTableViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYCustomCellTableViewController"];
        YYOrderOneInfoModel *orderOneInfoModel =  [_currentYYOrderInfoModel.groups objectAtIndex:section];

        YYOrderDetailSectionHead *sectionHead = [customCellTableViewController.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        sectionHead.orderOneInfoModel = orderOneInfoModel;
        sectionHead.isHiddenSelectDateView = YES;
        [sectionHead updateUI];
        YYSelecteDateView *selecteDateView = (YYSelecteDateView *)[sectionHead viewWithTag:90008];
        sectionHead.contentView.backgroundColor = [UIColor whiteColor];
        selecteDateView.backgroundColor = [UIColor whiteColor];
        return sectionHead;
    } else {
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(!_currentYYOrderInfoModel){
        return 0.1;
    }
    YYOrderOneInfoModel *orderOneInfoModel = _currentYYOrderInfoModel.groups[section];
    if ([orderOneInfoModel isInStock]) {
        return 0.1;
    } else {
        return 40;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeakSelf(ws);
    if(!_currentYYOrderInfoModel){
        static NSString *cellid = @"cellid";
        UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellid];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }

    static NSString *CellIdentifier = @"YYNewStyleDetailCell";
    YYNewStyleDetailCell *cell =  [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OrderDetail" bundle:[NSBundle mainBundle]];
        YYCustomCellTableViewController *customCellTableViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYCustomCellTableViewController"];
        cell = [customCellTableViewController.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    if (_currentYYOrderInfoModel && _currentYYOrderInfoModel.groups && [_currentYYOrderInfoModel.groups count] > 0) {
        YYOrderOneInfoModel *orderOneInfoModel = _currentYYOrderInfoModel.groups[indexPath.section];
        if (orderOneInfoModel.styles && [orderOneInfoModel.styles count] > 0) {
            YYOrderStyleModel *orderStyleModel = [orderOneInfoModel.styles objectAtIndex:indexPath.row];
            orderStyleModel.curType = _currentYYOrderInfoModel.curType;
            YYOrderSeriesModel *orderSeriesModel = self.currentYYOrderInfoModel.seriesMap[[orderStyleModel.seriesId stringValue]];
            cell.orderStyleModel = orderStyleModel;
            cell.orderOneInfoModel = orderOneInfoModel;
            cell.orderSeriesModel = orderSeriesModel;
        }
    }
    NSInteger transStatus = getOrderTransStatus(self.currentYYOrderTransStatusModel.designerTransStatus, self.currentYYOrderTransStatusModel.buyerTransStatus);
    if(transStatus == YYOrderCode_DELIVERING){
        cell.isReceived = YES;
    }else{
        cell.isReceived = NO;
    }
    cell.menuData = _menuData;
    cell.showRemarkButton = YES;
    cell.isModifyNow = 0;
    cell.indexPath = indexPath;
    cell.selectTaxType = getPayTaxTypeFormServiceNew(ws.menuData,[ws.currentYYOrderInfoModel.taxRate integerValue]);
    [cell updateUI];
    return cell;
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
    [_currentYYOrderInfoModel toPreData];
    [_tableView reloadData];
}

#pragma mark - --------------other----------------------

@end
