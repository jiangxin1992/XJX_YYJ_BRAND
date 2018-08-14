//
//  YYCreateOrModifyAddressViewController.m
//  Yunejian
//
//  Created by yyj on 15/7/20.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYCreateOrModifyAddressViewController.h"

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "YYNavigationBarViewController.h"

// 自定义视图
#import "YYPickView.h"
#import "YYCountryPickView.h"
#import "MBProgressHUD.h"

// 接口
#import "YYUserApi.h"
#import "YYOrderApi.h"

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "MLInputDodger.h"

#import "YYAddress.h"
#import "YYOrderInfoModel.h"
#import "YYCountryListModel.h"
#import "YYBuyerAddressModel.h"

#import "YYRspStatusAndMessage.h"
#import "UserDefaultsMacro.h"
#import "regular.h"
#import "YYVerifyTool.h"

@interface YYCreateOrModifyAddressViewController ()<UITextFieldDelegate,YYCountryPickViewDelegate,UITextViewDelegate>

@property (nonatomic,strong) YYCountryListModel *countryInfo;
@property (nonatomic,strong) YYCountryListModel *provinceInfo;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UIButton *countryButton;
@property (weak, nonatomic) IBOutlet UIButton *cityButton;
@property (weak, nonatomic) IBOutlet UILabel *countryTitle;
@property (weak, nonatomic) IBOutlet UITextField *postCodeField;
@property (weak, nonatomic) IBOutlet UIButton *phoneTipButton;

@property (weak, nonatomic) IBOutlet UITextView *detailAddressField;

@property (weak, nonatomic) IBOutlet UILabel *receiverAddressLabel;

@property (weak, nonatomic) IBOutlet UILabel *billAddressLabel;

@property (weak, nonatomic) IBOutlet UIView *yellowView;

@property (weak, nonatomic) IBOutlet UIButton *defaultReceiveButton;//默认收件地址
@property (weak, nonatomic) IBOutlet UIButton *defaultBillingButton;//默认发票地址
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property(nonatomic,strong) YYCountryPickView *countryPickerView;
@property(nonatomic,strong) YYCountryPickView *provincePickerView;
@property(nonatomic,assign) NSUInteger currentProvinceIndex;

@property(nonatomic,strong) UIView *pickBgView;

@property(nonatomic,strong) NSString *currentNation;
@property(nonatomic,strong) NSNumber *currentNationID;
@property(nonatomic,strong) NSString *currentProvinece;
@property(nonatomic,strong) NSNumber *currentProvineceID;
@property(nonatomic,strong) NSString *currentCity;
@property(nonatomic,strong) NSNumber *currentCityID;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameWidthLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneWidthLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countryWidthLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cityWidthLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codeWithLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressWidthLayout;

@property(nonatomic,assign) BOOL provinceIsChanged;

@property(nonatomic,assign) BOOL isDefaultReceive;
@property(nonatomic,assign) BOOL isDefaultBilling;
@property(nonatomic,strong) YYNavigationBarViewController *navigationBarViewController;
@end

@implementation YYCreateOrModifyAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self updateUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 进入埋点
    [MobClick beginLogPageView:kYYPageCreateOrModifyAddress];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageCreateOrModifyAddress];
}

#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
-(void)PrepareData{}
-(void)PrepareUI{
    _phoneTipButton.hidden = YES;
    _countryTitle.text = [LanguageManager isEnglishLanguage]?@"Country*":@"国家*";
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YYNavigationBarViewController *navigationBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNavigationBarViewController"];
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
            [ws cancelClicked:nil];
            blockVc = nil;
        }
    }];
    
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 44.0f+5.0f;
    [self.view registerAsDodgeViewForMLInputDodger];
    
    _provinceIsChanged = NO;
    
    _postCodeField.keyboardType = UIKeyboardTypeNumberPad;
    _phoneField.keyboardType = UIKeyboardTypeNumberPad;
    
    _nameField.delegate = self;
    _phoneField.delegate = self;
    _postCodeField.delegate = self;
    _detailAddressField.delegate = self;
    _detailAddressField.textAlignment = NSTextAlignmentLeft;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _saveBtn.layer.cornerRadius = 2.5;
    _saveBtn.layer.masksToBounds = YES;
    
    if([LanguageManager isEnglishLanguage]){
        _nameWidthLayout.constant = 120;
        _phoneWidthLayout.constant = 120;
        _countryWidthLayout.constant = 130;
        _cityWidthLayout.constant = 130;
        _codeWithLayout.constant = 120;
        _addressWidthLayout.constant = 130;
    }else{
        _nameWidthLayout.constant = 102;
        _phoneWidthLayout.constant = 102;
        _countryWidthLayout.constant = 112;
        _cityWidthLayout.constant = 112;
        _codeWithLayout.constant = 102;
        _addressWidthLayout.constant = 112;
    }
}
#pragma mark - Setter
-(void)setAddress:(YYAddress *)address{
    if(address){
        _address = address;
    }else{
        _address = [[YYAddress alloc] init];
        _address.nation = @"中国";
        _address.nationEn = @"China";
        _address.nationId = @(721);
    }
}
- (void)setShowValue{
    
    if (![NSString isNilOrEmpty:_address.receiverName]) {
        if (_address.receiverName) {
            _nameField.text = _address.receiverName;
        }
        
        if (_address.receiverPhone) {
            _phoneField.text = _address.receiverPhone;
        }
        
        if ([_address.nationId integerValue]) {
            
            self.currentNation = [LanguageManager isEnglishLanguage]?_address.nationEn:_address.nation;
            self.currentNationID = _address.nationId;
        }
        
        NSString *proviceAndCity = @"";
        if ([_address.provinceId integerValue]) {
            NSString *proviceStr = [LanguageManager isEnglishLanguage]?_address.provinceEn:_address.province;
            proviceAndCity = [proviceAndCity stringByAppendingString:proviceStr];
            self.currentProvinece = proviceStr;
            self.currentProvineceID = _address.provinceId;
        }
        if([_address.nationId integerValue]){
            if([NSString isNilOrEmpty:proviceAndCity]){
                proviceAndCity = @"-";
            }
        }
        
        if ([_address.cityId integerValue]) {
            NSString *cityStr = [LanguageManager isEnglishLanguage]?_address.cityEn:_address.city;
            if ([proviceAndCity length] > 0) {
                proviceAndCity = [proviceAndCity stringByAppendingString:@","];
            }
            proviceAndCity = [proviceAndCity stringByAppendingString:cityStr];
            self.currentCity = cityStr;
            self.currentCityID = _address.cityId;
        }
        
        [_cityButton setTitle:proviceAndCity forState:UIControlStateNormal];
        [_countryButton setTitle:self.currentNation forState:UIControlStateNormal];
        
        if (_address.zipCode) {
            _postCodeField.text = _address.zipCode;
        }
        
        if (_address.detailAddress) {
            _detailAddressField.text = _address.detailAddress;
        }
        
        self.isDefaultBilling = _address.defaultBilling;
        self.isDefaultReceive = _address.defaultShipping;
        
        [self updateDefaultButton];
        
    }
}

- (void)updateUI{
    if (_currentOperationType == OperationTypeModify) {
        _navigationBarViewController.nowTitle = NSLocalizedString(@"修改收件地址",nil);
        [self setShowValue];
    }else if(_currentOperationType == OperationTypeCreate){
        _navigationBarViewController.nowTitle = NSLocalizedString(@"新建收件地址",nil);
        [self setDefaultCountry];
    }else if(_currentOperationType == OperationTypeHelpCreate){
        _defaultBillingButton.hidden = YES;
        _defaultReceiveButton.hidden = YES;
        _receiverAddressLabel.hidden = YES;
        _billAddressLabel.hidden = YES;

        if (![NSString isNilOrEmpty:_address.receiverName]) {
            _navigationBarViewController.nowTitle = NSLocalizedString(@"修改买手店地址",nil);
            [self setShowValue];
        }else{
            _navigationBarViewController.nowTitle = NSLocalizedString(@"添加买手店地址",nil);
            [self setDefaultCountry];
        }
    }
    [_navigationBarViewController updateUI];
}
//确保只在符合的状态下进入该逻辑
-(void)setDefaultCountry{
    
    if (_currentOperationType == OperationTypeModify) {
        
    }else if(_currentOperationType == OperationTypeCreate){
        
        if ([_address.nationId integerValue]) {
            
            self.currentNation = [LanguageManager isEnglishLanguage]?_address.nationEn:_address.nation;
            self.currentNationID = _address.nationId;
        }
        [_countryButton setTitle:self.currentNation forState:UIControlStateNormal];
        
    }else if(_currentOperationType == OperationTypeHelpCreate){
        
        if (![NSString isNilOrEmpty:_address.receiverName]) {
            
        }else{
            
            if ([_address.nationId integerValue]) {
                
                self.currentNation = [LanguageManager isEnglishLanguage]?_address.nationEn:_address.nation;
                self.currentNationID = _address.nationId;
            }
            [_countryButton setTitle:self.currentNation forState:UIControlStateNormal];
            
        }
    }
}




- (void)updateDefaultButton{
    NSString *normalImage = @"confirm_normal.png";
    NSString *selectedImage = @"confirm_selected.png";
    
    
    if (_isDefaultBilling) {
        [_defaultBillingButton setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateNormal];
    }else{
        [_defaultBillingButton setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    }
    
    if (_isDefaultReceive) {
        [_defaultReceiveButton setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateNormal];
    }else{
        [_defaultReceiveButton setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    }
    
}


#pragma mark - SomeAction
-(BOOL)checkPhoneWarnWithPhoneCode:(NSInteger )phoneCode{
    if([NSString isNilOrEmpty:_phoneField.text]){
        //没有的时候不显示警告
        return YES;
    }else{
        if([YYVerifyTool numberVerift:_phoneField.text]){
            //通过数字验证
            if(phoneCode == 86){
                //            中国
                if(_phoneField.text.length == 11){
                    return YES;
                }
            }else{
                //            国外
                if(_phoneField.text.length <= 20 && _phoneField.text.length >= 6){
                    return YES;
                }
                
            }
        }
    }    return NO;
}

- (IBAction)countryButtonClicked:(id)sender {
    
    [_provincePickerView removeNoBlock];
    [regular dismissKeyborad];
    
    if(!_countryInfo){
        WeakSelf(ws);
        [YYUserApi getCountryInfoWithBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYCountryListModel *countryListModel, NSError *error) {
            if (rspStatusAndMessage.status == YYReqStatusCode100) {
                ws.countryInfo = countryListModel;
                
                if(ws.countryInfo.result.count){
                    ws.countryPickerView=[[YYCountryPickView alloc] initPickviewWithCountryArray:ws.countryInfo.result WithPlistType:CountryPickView isHaveNavControler:NO];
                    ws.countryPickerView.delegate = ws;
                    [ws.countryPickerView show:self.view];
                }
            }
        }];
    }else{
        [_countryPickerView show:self.view];
    }
}

- (IBAction)provinecesAndCityButtonClicked:(id)sender{
    
    [_countryPickerView removeNoBlock];
    [regular dismissKeyborad];
    
    if(!_provinceInfo){
        WeakSelf(ws);
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [YYUserApi getSubCountryInfoWithCountryID:[_currentNationID integerValue] WithBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYCountryListModel *countryListModel, NSInteger impId,NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (rspStatusAndMessage.status == YYReqStatusCode100) {
                if(countryListModel.result.count){
                    ws.provinceInfo = countryListModel;
                }else{
                    YYCountryModel *TempModel = [[YYCountryModel alloc] init];
                    TempModel.impId = @(-1);
                    TempModel.name = @"-";
                    TempModel.nameEn = @"-";
                    countryListModel.result = [NSArray arrayWithObject:TempModel];
                    ws.provinceInfo = countryListModel;
                }
                
                if(ws.provinceInfo.result.count){
                    ws.provincePickerView=[[YYCountryPickView alloc] initPickviewWithCountryArray:ws.provinceInfo.result WithPlistType:SubCountryPickView isHaveNavControler:NO];
                    ws.provincePickerView.delegate = self;
                    [ws.provincePickerView show:self.view];
                }
            }
        }];
    }else{
        [_provincePickerView show:self.view];
    }
}
- (IBAction)defaultBillingClicked:(id)sender{
    _isDefaultBilling = !_isDefaultBilling;
    [self updateDefaultButton];
}

- (IBAction)defaultReceiveClicked:(id)sender{
    _isDefaultReceive = !_isDefaultReceive;
    [self updateDefaultButton];
}
- (IBAction)cancelClicked:(id)sender{
    [_countryPickerView removeNoBlock];
    [_provincePickerView removeNoBlock];
    if (_cancelButtonClicked) {
        _cancelButtonClicked();
    }
}
- (IBAction)saveClicked:(id)sender{
    
    NSString *receiveName = trimWhitespaceOfStr(_nameField.text);
    NSString *receivePhone = trimWhitespaceOfStr(_phoneField.text);
    NSString *postCode = trimWhitespaceOfStr(_postCodeField.text);
    
    NSString *detailAddress = trimWhitespaceOfStr(_detailAddressField.text);
    
    UIView *customView = nil;
    if (_currentOperationType == OperationTypeHelpCreate) {
        customView = self.view;
    }
    
    if (! receiveName || [receiveName length] == 0) {
        [YYToast showToastWithView:customView title:NSLocalizedString(@"请输入收件人姓名",nil) andDuration:kAlertToastDuration];
        return;
    }
    
    if (! postCode || [postCode length] == 0) {
        [YYToast showToastWithView:customView title:NSLocalizedString(@"请输入邮编",nil) andDuration:kAlertToastDuration];
        return;
    }
    
    if (! detailAddress || [detailAddress length] == 0) {
        [YYToast showToastWithView:customView title:NSLocalizedString(@"请输入详细地址",nil) andDuration:kAlertToastDuration];
        return;
    }
    
    if(![_currentNationID integerValue]){
        [YYToast showToastWithView:customView title:NSLocalizedString(@"请选择国家",nil) andDuration:kAlertToastDuration];
        return;
    }
    
    //如果手机号码没有满足正确格式
    //中国 11 位数效验正确性  其他国家 6-20（中国 11位纯数字 国外 6-20位纯数字）
    BOOL _isValidPhone = [YYVerifyTool internationalPhoneVerify:receivePhone WithCountryCode:[_currentNationID integerValue]];
    if(!_isValidPhone){
        [YYToast showToastWithView:customView title:NSLocalizedString(@"手机号码格式错误",nil) andDuration:kAlertToastDuration];
        return;
    }
    
    if(_currentOperationType != OperationTypeModify){
        if ((![_currentProvineceID integerValue]) && (![_currentCityID integerValue])) {
            [YYToast showToastWithView:customView title:NSLocalizedString(@"请选择省市",nil) andDuration:kAlertToastDuration];
            return;
        }
    }
    
    YYAddress *nowAddress = [[YYAddress alloc] init];
    if ([_address.addressId integerValue]) {
        nowAddress.addressId = _address.addressId;
    }
    
    nowAddress.receiverName = receiveName;
    nowAddress.receiverPhone = receivePhone;
    nowAddress.zipCode = postCode;
    nowAddress.detailAddress = detailAddress;//[NSString stringWithFormat:@"%@%@%@",_currentProvinece,_currentCity,detailAddress];
    
    nowAddress.nation = _currentNation;
    nowAddress.province = _currentProvinece;
    nowAddress.city = _currentCity;
    
    nowAddress.nationEn = _currentNation;
    nowAddress.provinceEn = _currentProvinece;
    nowAddress.cityEn = _currentCity;
    
    nowAddress.nationId = _currentNationID;
    nowAddress.provinceId = _currentProvineceID;
    nowAddress.cityId = _currentCityID;
    
    nowAddress.defaultBilling = _isDefaultBilling;
    nowAddress.defaultShipping = _isDefaultReceive;
    
    WeakSelf(ws);
    __block YYAddress *blockAddress = nowAddress;
    
    if (_currentOperationType == OperationTypeHelpCreate) {
        [YYOrderApi createOrModifyAddress:nowAddress orderCode:nil andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYBuyerAddressModel *addressModel, NSError *error) {
            if (rspStatusAndMessage.status == YYReqStatusCode100
                && addressModel
                && addressModel.addressId){
                if (ws.addressForBuyerButtonClicked) {
                    blockAddress.addressId = addressModel.addressId;
                    ws.addressForBuyerButtonClicked(blockAddress);
                }
            }
            blockAddress = nil;
        }];
    }else{
        [YYUserApi createOrModifyAddress:nowAddress andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
            if (rspStatusAndMessage.status == YYReqStatusCode100) {
                [YYToast showToastWithView:customView title:NSLocalizedString(@"操作成功！",nil) andDuration:kAlertToastDuration];
                if (ws.modifySuccess) {
                    ws.modifySuccess();
                }
            }else{
                [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
            }
        }];
    }
}
-(void)initProvinceCityData{
    _provinceInfo = nil;
    _currentProvinece = @"";
    _currentCity = @"";
    _currentProvineceID = @(0);
    _currentCityID = @(0);
}
-(void)initProvinceData{
    _currentProvinece = @"";
    _currentProvineceID = @(0);
}
-(void)initCityData{
    _currentCity = @"";
    _currentCityID = @(0);
}
-(void)initCountryData{
    _currentNation = @"";
    _currentNationID = @(0);
}
-(void)updateCountryView{
    
    NSString *titleStr = @"";
    if(![NSString isNilOrEmpty:_currentNation]){
        titleStr = _currentNation;
    }
    [_countryButton setTitle:titleStr forState:UIControlStateNormal];
    
    NSString *temptitleStr = @"";
    if(![NSString isNilOrEmpty:_currentProvinece]){
        if(![NSString isNilOrEmpty:_currentCity]){
            temptitleStr = [[NSString alloc] initWithFormat:@"%@,%@",_currentProvinece,_currentCity];
        }else{
            temptitleStr = _currentProvinece;
        }
    }
    [_cityButton setTitle:temptitleStr forState:UIControlStateNormal];
    
}
#pragma mark YYpickVIewDelegate

-(void)toobarDonBtnHaveCountryClick:(YYCountryPickView *)pickView resultString:(NSString *)resultString{
    if(pickView == _countryPickerView){
        //        选择了国家 判断是不是切换了国家  切换了重置省 城市
        NSArray *countryArr = [resultString componentsSeparatedByString:@"/"];
        if(countryArr.count > 1){
            if([self.currentNationID integerValue] != [countryArr[1] integerValue]){
                //切换了初始化
                [self initProvinceCityData];
                //更新国家信息
                self.currentNation = countryArr[0];
                self.currentNationID = @([countryArr[1] integerValue]);
                NSLog(@"111");
            }
        }else{
            //切换了初始化
            [self initCountryData];
            [self initProvinceCityData];
        }
        NSLog(@"\ncurrentNation = %@ currentNationID = %ld \n currentProvinece = %@ currentProvineceID = %ld \n currentCity = %@ currentCityID = %ld \n",_currentNation,[_currentNationID integerValue],_currentProvinece,[_currentProvineceID integerValue],_currentCity,[_currentCityID integerValue]);
        //打开城市选择器
        id obj;
        [self provinecesAndCityButtonClicked:obj];
        
    }else if(pickView == _provincePickerView){
        NSArray *provinceCityArr = [resultString componentsSeparatedByString:@","];
        if(provinceCityArr.count){
            NSArray * provinceArr = [provinceCityArr[0] componentsSeparatedByString:@"/"];
            if(provinceArr.count > 1){
                self.currentProvinece = provinceArr[0];
                self.currentProvineceID = @([provinceArr[1] integerValue]);
            }else{
                [self initProvinceData];
            }
            
            if(provinceCityArr.count > 1){
                
                NSArray * cityArr = [provinceCityArr[1] componentsSeparatedByString:@"/"];
                if(cityArr.count > 1){
                    self.currentCity = cityArr[0];
                    self.currentCityID = @([cityArr[1] integerValue]);
                }else{
                    [self initCityData];
                }
            }else{
                [self initCityData];
            }
        }
        [self updateCountryView];
        
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [_countryPickerView removeNoBlock];
    [_provincePickerView removeNoBlock];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField == _phoneField){
        NSInteger phoneCode = 860;
        if([_currentNation isEqualToString:@"中国"]||[_currentNation isEqualToString:@"China"]){
            phoneCode = 86;
        }
        BOOL _ishide = [self checkPhoneWarnWithPhoneCode:phoneCode];
        _phoneTipButton.hidden = _ishide;
    }
}

#pragma mark - Other

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
