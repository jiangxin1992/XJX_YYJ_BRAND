//
//  YYOrderModifyViewController.m
//  Yunejian
//
//  Created by yyj on 15/8/18.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYOrderModifyViewController.h"

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "YYCustomCellTableViewController.h"
#import "YYNavigationBarViewController.h"
#import "YYTaxChooseViewController.h"
#import "YYCustomCell02ViewController.h"
#import "YYCreateOrModifyAddressViewController.h"
#import "YYStyleDetailListViewController.h"
#import "YYBuyerAddressViewController.h"
#import "YYOrderStylesRemarkViewController.h"

// 自定义视图
#import "YYOrderRemarkCell.h"
#import "YYBuyerMessageCell.h"
#import "YYNewStyleDetailCell.h"
#import "YYOrderTaxInfoCell.h"
#import "YYOrderDetailSectionHead.h"
#import "YYDiscountView.h"
#import "YYPickView.h"

// 接口
#import "YYOrderApi.h"
#import "YYUserApi.h"

// 分类
#import "UIView+UpdateAutoLayoutConstraints.h"
#import "UIImage+Tint.h"

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYUser.h"
#import "YYBuyerModel.h"
#import "YYSalesManListModel.h"
#import "YYOrderInfoModel.h"
#import "YYOrderSettingInfoModel.h"
#import "YYStylesAndTotalPriceModel.h"

#import "regular.h"
#import "AppDelegate.h"
#import "UserDefaultsMacro.h"

#import "MBProgressHUD.h"
#import "MLInputDodger.h"
#import "YYYellowPanelManage.h"

#define kDelaySeconds 2
#define kOrderModifyPageSize 8

@interface YYOrderModifyViewController ()<UITableViewDataSource,UITableViewDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,YYTableCellDelegate,YYPickViewDelegate>


@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic )YYNavigationBarViewController *navigationBarViewController;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet YYDiscountView *priceTotalDiscountView;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property(nonatomic,assign) NSInteger totalSections;

@property(nonatomic,strong) YYStylesAndTotalPriceModel *stylesAndTotalPriceModel;//总数

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomLayoutConstraint;

@property (nonatomic,strong) YYOrderSettingInfoModel *orderSettingInfoModel;

@property(nonatomic,strong) YYPickView *pickerView;
@property(nonatomic,strong) NSMutableArray *salesManList;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceTotalRightWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *minOrderRithtWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderBtnWidthLayout;

//税制
@property (assign, nonatomic)NSInteger selectTaxType;
@property (weak, nonatomic) IBOutlet UIButton *minOrderMoneyBtn1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countLabelLayoutBottomConstraint;

@property (nonatomic,strong) NSMutableArray *menuData;
@end

@implementation YYOrderModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _priceTotalRightWidth.constant = IsPhone6_gt?15.0f:5.0f;
    _minOrderRithtWidth.constant = IsPhone6_gt?15.0f:5.0f;
    _countLabel.font = [UIFont systemFontOfSize:IsPhone6_gt?15.0f:12.0f];
    _countLabel.adjustsFontSizeToFitWidth = YES;
    _orderBtnWidthLayout.constant = IsPhone6_gt?120.0f:100.0f;
    [_saveButton.titleLabel setFont:[UIFont systemFontOfSize:IsPhone6_gt?18.0f:15.0f]];
    
    
    YYUser *user = [YYUser currentUser];
    if(user.userType == 5||user.userType == 6||user.userType == 2)
    {
        self.currentYYOrderInfoModel.billCreatePersonId =  [NSNumber numberWithInteger: [user.userId integerValue]];
        self.currentYYOrderInfoModel.billCreatePersonName = user.name;
        [_tableView reloadData];
    }
    if (!user.userType) {
        self.currentYYOrderInfoModel.billCreatePersonType = [self.salesManListModel getTypeWithID:self.currentYYOrderInfoModel.billCreatePersonId WithName:self.currentYYOrderInfoModel.billCreatePersonName];
    }else{
        self.currentYYOrderInfoModel.billCreatePersonType = [NSNumber numberWithInteger:user.userType];
    }

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YYNavigationBarViewController *navigationBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNavigationBarViewController"];
    navigationBarViewController.nowTitle = NSLocalizedString(@"确认订单", nil);
    navigationBarViewController.previousTitle = @"";
    self.navigationBarViewController = navigationBarViewController;
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
            [ws closeButtonClicked:nil];
            blockVc = nil;
        }
    }];
    self.tableView.shiftHeightAsDodgeViewForMLInputDodger = 44.0f+5.0f;
    [self.tableView registerAsDodgeViewForMLInputDodger];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.orderModel) {
        appDelegate.orderSeriesArray = nil;
        appDelegate.orderModel = nil;
    }
    
    [YYOrderApi getOrderSettingInfoWithBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,YYOrderSettingInfoModel *orderSettingInfoModel, NSError *error) {
        if (rspStatusAndMessage.status == kCode100) {
            ws.orderSettingInfoModel = orderSettingInfoModel;
        }
    }];
    
    //买手店数据（可修改地址）
    if (_isCreatOrder && !_isReBuildOrder) {
        _buyerModel = nil;
        _nowBuyerAddress = nil;
    }else{
        _buyerModel = [[YYBuyerModel alloc] init];
        _buyerModel.buyerId = _currentYYOrderInfoModel.realBuyerId;
        _buyerModel.name = _currentYYOrderInfoModel.buyerName;
        _buyerModel.contactEmail = (_currentYYOrderInfoModel.buyerEmail?_currentYYOrderInfoModel.buyerEmail:@"");
        
        _buyerModel.nation = (_currentYYOrderInfoModel.buyerAddressId?_currentYYOrderInfoModel.buyerAddress.nation:@"");
        _buyerModel.province = (_currentYYOrderInfoModel.buyerAddressId?_currentYYOrderInfoModel.buyerAddress.province:@"");
        _buyerModel.city = (_currentYYOrderInfoModel.buyerAddressId?_currentYYOrderInfoModel.buyerAddress.city:@"");
        
        _buyerModel.nationEn = (_currentYYOrderInfoModel.buyerAddressId?_currentYYOrderInfoModel.buyerAddress.nationEn:@"");
        _buyerModel.provinceEn = (_currentYYOrderInfoModel.buyerAddressId?_currentYYOrderInfoModel.buyerAddress.provinceEn:@"");
        _buyerModel.cityEn = (_currentYYOrderInfoModel.buyerAddressId?_currentYYOrderInfoModel.buyerAddress.cityEn:@"");
        
        _buyerModel.nationId = (_currentYYOrderInfoModel.buyerAddressId?_currentYYOrderInfoModel.buyerAddress.nationId:@(0));
        _buyerModel.provinceId = (_currentYYOrderInfoModel.buyerAddressId?_currentYYOrderInfoModel.buyerAddress.provinceId:@(0));
        _buyerModel.cityId = (_currentYYOrderInfoModel.buyerAddressId?_currentYYOrderInfoModel.buyerAddress.cityId:@(0));
        
        _nowBuyerAddress = _currentYYOrderInfoModel.buyerAddress;

    }
    //初始化_menuData
    _menuData = getPayTaxInitData();
    NSNumber *changeNum = [NSNumber numberWithFloat:[_currentYYOrderInfoModel.taxRate floatValue]/100.0f];
    updateCustomTaxValue(_menuData, changeNum,YES);
    _selectTaxType = getPayTaxTypeFormServiceNew(_menuData, [_currentYYOrderInfoModel.taxRate integerValue]);

    [self updateUI];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateShoppingCarNotification:)
                                                 name:kUpdateShoppingCarNotification
                                               object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.orderModel) {
        appDelegate.orderSeriesArray = nil;
        appDelegate.orderModel = nil;
    }
    [self updateUI];
    // 进入埋点
    // 进入埋点
    if (_isCreatOrder) {
        // 确认订单
        [MobClick beginLogPageView:kYYPageOrderModifyConfirm];

    }else{
        if(!_isAppendOrder){
            //修改订单
            [MobClick beginLogPageView:kYYPageOrderModifyUpdate];

        }else{
            // 补货追单
            [MobClick beginLogPageView:kYYPageOrderModifyReplenishment];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    // 退出埋点
    if (_isCreatOrder) {
        // 确认订单
        [MobClick endLogPageView:kYYPageOrderModifyConfirm];

    }else{
        if(!_isAppendOrder){
            //修改订单
            [MobClick endLogPageView:kYYPageOrderModifyUpdate];

        }else{
            // 补货追单
            [MobClick endLogPageView:kYYPageOrderModifyReplenishment];
        }
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUpdateShoppingCarNotification object:nil];
}

- (void)updateShoppingCarNotification:(NSNotification *)note{
    [self orderAddStyleNotification:note];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)closeButtonClicked:(id)sender{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUpdateShoppingCarNotification object:nil];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.orderModel) {
        appDelegate.orderSeriesArray = nil;
        appDelegate.orderModel = nil;
    }
    
    if (self.closeButtonClicked) {
        self.closeButtonClicked();
    }
}

- (void)closeModifyOrderViewWhenSave{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUpdateShoppingCarNotification object:nil];

    if (self.modifySuccess) {
        self.modifySuccess();
    }else{
        if (self.closeButtonClicked) {
            self.closeButtonClicked();
        }
    }
}



//更新显示总数
- (void)updateTotalValue{
    _minOrderMoneyBtn1.hidden = YES;
    _countLabelLayoutBottomConstraint.constant = 14;
    self.stylesAndTotalPriceModel = [self.currentYYOrderInfoModel getTotalValueByOrderInfo:NO];

    if (_stylesAndTotalPriceModel) {
        _countLabel.text = [NSString stringWithFormat:NSLocalizedString(@"共%i款 %i件",nil),_stylesAndTotalPriceModel.totalStyles,_stylesAndTotalPriceModel.totalCount];
        
        
        _priceTotalDiscountView.backgroundColor = [UIColor clearColor];
        
        _priceTotalDiscountView.bgColorIsBlack = NO;

        self.currentYYOrderInfoModel.finalTotalPrice = [NSNumber numberWithFloat:self.stylesAndTotalPriceModel.finalTotalPrice];
        
        _priceTotalDiscountView.showDiscountValue = NO;
        
        NSString *finalValue = nil;
        if(_isCreatOrder){
            finalValue = replaceMoneyFlag([NSString stringWithFormat:@"￥%.2f",_stylesAndTotalPriceModel.finalTotalPrice],[_currentYYOrderInfoModel.curType integerValue]);
        }else{
            finalValue = replaceMoneyFlag([NSString stringWithFormat:@"￥%.2f",_stylesAndTotalPriceModel.finalTotalPrice],[_currentYYOrderInfoModel.curType integerValue]);
        }
        CGSize txtSize = [finalValue sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:IsPhone6_gt?15:13]}];

        
        _priceTotalDiscountView.notShowDiscountValueTextAlignmentLeft = YES;
        _priceTotalDiscountView.fontColorStr =  @"ed6498";
        [_priceTotalDiscountView updateUIWithOriginPrice:finalValue
                                              fianlPrice:finalValue
                                              originFont:[UIFont boldSystemFontOfSize:IsPhone6_gt?15:13]
                                               finalFont:[UIFont boldSystemFontOfSize:IsPhone6_gt?15:13]];
        [_priceTotalDiscountView setConstraintConstant:txtSize.width+1 forAttribute:NSLayoutAttributeWidth];
        WeakSelf(ws);
        __block double blockcostMeoney = _stylesAndTotalPriceModel.originalTotalPrice;
        __block float blockcurType = [self.currentYYOrderInfoModel.curType integerValue];
        if(blockcurType >= 0){
            [YYOrderApi getOrderUnitPrice:[self.currentYYOrderInfoModel.designerId unsignedIntegerValue] moneyType:blockcurType andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSUInteger orderUnitPrice, NSError *error) {
                if(orderUnitPrice > blockcostMeoney){

                    UIImage *icon = [[UIImage imageNamed:@"warn"] imageWithTintColor:[UIColor colorWithHex:@"ef4e31"]];
                    [ws.minOrderMoneyBtn1 setImage:icon forState:UIControlStateNormal];
                    [ws.minOrderMoneyBtn1 setTitle:replaceMoneyFlag([NSString stringWithFormat:NSLocalizedString(@"未达到每单起订额 ￥%ld",nil),orderUnitPrice],blockcurType) forState:UIControlStateNormal];
                    ws.minOrderMoneyBtn1.hidden = NO;
                    ws.countLabelLayoutBottomConstraint.constant = 14+7;
                }
            }];
        }
    }
}



- (void)updateUI{
    if (_isCreatOrder) {
        [_saveButton setTitle:NSLocalizedString(@"建立订单",nil) forState:UIControlStateNormal];
        //创建时，订单状态是正常
        if (!self.currentYYOrderInfoModel.designerOrderStatus || !self.currentYYOrderInfoModel.buyerOrderStatus) {
            self.currentYYOrderInfoModel.designerOrderStatus = [NSNumber numberWithInt:0];
            self.currentYYOrderInfoModel.buyerOrderStatus = [NSNumber numberWithInt:0];
        }

        if (!self.currentYYOrderInfoModel.shareCode) {
            //如果是新建订单，而且没有网络
            
            self.currentYYOrderInfoModel.shareCode = createOrderSharecode();
        }
        
    }else{
        if(!_isAppendOrder){
            _navigationBarViewController.nowTitle =NSLocalizedString( @"修改订单",nil);
            [_saveButton setTitle:NSLocalizedString(@"保存修改",nil) forState:UIControlStateNormal];
        }else{
            _navigationBarViewController.nowTitle = NSLocalizedString(@"补货追单",nil);
            [_saveButton setTitle:NSLocalizedString(@"确认追单",nil) forState:UIControlStateNormal];
        }
    }
    
    if (!self.currentYYOrderInfoModel.orderCreateTime) {
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970]*1000;
        self.currentYYOrderInfoModel.orderCreateTime = [NSNumber numberWithLongLong:time];
    }
    [_navigationBarViewController updateUI];
    [self updateTotalValue];
    
    self.totalSections = [self.currentYYOrderInfoModel.groups count]+2;

    if (!_stylesAndTotalPriceModel.totalStyles || !_stylesAndTotalPriceModel.totalCount) {
        _saveButton.backgroundColor = [UIColor colorWithHex:@"d3d3d3"];
    }else{
        _saveButton.backgroundColor = _define_black_color;
    }

    [self.tableView reloadData];
}
- (IBAction)saveButtonClicked:(id)sender{
    if (_stylesAndTotalPriceModel.totalStyles == 0) {
        [YYToast showToastWithView:self.view title:NSLocalizedString(@"订单中款式数为0，不能保存修改",nil)  andDuration:kAlertToastDuration];
        return;
    }
    
    if (_stylesAndTotalPriceModel.totalCount == 0) {
        [YYToast showToastWithView:self.view title:NSLocalizedString(@"订单中件数为0，不能保存修改",nil)  andDuration:kAlertToastDuration];
        return;
    }
    
    WeakSelf(ws);
    NSString *tmpBuyerName = (self.currentYYOrderInfoModel.buyerName?self.currentYYOrderInfoModel.buyerName:@"");
    tmpBuyerName = [tmpBuyerName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([tmpBuyerName isEqualToString:@""]) {
        [YYToast showToastWithView:self.view title:NSLocalizedString(@"请添加买家名称",nil)  andDuration:kAlertToastDuration];
        return;
    }
    if(_buyerModel){
        self.currentYYOrderInfoModel.buyerEmail =_buyerModel.contactEmail;
        self.currentYYOrderInfoModel.realBuyerId =_buyerModel.buyerId;
        self.currentYYOrderInfoModel.buyerName =_buyerModel.name;
    }

    NSMutableArray *seriesIds =  [[NSMutableArray alloc] init];
    [_currentYYOrderInfoModel.groups enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YYOrderOneInfoModel *orderOneInfoModel = obj;
        if (orderOneInfoModel) {
            if ([orderOneInfoModel.styles count] > 0) {
                for (YYOrderStyleModel *orderStyleModel in orderOneInfoModel.styles) {
                    if(![seriesIds containsObject:[orderStyleModel.seriesId stringValue]]){
                        [seriesIds addObject:[orderStyleModel.seriesId stringValue]];
                    }
                }
            }
        }
    }];

    //删除系列队列seriesMap
    NSArray *allKeys = [_currentYYOrderInfoModel.seriesMap allKeys];
    for (NSString *seriesId  in allKeys) {
        if(![seriesIds containsObject:seriesId]){
            [_currentYYOrderInfoModel.seriesMap removeObjectForKey:seriesId];
        }
    }

    if (self.stylesAndTotalPriceModel) {
        self.currentYYOrderInfoModel.totalPrice = [NSNumber numberWithFloat: self.stylesAndTotalPriceModel.originalTotalPrice];
        
    }
    if (!self.currentYYOrderInfoModel.orderCreateTime) {
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970]*1000;
        self.currentYYOrderInfoModel.orderCreateTime = [NSNumber numberWithLongLong:time];
    }

    if (![YYCurrentNetworkSpace isNetwork]) {
        [YYToast showToastWithView:self.view title:kNetworkIsOfflineTips andDuration:kAlertToastDuration];
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        YYAddress * adress = [self getcurBuyerAddress];
        if(adress != nil ){
            __block BOOL _inRunLoop = true;
            NSString *orderCode = (_isCreatOrder?nil:self.currentYYOrderInfoModel.orderCode);
            [YYOrderApi createOrModifyAddress:adress orderCode:orderCode andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYBuyerAddressModel *addressModel, NSError *error) {
                if (rspStatusAndMessage.status == kCode100
                    && addressModel
                    && addressModel.addressId){
                    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
                    ws.currentYYOrderInfoModel.buyerAddress.addressId = [numberFormatter numberFromString:addressModel.addressId];
                    ws.currentYYOrderInfoModel.buyerAddressId = [numberFormatter numberFromString:addressModel.addressId];
                    _inRunLoop = false;
                }else{
                    [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];
                }
            }];
            while (_inRunLoop) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
        }

        NSData *jsonData = [[self.currentYYOrderInfoModel toDictionary] mj_JSONData];

        NSString *actionRefer = (_isCreatOrder?@"create":@"modify");
        if(_isAppendOrder){
            actionRefer = @"append";
        }
        NSInteger realBuyerId = [_buyerModel.buyerId integerValue];

        [YYOrderApi createOrModifyOrderByJsonData:jsonData actionRefer:actionRefer realBuyerId:realBuyerId andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSString *orderCode, NSError *error) {
            if (rspStatusAndMessage.status == kCode100) {
                [YYToast showToastWithView:ws.view title:NSLocalizedString(@"操作成功",nil)  andDuration:kAlertToastDuration];
                
                if (ws.currentYYOrderInfoModel.shareCode
                    && !ws.currentYYOrderInfoModel.orderCode){
                    //这里要清除购物车
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    [appDelegate clearBuyCar];
                    //更新购物车按钮数量
                    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateShoppingCarNotification object:nil];
                 }

                // 延迟调用
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDelaySeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];
                    [ws closeModifyOrderViewWhenSave];
                });
                
            }else{
                [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];
                [YYToast showToastWithView:ws.view title:rspStatusAndMessage.message andDuration:kAlertToastDuration];
            }

        }];
    }
}

- (void)orderAddStyleNotification:(NSNotification *)note{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.orderModel) {
        NSLog(@"appDelegate.orderModel toJSONString : %@",[appDelegate.orderModel toJSONString]);
        
        self.currentYYOrderInfoModel = [[YYOrderInfoModel alloc] initWithDictionary:[appDelegate.orderModel toDictionary] error:nil];
        self.currentYYOrderInfoModel.finalTotalPrice = nil;
        if(note == nil){//不是消息就清理掉 添加款式多次用到缓存
            appDelegate.orderSeriesArray = nil;
            appDelegate.orderModel = nil;
        }
    }
     [self updateUI];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.totalSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rows = 0;
    if (section == 0) {
        return 3;
    }else if (section == self.totalSections-1) {
        return 1;
    }else{
        if (_currentYYOrderInfoModel
            && _currentYYOrderInfoModel.groups
            && [_currentYYOrderInfoModel.groups count] > 0) {
            
            NSInteger nowIndex = section-1;
            if (nowIndex >= 0
                && nowIndex < [_currentYYOrderInfoModel.groups count]) {
                YYOrderOneInfoModel *orderOneInfoModel = _currentYYOrderInfoModel.groups[nowIndex];
                if (orderOneInfoModel.styles
                    && [orderOneInfoModel.styles count] > 0) {
                    rows = [orderOneInfoModel.styles count];
                }
            }
        }
    }
    
    
    return rows;
}

- (NSInteger)getArrayCount:(NSArray *)data {
    if (data) {
        return [data count];
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    WeakSelf(ws);
    if (indexPath.section == 0) {
        if(indexPath.row == 0){
            static NSString *CellIdentifier = @"YYBuyerMessageCell";
            YYBuyerMessageCell *buyerMessageCell =  [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(!buyerMessageCell){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OrderDetail" bundle:[NSBundle mainBundle]];
            YYCustomCell02ViewController *customCell02ViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYCustomCell02ViewController"];
            buyerMessageCell = [customCell02ViewController.tableView dequeueReusableCellWithIdentifier:CellIdentifier];

            //选择送货方式这块
            [buyerMessageCell setOrderDeliverMethodButtonClicked:^(UIView *view){
                NSInteger dataCount = [ws getArrayCount:ws.orderSettingInfoModel.deliveryList];
                if(dataCount == 0){
                    [YYToast showToastWithView:ws.view title:NSLocalizedString(@"没有发货方式可供选择",nil) andDuration:kAlertToastDuration];
                    return ;
                }
                [ws showPickView:ws.orderSettingInfoModel.deliveryList type:UIDataTypeDeliveryList];
            }];
            //选择付款方式这块
            [buyerMessageCell setAccountsMethodButtonClicked:^(UIView *view){
                NSInteger dataCount = [ws getArrayCount:ws.orderSettingInfoModel.payList];
                if(dataCount == 0){
                    [YYToast showToastWithView:ws.view title:NSLocalizedString(@"没有结算方式可供选择",nil) andDuration:kAlertToastDuration];
                    return ;
                }
                
                [ws showPickView:ws.orderSettingInfoModel.payList type:UIDataTypePayList];
            }];
            //添加买家名称这块
            [buyerMessageCell setOrderCreateBuyerMessageButtonClicked:^(UIView *view){
                
                if (TARGET_IPHONE_SIMULATOR) {
                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                        UIImagePickerController *picker=[[UIImagePickerController alloc] init];
                        picker.view.backgroundColor = _define_white_color;
                        picker.delegate = ws;
                        picker.allowsEditing = NO;
                        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                        //picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                        [ws presentViewController:picker animated:YES completion:nil];
                    }else
                    {
                        NSLog(@"无法打开相册");
                    }
                }else{
                    
                    WeakSelf(ws);
                    UIImagePickerController *picker=[[UIImagePickerController alloc] init];
                    picker.view.backgroundColor = _define_white_color;
                    picker.delegate = self;
                    picker.videoQuality = UIImagePickerControllerQualityTypeLow;
                    picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                    UIAlertController * alertController = [regular getAlertWithFirstActionTitle:NSLocalizedString(@"相册",nil) FirstActionBlock:^{
                        
                        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                            picker.allowsEditing = NO;
                            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                            [ws presentViewController:picker animated:YES completion:nil];
                        }else
                        {
                            NSLog(@"无法打开相册");
                        }
                        
                    } SecondActionTwoTitle:NSLocalizedString(@"拍照",nil) SecondActionBlock:^{
                        
                        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                            //打开相机
                            picker.allowsEditing = NO;
                            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                            //picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                            [ws presentViewController:picker animated:YES completion:nil];
                        }else
                        {
                            NSLog(@"不能打开相机");
                        }
                        
                    }];
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                }
            }];
            //添加买家地址这块
            if(_currentYYOrderInfoModel.addressModifAvailable){
                [buyerMessageCell setOrderCreateBuyerAddressButtonClicked:^(){
                    [ws addAddress];
                }];
            }else{
                [buyerMessageCell setOrderCreateBuyerAddressButtonClicked:nil];
            }
            //添加买家名称
            if(_isCreatOrder){
                [buyerMessageCell setOrderCreateBuyerNameButtonClicked:^(){
                    [[YYYellowPanelManage instance] showOrderBuyerAddressListPanel:@"Order" andIdentifier:@"YYOrderAddressListController" needUnDefineBuyer:1 parentView:ws andCallBack:^(NSArray *value){
                        NSString* name = [value objectAtIndex:0];
                        YYBuyerModel *infoModel = nil;
                        if([value count] >= 2){
                            infoModel = [value objectAtIndex:1];
                            ws.currentYYOrderInfoModel.buyerName = infoModel.name;
                        }else{
                            ws.currentYYOrderInfoModel.buyerName = name;
                        }
                        ws.buyerModel = infoModel;
                        [ws updateUI];
                    }];
                }];
            }else{
                [buyerMessageCell setOrderCreateBuyerNameButtonClicked:nil];
            }
            
            }
            buyerMessageCell.currentYYOrderInfoModel = self.currentYYOrderInfoModel;
            buyerMessageCell.buyerAddress = _nowBuyerAddress;
            buyerMessageCell.buyerModel = _buyerModel;
            buyerMessageCell.delegate = self;
            buyerMessageCell.indexPath = indexPath;
            [buyerMessageCell updateUI];
            cell = buyerMessageCell;
        }else  if(indexPath.row == 2){
            if(_isCreatOrder && !_isReBuildOrder){
                UITableViewCell *nullcell = [self.tableView dequeueReusableCellWithIdentifier:@"YYOrderNullCell"];
                if(nullcell == nil){
                    nullcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YYOrderNullCell"];
                }
                cell = nullcell;
            }else{
                static NSString *CellIdentifier = @"YYAddStyleCell";
                UITableViewCell *addStyleCell =  [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if(!addStyleCell){
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OrderDetail" bundle:[NSBundle mainBundle]];
                    YYCustomCell02ViewController *customCell02ViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYCustomCell02ViewController"];
                    addStyleCell = [customCell02ViewController.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                }
                UIButton *addbtn = [addStyleCell viewWithTag:10001];
                [addbtn addTarget:self action:@selector(thirdButtonClicked) forControlEvents:UIControlEventTouchUpInside];
                cell = addStyleCell;
            }
        }else{
            static NSString *CellIdentifier = @"YYOrderTaxInfoCell";
            YYOrderTaxInfoCell *taxInfoCell =  [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(!taxInfoCell){
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OrderDetail" bundle:[NSBundle mainBundle]];
                YYCustomCell02ViewController *customCell02ViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYCustomCell02ViewController"];
                taxInfoCell = [customCell02ViewController.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            }
            taxInfoCell.menuData = _menuData;
            taxInfoCell.selectTaxType = _selectTaxType;
            taxInfoCell.delegate = self;
            taxInfoCell.indexPath = indexPath;
            taxInfoCell.stylesAndTotalPriceModel = _stylesAndTotalPriceModel;
            taxInfoCell.currentYYOrderInfoModel = _currentYYOrderInfoModel;
            taxInfoCell.moneyType = [_currentYYOrderInfoModel.curType integerValue];
            WeakSelf(ws);
            [taxInfoCell setTaxChooseBlock:^{
                YYTaxChooseViewController *chooseTaxView = [[YYTaxChooseViewController alloc] init];
                chooseTaxView.selectIndex = _selectTaxType;
                chooseTaxView.selectData = _menuData;
                [chooseTaxView setCancelButtonClicked:^(){
                    [ws.navigationController popViewControllerAnimated:YES];
                }];
                [chooseTaxView setSelectBlock:^(NSInteger selectIndex){
                    ws.selectTaxType = selectIndex;
                    if(selectIndex != 2){
                        ws.menuData = getPayTaxInitData();
                    }
                    [ws.navigationController popViewControllerAnimated:YES];
                    [self btnClick:indexPath.row section:indexPath.section andParmas:@[@"taxType",@(_selectTaxType)]];
                    NSLog(@"111");
                }];
                [self.navigationController pushViewController:chooseTaxView animated:YES];
            }];
            if(_isAppendOrder || [_currentYYOrderInfoModel.isAppend integerValue] == 1){
                taxInfoCell.viewType = 4;
            }else{
                taxInfoCell.viewType = (_isCreatOrder?1:2);
            }
            taxInfoCell.spaceViewType = 1;
            [taxInfoCell updateUI];
            cell = taxInfoCell;
        }
        
    }else if (indexPath.section != self.totalSections-1) {
        
        static NSString *CellIdentifier = @"YYNewStyleDetailCell";
        YYNewStyleDetailCell *tempCell =  [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!tempCell){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OrderDetail" bundle:[NSBundle mainBundle]];
            YYCustomCellTableViewController *customCellTableViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYCustomCellTableViewController"];
            tempCell = [customCellTableViewController.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        if (_currentYYOrderInfoModel && _currentYYOrderInfoModel.groups && [_currentYYOrderInfoModel.groups count] > 0) {
            YYOrderOneInfoModel *orderOneInfoModel = _currentYYOrderInfoModel.groups[indexPath.section - 1];
            if (orderOneInfoModel.styles && [orderOneInfoModel.styles count] > 0) {
                YYOrderStyleModel *orderStyleModel = [orderOneInfoModel.styles objectAtIndex:indexPath.row];
                orderStyleModel.curType = _currentYYOrderInfoModel.curType;
                YYOrderSeriesModel *orderSeriesModel = self.currentYYOrderInfoModel.seriesMap[[orderStyleModel.seriesId stringValue]];
                tempCell.orderStyleModel = orderStyleModel;
                tempCell.orderOneInfoModel = orderOneInfoModel;
                tempCell.orderSeriesModel = orderSeriesModel;
            }
        }
        if (_isCreatOrder) {
            if(_isReBuildOrder){
                tempCell.isModifyNow = 3;
            }else{
                tempCell.isModifyNow = 0;
            }
        }else{
            if(_isAppendOrder){
                tempCell.isModifyNow = 5;
            }else{
                tempCell.isModifyNow = 3;
            }
        }
        tempCell.menuData = _menuData;
        tempCell.delegate = self;
        tempCell.indexPath = indexPath;
        tempCell.selectTaxType = getPayTaxTypeFormServiceNew(_menuData,[ws.currentYYOrderInfoModel.taxRate integerValue]);
        tempCell.isAppendOrder = _isAppendOrder;
        [tempCell updateUI];
        cell = tempCell;
    }else if (indexPath.section == self.totalSections-1) {
        static NSString *CellIdentifier = @"YYOrderRemarkCell";
        YYOrderRemarkCell *orderRemarkCell  =  [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!orderRemarkCell){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OrderDetail" bundle:[NSBundle mainBundle]];
            YYCustomCell02ViewController *customCell02ViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYCustomCell02ViewController"];
            orderRemarkCell = [customCell02ViewController.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        orderRemarkCell.currentYYOrderInfoModel = self.currentYYOrderInfoModel;
        [orderRemarkCell updateUI];
        YYUser *user = [YYUser currentUser];
        if(user.userType != 5&&user.userType != 6&&user.userType != 2)
        {
            [orderRemarkCell setOneState:NO];
        }else
        {
            [orderRemarkCell setOneState:YES];
        }
        //订单备注这块
        [orderRemarkCell setTextViewIsEditCallback:^(BOOL isEdit){
            [UIView animateWithDuration:0.3 animations:^{
                [ws.tableView layoutIfNeeded];
                [ws.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:ws.totalSections-1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }];
            
        }];
        
        //销售代表
        [orderRemarkCell setBuyerButtonClicked:^(UIView *view){
            
            if(user.userType != 5&&user.userType != 6&&user.userType != 2)
            {
                WeakSelf(ws);
                _salesManList = [[NSMutableArray alloc] init];
                
                [YYUserApi getSalesManListWithBlockNew:^(YYRspStatusAndMessage *rspStatusAndMessage, YYSalesManListModel *salesManListModel, NSError *error) {
                    if (rspStatusAndMessage.status == kCode100) {
                        //排序
                        ws.salesManListModel = salesManListModel;
                        __block NSMutableArray *arr = [[NSMutableArray alloc] init];
                        [ws.salesManListModel sortModelWithAddArr:nil];
                        
                        NSInteger dataCount = [ws getArrayCount:ws.salesManListModel.result];
                        if(dataCount == 0 && [ws.salesManList count] == 0){
                            [YYToast showToastWithView:ws.view title:NSLocalizedString(@"没有销售代表可供选择",nil) andDuration:kAlertToastDuration];
                            return ;
                        }
                        for (YYSalesManModel* model in ws.salesManListModel.result) {
                            if([model.userType integerValue] == 5||[model.userType integerValue] == 6)
                            {
                                if(![NSString isNilOrEmpty:model.showroomName])
                                {
                                    [arr addObject:[[NSString alloc] initWithFormat:@"%@（%@）",model.username,model.showroomName]];
                                }else
                                {
                                    [arr addObject:model.username];
                                }
                            }else
                            {
                                [arr addObject:model.username];
                            }
                            [ws.salesManList addObject:model];
                        }

                        [ws showPickView:arr type:UIDataTypeSalesManList];
                        
                    }else{
                        [YYToast showToastWithView:ws.view title:rspStatusAndMessage.message andDuration:kAlertToastDuration];
                    }
                }];
            }
        }];
    
    //选择下单场这块
    [orderRemarkCell setOrderSituationButtonClicked:^(UIView *view){
        NSInteger dataCount = [ws getArrayCount:ws.orderSettingInfoModel.occasionList];
        if(dataCount == 0){
            [YYToast showToastWithView:ws.view title:NSLocalizedString(@"没有建单场合可供选择",nil) andDuration:kAlertToastDuration];
            return ;
        }

        [ws showPickView:ws.orderSettingInfoModel.occasionList type:UIDataTypeOccasionList];
     }];

    [orderRemarkCell setRemarkButtonClicked:^(){
        
        [ws showStyleRemarkViewController];
    }];
    
        cell = orderRemarkCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return  0.1;
}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if(indexPath.row == 0){
            if( _nowBuyerAddress == nil ){
                return 390 - 106 +48;
            }
            return 390 - 106 + 90;
        }else if(indexPath.row == 2){
            if( _isCreatOrder && !_isReBuildOrder){
                return 0.1;
            }
            return 66;
        }else{
            NSInteger moneyType = [_currentYYOrderInfoModel.curType integerValue];
            BOOL needTaxView = NO;
            if(needPayTaxView(moneyType)){
                needTaxView = YES;
            }
            BOOL needDiscountView = YES;
            if (_isCreatOrder) {
                needDiscountView = NO;
            }
            return [YYOrderTaxInfoCell CellHeight:needTaxView :needDiscountView];
        }
    }else if (indexPath.section == self.totalSections-1) {
        return 235+60;
    }else{
        
        NSInteger styleBuyedSizeCount = 0;
        NSInteger styleTotalNum = 0;
        YYOrderOneInfoModel *orderOneInfoModel =  [_currentYYOrderInfoModel.groups objectAtIndex:indexPath.section - 1];
        if (orderOneInfoModel && indexPath.row < [orderOneInfoModel.styles count]) {
            YYOrderStyleModel *styleModel = [orderOneInfoModel.styles objectAtIndex:indexPath.row];
            if (styleModel.colors && [styleModel.colors count] > 0) {
                for (int i=0; i<[styleModel.colors count]; i++) {
                    YYOrderOneColorModel *orderOneColorModel = [styleModel.colors objectAtIndex:i];

                    //判断amount是不是都是0
                    BOOL isColorSelect = [orderOneColorModel.isColorSelect boolValue];

                    if(isColorSelect){
                        if(!_isCreatOrder && _isAppendOrder){
                            //显示全部size
                            styleBuyedSizeCount += [orderOneColorModel.sizes count];
                        }else{
                            styleBuyedSizeCount += 1;
                        }
                    }else{
                        //判断amount是不是大于0
                        for (YYOrderSizeModel *sizeModel in orderOneColorModel.sizes) {
                            if([sizeModel.amount integerValue] > 0 || [sizeModel.amount integerValue] == -1){
                                styleBuyedSizeCount ++;
                            }
                        }
                    }

                    for (YYOrderSizeModel *sizeModel in orderOneColorModel.sizes) {
                        if([sizeModel.amount integerValue] > 0 || [sizeModel.amount integerValue] == -1){
                            styleTotalNum += MAX(0, [sizeModel.amount integerValue]);
                        }
                    }
                }
            }
            BOOL showHelpFlag = ((styleTotalNum < [styleModel.orderAmountMin integerValue]) || (self.isAppendOrder && [styleModel.supportAdd integerValue] ==0));
            return [YYNewStyleDetailCell CellHeight:styleBuyedSizeCount showHelpFlag:showHelpFlag showTopHeader:[orderOneInfoModel isInStock]];
        }
    }
    
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section != 0 && section != self.totalSections - 1) {
        YYOrderOneInfoModel *orderOneInfoModel = _currentYYOrderInfoModel.groups[section - 1];
        if (![orderOneInfoModel isInStock]) {
            static NSString *CellIdentifier = @"YYOrderDetailSectionHead";
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OrderDetail" bundle:[NSBundle mainBundle]];
            YYCustomCellTableViewController *customCellTableViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYCustomCellTableViewController"];
            
            YYOrderOneInfoModel *orderOneInfoModel =  [_currentYYOrderInfoModel.groups objectAtIndex:section-1];
            YYOrderDetailSectionHead *sectionHead = [customCellTableViewController.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            sectionHead.isHiddenSelectDateView = YES;
            sectionHead.contentView.backgroundColor = [UIColor whiteColor];
            sectionHead.orderOneInfoModel = orderOneInfoModel;
            [sectionHead updateUI];
            return sectionHead;
        } else {
            return nil;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 || section == self.totalSections-1) {
        return 0;
    } else {
        YYOrderOneInfoModel *orderOneInfoModel = _currentYYOrderInfoModel.groups[section - 1];
        if ([orderOneInfoModel isInStock]) {
            return 0;
        } else {
            return 40;
        }
    }
}

#pragma 编辑
-(void)showShoppingView:(NSIndexPath *)indexPath{
   // NSLog(@"indexPath.section ,indexPath.row %d %d",indexPath.section,indexPath.row);
    //把当前的订单对象，传到全局的AppDelegate中
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.orderModel = [[YYOrderInfoModel alloc] initWithDictionary:[self.currentYYOrderInfoModel toDictionary] error:nil];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:0];
    [tempArray addObjectsFromArray:self.currentYYOrderInfoModel.groups];
    appDelegate.orderSeriesArray = tempArray;
    
    YYOrderOneInfoModel *oneInfoModel = _currentYYOrderInfoModel.groups[indexPath.section-1];
    YYOrderStyleModel *orderStyleModel = [oneInfoModel.styles objectAtIndex:indexPath.row];
    orderStyleModel.tmpDateRange = oneInfoModel.dateRange;
    YYOrderSeriesModel *orderseriesModel = [_currentYYOrderInfoModel.seriesMap objectForKey:[orderStyleModel.seriesId stringValue]];
    if(orderStyleModel == nil || orderseriesModel == nil){
        return;
    }
    
    UIView *superView = self.view;
    [appDelegate showShoppingView:YES styleInfoModel:orderStyleModel seriesModel:orderseriesModel opusStyleModel:nil parentView:superView fromBrandSeriesView:NO WithBlock:nil];
}

-(void)deleteCellStyleInfo:(NSIndexPath *)indexPath{
    YYOrderOneInfoModel *orderOneInfo = _currentYYOrderInfoModel.groups[indexPath.section-1];
    if([orderOneInfo.styles count] > indexPath.row){
        [orderOneInfo.styles removeObjectAtIndex:indexPath.row];
    }
    if([orderOneInfo.styles count] == 0){
        [_currentYYOrderInfoModel.groups removeObjectAtIndex:indexPath.section-1];
    }
    self.totalSections = [self.currentYYOrderInfoModel.groups count]+2;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //    获取选择图片
    UIImage *image = [UIImage fixOrientation:info[UIImagePickerControllerOriginalImage]];
    WeakSelf(ws);
    
    if (image) {
        
        if (![YYCurrentNetworkSpace isNetwork]) {
            if (self.currentYYOrderInfoModel.shareCode
                && !self.currentYYOrderInfoModel.orderCode) {
                [ws updateUI];
            }
        }else{
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [YYOrderApi uploadImage:image size:2.0f andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSString *imageUrl, NSError *error) {
                [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];
                if (imageUrl
                    && [imageUrl length] > 0) {
                    NSLog(@"imageUrl: %@",imageUrl);
                    
                    ws.currentYYOrderInfoModel.businessCard = imageUrl;
                    [ws updateUI];
                }
                
            }];
            
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma YYTableCellDelegate
-(void)btnClick:(NSInteger)row section:(NSInteger)section andParmas:(NSArray *)parmas{
    WeakSelf(ws);
    if(section == 0){
        if(row == 0){
            [self changeAddress];
        }else if(row == 2){
            [self thirdButtonClicked];
        }else{
            NSString *type = [parmas objectAtIndex:0];
            if ([type isEqualToString:@"taxType"]){
                _selectTaxType = [[parmas objectAtIndex:1] integerValue];
                _currentYYOrderInfoModel.taxRate = [NSNumber numberWithInteger:getPayTaxTypeToServiceNew(_menuData,_selectTaxType)];
                [self updateUI];
            }else if([type isEqualToString:@"discount"]){
                double originalPrice = self.stylesAndTotalPriceModel.originalTotalPrice*(1 + [self.currentYYOrderInfoModel.taxRate doubleValue]/100);
                double finalPrice = [self.currentYYOrderInfoModel.finalTotalPrice doubleValue];
                //若为款式添加折扣，订单总价的折扣将被清除，是否继续吗？继续添加折扣/取消
                [[YYYellowPanelManage instance] showStyleDiscountPanel:@"Account" andIdentifier:@"YYDiscountViewController" type:DiscountTypeTotalPrice orderStyleModel:nil orderInfoModel:ws.currentYYOrderInfoModel AndSeriesId:0 originalPrice:originalPrice finalPrice:finalPrice parentView:self andCallBack:^(NSArray *value) {
                    ws.currentYYOrderInfoModel.discount = [value objectAtIndex:0];
                    [ws updateUI];
                }];
            }
        }
    }else if(section > 0){
        NSString *type = [parmas objectAtIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        
        if([type isEqualToString:@"edit"]){
            [self showShoppingView:indexPath];
        }else if ([type isEqualToString:@"delete"]){
            CMAlertView *alertView = [[CMAlertView alloc] initWithTitle:NSLocalizedString(@"确定要删除款式吗？",nil) message:nil needwarn:NO delegate:nil cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:@[NSLocalizedString(@"删除款式",nil)]];
            alertView.specialParentView = self.view;
            [alertView setAlertViewBlock:^(NSInteger selectedIndex){
                if (selectedIndex == 1) {
                    [ws deleteCellStyleInfo:indexPath];
                    ws.currentYYOrderInfoModel.finalTotalPrice = nil;
                    [ws updateTotalValue];
                    [ws.tableView reloadData];
                }
            }];
            [alertView show];
        }else if([type isEqualToString:@"editStyleNum"]){
            NSIndexPath *sizeIndexPath = [parmas objectAtIndex:1];
            NSString *num = [parmas objectAtIndex:2];
            [self editCellStyleInfo:indexPath sizeIndex:sizeIndexPath amount:num];
            [self updateUI];
        }
    }
}

-(void)editCellStyleInfo:(NSIndexPath *)indexPath sizeIndex:(NSIndexPath *)index amount:(NSString *)amount{
    YYOrderOneInfoModel *orderOneInfo = _currentYYOrderInfoModel.groups[indexPath.section-1];
    YYOrderStyleModel *orderStyleModel = [orderOneInfo.styles objectAtIndex:indexPath.row];
    YYOrderOneColorModel * oneColorModel = [orderStyleModel.colors objectAtIndex:index.section];
    YYOrderSizeModel * sizeModel = [oneColorModel.sizes objectAtIndex:index.row];
    sizeModel.amount = [[NSNumber alloc] initWithInteger:[amount integerValue]];
    if([amount integerValue] == 0){
        for (oneColorModel in orderStyleModel.colors) {
            for (sizeModel in oneColorModel.sizes) {
                if(sizeModel.amount && [sizeModel.amount integerValue] != 0){
                    return;
                }
            }
        }
        [orderOneInfo.styles removeObjectAtIndex:indexPath.row];
    }
}

#pragma mark --更换地址
-(void)changeAddress{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Account" bundle:[NSBundle mainBundle]];
    YYBuyerAddressViewController *buyerAddressViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYBuyerAddressViewController"];
    WeakSelf(ws);
    [buyerAddressViewController setCancelButtonClicked:
     ^(){
         [ws.navigationController popViewControllerAnimated:YES];
     }];
    [buyerAddressViewController setSelectAddressClicked:
     ^(YYAddress *address){
         [ws.navigationController popViewControllerAnimated:YES];
         [ws updateBuyerAddress:address];
     }];
    buyerAddressViewController.isSelect = 1;
    [self.navigationController pushViewController:buyerAddressViewController animated:YES];

}

//添加收货地址
- (void)addAddress{
    if(!_currentYYOrderInfoModel.addressModifAvailable){
        [YYToast showToastWithView:self.view title:NSLocalizedString(@"买手店已添加过的地址,不能再次添加!",nil) andDuration:kAlertToastDuration];
        return;
    }
    WeakSelf(ws);

    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Account" bundle:[NSBundle mainBundle]];
    YYCreateOrModifyAddressViewController *createOrModifyAddressViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYCreateOrModifyAddressViewController"];
    createOrModifyAddressViewController.currentOperationType = OperationTypeHelpCreate;
    createOrModifyAddressViewController.currentYYOrderInfoModel = self.currentYYOrderInfoModel;
    if (_nowBuyerAddress) {
        YYAddress *address = [[YYAddress alloc] init];
        address.receiverName = _nowBuyerAddress.receiverName;
        address.receiverPhone = _nowBuyerAddress.receiverPhone;
        address.zipCode = _nowBuyerAddress.zipCode;
        address.detailAddress = _nowBuyerAddress.detailAddress;
        address.nation = _nowBuyerAddress.nation;
        address.province = _nowBuyerAddress.province;
        address.city = _nowBuyerAddress.city;
        address.nationEn = _nowBuyerAddress.nationEn;
        address.provinceEn = _nowBuyerAddress.provinceEn;
        address.cityEn = _nowBuyerAddress.cityEn;
        address.nationId = _nowBuyerAddress.nationId;
        address.provinceId = _nowBuyerAddress.provinceId;
        address.cityId = _nowBuyerAddress.cityId;

        address.street = _nowBuyerAddress.street;
        createOrModifyAddressViewController.address = address;
    }else{
        createOrModifyAddressViewController.address = nil;
    }
    [self.navigationController pushViewController:createOrModifyAddressViewController animated:YES];
    

    [createOrModifyAddressViewController setCancelButtonClicked:^(){
        [ws.navigationController popViewControllerAnimated:YES];
    }];
    
    [createOrModifyAddressViewController setModifySuccess:^(){
        [ws.navigationController popViewControllerAnimated:NO];
    }];
    
    [createOrModifyAddressViewController setAddressForBuyerButtonClicked:^(YYAddress *nowAddress){
        if (nowAddress) {
            [ws updateBuyerAddress:nowAddress];
        }
        [ws.navigationController popViewControllerAnimated:NO];
        if(ws.updateBlock){
            ws.updateBlock();
        }
    }];
}

-(void)showStyleRemarkViewController{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OrderDetail" bundle:[NSBundle mainBundle]];
    YYOrderStylesRemarkViewController *orderStylesRemarkViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYOrderStylesRemarkViewController"];
    WeakSelf(ws);
    [orderStylesRemarkViewController setCancelButtonClicked:
     ^(){
         [ws.navigationController popViewControllerAnimated:YES];
     }];
    [orderStylesRemarkViewController setSaveButtonClicked:
     ^(){
         [ws.navigationController popViewControllerAnimated:YES];
     }];
    orderStylesRemarkViewController.orderInfoModel = _currentYYOrderInfoModel;
    [self.navigationController pushViewController:orderStylesRemarkViewController animated:YES];

}

#pragma mark --添加款式
- (void)thirdButtonClicked{
    //把当前的订单对象，传到全局的AppDelegate中
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.orderModel = [[YYOrderInfoModel alloc] initWithDictionary:[self.currentYYOrderInfoModel toDictionary] error:nil];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:0];
    [tempArray addObjectsFromArray:self.currentYYOrderInfoModel.groups];
    appDelegate.orderSeriesArray = tempArray;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Opus" bundle:[NSBundle mainBundle]];
    YYStyleDetailListViewController *styleDetailListViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYStyleDetailListViewController"];
    styleDetailListViewController.isModifyOrder = YES;
    styleDetailListViewController.designerId = [self.currentYYOrderInfoModel.designerId integerValue];    
    styleDetailListViewController.currentYYOrderInfoModel = self.currentYYOrderInfoModel;
    
    [self.navigationController pushViewController:styleDetailListViewController animated:YES];
}

-(YYAddress *)getcurBuyerAddress{
    if(_currentYYOrderInfoModel.buyerAddress == nil || ([_nowBuyerAddress.addressId integerValue] >0 && [_currentYYOrderInfoModel.buyerAddress.addressId integerValue] == [_nowBuyerAddress.addressId integerValue] )){
        return nil;
    }
    YYAddress *newAddress = [[YYAddress alloc] init];
    newAddress.addressId = 0;
    newAddress.receiverName = _nowBuyerAddress.receiverName;
    newAddress.receiverPhone = _nowBuyerAddress.receiverPhone;
    newAddress.zipCode = _nowBuyerAddress.zipCode;
    newAddress.detailAddress = _nowBuyerAddress.detailAddress;
    newAddress.nation = _nowBuyerAddress.nation;
    newAddress.province = _nowBuyerAddress.province;
    newAddress.city = _nowBuyerAddress.city;
    newAddress.nationEn = _nowBuyerAddress.nationEn;
    newAddress.provinceEn = _nowBuyerAddress.provinceEn;
    newAddress.cityEn = _nowBuyerAddress.cityEn;
    newAddress.nationId = _nowBuyerAddress.nationId;
    newAddress.provinceId = _nowBuyerAddress.provinceId;
    newAddress.cityId = _nowBuyerAddress.cityId;
    if([_nowBuyerAddress.defaultShippingAddress integerValue] > 0 || [_nowBuyerAddress.defaultShipping integerValue] > 0){
        newAddress.defaultShipping = YES;
    }else{
        newAddress.defaultShipping = NO;
    }
    return newAddress;
}

- (void)updateBuyerAddress:(YYAddress *)nowAddress{
    YYOrderBuyerAddress *buyerAddress = [[YYOrderBuyerAddress alloc] init];
    
    buyerAddress.addressId = [[NSNumber alloc] initWithInt:0];
    if (nowAddress.receiverName) {
        buyerAddress.receiverName = nowAddress.receiverName;
    }
    if (nowAddress.receiverPhone) {
        buyerAddress.receiverPhone = nowAddress.receiverPhone;
    }
    if (nowAddress.zipCode) {
        buyerAddress.zipCode = nowAddress.zipCode;
    }
    if (nowAddress.detailAddress) {
        buyerAddress.detailAddress = nowAddress.detailAddress;
    }
    if (nowAddress.defaultShipping){
        buyerAddress.defaultShipping = [[NSNumber alloc] initWithInt:1];
        buyerAddress.defaultShippingAddress= [[NSNumber alloc] initWithInt:1];
    }else{
        buyerAddress.defaultShipping = [[NSNumber alloc] initWithInt:0];
        buyerAddress.defaultShippingAddress= [[NSNumber alloc] initWithInt:1];
    }
    if (nowAddress.nation) {
        buyerAddress.nation = nowAddress.nation;
    }
    if (nowAddress.province) {
        buyerAddress.province = nowAddress.province;
    }
    if (nowAddress.city) {
        buyerAddress.city = nowAddress.city;
    }
    if (nowAddress.nationEn) {
        buyerAddress.nationEn = nowAddress.nationEn;
    }
    if (nowAddress.provinceEn) {
        buyerAddress.provinceEn = nowAddress.provinceEn;
    }
    if (nowAddress.cityEn) {
        buyerAddress.cityEn = nowAddress.cityEn;
    }
    if (nowAddress.nationId) {
        buyerAddress.nationId = nowAddress.nationId;
    }
    if (nowAddress.provinceId) {
        buyerAddress.provinceId = nowAddress.provinceId;
    }
    if (nowAddress.cityId) {
        buyerAddress.cityId = nowAddress.cityId;
    }
    
    if(self.currentYYOrderInfoModel.buyerAddress == nil){
        self.currentYYOrderInfoModel.buyerAddress = buyerAddress;
        self.currentYYOrderInfoModel.buyerAddressId = buyerAddress.addressId;
    }
    
    _nowBuyerAddress = buyerAddress;
    [self updateUI];
}

-(void)showPickView:(NSArray *)dataArr type:(UIDataType)uidataType{
    if(self.pickerView.superview != nil){
        return;
    }
    self.pickerView=[[YYPickView alloc] initPickviewWithArray:dataArr isHaveNavControler:NO];
    [self.pickerView show:self.view];
    [self.pickerView selectPickerRow:0 inComponent:0 animated:YES];
    self.pickerView.delegate = self;
    self.pickerView.uidataType = uidataType;
}

#pragma mark YYpickVIewDelegate

-(void)toobarDonBtnHaveClick:(YYPickView *)pickView resultString:(NSString *)resultString{
    
    NSArray * dataInfo = [resultString componentsSeparatedByString:@"|"];
    __block NSString *data = [dataInfo objectAtIndex:0];
    __block NSString *index = [dataInfo objectAtIndex:1];
    
    if (pickView.uidataType == UIDataTypeSalesManList && self.salesManList) {
        YYSalesManModel *salesManModel = [self.salesManList objectAtIndex:[index integerValue]];
        self.currentYYOrderInfoModel.billCreatePersonId =  [NSNumber numberWithInteger: [salesManModel.userId integerValue]];
        self.currentYYOrderInfoModel.billCreatePersonName = salesManModel.username;
        self.currentYYOrderInfoModel.billCreatePersonType = [self.salesManListModel getTypeWithID:self.currentYYOrderInfoModel.billCreatePersonId WithName:self.currentYYOrderInfoModel.billCreatePersonName];
        [self.tableView reloadData];
    }else if(pickView.uidataType == UIDataTypeOccasionList &&  self.orderSettingInfoModel.occasionList){
        self.currentYYOrderInfoModel.occasion = data;
        [self.tableView reloadData];
    }else if(pickView.uidataType == UIDataTypeDeliveryList && self.orderSettingInfoModel.deliveryList){
        self.currentYYOrderInfoModel.deliveryChoose = data;
        [self.tableView reloadData];
    }else if (pickView.uidataType == UIDataTypePayList && self.orderSettingInfoModel.payList){
        self.currentYYOrderInfoModel.payApp = data;
        [self.tableView reloadData];
    }


}


@end
