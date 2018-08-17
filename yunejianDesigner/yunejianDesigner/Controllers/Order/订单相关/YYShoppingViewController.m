//
//  YYShoppingViewController.m
//  Yunejian
//
//  Created by Apple on 15/7/31.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYShoppingViewController.h"

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "YYNavigationBarViewController.h"

// 自定义视图
#import "MLInputDodger.h"
#import "YYShoppingCell.h"
#import "YYShoppingStyleInfoCell.h"

// 接口
#import "YYOpusApi.h"

// 分类
#import "UIImage+YYImage.h"
#import "UIImageView+WebCache.h"

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYUser.h"
#import "YYColorModel.h"
#import "YYStyleInfoModel.h"
#import "YYOrderInfoModel.h"
#import "YYOpusStyleModel.h"
#import "YYOrderStyleModel.h"
#import "YYBrandSeriesToCartTempModel.h"

#import "AppDelegate.h"
#import "YYRequestHelp.h"
#import "UserDefaultsMacro.h"

@interface YYShoppingViewController ()<UITableViewDelegate, UITableViewDataSource,YYTableCellDelegate>{
    NSInteger thisStyleSumCount;//当前款式已加购的数量
    NSInteger thisStyleColorCount;//当前款式以选颜色的数量
}

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLab;
@property (weak, nonatomic) IBOutlet UIButton *configModify;//修改订单的弹框的按钮

//用于隐藏底部totalPriceLab
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalPriceTopLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalPriceBottomLayout;


@property (nonatomic, strong) YYOrderInfoModel *tempOrderInfoModel;//当前要修改的购物车或订单对象
@property (nonatomic, strong) NSMutableArray *tempSeriesArray;//当前要修改的，临时使用的系列数组对象

@property (nonatomic, copy) NSArray *amountSizeArr;//当前颜色尺寸购买数量 YYOrderOneColorModel
@property (nonatomic, copy) NSArray *sizeNameArr;//当前款式所有的尺寸名 YYSizeModel

@property (nonatomic,strong) NSMutableArray *selectColorArr;//锁定的color存放
@property (nonatomic,strong) YYOrderStyleModel *oldOrderStyleModel;//老的数据  没有为nil

@end

@implementation YYShoppingViewController
#pragma mark - --------------生命周期--------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 进入埋点
    [MobClick beginLogPageView:kYYPageShopping];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageShopping];
}
#pragma mark - --------------SomePrepare--------------
- (void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
- (void)PrepareData{
    _selectColorArr = [[NSMutableArray alloc] init];

    BOOL isexist = NO;
    _oldOrderStyleModel = nil;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for (YYOrderOneInfoModel *orderOneInfoModel in appDelegate.cartModel.groups) {
        for (YYOrderStyleModel *orderStyleModel in orderOneInfoModel.styles) {
            if ([orderStyleModel.styleId intValue] == [_styleInfoModel.style.id intValue]) {
                _oldOrderStyleModel = orderStyleModel;
                isexist = YES;
                for (YYOrderOneColorModel *orderOneColorModel in orderStyleModel.colors) {
                    for (YYColorModel *color in _styleInfoModel.colorImages) {
                        if([orderOneColorModel.colorId integerValue] == [color.id integerValue]){
                            if([orderOneColorModel.isColorSelect boolValue]){
                                color.isSelect = orderOneColorModel.isColorSelect;
                                [_selectColorArr addObject:@{@"colorIsSelect":color.isSelect,@"colorId":color.id}];
                            }
                        }
                    }
                }
            }
        }
    }
    if(!isexist){
        for (YYColorModel *color in _styleInfoModel.colorImages) {
            color.isSelect = @(NO);
        }
    }
    NSLog(@"1111");
}
- (void)PrepareUI{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YYNavigationBarViewController *navigationBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNavigationBarViewController"];
    navigationBarViewController.previousTitle = @"";
    navigationBarViewController.nowTitle = @"";
    [_containerView insertSubview:navigationBarViewController.view atIndex:0];
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
            [ws.view removeFromSuperview];
            blockVc = nil;
        }
    }];

    self.detailTableView.shiftHeightAsDodgeViewForMLInputDodger = 44.0f+5.0f;
    [self.detailTableView registerAsDodgeViewForMLInputDodger];

    self.detailTableView.delegate = self;
    self.detailTableView.dataSource = self;
    [self.detailTableView registerNib:[UINib nibWithNibName:@"YYShoppingCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"shoppingCell"];
    [self.detailTableView registerNib:[UINib nibWithNibName:@"YYShoppingStyleInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"YYShoppingStyleInfoCell"];

    self.detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.configModify.hidden = YES;

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];


    if (self.isModifyOrder) {
        self.configModify.hidden = NO;

        self.tempOrderInfoModel = appDelegate.orderModel;
        self.tempSeriesArray = appDelegate.orderSeriesArray;

        navigationBarViewController.nowTitle = NSLocalizedString(@"修改款式数量",nil);
        if (!self.styleInfoModel) {
            [self loadStyleInfoWithStyleId:[_opusStyleModel.id longValue]];
        }

    }else{
        self.tempOrderInfoModel = appDelegate.cartModel;
        self.tempSeriesArray = appDelegate.seriesArray;

        navigationBarViewController.nowTitle = NSLocalizedString(@"加入购物车",nil);
    }
    [navigationBarViewController updateUI];
    if(self.tempSeriesArray == nil){
        self.tempSeriesArray = [[NSMutableArray alloc] init];
    }

    [self updateThisStyleSumCount];
    [self updateStyleModel];
    [self updateTotalInfo:thisStyleSumCount];
}
-(void)updateStyleModel{
    if(_styleInfoModel){
        for (YYOrderOneInfoModel *oneInfoModel in self.tempOrderInfoModel.groups) {
            for (YYOrderStyleModel *styleModel in oneInfoModel.styles) {
                if ( [styleModel.styleId intValue] == [_styleInfoModel.style.id intValue]) {
                    for (YYColorModel *colorModel in _styleInfoModel.colorImages) {
                        for (YYOrderOneColorModel *orderOneColorModel in styleModel.colors) {
                            if([colorModel.id integerValue] == [orderOneColorModel.colorId integerValue]){
                                colorModel.isSelect = orderOneColorModel.isColorSelect;
                            }
                        }
                    }
                }
            }
        }
    }
    if(_opusStyleModel){
        for (YYOrderOneInfoModel *oneInfoModel in self.tempOrderInfoModel.groups) {
            for (YYOrderStyleModel *styleModel in oneInfoModel.styles) {
                if ( [styleModel.styleId intValue] == [_opusStyleModel.id intValue]) {
                    for (YYColorModel *colorModel in _opusStyleModel.color) {
                        for (YYOrderOneColorModel *orderOneColorModel in styleModel.colors) {
                            if([colorModel.id integerValue] == [orderOneColorModel.colorId integerValue]){
                                colorModel.isSelect = orderOneColorModel.isColorSelect;
                            }
                        }
                    }
                }
            }
        }
    }
}

#pragma mark - --------------系统代理----------------------
#pragma mark -UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _styleInfoModel.colorImages.count*2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    YYShoppingStyleInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYShoppingStyleInfoCell" ];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.styleInfoModel = _styleInfoModel;
    cell.opusSeriesModel = _opusSeriesModel;
    cell.opusStyleModel = _opusStyleModel;
    cell.isOnlyColor = _isOnlyColor;
    cell.isModifyOrder = _isModifyOrder;
    [cell updateUI];
    if(!_isModifyOrder){
        [cell setChangeChooseStyle:^(){
            _isOnlyColor = !_isOnlyColor;
            [self reloadTableViewData];
        }];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(_isModifyOrder){
        return 112;
    }
    return 163;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row%2 == 0){
        return 10;
    }else{
        if(_isOnlyColor){
            return 70;
        }else{
            NSInteger maxSizeCount = kMaxSizeCount;
            if ([_styleInfoModel.size count] <= kMaxSizeCount) {
                maxSizeCount = [_styleInfoModel.size count];
            }
            return maxSizeCount*50 + 20;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row%2 == 0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYOrderNullCell"];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YYOrderNullCell"];
            cell.contentView.backgroundColor = [UIColor colorWithHex:@"f8f8f8"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }

    YYShoppingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shoppingCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.styleInfoModel = _styleInfoModel;

    NSInteger cellRow = indexPath.row/2 ;
    YYColorModel *colorModel = [_styleInfoModel.colorImages objectAtIndex:cellRow];
    cell.amountsizeArr = nil;
    if (_amountSizeArr.count != 0 ){
        for (YYOrderOneColorModel *oneColorModel in _amountSizeArr) {
            if([oneColorModel.colorId integerValue] == [colorModel.id integerValue]){
                cell.amountsizeArr = oneColorModel.sizes;
                break;
            }
        }
    }
    cell.isOnlyColor = _isOnlyColor;
    cell.indexPath = indexPath;
    cell.delegate = self;
    [cell updateUI];
    return cell;
}

#pragma mark - --------------自定义代理/block----------------------
#pragma mark -YYTableCellDelegate
-(void)btnClick:(NSInteger)row section:(NSInteger)section andParmas:(NSArray *)parmas{
    NSString *type = parmas[0];
    if([type isEqualToString:@"styleNumChange"]){
        //增加减少
        [self editStyleNumIsSeletColor:NO row:row section:section andParmas:parmas];
    }else if([type isEqualToString:@"selectColor"]){
        //选中颜色
        [self editStyleNumIsSeletColor:YES row:row section:section andParmas:parmas];
    }
}

-(void)editStyleNumIsSeletColor:(BOOL )isSeletColor row:(NSInteger)row section:(NSInteger)section andParmas:(NSArray *)parmas{
    if (_amountSizeArr == nil){
        NSMutableArray *oneColorArr = [NSMutableArray array];
        NSMutableArray *detailModelArr = [NSMutableArray array];
        for (int i = 0; i <  _styleInfoModel.colorImages.count; i++) {
            NSMutableArray *sizeModelArr = [NSMutableArray array];
            YYOrderOneColorModel *oneColorModel = [[YYOrderOneColorModel alloc] init];
            YYColorModel *color = _styleInfoModel.colorImages[i];
            oneColorModel.colorId = color.id;
            oneColorModel.name = color.name;
            oneColorModel.value = color.value;
            oneColorModel.styleCode = color.styleCode;
            oneColorModel.imgs = color.imgs;
            oneColorModel.originalPrice = color.tradePrice;
            oneColorModel.finalPrice = color.tradePrice;
            oneColorModel.isColorSelect = @(isSeletColor);
            
            for (int j = 0; j < _styleInfoModel.size.count; j++) {
                YYOrderSizeModel *sizeModel = [[YYOrderSizeModel alloc] init];

                sizeModel.amount = [NSNumber numberWithInteger:0];
                sizeModel.sizeId = [NSNumber numberWithInteger:[[_styleInfoModel.size[j] valueForKey:@"id"] intValue]];
                if (color.sizeStocks.count == self.styleInfoModel.size.count) {
                    sizeModel.stock = color.sizeStocks[j];
                }
                [sizeModelArr addObject:sizeModel];
                if (i == 0) {
                    YYSizeModel *detailModel = [[YYSizeModel alloc] init];
                    detailModel.id = [NSNumber numberWithInteger:[[_styleInfoModel.size[j] valueForKey:@"id"] intValue]];
                    detailModel.value = [NSString stringWithFormat:@"%@", [_styleInfoModel.size[j] valueForKey:@"value"]];
                    [detailModelArr addObject:detailModel];
                }
            }
            oneColorModel.sizes = (NSArray<YYOrderSizeModel, ConvertOnDemand> *)sizeModelArr;
            [oneColorArr addObject:oneColorModel];
        }
        _amountSizeArr = oneColorArr;
        _sizeNameArr = detailModelArr;
    }

    NSInteger cellRow = row/2;
    YYOrderOneColorModel *oneColorModel = [_amountSizeArr objectAtIndex:cellRow];
    if(!isSeletColor){
        NSInteger index = [[parmas objectAtIndex:1] integerValue];
        NSInteger value = [[parmas objectAtIndex:2] integerValue];
        YYOrderSizeModel *sizeModel =  [oneColorModel.sizes objectAtIndex:index];
        NSInteger amount = MAX(0, [sizeModel.amount integerValue]);
        thisStyleSumCount = thisStyleSumCount - amount + value;
        sizeModel.amount = [NSNumber numberWithInteger:value];
        [self updateTotalInfo:thisStyleSumCount];
    }else{

        BOOL isContain = NO;
        NSInteger selectIndex = 0;
        for (int i = 0; i<_selectColorArr.count; i++) {
            NSDictionary *tempDict = _selectColorArr[i];
            if([[tempDict objectForKey:@"colorId"] integerValue] == [oneColorModel.colorId integerValue]){
                isContain = YES;
                selectIndex = i;
            }
        }

        NSNumber *colorIsSelect = [parmas objectAtIndex:1];
        //当前数组中是否存在
        if(isContain){
            //存在 。。。
            [_selectColorArr removeObjectAtIndex:selectIndex];
        }
        [_selectColorArr addObject:@{@"colorIsSelect":colorIsSelect,@"colorId":oneColorModel.colorId}];
        [self reloadTableViewData];
    }
}
#pragma mark - --------------自定义响应----------------------
//加购
- (IBAction)shoppingCarBtn:(UIButton *)sender {

    NSInteger tempLimitNum = 0;
    BOOL haveSelectColor = [self haveSelectColorInIsOnlyColorStatus];
    if(_isOnlyColor){
        tempLimitNum = 1;//永远成立
    }else{
        tempLimitNum = thisStyleSumCount;
    }
    //_isOnlyColor下看是否有选中的color
    NSLog(@"thisStyleSumCount = %ld",thisStyleSumCount);
    if (tempLimitNum > 0 && haveSelectColor) {

        if(_isFromSeries){
            if(_seriesChooseBlock){
                YYBrandSeriesToCartTempModel *brandSeriesToCardTempModel = [[YYBrandSeriesToCartTempModel alloc] init];
                brandSeriesToCardTempModel.isModifyOrder = _isModifyOrder;
                brandSeriesToCardTempModel.styleInfoModel = _styleInfoModel;
                brandSeriesToCardTempModel.opusSeriesModel = _opusSeriesModel;
                brandSeriesToCardTempModel.tempOrderInfoModel = _tempOrderInfoModel;
                brandSeriesToCardTempModel.isOnlyColor = @(_isOnlyColor);
                brandSeriesToCardTempModel.selectColorArr = _selectColorArr;
                brandSeriesToCardTempModel.sizeNameArr = (NSArray<YYSizeModel> *)_sizeNameArr;
                brandSeriesToCardTempModel.amountSizeArr = (NSArray<YYOrderOneColorModel> *)_amountSizeArr;
                _seriesChooseBlock(brandSeriesToCardTempModel);
            }
        }else{
            [self addToLocalCart];
        }
        //移除view
        [self.view removeFromSuperview];
    }else{
        if (_isModifyOrder) {
            //移除view
            [self.view removeFromSuperview];
        }
    }
}
-(void)addToLocalCart{
    NSString *_remark = @"";
    YYDateRangeModel *_tmpDateRange = nil;
    NSString *_tmpRemark = @"";

    YYOrderOneInfoModel *orderOneInfoM = nil;
    NSMutableArray *curtempSeriesArray = [self.tempSeriesArray mutableCopy];
    if ([curtempSeriesArray count] > 0) {
        //已经有系列创建
        //查询是否已经有该系列

        for (YYOrderOneInfoModel *orderOneInfoModel in curtempSeriesArray) {
            if((_styleInfoModel.dateRange && [_styleInfoModel.dateRange.id integerValue] > 0 &&  [orderOneInfoModel.dateRange.id  integerValue] == [_styleInfoModel.dateRange.id integerValue]) || ((!_styleInfoModel.dateRange || [_styleInfoModel.dateRange.id integerValue] == 0) &&(orderOneInfoModel.dateRange == nil || [orderOneInfoModel.dateRange.id  integerValue] == 0))){
                orderOneInfoM = orderOneInfoModel;
                break;
            }
        }

        if (orderOneInfoM) {
            NSArray *arr = orderOneInfoM.styles; //当前系列所有款式
            for (YYOrderStyleModel *style in arr){
                if ([style.styleId intValue] == [_styleInfoModel.style.id intValue]) {
                    _remark = style.remark;
                    _tmpDateRange = style.tmpDateRange;
                    _tmpRemark = style.tmpRemark;
                    [orderOneInfoM.styles removeObject:style];
                    break;
                }
            }
        }
    }

    if (!orderOneInfoM) {
        orderOneInfoM = [[YYOrderOneInfoModel alloc] init];
        orderOneInfoM.dateRange = _styleInfoModel.dateRange;
        orderOneInfoM.styles = (NSMutableArray<YYOrderStyleModel>*)[[NSMutableArray alloc] init];
        [curtempSeriesArray addObject:orderOneInfoM];
    }

    //增加系列队列
    if(_opusSeriesModel){
        NSMutableDictionary *tempOrderInfoModelseriesMap = [[NSMutableDictionary alloc] init];
        if(!self.tempOrderInfoModel.seriesMap){
            self.tempOrderInfoModel = [[YYOrderInfoModel alloc] init];
        }else{
            tempOrderInfoModelseriesMap = [self.tempOrderInfoModel.seriesMap mutableCopy];
        }
        YYOrderSeriesModel *seriesModel = [[YYOrderSeriesModel alloc] init];
        seriesModel.seriesId = _opusSeriesModel.id;
        seriesModel.name = _opusSeriesModel.name;
        seriesModel.orderAmountMin = _opusSeriesModel.orderAmountMin;// style 有orderAmountMin
        seriesModel.supplyStatus = _opusSeriesModel.supplyStatus;

        [tempOrderInfoModelseriesMap setObject:seriesModel forKey:[seriesModel.seriesId stringValue]];
        self.tempOrderInfoModel.seriesMap = [tempOrderInfoModelseriesMap copy];
    }

    YYOrderStyleModel *orderStyleModel = [[YYOrderStyleModel alloc] init];
    orderStyleModel.styleId = _styleInfoModel.style.id;
    orderStyleModel.albumImg = _styleInfoModel.style.albumImg;
    orderStyleModel.name = _styleInfoModel.style.name;
    orderStyleModel.finalPrice = (_styleInfoModel.style.finalPrice !=nil?_styleInfoModel.style.finalPrice: _styleInfoModel.style.tradePrice);
    orderStyleModel.originalPrice = _styleInfoModel.style.tradePrice;
    orderStyleModel.retailPrice = _styleInfoModel.style.retailPrice;
    orderStyleModel.orderAmountMin = _styleInfoModel.style.orderAmountMin;
    orderStyleModel.styleCode = _styleInfoModel.style.styleCode;
    orderStyleModel.styleModifyTime = _styleInfoModel.style.modifyTime;
    orderStyleModel.sizeNameList = (NSArray<YYSizeModel, ConvertOnDemand> *) _sizeNameArr;
    orderStyleModel.stockEnabled = @(self.styleInfoModel.stockEnabled);
    orderStyleModel.dateRange = self.styleInfoModel.dateRange;
    orderStyleModel.colors =(NSArray<YYOrderOneColorModel, ConvertOnDemand> *) _amountSizeArr;
    orderStyleModel.curType = _styleInfoModel.style.curType;
    orderStyleModel.seriesId = _opusSeriesModel.id;
    orderStyleModel.supportAdd = _styleInfoModel.style.supportAdd;
    orderStyleModel.remark = _remark;
    orderStyleModel.tmpDateRange = _tmpDateRange;
    orderStyleModel.tmpRemark = _remark;

    [orderOneInfoM.styles insertObject:orderStyleModel atIndex:0];

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    self.tempSeriesArray = [curtempSeriesArray copy];
    if (self.isModifyOrder) {
        //修改订单
        appDelegate.orderModel.groups = (NSMutableArray<YYOrderOneInfoModel> *)self.tempSeriesArray;
        appDelegate.orderModel.seriesMap = self.tempOrderInfoModel.seriesMap;
        appDelegate.orderSeriesArray = (NSMutableArray<YYOrderOneInfoModel> *)self.tempSeriesArray;
    }else{
        //修改购物车
        //组合最终的YYOrderInfoModel模型对象。
        NSInteger cartMoneyType = [_styleInfoModel.style.curType integerValue];

        if (appDelegate.cartModel.designerId) {
            appDelegate.cartModel.groups = (NSMutableArray<YYOrderOneInfoModel> *)self.tempSeriesArray;
            appDelegate.cartModel.seriesMap = self.tempOrderInfoModel.seriesMap;
            appDelegate.cartModel.stockEnabled = @(self.styleInfoModel.stockEnabled);
            appDelegate.seriesArray=(NSMutableArray<YYOrderOneInfoModel> *)self.tempSeriesArray;
        }else{
            YYUser *user = [YYUser currentUser];
            YYOrderInfoModel *orderInfoModel = [[YYOrderInfoModel alloc] init];
            orderInfoModel.stockEnabled = @(self.styleInfoModel.stockEnabled);
            orderInfoModel.designerId = _opusSeriesModel.designerId;
            orderInfoModel.orderDescription = nil;
            orderInfoModel.brandLogo = user.logo;
            orderInfoModel.brandName = user.name;
            orderInfoModel.groups = (NSMutableArray<YYOrderOneInfoModel> *)self.tempSeriesArray;
            orderInfoModel.seriesMap = self.tempOrderInfoModel.seriesMap;
            orderInfoModel.curType = [NSNumber numberWithInteger:cartMoneyType];
            appDelegate.cartModel = orderInfoModel;
            appDelegate.seriesArray =(NSMutableArray<YYOrderOneInfoModel> *)self.tempSeriesArray;

        }

        //重设isColorSelect
        [self resetCartModel];

        //储存对象的JSONString
        NSString *designerId = [appDelegate.cartModel.designerId stringValue];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *jsonString = appDelegate.cartModel.toJSONString;
        NSLog(@"%@",jsonString);

        [userDefault setObject:jsonString forKey:[NSString stringWithFormat:@"%@_%@",KUserCartKey,designerId]];
        if(![appDelegate.cartDesignerIdArray containsObject:designerId]){
            [appDelegate.cartDesignerIdArray addObject:designerId];
            [userDefault setObject:[appDelegate.cartDesignerIdArray componentsJoinedByString:@","] forKey:KUserCartBrandKey];
            [userDefault setObject:[NSString stringWithFormat:@"%ld",(long)cartMoneyType] forKey:[NSString stringWithFormat:@"%@_%@",KUserCartMoneyTypeKey,designerId]];
        }
        [userDefault synchronize];
    }

    //发出通知，更新购物车图标
    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateShoppingCarNotification object:nil];
}
- (void)resetCartModel{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for (YYOrderOneInfoModel *orderOneInfoModel in appDelegate.cartModel.groups) {
        for (YYOrderStyleModel *orderStyleModel in orderOneInfoModel.styles) {
            if ([orderStyleModel.styleId intValue] == [_styleInfoModel.style.id intValue]) {
                for (YYOrderOneColorModel *orderOneColorModel in orderStyleModel.colors) {
                    if(_isOnlyColor){
                        //锁定的情况下清空amout
                        BOOL colorIsSelect = NO;
                        for (NSDictionary *tempDict in _selectColorArr) {
                            if([[tempDict objectForKey:@"colorId"] integerValue] == [orderOneColorModel.colorId integerValue]){
                                colorIsSelect = [[tempDict objectForKey:@"colorIsSelect"] boolValue];
                            }
                        }
                        if(colorIsSelect){
                            orderOneColorModel.isColorSelect = @(YES);
                            for (YYOrderSizeModel *orderSizeModel in orderOneColorModel.sizes) {
                                orderSizeModel.amount = @(0);
                            }
                        }else{
                            orderOneColorModel.isColorSelect = @(NO);
                            for (YYOrderSizeModel *orderSizeModel in orderOneColorModel.sizes) {
                                //给他设原来的amout    colorId  sizeId
                                orderSizeModel.amount = [self getOldAmountWithColorId:[orderOneColorModel.colorId integerValue] WithSizeId:[orderSizeModel.sizeId integerValue]];
                            }
                        }
                    }else{
                        BOOL haveAmount = NO;
                        for (YYOrderSizeModel *orderSizeModel in orderOneColorModel.sizes) {
                            if([orderSizeModel.amount integerValue]){
                                haveAmount = YES;
                            }
                        }

                        if(haveAmount){
                            orderOneColorModel.isColorSelect = @(NO);
                        }
                    }
                }
            }
        }
    }
}
- (NSNumber *)getOldAmountWithColorId:(NSInteger )colorId WithSizeId:(NSInteger )sizeId{
    NSInteger returnamount = 0;
    if(_oldOrderStyleModel){
        for (YYOrderOneColorModel *orderOneColorModel in _oldOrderStyleModel.colors) {
            if([orderOneColorModel.colorId integerValue] == colorId){
                for (YYOrderSizeModel *orderSizeModel in orderOneColorModel.sizes) {
                    if([orderSizeModel.sizeId integerValue] == sizeId){
                        returnamount = [orderSizeModel.amount integerValue];
                    }
                }
            }
        }
    }
    return @(returnamount);
}

#pragma mark - --------------自定义方法----------------------
- (BOOL )haveSelectColorInIsOnlyColorStatus{
    BOOL haveSelectColor = NO;
    if(_isOnlyColor){
        for (NSDictionary *dict in _selectColorArr) {
            BOOL colorIsSelect = [[dict objectForKey:@"colorIsSelect"] boolValue];
            if(colorIsSelect){
                haveSelectColor = YES;
            }
        }
    }else{
        haveSelectColor = YES;
    }
    return haveSelectColor;
}
/**
 更新视图 根据当前类型
 */
-(void)reloadTableViewData{
    _totalPriceLab.hidden = _isOnlyColor;
    _lineView.hidden = _isOnlyColor;
    if(_isOnlyColor){
        _bottomViewHeightLayout.constant = 60;
        _totalPriceTopLayout.constant = 0;
        _totalPriceBottomLayout.constant = 0;
    }else{
        _bottomViewHeightLayout.constant = 105;
        _totalPriceTopLayout.constant = 7;
        _totalPriceBottomLayout.constant = 7;
    }
    [_detailTableView reloadData];
}
/**
 更新界面下面的描述label

 @param sunCount 款式总计数量
 */
-(void)updateTotalInfo:(NSInteger)sunCount{
    __block float costMeoney = 0;
    [self.amountSizeArr enumerateObjectsUsingBlock:^(YYOrderOneColorModel *orderOneColorModel, NSUInteger idx, BOOL *stop) {
        NSInteger amount = [orderOneColorModel getTotalAmount];
        costMeoney += [orderOneColorModel.originalPrice floatValue] * amount;
    }];
    NSString *priceStr = replaceMoneyFlag([NSString stringWithFormat:@"￥%.2f",costMeoney],[_styleInfoModel.style.curType integerValue]);
    NSString *titleStr = [[NSString alloc] initWithFormat:NSLocalizedString(@"共计：%ld 款 %ld 件  %@",nil),[self getStleNum],sunCount,priceStr];

    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString: titleStr];
    NSRange range = NSMakeRange(titleStr.length - priceStr.length, priceStr.length);
    [attributedStr addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithHex:@"ed6498"] range:range];
    [attributedStr addAttribute: NSFontAttributeName value: [UIFont boldSystemFontOfSize:16] range:range];
    self.totalPriceLab.attributedText = attributedStr;
}

-(NSInteger )getStleNum{
    if(_amountSizeArr && _amountSizeArr.count){
        NSInteger num = 0;
        for (YYOrderOneColorModel *colorModel in _amountSizeArr) {
            BOOL hasAdd = NO;
            for (YYOrderSizeModel *sizeModel in colorModel.sizes) {
                if(!hasAdd && [sizeModel.amount integerValue] > 0){
                    num ++;
                    hasAdd = YES;
                }
            }
        }
        return num;
    }
    return 0;
}
/**
 获取款式已加购的数量，并初始化（amountSizeArr sizeNameArr）
 这个是初始化方法啊  不应该放在reloaddata中
 */
-(void)updateThisStyleSumCount{
    thisStyleSumCount = 0;
    thisStyleColorCount = 0;
    for (YYOrderOneInfoModel *oneInfoModel in self.tempOrderInfoModel.groups) {
        for (YYOrderStyleModel *styleModel in oneInfoModel.styles) {
            if ( [styleModel.styleId intValue] == [_styleInfoModel.style.id intValue]) {
                _amountSizeArr = styleModel.colors;
                _sizeNameArr = styleModel.sizeNameList;
                if (styleModel.colors && [styleModel.colors count] > 0) {
                    for (YYOrderOneColorModel *orderOneColorModel in styleModel.colors) {
                        if (orderOneColorModel.sizes && [orderOneColorModel.sizes count] > 0) {
                            for (YYOrderSizeModel *orderSizeModel in orderOneColorModel.sizes)
                            {
                                thisStyleSumCount += MAX(0,[orderSizeModel.amount intValue]);
                            }
                        }
                    }
                }
            }
        }
    }
    NSLog(@"111");
}
/**
 获取款式详情
 isModifyOrder == YES 时候才会调用
 @param styleID
 */
- (void)loadStyleInfoWithStyleId:(NSInteger )styleID{
    WeakSelf(ws);
    [YYOpusApi getStyleInfoByStyleId:styleID orderCode:nil andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYStyleInfoModel *styleInfoModel, NSError *error) {
        if (rspStatusAndMessage.status == YYReqStatusCode100) {
            ws.styleInfoModel = styleInfoModel;
            [ws updateThisStyleSumCount];
            [ws updateTotalInfo:thisStyleSumCount];
            [ws reloadTableViewData];
        }
    }];
}
#pragma mark - --------------other----------------------

@end
