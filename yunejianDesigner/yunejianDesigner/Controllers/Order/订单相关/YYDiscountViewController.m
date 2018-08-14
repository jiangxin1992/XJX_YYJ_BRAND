//
//  YYDiscountViewController.m
//  Yunejian
//
//  Created by yyj on 15/8/26.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYDiscountViewController.h"

#import "RegexKitLite.h"
#import "UIImage+YYImage.h"
#import "UIView+UpdateAutoLayoutConstraints.h"
#import "YYNavigationBarViewController.h"
#import "YYVerifyTool.h"
#import "MLInputDodger.h"

static int   multiple = 10; //倍数

@interface YYDiscountViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *originalPriceLabel;


@property (weak, nonatomic) IBOutlet UITextField *discountField;
@property (weak, nonatomic) IBOutlet UILabel *reduceField;
@property (strong,nonatomic) NSString *finalPriceField;

@property (weak, nonatomic) IBOutlet UIButton *reduceButton;
@property (weak, nonatomic) IBOutlet UIButton *increaseButton;

@property (weak, nonatomic) IBOutlet UILabel *tiplabel;
@property (strong, nonatomic) NSNumber <Optional>*curType;//货币类型
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property(nonatomic,strong) YYNavigationBarViewController *navigationBarViewController;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *discountTextWidthLayout;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation YYDiscountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self updateUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 进入埋点
    [MobClick beginLogPageView:kYYPageDiscount];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageDiscount];
}

#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
-(void)PrepareData{}
-(void)PrepareUI{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YYNavigationBarViewController *navigationBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNavigationBarViewController"];
    
    navigationBarViewController.nowTitle = NSLocalizedString(@"编辑折扣",nil);
    
    self.navigationBarViewController = navigationBarViewController;
    [_containerView addSubview:navigationBarViewController.view];
    __weak UIView *_weakContainerView = _containerView;
    [navigationBarViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_weakContainerView.mas_top);
        make.left.equalTo(_weakContainerView.mas_left);
        make.bottom.equalTo(_weakContainerView.mas_bottom);
        make.right.equalTo(_weakContainerView.mas_right);
    }];
    
    WeakSelf(ws);
    
    [navigationBarViewController setNavigationButtonClicked:^(NavigationButtonType buttonType){
        if (buttonType == NavigationButtonTypeGoBack) {
            [ws.navigationController popViewControllerAnimated:YES];
            ws.navigationBarViewController = nil;
        }
    }];
    
    self.saveButton.layer.masksToBounds = YES;
    self.saveButton.layer.cornerRadius = 3;
    self.discountField.keyboardType = UIKeyboardTypeNumberPad;
    self.discountField.layer.borderColor = [UIColor colorWithHex:@"d3d3d3"].CGColor;
    self.discountField.layer.borderWidth = 1;
    self.discountField.layer.cornerRadius = 2.5;
    self.discountField.layer.masksToBounds = YES;
    self.discountField.delegate = self;
    [self.view registerAsDodgeViewForMLInputDodger];
    
    if([LanguageManager isEnglishLanguage]){
        _discountTextWidthLayout.constant = 80;
        _reduceButton.hidden = YES;
        _increaseButton.hidden = YES;
        self.discountField.enabled = YES;
    }else{
        _discountTextWidthLayout.constant = 125;
        _reduceButton.hidden = NO;
        _increaseButton.hidden = NO;
        self.discountField.enabled = NO;
    }
    
    _curType = _currentYYOrderInfoModel.curType;
    float tipTxtHeight = getTxtHeight((SCREEN_WIDTH-20-96), _tiplabel.text, @{NSFontAttributeName:_tiplabel.font});
    [_tiplabel setConstraintConstant:tipTxtHeight forAttribute:NSLayoutAttributeHeight];
}
#pragma mark - SomeAction
//减
- (IBAction)reduceButtonClicked:(id)sender{
    NSString *discountValue = _discountField.text;
    float nowDiscount = [discountValue doubleValue];
    if (nowDiscount > 0.1) {
        nowDiscount = round((nowDiscount-0.1)*10)/10.0;
        [self updateReduceAndFinalbyDiscount:nowDiscount];
    }
}
//加
- (IBAction)increaseButtonClicked:(id)sender{
    NSString *discountValue = _discountField.text;
    float nowDiscount = [discountValue doubleValue];
    if (nowDiscount < 9.9) {
        nowDiscount =  round((nowDiscount+0.1)*10)/10.0;
        [self updateReduceAndFinalbyDiscount:nowDiscount];
    }
}

- (void)updateReduceAndFinalbyDiscount:(float)discount{
    if([LanguageManager isEnglishLanguage]){
        if (discount >= 0
            && discount < 100) {
            _discountField.text = [NSString stringWithFormat:@"%.0f",discount];
            double finalValue = _originalTotalPrice*(100-discount)/100.0f;
            _finalPriceField = replaceMoneyFlag([NSString stringWithFormat:@"￥%.2f",finalValue],[_curType integerValue]);
            _reduceField.text = replaceMoneyFlag([NSString stringWithFormat:@"-￥%.2f",(_originalTotalPrice-finalValue)],[_curType integerValue]);
            [self updateButtonStauts];
        }
    }else{
        if (discount > 0
            && discount <= 10) {
            _discountField.text = [NSString stringWithFormat:@"%.2f",discount];
            double finalValue = _originalTotalPrice*discount/multiple;
            _finalPriceField = replaceMoneyFlag([NSString stringWithFormat:@"￥%.2f",finalValue],[_curType integerValue]);
            _reduceField.text = replaceMoneyFlag([NSString stringWithFormat:@"-￥%.2f",(_originalTotalPrice-finalValue)],[_curType integerValue]);
            [self updateButtonStauts];
        }
    }
}
//更新那两个加减按钮（是否可点击）
- (void)updateButtonStauts{
     _reduceButton.enabled = YES;
    _increaseButton.enabled = YES;
    
    if([LanguageManager isEnglishLanguage]){
        _reduceButton.enabled = NO;
        _increaseButton.enabled = NO;
    }else{
        NSString *discountValue = _discountField.text;
        float nowDiscount = [discountValue floatValue];
        if (nowDiscount < 0.2) {
            _reduceButton.enabled = NO;
        }else if (nowDiscount > 9.9){
            _increaseButton.enabled = NO;
        }
        NSLog(@"nowDiscount: %f",nowDiscount);
    }
}

- (void)updateUI{
    _originalPriceLabel.adjustsFontSizeToFitWidth = YES;
    _originalPriceLabel.text = replaceMoneyFlag([NSString stringWithFormat:@"￥%.2f",_originalTotalPrice],[_curType integerValue]);
    _finalPriceField = replaceMoneyFlag([NSString stringWithFormat:@"￥%.2f",_finalTotalPrice],[_curType integerValue]);
    
    if([LanguageManager isEnglishLanguage]){
        NSString *reduceValue = @"0";
        NSString *discountValue = @"0";
        if (_originalTotalPrice > _finalTotalPrice) {
            reduceValue = replaceMoneyFlag([NSString stringWithFormat:@"-￥%.2f",(_originalTotalPrice-_finalTotalPrice)],[_curType integerValue]);
            discountValue = [NSString stringWithFormat:@"%.0f",(100-100*_finalTotalPrice/_originalTotalPrice)];
        }
        
        _reduceField.text = reduceValue;
        _discountField.text = discountValue;
    }else{
        NSString *reduceValue = @"0";
        NSString *discountValue = @"10.00";
        if (_originalTotalPrice > _finalTotalPrice) {
            reduceValue = replaceMoneyFlag([NSString stringWithFormat:@"-￥%.2f",(_originalTotalPrice-_finalTotalPrice)],[_curType integerValue]);
            discountValue = [NSString stringWithFormat:@"%.2f",_finalTotalPrice/_originalTotalPrice*multiple];
        }
        
        _reduceField.text = reduceValue;
        _discountField.text = discountValue;
    }
    
    
    [self updateButtonStauts];
}



- (IBAction)cancelClicked:(id)sender{
    if (_cancelButtonClicked) {
        _cancelButtonClicked();
    }
}
- (IBAction)clearDiscountHandler:(id)sender {
    [self updateReduceAndFinalbyDiscount:[LanguageManager isEnglishLanguage]?0:10];
}

- (IBAction)saveClicked:(id)sender{
    
    NSString *finalValue = [_finalPriceField substringFromIndex:1];
    float nowFinalValue = [finalValue floatValue];//最后的价格
    
    double discountValue = 0;
    NSNumber *discount = nil;
    if([LanguageManager isEnglishLanguage]){
        discountValue = [_discountField.text doubleValue];
    }else{
        discountValue = [_discountField.text doubleValue]*10;
    }
    if (nowFinalValue > 0
        && nowFinalValue <= _originalTotalPrice) {
        if([LanguageManager isEnglishLanguage]){
            if(discountValue <= 0){
                discount = [NSNumber numberWithDouble:0];
            }else{
                discount = [NSNumber numberWithDouble:discountValue];
            }
        }else{
            if(discountValue >= 100){
                discount = [NSNumber numberWithDouble:100];
            }else{
                discount = [NSNumber numberWithDouble:discountValue];
            }
        }
    }
    
    if (_modifySuccess && discount) {
        _modifySuccess(@[discount]);
    }
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL returnValue = NO;
    NSString *message = NSLocalizedString(@"数据格式错误",nil);
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (![NSString isNilOrEmpty:str]) {
        if([YYVerifyTool numberVerift:str]){
            message = nil;
            if([str length] > 0 && [str length] < 3){
                if([str length] == 2){
                    if([str hasPrefix:@"0"]){
                        textField.text = [str substringFromIndex:1];
                        str = [str substringFromIndex:1];
                        returnValue = NO;
                    }else{
                        returnValue = YES;
                    }
                }else{
                    returnValue = YES;
                }
            }else if([str length] >= 3){
                textField.text = [str substringToIndex:2];
                str = [str substringToIndex:2];
                returnValue = NO;
            }
        }
    }else{
        message = nil;
        textField.text = @"0";
        str = @"0";
        returnValue = NO;
    }
    NSLog(@"message: %@",message);
    if ([NSString isNilOrEmpty:message]) {
        [self updateButtonStauts];
        
        CGFloat discount = [str integerValue];
        [self updateReduceFieldWithDiscount:discount];
        
    }else{
        [YYToast showToastWithView:self.view title:message  andDuration:kAlertToastDuration];
        
    }
    return returnValue;
}

-(void)updateReduceFieldWithDiscount:(CGFloat )discount{
    if([LanguageManager isEnglishLanguage]){
        if (discount >= 0
            && discount < 100) {
            double finalValue = _originalTotalPrice*(100-discount)/100.0f;
            _finalPriceField = replaceMoneyFlag([NSString stringWithFormat:@"￥%.2f",finalValue],[_curType integerValue]);
            _reduceField.text = replaceMoneyFlag([NSString stringWithFormat:@"-￥%.2f",(_originalTotalPrice-finalValue)],[_curType integerValue]);
        }
    }else{
        if (discount > 0
            && discount <= 10) {
            double finalValue = _originalTotalPrice*discount/multiple;
            _finalPriceField = replaceMoneyFlag([NSString stringWithFormat:@"￥%.2f",finalValue],[_curType integerValue]);
            _reduceField.text = replaceMoneyFlag([NSString stringWithFormat:@"-￥%.2f",(_originalTotalPrice-finalValue)],[_curType integerValue]);
        }
    }
}
#pragma mark - Other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
