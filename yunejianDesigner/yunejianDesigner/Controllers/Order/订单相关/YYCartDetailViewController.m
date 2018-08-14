//
//  YYCartDetailViewController.m
//  Yunejian
//
//  Created by lixuezhi on 15/8/17.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYCartDetailViewController.h"

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "YYCustomCellTableViewController.h"
#import "YYTaxChooseViewController.h"
#import "YYNavigationBarViewController.h"

// 自定义视图
#import "YYNewStyleDetailCell.h"
#import "MLInputDodger.h"
#import "YYDiscountView.h"
#import "ASPopUpView.h"

// 接口
#import "YYOrderApi.h"
#import "YYUserApi.h"

// 分类
#import "UIImage+Tint.h"
#import "UIView+UpdateAutoLayoutConstraints.h"

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYUser.h"
#import "YYOrderOneColorModel.h"
#import "YYOrderOneInfoModel.h"
#import "YYOrderStyleModel.h"
#import "YYOrderInfoModel.h"
#import "YYOrderStyleModifyReslutModel.h"
#import "YYStylesAndTotalPriceModel.h"

#import "AppDelegate.h"
#import "UserDefaultsMacro.h"

@interface YYCartDetailViewController ()<UITableViewDataSource, UITableViewDelegate ,YYTableCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) YYNavigationBarViewController *navigationBarViewController;

@property (nonatomic, strong) NSMutableArray *orderInfoArray;
@property (nonatomic, strong) AppDelegate *appdelegate;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIButton *buildOrderBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@property (weak, nonatomic) IBOutlet UIButton *finishEditBtn;

@property (nonatomic, assign) BOOL isOrderEdit;

@property (nonatomic,strong) UIView *noDataView;

@property(nonatomic,strong) YYStylesAndTotalPriceModel *stylesAndTotalPriceModel;//总数

@property (nonatomic, strong)NSMutableArray *styleModifyReslut;//过期的款式ids

@property (nonatomic,assign) NSInteger selectBrandIndex;
@property (nonatomic,strong) NSMutableArray *hidesectionKeyArr;

@property (nonatomic, assign) BOOL isFirstload;
@property (nonatomic, assign)NSInteger curCartModelDesignerId ;
//税制
@property (weak, nonatomic) IBOutlet UIButton *taxTypeBtn;
@property (assign, nonatomic) NSInteger selectTaxType;
@property (strong, nonatomic) ASPopUpView *popUpView;

@property (strong, nonatomic) NSString *minOrderMoneyTip;

@property (weak, nonatomic) IBOutlet UIButton *minOrderMoneyBtn1;
@property (weak, nonatomic) IBOutlet UIButton *minOrderMoneyBtn2;
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet YYDiscountView *priceTotalDiscountView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *minOrderMoneyTipLayoutLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countLabelLayoutBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderBtnWidthLayout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *minOrderMoneyRightLength;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceTotalRightLength;

@property (nonatomic,strong) NSMutableArray *menuData;
@end

@implementation YYCartDetailViewController
#pragma mark - --------------生命周期--------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(_isFirstload){
        [self loadShoppingCarData];
    }
    _isFirstload = YES;
    // 进入埋点
    [MobClick beginLogPageView:kYYPageCartDetail];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageCartDetail];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)OnTapBg:(UITapGestureRecognizer *)sender{
    [self hidePopUpViewAnimated:NO];
}

- (void)showPopUpViewAnimated:(BOOL)animated
{
    if (self.popUpView.alpha == 1.0) return;
    [self.popUpView showAnimated:animated];
}

- (void)hidePopUpViewAnimated:(BOOL)animated
{
    if (self.popUpView.alpha == 0.0) return;
    //    WeakSelf(weakSelf);
    [self.popUpView hideAnimated:animated completionBlock:^{
        //weakSelf.popUpView = nil;
    }];
}
#pragma mark - --------------SomePrepare--------------
- (void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
- (void)PrepareData{
    _menuData = getPayTaxInitData();
    _selectTaxType = 0;

    //获取appdelegate的存储信息
    _appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _curCartModelDesignerId = [_appdelegate.cartModel.designerId integerValue];

    _hidesectionKeyArr = [[NSMutableArray alloc] init];

    [self loadShoppingCarData];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateShoppingCarNotification:) name:kUpdateShoppingCarNotification object:nil];
}
- (void)updateShoppingCarNotification:(NSNotification *)note{
    [self loadShoppingCarData];
    if(_selectBrandIndex > -1 && [_orderInfoArray count] > 0){
        YYOrderInfoModel * orderIndoModel = [_orderInfoArray objectAtIndex:_selectBrandIndex];
        [self updateCurSelectPriceInfo:orderIndoModel];
    }
    [self.tableView reloadData];
}
- (void)PrepareUI{

    self.countLab.font = [UIFont systemFontOfSize:IsPhone6_gt?15.0f:12.0f];
    self.countLab.adjustsFontSizeToFitWidth = YES;
    _orderBtnWidthLayout.constant = IsPhone6_gt?120.0f:100.0f;
    [_buildOrderBtn.titleLabel setFont:[UIFont systemFontOfSize:IsPhone6_gt?18.0f:15.0f]];
    _minOrderMoneyRightLength.constant = IsPhone6_gt?15:5;
    _priceTotalRightLength.constant = IsPhone6_gt?15:5;

    self.tableView.shiftHeightAsDodgeViewForMLInputDodger = 44.0f+5.0f;
    [self.tableView registerAsDodgeViewForMLInputDodger];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self finishEditBtnAction:nil];

    if([_orderInfoArray count] <= 0) {
        self.noDataView = addNoDataView_phone(self.view,NSLocalizedString(@"暂无数据",nil),nil,nil);
    }

    if([_orderInfoArray count] > 0){
        _selectBrandIndex = 0;
        YYOrderInfoModel * orderIndoModel = [_orderInfoArray objectAtIndex:_selectBrandIndex];
        [self updateCurSelectPriceInfo:orderIndoModel];
    }else{
        _selectBrandIndex = -1;
    }
    //验证失效
    for (YYOrderInfoModel * orderInfoModel in _orderInfoArray) {
        [self checkStyleModify:orderInfoModel callBack:nil];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBg:)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{
    [self createNavigationBarView];
}
-(void)createNavigationBarView{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YYNavigationBarViewController *navigationBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNavigationBarViewController"];
    navigationBarViewController.previousTitle = @"";
    self.navigationBarViewController = navigationBarViewController;
    navigationBarViewController.nowTitle = NSLocalizedString(@"购物车",nil);
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
            [ws backBtnAction:nil];//appdelegate的恢复信息
            blockVc = nil;
        }
    }];
}
//#pragma mark - --------------请求数据----------------------
//-(void)RequestData{}

#pragma mark - --------------系统代理----------------------
#pragma mark -UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([_orderInfoArray count] > 0) {
        return [_orderInfoArray count];
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_orderInfoArray count] > 0) {
        NSInteger totalStylesCount = 0;
        YYOrderInfoModel * orderIndoModel = [_orderInfoArray objectAtIndex:section];
        for (YYOrderOneInfoModel * orderOneInfo in orderIndoModel.groups){
            totalStylesCount += [orderOneInfo.styles count];
        }
        return totalStylesCount;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *styleInfo = [self getCellStyleInfo:indexPath];
    NSString *sectionKey = [NSString stringWithFormat:@"%ld",(long)indexPath.section];//indexPath.section
    if(styleInfo ==nil || [_hidesectionKeyArr containsObject:sectionKey]){
        static NSString *CellIdentifier = @"YYNullCell";

        UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
    cell.isReceived = NO;
    cell.menuData = _menuData;
    cell.selectTaxType = _selectTaxType;
    cell.orderStyleModel = [styleInfo objectAtIndex:1];
    cell.orderOneInfoModel = [styleInfo objectAtIndex:0];
    cell.hiddenTopHeader = YES;
    NSUInteger styleId = [cell.orderStyleModel.styleId unsignedIntegerValue];
    if((_styleModifyReslut && [_styleModifyReslut containsObject:@(styleId)])){
        cell.isModifyNow = 4;
    }else{
        cell.isModifyNow = (self.isOrderEdit?2:1);
    }
    cell.delegate = self;
    cell.indexPath = indexPath;
    [cell updateUI];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *styleInfo = [self getCellStyleInfo:indexPath];
    NSString *sectionKey = [NSString stringWithFormat:@"%ld",(long)indexPath.section];//indexPath.section
    if(styleInfo ==nil || [_hidesectionKeyArr containsObject:sectionKey]){
        return 0;
    }

    YYOrderStyleModel *styleModel = [styleInfo objectAtIndex:1];
    NSUInteger styleId = [styleModel.styleId unsignedIntegerValue];
    if((_styleModifyReslut && [_styleModifyReslut containsObject:@(styleId)])){
        return 112;
    }

    NSInteger styleBuyedSizeCount = 0;
    NSInteger styleTotalNum = 0;
    if (styleModel.colors
        && [styleModel.colors count] > 0) {
        for (int i = 0; i < [styleModel.colors count]; i++) {
            YYOrderOneColorModel *orderOneColorModel = [styleModel.colors objectAtIndex:i];

            BOOL isColorSelect = [orderOneColorModel.isColorSelect boolValue];

            if(isColorSelect){
                if(self.isOrderEdit){
                    //显示全部size
                    styleBuyedSizeCount += [orderOneColorModel.sizes count];
                }else{
                    styleBuyedSizeCount += 1;
                }
            }else{
                //判断amount是不是大于0
                for (YYOrderSizeModel *sizeModel in orderOneColorModel.sizes) {
                    if([sizeModel.amount integerValue] > 0){
                        styleBuyedSizeCount ++;
                    }
                }
            }
            
            for (YYOrderSizeModel *sizeModel in orderOneColorModel.sizes) {
                styleTotalNum += [sizeModel.amount integerValue];
            }
        }
    }
    BOOL showMinAmount = (styleTotalNum < [styleModel.orderAmountMin integerValue]);
    return [YYNewStyleDetailCell CellHeight:styleBuyedSizeCount showHelpFlag:showMinAmount showTopHeader:NO];//210 + styleModel.amount.count * 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{

    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

}
#pragma mark - --------------自定义代理/block----------------------
#pragma YYTableCellDelegate
-(void)btnClick:(NSInteger)row section:(NSInteger)section andParmas:(NSArray *)parmas{
    [self updateTaxByOrderInfoArray];
    NSString *type = [parmas objectAtIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    if([type isEqualToString:@"select"]){
        _selectBrandIndex = section;

        YYOrderInfoModel * orderIndoModel = [_orderInfoArray objectAtIndex:section];

        [self updateCurSelectPriceInfo:orderIndoModel];

        [_tableView reloadData];
    }else  if([type isEqualToString:@"hide"]){
        NSString *sectionKey = [NSString stringWithFormat:@"%ld",(long)section];
        if([_hidesectionKeyArr containsObject:sectionKey]){
            [_hidesectionKeyArr removeObject:sectionKey];
        }else{
            [_hidesectionKeyArr addObject:sectionKey];
        }

        [_tableView reloadData];
    }else  if([type isEqualToString:@"edit"]){
        [self modifyStyleShopingData:[NSIndexPath indexPathForRow:row inSection:section]];

    }else  if([type isEqualToString:@"delete"]){
        WeakSelf(ws);
        CMAlertView *alertView = [[CMAlertView alloc] initWithTitle:NSLocalizedString(@"确定要删除款式吗？",nil) message:nil needwarn:NO delegate:nil cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:@[NSLocalizedString(@"删除款式",nil)]];
        alertView.specialParentView = self.view;
        [alertView setAlertViewBlock:^(NSInteger selectedIndex){
            if (selectedIndex == 1) {
                [ws deleteCellStyleInfo:indexPath];
                if(ws.isOrderEdit == NO){
                    [self finishEditBtnAction:ws.finishEditBtn];
                }else{
                    [ws.tableView reloadData];
                }

                if(ws.selectBrandIndex>-1){
                    YYOrderInfoModel * orderIndoModel = [_orderInfoArray objectAtIndex:_selectBrandIndex];
                    [ws updateCurSelectPriceInfo:orderIndoModel];
                }else{
                    [ws updateCurSelectPriceInfo:nil];
                }
            }
        }];
        [alertView show];

    }else if([type isEqualToString:@"editStyleNum"]){
        NSIndexPath *sizeIndexPath = [parmas objectAtIndex:1];
        NSString *num = [parmas objectAtIndex:2];
        [self editCellStyleInfo:indexPath sizeIndex:sizeIndexPath amount:num];
        if(_selectBrandIndex> -1){
            YYOrderInfoModel * orderIndoModel = [_orderInfoArray objectAtIndex:_selectBrandIndex];
            [self updateCurSelectPriceInfo:orderIndoModel];
        }
        [_tableView reloadData];
    }
}

#pragma mark - --------------自定义响应----------------------
//清除购物车
- (IBAction)clearBtnAction:(id)sender {
    WeakSelf(ws);
    CMAlertView *alertView = [[CMAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"确认要清空购物车吗？",nil) needwarn:NO delegate:nil cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:@[NSLocalizedString(@"确认",nil)]];
    alertView.specialParentView = self.view;
    [alertView setAlertViewBlock:^(NSInteger selectedIndex){
        if (selectedIndex == 1) {
            [ws.orderInfoArray removeAllObjects];
            [ws.tableView reloadData];
            [_appdelegate clearBuyCar];

            if (ws.goBackButtonClicked) {
                ws.goBackButtonClicked();
            }
        }
    }];
    [alertView show];
}

//编辑按钮
- (IBAction)editBtnAction:(id)sender {
    //显示编辑状态下的按钮
    self.finishEditBtn.hidden = NO;
    //隐藏非编辑状态下的按钮
    self.buildOrderBtn.hidden = NO;
    [self.buildOrderBtn setTitle:NSLocalizedString(@"一键清空",nil) forState:UIControlStateNormal];
    self.editBtn.hidden = YES;
    self.isOrderEdit = YES;
    _navigationBarViewController.nowTitle = NSLocalizedString(@"编辑购物车",nil);
    [_navigationBarViewController updateUI];
    //改变约束
    [self.tableView reloadData];
}

//完成编辑按钮
- (IBAction)finishEditBtnAction:(id)sender {
    //隐藏编辑状态下的按钮

    self.finishEditBtn.hidden = YES;
    //显示非编辑状态下的按钮
    [self.buildOrderBtn setTitle:NSLocalizedString(@"建立订单",nil) forState:UIControlStateNormal];

    self.buildOrderBtn.hidden = NO;
    self.editBtn.hidden = NO;
    self.isOrderEdit = NO;

    _navigationBarViewController.nowTitle = NSLocalizedString(@"购物车",nil);
    [_navigationBarViewController updateUI];
    //改变约束
    if(sender != nil){

        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        for(NSString *designerId in _appdelegate.cartDesignerIdArray) {
            [userDefault removeObjectForKey:[NSString stringWithFormat:@"%@_%@",KUserCartKey,designerId]];
            [userDefault removeObjectForKey:[NSString stringWithFormat:@"%@_%@",KUserCartMoneyTypeKey,designerId]];
        }
        _appdelegate.cartDesignerIdArray = [[NSMutableArray alloc] init];
        [userDefault removeObjectForKey:KUserCartBrandKey];
        NSString *designerId = nil;
        NSString *jsonString = nil;

        //重设isColorSelect
        [self resetCartModel];

        for (YYOrderInfoModel * orderInfoModel in _orderInfoArray){
            if(orderInfoModel.groups && [orderInfoModel.groups count] > 0){
                designerId = [orderInfoModel.designerId stringValue];
                jsonString = orderInfoModel.toJSONString;
                [userDefault setObject:jsonString forKey:[NSString stringWithFormat:@"%@_%@",KUserCartKey,designerId]];
                if(orderInfoModel.curType){
                    [userDefault setObject:[NSString stringWithFormat:@"%ld",(long)[orderInfoModel.curType integerValue]] forKey:[NSString stringWithFormat:@"%@_%@",KUserCartMoneyTypeKey,designerId]];
                }else{
                    YYOrderOneInfoModel *orderOneInfoModel= [orderInfoModel.groups objectAtIndex:0];
                    if(orderOneInfoModel.styles && [orderOneInfoModel.styles count] > 0){
                        YYOrderStyleModel *orderStyleModel = [orderOneInfoModel.styles objectAtIndex:0];
                        [userDefault setObject:[NSString stringWithFormat:@"%ld",(long)[orderStyleModel.curType integerValue ]] forKey:[NSString stringWithFormat:@"%@_%@",KUserCartMoneyTypeKey,designerId]];
                    }
                }
                [_appdelegate.cartDesignerIdArray addObject:designerId];
            }
        }
        [userDefault setObject:[_appdelegate.cartDesignerIdArray componentsJoinedByString:@","] forKey:KUserCartBrandKey];
        [userDefault synchronize];

        _appdelegate.cartModel = nil;//购物车对象
        _appdelegate.seriesArray = nil;//系列数组

        if(_curCartModelDesignerId){
            NSString *jsonString = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%ld",KUserCartKey,(long)_curCartModelDesignerId]];
            _appdelegate.cartModel = [[YYOrderInfoModel alloc] initWithString:jsonString error:nil];
            if (_appdelegate.cartModel.groups.count != 0) {
                _appdelegate.seriesArray = [_appdelegate valueForKeyPath:@"cartModel.groups"];
            }
        }
        [self loadShoppingCarData];
        [self.tableView reloadData];
    }
}
- (IBAction)backBtnAction:(id)sender {
    if (self.goBackButtonClicked) {
        self.goBackButtonClicked();
    }
}
- (IBAction)showTaxTypeMenu:(id)sender {

    //跳转税率选择界面
    YYTaxChooseViewController *chooseTaxView = [[YYTaxChooseViewController alloc] init];
    chooseTaxView.selectIndex = _selectTaxType;
    chooseTaxView.selectData = _menuData;
    WeakSelf(ws);
    [chooseTaxView setCancelButtonClicked:^(){
        [ws.navigationController popViewControllerAnimated:YES];
    }];
    [chooseTaxView setSelectBlock:^(NSInteger selectIndex){
        ws.selectTaxType = selectIndex;
        if(selectIndex != 2){
            ws.menuData = getPayTaxInitData();
        }
        //更新_orderInfoArray中的tax
        [ws updateTaxByOrderInfoArray];
        [ws.navigationController popViewControllerAnimated:YES];
        [ws.tableView reloadData];
        [ws updateTaxTypeUI];
        NSLog(@"111");
    }];
    [self.navigationController pushViewController:chooseTaxView animated:YES];

}
#pragma mark -warnOrderMinMoney
- (IBAction)warnOrderMinMoney:(id)sender {

    [self hidePopUpViewAnimated:NO];

    if(self.popUpView == nil){
        self.popUpView = [[ASPopUpView alloc] initWithFrame:CGRectZero];
        self.popUpView.alpha = 0.0;
        [self.popUpView setFont:[UIFont systemFontOfSize:12]];
        [self.popUpView setTextColor:[UIColor colorWithHex:@"ef4e31"]];
        [self.popUpView setColor:[UIColor colorWithHex:@"ef4e31"]];
        [_bottomView addSubview:self.popUpView];
    }
    NSString *string =  _minOrderMoneyTip;
    CGSize size = [self.popUpView popUpSizeForString:string];
    float popUpViewOffsetX = CGRectGetMidX(_minOrderMoneyBtn1.frame);
    CGRect popUpRect = CGRectMake(-(size.width+10)/2+popUpViewOffsetX,6, size.width+10, size.height+20);
    [self.popUpView setFrame:popUpRect arrowOffset:0 text:string];
    [self showPopUpViewAnimated:YES];

}
#pragma mark -建立意向单
- (IBAction)buildOrderBtnAction:(id)sender {
    if(_isOrderEdit){
        //一键清空
        WeakSelf(ws);
        CMAlertView *alertView = [[CMAlertView alloc] initWithTitle:NSLocalizedString(@"确认将购物车清空？",nil) message:nil needwarn:NO delegate:nil cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:@[NSLocalizedString(@"确定",nil)]];
        alertView.specialParentView = self.view;
        [alertView setAlertViewBlock:^(NSInteger selectedIndex){
            if(selectedIndex == 1 ){
                [ws clearBuyCar];
            }
        }];
        [alertView show];
    }else{
        if(_orderInfoArray && _orderInfoArray.count > 0){
            if(_selectBrandIndex < 0){
                [YYToast showToastWithView:self.view title:NSLocalizedString(@"请选择需要下单的品牌",nil) andDuration:kAlertToastDuration];
                return;
            }

            //判断是否存在仅选颜色的款式
            BOOL haveSelectColorStyle = NO;
            for (YYOrderInfoModel *orderInfoModel in _orderInfoArray) {
                for (YYOrderOneInfoModel *orderOneInfoModel in orderInfoModel.groups) {
                    for (YYOrderStyleModel *orderStyleModel in orderOneInfoModel.styles) {
                        for (YYOrderOneColorModel *orderOneColorModel in orderStyleModel.colors) {
                            if([orderOneColorModel.isColorSelect boolValue]){
                                haveSelectColorStyle = YES;
                                break;
                            }
                        }
                    }
                }
            }

            if(haveSelectColorStyle){
                [YYToast showToastWithView:self.view title:NSLocalizedString(@"对不起，无法创建订单！\n请补全所选款式的尺码和数量",nil) andDuration:kAlertToastDuration];
                return;
            }

            WeakSelf(ws);
            [YYUserApi getUserStatus:-1 andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSInteger status, NSError *error) {
                if(rspStatusAndMessage.status == YYReqStatusCode100){
                    if(status == YYUserStatusOk){
                        [ws checkStylesModify];
                    }else{
                        [YYToast showToastWithView:ws.view title:NSLocalizedString(@"您还没有通过品牌身份认证，不能建立订单",nil) andDuration:kAlertToastDuration];
                    }
                }else{
                    [YYToast showToastWithView:ws.view title:rspStatusAndMessage.message andDuration:kAlertToastDuration];
                }
            }];
        }else{
            [YYToast showToastWithView:self.view title:NSLocalizedString(@"购物车暂无数据",nil) andDuration:kAlertToastDuration];
        }
    }
}

#pragma mark - --------------自定义方法----------------------
- (void)resetCartModel{
    for (YYOrderInfoModel * orderInfoModel in _orderInfoArray){
        for (YYOrderOneInfoModel *orderOneInfoModel in orderInfoModel.groups) {
            for (YYOrderStyleModel *orderStyleModel in orderOneInfoModel.styles) {
                for (YYOrderOneColorModel *orderOneColorModel in orderStyleModel.colors) {
                    //凡是编辑过的都设置isColorSelect为NO
                    BOOL havenum = NO;
                    for (YYOrderSizeModel *orderSizeModel in orderOneColorModel.sizes) {
                        if([orderSizeModel.amount integerValue]){
                            havenum = YES;
                        }
                    }
                    if(!havenum && [orderOneColorModel.isColorSelect boolValue]){
                        orderOneColorModel.isColorSelect = @(YES);
                    }else{
                        orderOneColorModel.isColorSelect = @(NO);
                    }
                }
            }
        }
    }
}
//加载购物车数据
- (void)loadShoppingCarData{
    _orderInfoArray = [[NSMutableArray alloc] init];
    for (NSString *key in _appdelegate.cartDesignerIdArray) {
        NSString *jsonString = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@",KUserCartKey,key]];
        YYOrderInfoModel * orderInfoModel = [[YYOrderInfoModel alloc] initWithString:jsonString error:nil];
        [_orderInfoArray addObject:orderInfoModel];
    }
    [_navigationBarViewController updateUI];

    [self.tableView reloadData];
}

-(void)checkStyleModify:(YYOrderInfoModel *)orderInfoModel callBack:(void (^)())block{
    NSMutableDictionary *styleInfo = [[NSMutableDictionary alloc] init];
    for(YYOrderOneInfoModel *oneInfoModel in orderInfoModel.groups) {
        for (YYOrderStyleModel *styleModel in oneInfoModel.styles) {
            [styleInfo setValue:styleModel.styleModifyTime forKey:[styleModel.styleId stringValue]];
        }
    }
    WeakSelf(ws);
    __block NSMutableDictionary *blockStyleInfo = styleInfo;
    [YYOrderApi isStyleModifyWithData:[styleInfo copy] andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYOrderStyleModifyReslutModel *styleModifyReslut, NSError *error) {
        if (rspStatusAndMessage.status == YYReqStatusCode203) {
            if(ws.styleModifyReslut == nil){
                ws.styleModifyReslut = [[NSMutableArray alloc] init];
            }

            [ws.styleModifyReslut addObjectsFromArray:styleModifyReslut.result];
            [ws.tableView reloadData];
            if( [blockStyleInfo count] > 0 && [blockStyleInfo count] == [styleModifyReslut.result count]){
                if(block){
                    [YYToast showToastWithView:ws.view title:[NSString stringWithFormat:NSLocalizedString(@"%@ 已过期,处理后才能下单",nil),NSLocalizedString(@"款式",nil)] andDuration:kAlertToastDuration];
                }
                return ;
            }
        }
        if(block){
            block();
        }else
        {
            NSLog(@"111");
        }
    }];

}
-(void)deleteCellStyleInfo:(NSIndexPath *)indexPath{
    YYOrderInfoModel * orderIndoModel = [_orderInfoArray objectAtIndex:indexPath.section];
    NSInteger row = indexPath.row;
    for (YYOrderOneInfoModel * orderOneInfo in orderIndoModel.groups){
        NSInteger count = [orderOneInfo.styles count];
        if(row < count){
            [orderOneInfo.styles removeObjectAtIndex:row];
            if([orderOneInfo.styles count]==0){
                [orderIndoModel.groups removeObjectAtIndex:[orderIndoModel.groups indexOfObject:orderOneInfo]];
            }
            if([orderIndoModel.groups count] == 0){
                [_orderInfoArray removeObjectAtIndex:indexPath.section];
                if(_selectBrandIndex == indexPath.section){
                    if([_orderInfoArray count] > 0){
                        _selectBrandIndex = 0;
                    }else{
                        _selectBrandIndex = -1;
                    }
                }else if (self.selectBrandIndex > indexPath.section) {
                    self.selectBrandIndex --;
                }
            }
            break;
        }
        row = row-count;
    }
}

-(void)editCellStyleInfo:(NSIndexPath *)indexPath sizeIndex:(NSIndexPath *)index amount:(NSString *)amount{
    YYOrderInfoModel * orderIndoModel = [_orderInfoArray objectAtIndex:indexPath.section];
    NSInteger row = indexPath.row;
    for (YYOrderOneInfoModel * orderOneInfo in orderIndoModel.groups){
        NSInteger count = [orderOneInfo.styles count];
        if(row < count){
            YYOrderStyleModel *orderStyleModel = [orderOneInfo.styles objectAtIndex:row];
            YYOrderOneColorModel * oneColorModel = [orderStyleModel.colors objectAtIndex:index.section];
            YYOrderSizeModel * sizeModel = [oneColorModel.sizes objectAtIndex:index.row];
            sizeModel.amount = [[NSNumber alloc] initWithInteger:[amount integerValue]];
            if([amount integerValue] == 0){
                for (oneColorModel in orderStyleModel.colors) {
                    for (sizeModel in oneColorModel.sizes) {
                        if(sizeModel.amount && [sizeModel.amount integerValue] > 0){
                            return;
                        }
                    }
                }
                if(![oneColorModel.isColorSelect boolValue]){
                    [orderOneInfo.styles removeObjectAtIndex:row];
                }
            }
            return;
        }
        row = row-count;
    }
}
-(YYOrderStyleModel *)checkArrayContainMode:(NSArray*)array model:(YYOrderStyleModel*)model{
    for (YYOrderStyleModel *selectOrderStyleModel in array) {
        if (model.styleId == selectOrderStyleModel.styleId) {
            return  selectOrderStyleModel;
        }
    }
    return nil;
}
-(void)updateCurSelectPriceInfo:(YYOrderInfoModel *)orderInfoModel{
    _minOrderMoneyRightLength.constant = IsPhone6_gt?15:5;//4 15
    [self hidePopUpViewAnimated:NO];
    _minOrderMoneyTip = @"";
    if(orderInfoModel != nil){
        self.stylesAndTotalPriceModel = [orderInfoModel getTotalValueByOrderInfo:_isOrderEdit];
        self.countLab.text = [NSString stringWithFormat:NSLocalizedString(@"共%d款 %d件",nil), self.stylesAndTotalPriceModel.totalStyles, self.stylesAndTotalPriceModel.totalCount];
        NSInteger curType =getMoneyType([orderInfoModel.designerId integerValue]);
        float costMeoney = self.stylesAndTotalPriceModel.finalTotalPrice;
        NSString *priceStr = replaceMoneyFlag([NSString stringWithFormat:@"￥%.2f",costMeoney],curType);
        _priceTotalDiscountView.notShowDiscountValueTextAlignmentLeft = YES;
        _priceTotalDiscountView.fontColorStr =  @"ed6498";
        CGSize txtSize = CGSizeZero;
        float taxRate = 0;
        if(needPayTaxView(curType)){
            _taxTypeBtn.enabled = YES;
            _taxTypeBtn.alpha = 1;
        }else{
            _taxTypeBtn.enabled = NO;
            _taxTypeBtn.alpha = 0.5;
        }
        NSLog(@"\n needPayTaxView =%d \n _selectTaxType=%ld",needPayTaxView(curType),_selectTaxType);
        if(_selectTaxType && needPayTaxView(curType) ){
            _priceTotalDiscountView.showDiscountValue = NO;
            taxRate = [getPayTaxValue(_menuData, _selectTaxType, NO) doubleValue];
            txtSize = [priceStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:IsPhone6_gt?15.0f:13.0f]}];
            [_priceTotalDiscountView updateUIWithTaxPrice:@""
                                               fianlPrice:priceStr
                                                  taxFont:[UIFont systemFontOfSize:IsPhone6_gt?14.0f:12.0f]
                                                finalFont:[UIFont boldSystemFontOfSize:IsPhone6_gt?15.0f:13.0f]];
        }else{
            _priceTotalDiscountView.showDiscountValue = NO;
            txtSize = [priceStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:IsPhone6_gt?15.0f:13.0f]}];
            [_priceTotalDiscountView updateUIWithTaxPrice:@""
                                               fianlPrice:priceStr
                                                  taxFont:[UIFont systemFontOfSize:IsPhone6_gt?14.0f:12.0f]
                                                finalFont:[UIFont boldSystemFontOfSize:IsPhone6_gt?15.0f:13.0f]];

        }
        [_priceTotalDiscountView setConstraintConstant:txtSize.width+1 forAttribute:NSLayoutAttributeWidth];

        _minOrderMoneyBtn1.hidden = YES;
        _minOrderMoneyBtn2.hidden = YES;
        _countLabelLayoutBottomConstraint.constant = 14;
        __block double blockcostMeoney = self.stylesAndTotalPriceModel.originalTotalPrice;
        __block float blocktaxRate = taxRate;
        __block float blockcurType = curType;
        WeakSelf(ws);
        if(curType >= 0){
            [YYOrderApi getOrderUnitPrice:[orderInfoModel.designerId unsignedIntegerValue] moneyType:curType andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSUInteger orderUnitPrice, NSError *error) {
                if(orderUnitPrice > blockcostMeoney){
                    //未达到起订额
                    if(blocktaxRate > 0){
                        ws.minOrderMoneyTip = replaceMoneyFlag([NSString stringWithFormat:@"%@\n ￥%ld",NSLocalizedString(@"未达到每单起订额",nil),orderUnitPrice],blockcurType);
                        //有税率
                        UIImage *icon = [[UIImage imageNamed:@"warn"] imageWithTintColor:[UIColor colorWithHex:@"ef4e31"]];
                        [ws.minOrderMoneyBtn1 setImage:icon forState:UIControlStateNormal];

                        ws.minOrderMoneyBtn1.hidden = NO;

                        ws.countLabelLayoutBottomConstraint.constant = 14+7;

                        ws.minOrderMoneyBtn2.hidden = NO;
                        [ws.minOrderMoneyBtn2 setImage:nil forState:UIControlStateNormal];
                        NSString *taxPriceStr = replaceMoneyFlag([NSString stringWithFormat:NSLocalizedString(@"（税前￥%.2f）",nil),self.stylesAndTotalPriceModel.originalTotalPrice],curType);
                        [ws.minOrderMoneyBtn2 setTitle:taxPriceStr forState:UIControlStateNormal];
                        ws.minOrderMoneyBtn2.titleLabel.font = [UIFont systemFontOfSize:IsPhone6_gt?14.0f:12.0f];
                        [ws.minOrderMoneyBtn2 setTitleColor:[UIColor colorWithHex:@"919191"] forState:UIControlStateNormal];


                        CGSize txtSize1 = [priceStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:IsPhone6_gt?14.0f:12.0f]}];

                        ws.minOrderMoneyTipLayoutLeftConstraint.constant = (txtSize1.width -  txtSize.width)/2+5;
                    }else{
                        //无税率
                        ws.minOrderMoneyBtn2.hidden = NO;
                        UIImage *icon = [[UIImage imageNamed:@"warn"] imageWithTintColor:[UIColor colorWithHex:@"ef4e31"]];
                        [ws.minOrderMoneyBtn2 setImage:icon forState:UIControlStateNormal];
                        [ws.minOrderMoneyBtn2 setTitle:replaceMoneyFlag([NSString stringWithFormat:@"%@ ￥%ld",NSLocalizedString(@"未达到每单起订额",nil),orderUnitPrice],blockcurType) forState:UIControlStateNormal];
                        ws.minOrderMoneyBtn2.titleLabel.font = [UIFont systemFontOfSize:12.0f];
                        [ws.minOrderMoneyBtn2 setTitleColor:[UIColor colorWithHex:@"ef4e31"] forState:UIControlStateNormal];

                        ws.minOrderMoneyBtn1.hidden = YES;
                        ws.countLabelLayoutBottomConstraint.constant = 14+7;

                    }
                }else{
                    //达到起订额
                    _minOrderMoneyRightLength.constant = 24;
                    if(blocktaxRate > 0){
                        //有税率

                        ws.minOrderMoneyBtn2.hidden = NO;
                        [ws.minOrderMoneyBtn2 setImage:nil forState:UIControlStateNormal];
                        NSString *taxPriceStr = replaceMoneyFlag([NSString stringWithFormat:NSLocalizedString(@"（税前￥%.2f）",nil),self.stylesAndTotalPriceModel.originalTotalPrice],curType);
                        [ws.minOrderMoneyBtn2 setTitle:taxPriceStr forState:UIControlStateNormal];
                        ws.minOrderMoneyBtn2.titleLabel.font = [UIFont systemFontOfSize:IsPhone6_gt?14.0f:12.0f];
                        [ws.minOrderMoneyBtn2 setTitleColor:[UIColor colorWithHex:@"919191"] forState:UIControlStateNormal];


                        CGSize txtSize1 = [priceStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:IsPhone6_gt?14.0f:12.0f]}];

                        ws.minOrderMoneyTipLayoutLeftConstraint.constant = (txtSize1.width -  txtSize.width)/2+5;

                        ws.minOrderMoneyBtn1.hidden = YES;
                        ws.countLabelLayoutBottomConstraint.constant = 14+7;
                    }else{
                        //无税率
                        ws.minOrderMoneyBtn2.hidden = YES;
                        ws.minOrderMoneyBtn1.hidden = YES;
                        ws.countLabelLayoutBottomConstraint.constant = 14;
                    }
                }
            }];
        }
    }else{
        _minOrderMoneyBtn1.hidden = YES;
        _minOrderMoneyBtn2.hidden = YES;
        _countLabelLayoutBottomConstraint.constant = 14+7;

        self.countLab.text = @"";
        _priceTotalDiscountView.showDiscountValue = NO;
        [_priceTotalDiscountView updateUIWithOriginPrice:@""
                                              fianlPrice:@""
                                              originFont:[UIFont systemFontOfSize:IsPhone6_gt?15.0f:13.0f]
                                               finalFont:[UIFont systemFontOfSize:IsPhone6_gt?15.0f:13.0f]];
    }
}
- (void)modifyStyleShopingData:(NSIndexPath *)indexPath{
    UIView *superView = self.view;

    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.cartModel =  [_orderInfoArray objectAtIndex:indexPath.section];
    if (appdelegate.cartModel.groups.count != 0) {
        appdelegate.seriesArray = [appdelegate valueForKeyPath:@"cartModel.groups"];
    }


    NSArray *styleInfo = [self getCellStyleInfo:indexPath];
    if(styleInfo ==nil){
        return;
    }
    YYOrderOneInfoModel *oneInfoModel = [styleInfo objectAtIndex:0];
    YYOrderStyleModel *orderStyleModel = [styleInfo objectAtIndex:1];
    if(oneInfoModel == nil || orderStyleModel == nil){
        return;
    }
    orderStyleModel.tmpDateRange = oneInfoModel.dateRange;
    YYOrderSeriesModel *orderseriesModel = [_appdelegate.cartModel.seriesMap objectForKey:[orderStyleModel.seriesId stringValue]];
    [appdelegate showShoppingView:NO styleInfoModel:orderStyleModel seriesModel:orderseriesModel opusStyleModel:nil parentView:superView fromBrandSeriesView:NO WithBlock:nil];
}
-(void)clearBuyCar{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate clearBuyCar];
    _taxTypeBtn.enabled = NO;
    _taxTypeBtn.alpha = 0.5;
    [self updateCurSelectPriceInfo:nil];
    [self finishEditBtnAction:nil];
    _selectBrandIndex = -1;
    [self updateTaxTypeUI];
    [_tableView reloadData];
}
-(void)checkStylesModify{

    WeakSelf(ws);
    YYOrderInfoModel * orderInfoModel = [_orderInfoArray objectAtIndex:_selectBrandIndex];
    if(_selectTaxType && needPayTaxView([orderInfoModel.curType integerValue])){
        NSInteger taxRate = getPayTaxTypeToServiceNew(_menuData, _selectTaxType);
        orderInfoModel.taxRate = [NSNumber numberWithInteger:taxRate];
    }else{
        orderInfoModel.taxRate = nil;
    }

    orderInfoModel.curType = [[NSNumber alloc] initWithInteger:getMoneyType([orderInfoModel.designerId integerValue])];
    [self checkStyleModify:orderInfoModel callBack:^{
        [ws showBuildOrderUI];
    }];
}

-(void)showBuildOrderUI{
    WeakSelf(ws);
    YYOrderInfoModel * orderInfoModel = [_orderInfoArray objectAtIndex:_selectBrandIndex];
    //过滤失效
    __block NSMutableArray *blockStyleModifyResut = _styleModifyReslut;
    [orderInfoModel.groups enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YYOrderOneInfoModel *oneInfoModel = obj;
        if(oneInfoModel != nil && oneInfoModel.styles != nil){
            [oneInfoModel.styles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YYOrderStyleModel *styleModel = obj;
                if(styleModel && [blockStyleModifyResut containsObject:@([styleModel.styleId integerValue])]){
                    [oneInfoModel.styles removeObject:obj];
                }
            }];
            if([oneInfoModel.styles count] == 0){
                [orderInfoModel.groups removeObject:obj];
            }
        }
    }];

    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    orderInfoModel.orderConnStatus = [[NSNumber alloc] initWithInteger:YYOrderConnStatusUnconfirmed];
    orderInfoModel.designerOrderStatus =[[NSNumber alloc] initWithInteger:YYOrderCode_NEGOTIATION];
    orderInfoModel.buyerOrderStatus =[[NSNumber alloc] initWithInteger:YYOrderCode_NEGOTIATION] ;
    orderInfoModel.curType = [[NSNumber alloc] initWithInteger:getMoneyType([orderInfoModel.designerId integerValue])];
    orderInfoModel.addressModifAvailable = YES;
    [appDelegate showBuildOrderViewController:orderInfoModel parent:self isCreatOrder:YES isReBuildOrder:NO isAppendOrder:NO isFromCardDetail:YES modifySuccess:^(){
        if ( ws.toOrderList) {
            ws.toOrderList();
        }
    }];
}
-(void)updateTaxByOrderInfoArray{

    NSInteger taxRate = [getPayTaxValue(_menuData, _selectTaxType, NO) floatValue] * 100;
    for (YYOrderInfoModel * orderIndoModel in _orderInfoArray) {
        orderIndoModel.taxRate = [NSNumber numberWithInteger:taxRate];
    }

}
-(void)updateTaxTypeUI{
    NSString *taxTypeStr = nil;
    if(self.selectTaxType > 0){
        [_taxTypeBtn setTitleColor:[UIColor colorWithHex:@"ed6498"] forState:UIControlStateNormal];
        taxTypeStr = getPayTaxValue(_menuData, self.selectTaxType, YES);
    }else{
        [_taxTypeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        taxTypeStr = NSLocalizedString(@"税制_phone",nil);
    }
    CGSize txtSize = [taxTypeStr sizeWithAttributes:@{NSFontAttributeName:_taxTypeBtn.titleLabel.font}];
    [_taxTypeBtn setConstraintConstant:txtSize.width forAttribute:NSLayoutAttributeWidth];
    [_taxTypeBtn setTitle:taxTypeStr forState:UIControlStateNormal];
    if(_selectBrandIndex>-1){
        YYOrderInfoModel * orderIndoModel = [_orderInfoArray objectAtIndex:_selectBrandIndex];

        NSInteger taxNum = [getPayTaxValue(_menuData, _selectTaxType, NO) floatValue]*100;
        orderIndoModel.taxRate = [NSNumber numberWithInteger:taxNum];
        [self updateCurSelectPriceInfo:orderIndoModel];
    }
}
#pragma mark -操作StyleInfo
-(NSArray *)getCellStyleInfo:(NSIndexPath *)indexPath{
    YYOrderInfoModel * orderIndoModel = [_orderInfoArray objectAtIndex:indexPath.section];
    NSInteger row = indexPath.row;
    for (YYOrderOneInfoModel * orderOneInfo in orderIndoModel.groups){
        NSInteger count = [orderOneInfo.styles count];
        if(row < count){
            YYOrderStyleModel *orderStyleModel = [orderOneInfo.styles objectAtIndex:row];
            return @[orderOneInfo, orderStyleModel];
        }
        row = row-count;
    }
    return nil;
}
#pragma mark - --------------other----------------------


@end
