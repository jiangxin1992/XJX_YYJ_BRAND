//
//  YYOrderAddMoneyLogController.m
//  Yunejian
//
//  Created by Apple on 15/11/26.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "YYOrderAddMoneyLogController.h"

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "YYNavigationBarViewController.h"

// 自定义视图
#import "MBProgressHUD.h"
#import "MLInputDodger.h"

// 接口
#import "YYOrderApi.h"

// 分类
#import "UIView+UpdateAutoLayoutConstraints.h"
#import "UIImage+Tint.h"

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYPaymentNoteListModel.h"

@interface YYOrderAddMoneyLogController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *orderCodeLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalMoneyRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *giveMoneyRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *giveMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *pendingMoneyRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *pendingMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *lastMoneyRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMoneyLabel;

@property (weak, nonatomic) IBOutlet UIView *addMoneyBackView;
@property (weak, nonatomic) IBOutlet UILabel *lastMoneyTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *addMoneyTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyTypeLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputText;

@property (weak, nonatomic) IBOutlet UIView *refundBackView;
@property (weak, nonatomic) IBOutlet UIButton *refundMoneyButton;
@property (weak, nonatomic) IBOutlet UILabel *refundMoneyLabel;

@property (nonatomic, assign) BOOL isSelectRefund;

@property (weak, nonatomic) IBOutlet UILabel *addMoneyTipLabel1;
@property (weak, nonatomic) IBOutlet UILabel *makeSureTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *makeSureBtn;


@property (nonatomic, strong) YYPaymentNoteListModel *paymentNoteList;

@end

@implementation YYOrderAddMoneyLogController
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
    [MobClick beginLogPageView:kYYPageOrderAddMoneyLog];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageOrderAddMoneyLog];
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
- (void)PrepareData{
    _isSelectRefund = NO;
}
- (void)PrepareUI{

    _addMoneyBackView.hidden = _isNeedRefund;
    _refundBackView.hidden = !_isNeedRefund;
    _makeSureTitleLabel.text = _isNeedRefund?NSLocalizedString(@"本次退款",nil):NSLocalizedString(@"本次收款",nil);

    if(!_addMoneyBackView.hidden){
        self.scrollView.shiftHeightAsDodgeViewForMLInputDodger = 44.0f + 5.0f;
        [self.scrollView registerAsDodgeViewForMLInputDodger];
        [self.scrollView layoutSubviews];

        _inputText.delegate = self;
        _inputText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _inputText.layer.borderColor = [UIColor colorWithHex:kDefaultBorderColor].CGColor;
        _inputText.layer.borderWidth = 1;
        _inputText.layer.cornerRadius = 2.5;
        _inputText.layer.masksToBounds = YES;
        _inputText.text = @"0";

        _moneyTypeLabel.text = replaceMoneyFlag(@"￥",_moneyType);

        _lastMoneyTipLabel.text = NSLocalizedString(@"填写本次收款金额，需要小于等于尚未收款金额。",nil);
    }

    if(!_refundBackView.hidden){
        _refundMoneyButton.layer.masksToBounds = YES;
        _refundMoneyButton.layer.cornerRadius = 3.f;
    }

    _makeSureBtn.enabled = NO;
    _makeSureBtn.alpha = 0.5;
    _makeSureBtn.layer.masksToBounds = YES;
    [_makeSureBtn setTitle:NSLocalizedString(@"保存",nil) forState:UIControlStateNormal];

    _orderCodeLabel.text = _orderCode;

    _totalMoneyRateLabel.text = @"100.00%";
    _totalMoneyLabel.text = replaceMoneyFlag([NSString stringWithFormat:@"￥%.2f",_totalMoney],_moneyType);

    _pendingMoneyRateLabel.text = [[NSString alloc] initWithFormat:@"%.2lf%@",[_paymentNoteList.pendingRate floatValue],@"%"];
    _pendingMoneyLabel.text = replaceMoneyFlag([NSString stringWithFormat:@"￥%.2f",[_paymentNoteList.pendingMoney doubleValue]],_moneyType);

    [self setWillCostMoney:0.f];

}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{
    [self createNavView];
}
-(void)createNavView{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YYNavigationBarViewController *navigationBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNavigationBarViewController"];
    navigationBarViewController.previousTitle = @"";
    if(_isNeedRefund){
        navigationBarViewController.nowTitle = NSLocalizedString(@"退款",nil);
    }else{
        navigationBarViewController.nowTitle = NSLocalizedString(@"添加收款记录",nil);
    }
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
            [ws closeAction];
            blockVc = nil;
        }
    }];
}
#pragma mark - --------------请求数据----------------------
-(void)RequestData{
    WeakSelf(ws);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [YYOrderApi getPaymentNoteList:_orderCode finalTotalPrice:_totalMoney andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYPaymentNoteListModel *paymentNoteList, NSError *error) {
        [hud hideAnimated:YES];
        if (rspStatusAndMessage.status == YYReqStatusCode100) {
            ws.paymentNoteList = paymentNoteList;
            [ws updateUI];
        } else {
            [YYToast showToastWithView:ws.view title:rspStatusAndMessage.message andDuration:kAlertToastDuration];
        }
    }];
}
-(void)addPaymentNote:(double)costMoney{
    WeakSelf(ws);
    [YYOrderApi addPaymentNote:_orderCode amount:[[NSString stringWithFormat:@"%.2f",costMoney] floatValue] andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
        if(rspStatusAndMessage.status == YYReqStatusCode100){
            [YYToast showToastWithTitle:NSLocalizedString(@"成功",nil) andDuration:kAlertToastDuration];
            [ws getPaymentNoteList];
        }else{
            [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
        }
    }];
}
-(void)addRefundNote{
    double refundMoney = MAX(0,[_paymentNoteList.hasGiveMoney doubleValue] - _totalMoney);
    if(refundMoney){
        WeakSelf(ws);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [YYOrderApi addRefundNote:_orderCode amount:refundMoney andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
            [hud hideAnimated:YES];
            if(rspStatusAndMessage.status == YYReqStatusCode100){
                [YYToast showToastWithView:ws.view title:NSLocalizedString(@"已退款",nil) andDuration:kAlertToastDuration];
                ws.modifySuccess(ws.orderCode,@(100.f));
            }else{
                [YYToast showToastWithView:ws.view title:rspStatusAndMessage.message andDuration:kAlertToastDuration];
            }
        }];
    }
}
-(void)getPaymentNoteList{
    WeakSelf(ws);
    [YYOrderApi getPaymentNoteList:_orderCode finalTotalPrice:_totalMoney andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYPaymentNoteListModel *paymentNoteList, NSError *error) {
        CGFloat hasGiveRate = 0.f;
        if(rspStatusAndMessage.status == YYReqStatusCode100){
            if(ws.paymentNoteList){
                hasGiveRate = [paymentNoteList.hasGiveRate floatValue];
            }
        }
        ws.modifySuccess(ws.orderCode,@(hasGiveRate));
    }];
}
#pragma mark - --------------系统代理----------------------
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string{

    NSCharacterSet *cs = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    NSLog(@"test %@",filtered);
    BOOL basicTest = [NSString isNilOrEmpty:filtered];

    if(basicTest) {

        if ([textField.text containsString:@"."]) {
            if([string isEqualToString:@"."]){
                //如果有两个点
                return NO;
            }else{
                //已存在一个点.输入的不是，
                NSArray *separatedArray = [textField.text componentsSeparatedByString:@"."];
                if(separatedArray.count == 2){
                    NSInteger decimalsLength = ((NSString *)separatedArray[1]).length;
                    if((decimalsLength >= 2) && ![NSString isNilOrEmpty:string]){
                        return NO;
                    }
                }else{
                    return NO;
                }
            }
        }

        //删到底给默认"0"
        if([NSString isNilOrEmpty:string] && textField.text.length == 1){
            textField.text = @"0";
            [self updateState:textField.text];
            return NO;
        }

        //为"0"的时候，输入，去除0，并键入输入内容（除非输入"."）
        if([textField.text isEqualToString:@"0"] && ![NSString isNilOrEmpty:string] && ![string isEqualToString:@"."]){
            textField.text = string;
            [self updateState:textField.text];
            return NO;
        }

        //为空是不能输入"."
        if([string isEqualToString:@"."] && [NSString isNilOrEmpty:textField.text]){
            return NO;
        }

        CGFloat lastGiveAmount = [self getLastGiveAmount];
        if([textField.text isEqualToString:[[NSString alloc] initWithFormat:@"%.2lf",lastGiveAmount]] && ![NSString isNilOrEmpty:string]){
            return NO;
        }

        NSString *numStr = [_inputText.text stringByReplacingCharactersInRange:range withString:string];
        [self updateState:numStr];
        return YES;
    }
    return NO;
}

#pragma mark - --------------自定义代理/block----------------------


#pragma mark - --------------自定义响应----------------------
- (IBAction)makeSureHandler:(id)sender {
    if(_isNeedRefund){
        [self addRefundNote];
    }else{
        if(self.modifySuccess){
            double costMoney = [_inputText.text floatValue];
            costMoney = MIN(costMoney, (_totalMoney-[_paymentNoteList.hasGiveMoney doubleValue]));
            if(costMoney > 0){
                [self addPaymentNote:costMoney];
            }
        }
    }
}
- (IBAction)refundMoneyAction:(id)sender {
    if(!_isSelectRefund){
        _isSelectRefund = YES;

        _refundMoneyButton.enabled = NO;
        _refundMoneyButton.backgroundColor = [UIColor colorWithHex:@"D3D3D3"];

        _makeSureBtn.alpha = 1;
        _makeSureBtn.enabled = YES;

        _giveMoneyRateLabel.text = @"100.00%";
        _giveMoneyLabel.text = replaceMoneyFlag([NSString stringWithFormat:@"￥%.2f",_totalMoney],_moneyType);

        double refundMoney = MAX(0,[_paymentNoteList.hasGiveMoney doubleValue] - _totalMoney);
        _addMoneyTipLabel1.text = replaceMoneyFlag([NSString stringWithFormat:@"￥%.2f",refundMoney],_moneyType);
        CGSize textSize = [_addMoneyTipLabel1.text sizeWithAttributes:@{NSFontAttributeName:_addMoneyTipLabel1.font}];
        [_addMoneyTipLabel1 setConstraintConstant:textSize.width+1 forAttribute:NSLayoutAttributeWidth];
    }
}
#pragma mark - --------------自定义方法----------------------
-(void)updateUI{

    _pendingMoneyRateLabel.text = [[NSString alloc] initWithFormat:@"%.2lf%@",[_paymentNoteList.pendingRate floatValue],@"%"];
    _pendingMoneyLabel.text = replaceMoneyFlag([NSString stringWithFormat:@"￥%.2f",[_paymentNoteList.pendingMoney doubleValue]],_moneyType);

    double refundMoney = MAX(0,[_paymentNoteList.hasGiveMoney doubleValue] - _totalMoney);
    _refundMoneyLabel.text = replaceMoneyFlag([NSString stringWithFormat:@"￥%.2f",refundMoney],_moneyType);

    [self setWillCostMoney:0.f];
}
-(void)updateState:(NSString *)numStr{
    CGFloat lastGiveAmount = [self getLastGiveAmount];
    CGFloat num = [numStr floatValue];
    if(num > lastGiveAmount){
        if(lastGiveAmount){
            _inputText.text = [NSString stringWithFormat:@"%.2lf",lastGiveAmount];
        }else{
            _inputText.text = [NSString stringWithFormat:@"%.lf",lastGiveAmount];
        }
        [_inputText resignFirstResponder];
    }
    if(num == 0){
        _makeSureBtn.alpha = 0.5;
        _makeSureBtn.enabled = NO;
    }else{
        _makeSureBtn.alpha = 1;
        _makeSureBtn.enabled = YES;
    }
    lastGiveAmount = MIN(lastGiveAmount, num);
    [self setWillCostMoney:lastGiveAmount];
}

-(void)setWillCostMoney:(CGFloat)costMoney{

    CGFloat costRate = (costMoney/_totalMoney)*100.f;

    if(!_addMoneyBackView.hidden){
        _addMoneyTipLabel.text = [[NSString alloc] initWithFormat:@"    %.2lf%%",costRate];
    }

    _addMoneyTipLabel1.text = replaceMoneyFlag([NSString stringWithFormat:@"￥%.2f",costMoney],_moneyType);
    CGSize textSize = [_addMoneyTipLabel1.text sizeWithAttributes:@{NSFontAttributeName:_addMoneyTipLabel1.font}];
    [_addMoneyTipLabel1 setConstraintConstant:textSize.width+1 forAttribute:NSLayoutAttributeWidth];

    _giveMoneyRateLabel.text = [NSString stringWithFormat:@"%.2lf%@",([_paymentNoteList.hasGiveRate floatValue] + costRate),@"%"];
    _lastMoneyRateLabel.text = [NSString stringWithFormat:@"%.2lf%@",(MAX(0,100 - [_paymentNoteList.hasGiveRate floatValue] - costRate - [_paymentNoteList.pendingRate floatValue])),@"%"];

    _giveMoneyLabel.text = replaceMoneyFlag([NSString stringWithFormat:@"￥%.2f",[_paymentNoteList.hasGiveMoney doubleValue]+costMoney],_moneyType);
    _lastMoneyLabel.text = replaceMoneyFlag([NSString stringWithFormat:@"￥%.2f",(MAX(0,_totalMoney - [_paymentNoteList.hasGiveMoney doubleValue] - costMoney - [_paymentNoteList.pendingMoney doubleValue]))],_moneyType);

}
#pragma mark -other

/**
 剩余支付比例

 @return ...
 */
-(CGFloat)getLastGiveRate{
    return MAX(0,100 - [_paymentNoteList.hasGiveRate floatValue] - [_paymentNoteList.pendingRate floatValue]);
}

/**
 剩余可付款

 @return ...
 */
-(double)getLastGiveAmount{
    return MAX(0,_totalMoney - [_paymentNoteList.hasGiveMoney doubleValue] - [_paymentNoteList.pendingMoney doubleValue]);
}

- (void)closeAction{
    if (self.cancelButtonClicked) {
        self.cancelButtonClicked();
    }
}

#pragma mark - --------------other----------------------

@end
