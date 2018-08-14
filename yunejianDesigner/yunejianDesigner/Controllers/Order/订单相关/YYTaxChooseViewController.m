//
//  YYTaxChooseViewController.m
//  yunejianDesigner
//
//  Created by yyj on 2017/6/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YYTaxChooseViewController.h"

#import "YYNavigationBarViewController.h"

#import "regular.h"
#import "YYBuyerInfoTool.h"
#import <MJRefresh.h>
#import "YYTypeButton.h"
#import "YYVerifyTool.h"
#import "MLInputDodger.h"

@interface YYTaxChooseViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) YYNavigationBarViewController *navigationBarViewController;

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic,strong) YYTypeButton *freeTaxButton;
@property (nonatomic,strong) YYTypeButton *defaultTaxButton;
@property (nonatomic,strong) YYTypeButton *customTaxButton;

@property (nonatomic,strong) UITextField *customTaxTextField;
@property (nonatomic,strong) UILabel *customTaxTitleLabel;
@property (nonatomic,strong) UILabel *customTaxLabel;

@end

@implementation YYTaxChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self selectBtnWithIndex:_selectIndex];
    if(_selectIndex != 2){
        _customTaxTextField.hidden = YES;
        _customTaxTitleLabel.hidden = YES;
        _customTaxLabel.hidden = NO;
        [self updateCustomValue];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 进入埋点
    [MobClick beginLogPageView:kYYPageTaxChoose];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageTaxChoose];
}

#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
-(void)PrepareData{
    [self addObserverForKeyboard];
}
- (void)addObserverForKeyboard{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAppear:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}
-(void)PrepareUI{
    self.view.backgroundColor = _define_white_color;
    [self.view registerAsDodgeViewForMLInputDodger];
    // 46 44 17
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    _navigationBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNavigationBarViewController"];
    _navigationBarViewController.previousTitle = @"";
    _navigationBarViewController.nowTitle = NSLocalizedString(@"税率选择",nil);
    [self.view addSubview:_navigationBarViewController.view];
    [_navigationBarViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(kStatusBarHeight);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kNavigationBarHeight);
    }];
    WeakSelf(ws);
    
    __block YYNavigationBarViewController *blockVc = _navigationBarViewController;
    
    [_navigationBarViewController setNavigationButtonClicked:^(NavigationButtonType buttonType){
        if (buttonType == NavigationButtonTypeGoBack) {
            if (ws.cancelButtonClicked) {
                ws.cancelButtonClicked();
            }
            blockVc = nil;
        }
    }];
    
    _containerView = [UIView getCustomViewWithColor:_define_white_color];
    [self.view addSubview:_containerView];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(_navigationBarViewController.view.mas_bottom).with.offset(0);
    }];
    
    NSString *normalImageName = @"selectCircle";
    NSString *selectImageName = @"selectedCircle";
    _freeTaxButton = [YYTypeButton getCustomImgBtnWithImageStr:normalImageName WithSelectedImageStr:selectImageName];
    _defaultTaxButton = [YYTypeButton getCustomImgBtnWithImageStr:normalImageName WithSelectedImageStr:selectImageName];
    _customTaxButton = [YYTypeButton getCustomImgBtnWithImageStr:normalImageName WithSelectedImageStr:selectImageName];
    
}
#pragma mark - UIConfig
-(void)UIConfig{
    //创建视图
    UIView *lastView = nil;
    NSArray *btnArr = @[_freeTaxButton,_defaultTaxButton,_customTaxButton];
    NSArray *btnTitleArr = @[NSLocalizedString(@"不加税",nil),NSLocalizedString(@"16%税",nil),NSLocalizedString(@"自定义税率",nil)];
    for (int i = 0;i < btnArr.count ; i++) {
        YYTypeButton *tempBtn = btnArr[i];
        [_containerView addSubview:tempBtn];
        [tempBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [tempBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 17, 0, 0)];
        [tempBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 23, 0, 0)];
        [tempBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        tempBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [tempBtn setTitle:btnTitleArr[i] forState:UIControlStateNormal];
        [tempBtn setTitleColor:_define_black_color forState:UIControlStateNormal];
        [tempBtn setTitle:btnTitleArr[i] forState:UIControlStateSelected];
        [tempBtn setTitleColor:_define_black_color forState:UIControlStateSelected];
        tempBtn.tag = 100+i;
        [tempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(54);
            if(lastView){
                make.top.mas_equalTo(lastView.mas_bottom).with.offset(0);
            }else{
                make.top.mas_equalTo(0);
            }
        }];
        
        UIView *btnLineView = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"EFEFEF"]];
        [_containerView addSubview:btnLineView];
        [btnLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-13);
            make.left.mas_equalTo(13);
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(tempBtn.mas_bottom).with.offset(0);
        }];
        
        lastView = btnLineView;
    }
    
    UIButton *saveBtn = [UIButton getCustomTitleBtnWithAlignment:0 WithFont:15 WithSpacing:0 WithNormalTitle:NSLocalizedString(@"保存",nil) WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [_containerView addSubview:saveBtn];
    saveBtn.layer.masksToBounds = YES;
    saveBtn.layer.cornerRadius = 3;
    saveBtn.backgroundColor = _define_black_color;
    [saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
        make.top.mas_equalTo(lastView.mas_bottom).with.offset(40);
        make.height.mas_equalTo(40);
    }];
    
    
    _customTaxTextField = [[UITextField alloc] init];
    [_customTaxButton addSubview:_customTaxTextField];
    _customTaxTextField.backgroundColor = _define_white_color;
    _customTaxTextField.keyboardType = UIKeyboardTypeNumberPad;
    _customTaxTextField.layer.masksToBounds = YES;
    _customTaxTextField.layer.cornerRadius = 2;
    _customTaxTextField.layer.borderWidth = 1;
    _customTaxTextField.delegate = self;
    _customTaxTextField.layer.borderColor = [[UIColor colorWithHex:@"EFEFEF"] CGColor];
    _customTaxTextField.leftViewMode = UITextFieldViewModeAlways;
    _customTaxTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 30)];
    _customTaxTextField.textColor = _define_black_color;
    _customTaxTextField.font = [UIFont systemFontOfSize:14.0f];
    [_customTaxTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-58);
        make.centerY.mas_equalTo(_customTaxButton);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    _customTaxTextField.hidden = YES;
    
    _customTaxTitleLabel = [UILabel getLabelWithAlignment:0 WithTitle:[LanguageManager isEnglishLanguage]?@"% Tax":@"% 税" WithFont:14.0f WithTextColor:_define_black_color WithSpacing:0];
    [_customTaxButton addSubview:_customTaxTitleLabel];
    [_customTaxTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_customTaxTextField.mas_right).with.offset(5);
        make.centerY.mas_equalTo(_customTaxTextField);
        make.right.mas_equalTo(0);
    }];
    _customTaxTitleLabel.hidden = YES;
    
    NSString *taxValueStr = @"";
    CGFloat taxValue = [getPayTaxValue(_selectData,_selectIndex,NO) floatValue];
    if(taxValue > 0){
        taxValueStr = [[NSString alloc] initWithFormat:@"%.0lf%%  %@",taxValue*100,[LanguageManager isEnglishLanguage]?@"Tax":@"税"];
    }
    _customTaxLabel = [UILabel getLabelWithAlignment:2 WithTitle:taxValueStr WithFont:14.0f WithTextColor:[UIColor colorWithHex:@"47A3DC"] WithSpacing:0];
    [_customTaxButton addSubview:_customTaxLabel];
    [_customTaxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_customTaxTextField);
        make.right.mas_equalTo(-17);
    }];
    _customTaxLabel.hidden = YES;
    
}
#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == _customTaxTextField){
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
            CGFloat discount = [str integerValue];
            [self updateReduceFieldWithDiscount:discount];
            NSLog(@"111");
        }else{
            [YYToast showToastWithView:self.view title:message  andDuration:kAlertToastDuration];
        }
        return returnValue;
    }
    
    return YES;
}

#pragma mark - SomeAction

-(void)saveAction{
    if(_selectIndex == 2){
        NSInteger selectValue = [getPayTaxValue(_selectData, _selectIndex,NO) floatValue]*100.0f;
        if(!selectValue){
            _selectIndex = 0;
        }else{
            if(selectValue == 16){
                _selectIndex = 1;
            }
        }
    }
    if(_selectBlock){
        _selectBlock(_selectIndex);
    }
}

//更新
-(void)updateReduceFieldWithDiscount:(CGFloat )discount{
    if (discount >= 0
        && discount < 100) {
        updateCustomTaxValue(_selectData,@(discount/100.0f),NO);//更新自定义税率
        NSLog(@"111");
    }
}

-(void)selectAction:(UIButton *)btn{
    NSInteger index = btn.tag - 100;
    [self selectBtnWithIndex:index];
}
//锁定某个index
-(void)selectBtnWithIndex:(NSInteger )index{
    NSArray *btnArr = @[_freeTaxButton,_defaultTaxButton,_customTaxButton];
    for (int i = 0; i<btnArr.count; i++) {
        UIButton *tempBtn = btnArr[i];
        if(i == index){
            _selectIndex = i;
            tempBtn.selected = YES;
            tempBtn.backgroundColor = [UIColor colorWithHex:@"f8f8f8"];
        }else{
            tempBtn.selected = NO;
            tempBtn.backgroundColor = _define_white_color;
        }
    }
    if(index == 2){
        //自定义税率
        [_customTaxTextField becomeFirstResponder];
    }else{
        [regular dismissKeyborad];
    }
}
//在键盘出现／消失的时候去更新
- (void)keyboardWillHide:(NSNotification *)note
{
    //键盘将要消失的时候回调
    _customTaxTextField.hidden = YES;
    _customTaxTitleLabel.hidden = YES;
    _customTaxLabel.hidden = NO;
    [self updateCustomValue];
}
- (void)keyboardWillAppear:(NSNotification *)note
{
    //键盘将要出现的时候回调
    _customTaxTextField.hidden = NO;
    _customTaxTitleLabel.hidden = NO;
    _customTaxLabel.hidden = YES;
    [self updateCustomValue];
}
-(void)updateCustomValue{
    CGFloat taxValue = [getPayTaxValue(_selectData,2,NO) floatValue];
    if(!_customTaxTextField.hidden){
        if(taxValue > 0){
            _customTaxTextField.text = [[NSString alloc] initWithFormat:@"%.0lf",taxValue*100];
        }else{
            _customTaxTextField.text = @"0";
        }
    }
    
    if(!_customTaxLabel.hidden){
        if(taxValue > 0){
            _customTaxLabel.text = [[NSString alloc] initWithFormat:@"%.0lf%%  %@",taxValue*100,[LanguageManager isEnglishLanguage]?@"Tax":@"税"];
        }else{
            _customTaxLabel.text = @"";
        }
    }
    
}

#pragma mark - Other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
