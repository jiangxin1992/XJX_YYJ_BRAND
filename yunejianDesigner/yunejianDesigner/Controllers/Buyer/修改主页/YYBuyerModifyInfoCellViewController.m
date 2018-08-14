//
//  YYBuyerModifyInfoTxtViewController.m
//  YunejianBuyer
//
//  Created by Apple on 16/12/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYBuyerModifyInfoCellViewController.h"

#import "YYNavigationBarViewController.h"

#import "YYBuyerModifyCellDetailAddressViewCell.h"
#import "YYBuyerModifyCellSubmitViewCell.h"
#import "YYBuyerModifyCellDescViewCell.h"
#import "YYBuyerModifyCellPriceViewCell.h"
#import "YYBuyerModifyCellConnBrandViewCell.h"
#import "YYBuyerModifyCellSocialViewCell.h"
#import "YYBuyerModifyCellContactMobileViewCell.h"
#import "YYBuyerModifyCellContactTelephoneViewCell.h"
#import "YYBuyerModifyCellContactTxtViewCell.h"

#import "YYPickView.h"

#import "regular.h"
#import "YYVerifyTool.h"
#import "YYBuyerHomeUpdateModel.h"
#import "MJExtension.h"

@interface YYBuyerModifyInfoCellViewController ()<UITableViewDelegate,UITableViewDataSource,YYTableCellDelegate,YYPickViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic ,strong) NSString *paramStr;

@property(nonatomic,strong) YYPickView *localTypePickerView;
@property(nonatomic,assign)NSInteger selectlocalValue;

@property(nonatomic,strong) YYPickView *limitTypePickerView;
@property(nonatomic,assign)NSInteger selectlimitValue;

@end

@implementation YYBuyerModifyInfoCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
}

#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}

-(void)PrepareData
{
    _selectlimitValue= -1;
}
-(void)PrepareUI
{
    [_tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyborad)]];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YYNavigationBarViewController *navigationBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNavigationBarViewController"];
    
    navigationBarViewController.previousTitle = @"";
    NSString *_nowTitle = @"";
    if(_viewType == YYBuyerModifyInfoCellViewDetailAddress){
        _nowTitle = NSLocalizedString(@"详细地址",nil);
    }else if(_viewType == YYBuyerModifyInfoCellViewDesc){
        _nowTitle = NSLocalizedString(@"买手店简介",nil);
    }else if(_viewType == YYBuyerModifyInfoCellViewPrice){
        _nowTitle = NSLocalizedString(@"款式零售价范围",nil);
    }else if(_viewType == YYBuyerModifyInfoCellViewConnBrand){
        _nowTitle = NSLocalizedString(@"列举合作品牌",nil);
    }else if(_viewType == YYBuyerModifyInfoCellViewWebsite)
    {
        _nowTitle = NSLocalizedString(@"网站",nil);
    }else if(_viewType == YYBuyerModifyInfoCellViewContactTxt){
        if([_detailType isEqualToString:@"email"])
        {
            _nowTitle = @"Email";
        }else if([_detailType isEqualToString:@"weixin"])
        {
            _nowTitle = NSLocalizedString(@"微信",nil);
        }else if([_detailType isEqualToString:@"qq"])
        {
            _nowTitle = @"QQ";
        }
    }else if(_viewType == YYBuyerModifyInfoCellViewContactMobile){
        _nowTitle=NSLocalizedString(@"手机",nil);
    }else if(_viewType == YYBuyerModifyInfoCellViewContactTelephone){
        _nowTitle=NSLocalizedString(@"固定电话",nil);
    }else if(_viewType == YYBuyerModifyInfoCellViewSocial){
        if([_detailType isEqualToString:@"social_weixin"])
        {
            _nowTitle = NSLocalizedString(@"微信公众号",nil);
        }else if([_detailType isEqualToString:@"social_sina"])
        {
            _nowTitle = NSLocalizedString(@"新浪微博",nil);
        }else if([_detailType isEqualToString:@"social_instagram"])
        {
            _nowTitle = @"Instagram";
        }else if([_detailType isEqualToString:@"social_facebook"])
        {
            _nowTitle = @"Facebook";
        }
    }
    navigationBarViewController.nowTitle = _nowTitle;
    
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
            if (ws.cancelButtonClicked) {
                ws.cancelButtonClicked();
            }
            blockVc = nil;
        }
    }];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(_viewType == YYBuyerModifyInfoCellViewDetailAddress){
            return 120;
        }else if(_viewType == YYBuyerModifyInfoCellViewDesc){
            return 235;
        }else if(_viewType == YYBuyerModifyInfoCellViewPrice){
            return 80;
        }else if(_viewType == YYBuyerModifyInfoCellViewConnBrand){
            return 210;
        }else if(_viewType == YYBuyerModifyInfoCellViewSocial||_viewType == YYBuyerModifyInfoCellViewWebsite){
            return 65;
        }else if(_viewType == YYBuyerModifyInfoCellViewContactTxt){
            return 110;
        }else if(_viewType == YYBuyerModifyInfoCellViewContactTelephone){
            return 165;
        }else if(_viewType == YYBuyerModifyInfoCellViewContactMobile){
            return 165;
        }
    }else {
        return 100;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){

        if(_viewType == YYBuyerModifyInfoCellViewDetailAddress){
            YYBuyerModifyCellDetailAddressViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYBuyerModifyCellDetailAddressViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.detailType = _detailType;
            cell.value = _value;
            cell.delegate = self;
            [cell updateUI];
            return cell;
        }else if(_viewType == YYBuyerModifyInfoCellViewDesc){
            YYBuyerModifyCellDescViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYBuyerModifyCellDescViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.detailType = _detailType;
            cell.value = _value;
            cell.delegate = self;
            [cell updateUI];
            return cell;
        }else if(_viewType == YYBuyerModifyInfoCellViewPrice){
            YYBuyerModifyCellPriceViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYBuyerModifyCellPriceViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.detailType = _detailType;
            cell.value = _value;
            cell.delegate = self;
            [cell updateUI];
            return cell;
        }else if(_viewType == YYBuyerModifyInfoCellViewConnBrand){
            YYBuyerModifyCellConnBrandViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYBuyerModifyCellConnBrandViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //_tableView.rowHeight = cell.frame.size.height;
            cell.detailType = _detailType;
            cell.value = _value;
            cell.delegate = self;
            [cell updateUI];
            return cell;
        }else if(_viewType == YYBuyerModifyInfoCellViewSocial||_viewType == YYBuyerModifyInfoCellViewWebsite){
            YYBuyerModifyCellSocialViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYBuyerModifyCellSocialViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.detailType = _detailType;
            cell.delegate = self;
            cell.value = _value;
            [cell updateUI];
            return cell;
        }else if(_viewType == YYBuyerModifyInfoCellViewContactTxt){
            YYBuyerModifyCellContactTxtViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYBuyerModifyCellContactTxtViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.detailType = _detailType;
            cell.delegate = self;
            cell.value = _value;
            cell.selectlimitValue = _selectlimitValue;
            [cell updateUI];
            return cell;
        }else if(_viewType == YYBuyerModifyInfoCellViewContactTelephone){
            YYBuyerModifyCellContactTelephoneViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYBuyerModifyCellContactTelephoneViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.detailType = _detailType;
            cell.delegate = self;
            cell.value = _value;
            cell.selectlimitValue = _selectlimitValue;
            cell.selectlocalValue = _selectlocalValue;
            [cell updateUI];
            return cell;
        }else if(_viewType == YYBuyerModifyInfoCellViewContactMobile){
            YYBuyerModifyCellContactMobileViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYBuyerModifyCellContactMobileViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.detailType = _detailType;
            cell.delegate = self;
            cell.value = _value;
            cell.selectlimitValue = _selectlimitValue;
            cell.selectlocalValue = _selectlocalValue;
            [cell updateUI];
            return cell;
        }
    }else {
        YYBuyerModifyCellSubmitViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYBuyerModifyCellSubmitViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }
    return nil;
}
#pragma mark - SomeAction
-(void)dismissKeyborad
{
    [regular dismissKeyborad];
}
-(void)btnClick:(NSInteger)row section:(NSInteger)section andParmas:(NSArray *)parmas{
    NSString *type = [parmas objectAtIndex:0];
    if([type isEqualToString:@"modify"]){
        NSString *parmasStr = [parmas objectAtIndex:1];
        _value = parmasStr;
    }else if([type isEqualToString:@"save"]){
        if(_detailType)
        {
            if([_detailType isEqualToString:@"email"]){
                BOOL _emailFormatCorrect = NO;
                if(![NSString isNilOrEmpty:_value])
                {
                    YYBuyerHomeUpdateModel *model = [YYBuyerHomeUpdateModel createUploadCertModel:@[_value]];
                    if(model.userContactInfos)
                    {
                        if(model.userContactInfos.count)
                        {
                            YYBuyerContactInfoModel *contactModel = model.userContactInfos[0];
                            if(![NSString isNilOrEmpty:contactModel.contactValue])
                            {
                                if([YYVerifyTool emailVerify:contactModel.contactValue])
                                {
                                    _emailFormatCorrect = YES;
                                }
                            }else
                            {
                                _emailFormatCorrect = YES;
                            }
                        }
                    }
                }
                if(_emailFormatCorrect)
                {
                    if(_saveButtonClicked){
                        NSString *noBlankValue = [_value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        _saveButtonClicked(noBlankValue);
                    }
                }else
                {
                    [YYToast showToastWithTitle:NSLocalizedString(@"请输入正确邮箱",nil) andDuration:kAlertToastDuration];
                }
            }else{
                if(_saveButtonClicked){
                    _saveButtonClicked(_value);
                }
            }
        }else
        {
            
            if(_viewType == 8)
            {
                //            手机号码
                BOOL _phoneFormatCorrect = NO;
                NSArray *arr = [_value componentsSeparatedByString:@"="];
                if(arr.count>1)
                {
                    NSArray *objArr = [arr[1] mj_JSONObject];
                    if(objArr.count>1)
                    {
                        NSArray *phonenumArr = [objArr[0] componentsSeparatedByString:@" "];
                        if(phonenumArr.count>1)
                        {
                            NSString *typeStr = arr[0];
                            if([typeStr isEqualToString:@"Contact_1"])
                            {
                                NSString *phoneNum = phonenumArr[1];
                                if(![NSString isNilOrEmpty:phoneNum])
                                {
                                    if([YYVerifyTool numberVerift:phoneNum])
                                    {
                                        //纯数字
                                        if([phonenumArr[0] isEqualToString:@"+86"])
                                        {
                                            
                                            //中国大陆手机正则
                                            if([YYVerifyTool phoneVerify:phoneNum])
                                            {
                                                _phoneFormatCorrect = YES;
                                            }
                                        }else
                                        {
                                            if(phoneNum.length>=6&&phoneNum.length<=20)
                                            {
                                                _phoneFormatCorrect = YES;
                                            }
                                        }
                                    }
                                }else
                                {
                                    _phoneFormatCorrect = YES;
                                }
                            }
                        }
                    }
                }
                if(_phoneFormatCorrect)
                {
                    if(_saveButtonClicked){
                        _saveButtonClicked(_value);
                    }
                }else
                {
                    [YYToast showToastWithTitle:NSLocalizedString(@"请输入正确格式手机号码",nil) andDuration:kAlertToastDuration];
                }
            }else if(_viewType == 9)
            {
                //固定电话验证
                __block BOOL _telephoneFormatCorrect = NO;
                __block BOOL _telephoneFormatComplete = YES;
                NSArray *arr = [_value componentsSeparatedByString:@"="];
                if(arr.count>1)
                {
                    NSArray *objArr = [arr[1] mj_JSONObject];
                    if(objArr.count>1)
                    {
                        NSArray *phonenumArr = [objArr[0] componentsSeparatedByString:@" "];
                        if(phonenumArr.count>1)
                        {
                            NSString *typeStr = arr[0];
                            if([typeStr isEqualToString:@"Contact_4"])
                            {
                                NSString *phoneNum = phonenumArr[1];
                                NSArray *phoneNumArr = [phoneNum componentsSeparatedByString:@"-"];
                                [phoneNumArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                    
                                    if(idx == 1)
                                    {
                                        if([NSString isNilOrEmpty:obj]&&[NSString isNilOrEmpty:phoneNumArr[0]])
                                        {
                                            
                                        }else if([NSString isNilOrEmpty:obj]||[NSString isNilOrEmpty:phoneNumArr[0]])
                                        {
                                            _telephoneFormatComplete = NO;
                                            *stop = YES;
                                        }
                                    }
                                    
                                    if(![NSString isNilOrEmpty:obj])
                                    {
                                        if([YYVerifyTool numberVerift:obj]){
                                            if(idx == 2){
                                                if(obj.length <= 6)
                                                {
                                                    _telephoneFormatCorrect = YES;
                                                }else
                                                {
                                                    _telephoneFormatCorrect = NO;
                                                    *stop = YES;
                                                }
                                            }else if(idx == 1){
                                                if(obj.length >= 5 && obj.length <= 10)
                                                {
                                                    _telephoneFormatCorrect = YES;
                                                }else
                                                {
                                                    _telephoneFormatCorrect = NO;
                                                    *stop = YES;
                                                }
                                            }else{
                                                if([phonenumArr[0] isEqualToString:@"+86"])
                                                {
                                                    if(idx == 0){
                                                        if([YYVerifyTool telephoneAreaCode:obj])
                                                        {
                                                            _telephoneFormatCorrect = YES;
                                                        }else
                                                        {
                                                            _telephoneFormatCorrect = NO;
                                                            *stop = YES;
                                                        }
                                                    }
                                                }else
                                                {
                                                    if(idx == 0){
                                                        if(obj.length >= 3 && obj.length <= 6)
                                                        {
                                                            _telephoneFormatCorrect = YES;
                                                        }else
                                                        {
                                                            _telephoneFormatCorrect = NO;
                                                            *stop = YES;
                                                        }
                                                    }
                                                }
                                            }
                                            
                                        }else
                                        {
                                            _telephoneFormatCorrect = NO;
                                            *stop = YES;
                                        }
                                    }else
                                    {
                                        _telephoneFormatCorrect = YES;
                                    }
                                }];
                            }
                        }
                    }
                }
                if(_telephoneFormatComplete)
                {
                    if(_telephoneFormatCorrect)
                    {
                        if(_saveButtonClicked){
                            _saveButtonClicked(_value);
                        }
                    }else
                    {
                        [YYToast showToastWithTitle:NSLocalizedString(@"请输入正确信息",nil) andDuration:kAlertToastDuration];
                    }
                }else
                {
                    [YYToast showToastWithTitle:NSLocalizedString(@"请输入完整信息",nil) andDuration:kAlertToastDuration];
                }
                
            }else if(_viewType == 3)
            {
                //价格
                NSString *priceMin = nil;
                NSString *priceMax  =nil;
                NSArray *arr = [_value componentsSeparatedByString:@"&"];
                if(arr.count>1)
                {
                    NSArray *tempminArr = [arr[0] componentsSeparatedByString:@"="];
                    NSArray *tempmaxArr = [arr[1] componentsSeparatedByString:@"="];;
                    if(tempminArr.count>1&&tempmaxArr.count>1)
                    {
                        priceMin = tempminArr[1];
                        priceMax = tempmaxArr[1];
                    }
                }
                if(!([YYVerifyTool numberVerift:priceMin]&&[YYVerifyTool numberVerift:priceMax]))
                {
                    [YYToast showToastWithTitle:NSLocalizedString(@"请输入正确信息",nil) andDuration:kAlertToastDuration];
                }else if([priceMin integerValue ]>[priceMax integerValue])
                {
                    [YYToast showToastWithTitle:NSLocalizedString(@"价格填写有误",nil) andDuration:kAlertToastDuration];
                }else
                {
                    if(_saveButtonClicked){
                        _saveButtonClicked(_value);
                    }
                }
            }else{
                if(_saveButtonClicked){
                    _saveButtonClicked(_value);
                }
            }
        }
        
    }else if([type isEqualToString:@"selectlimit"]){
        [self selectLimit];
    }else if([type isEqualToString:@"selectlocal"]){
        [self selectlocal];
    }
}
-(void)toobarDonBtnHaveClick:(YYPickView *)pickView resultString:(NSString *)resultString{
    
    if(pickView == (YYPickView *)_localTypePickerView)
    {
        NSArray *arr = [_value componentsSeparatedByString:@"="];
        if(arr.count>1){
            NSArray *numArr = [resultString componentsSeparatedByString:@" "];
            if(numArr.count>1)
            {
                NSArray *localArr = [numArr[0] componentsSeparatedByString:@"+"];
                if(localArr.count>1){
                    NSInteger localValue = [localArr[1] integerValue];
                    _selectlocalValue = localValue;
                }
                
                NSArray *objArr = [arr[1] mj_JSONObject];
                if(objArr.count>1)
                {
                    NSArray *phonenumArr = [objArr[0] componentsSeparatedByString:@" "];
                    if(phonenumArr.count>1)
                    {
                        NSString *typeStr = arr[0];
                        NSArray *valueArr = @[[[NSString alloc] initWithFormat:@"%@ %@",numArr[0],phonenumArr[1]],objArr[1]];
                        NSString *jsonStr = objArrayToJSON(valueArr);
                        if([typeStr isEqualToString:@"Contact_1"])
                        {
                            //移动电话
                            _value = [NSString stringWithFormat:@"Contact_1=%@",jsonStr];
                        }else if([typeStr isEqualToString:@"Contact_4"])
                        {
                            //固定电话
                            _value = [NSString stringWithFormat:@"Contact_4=%@",jsonStr];
                        }
                    }
                }
            }
        }
        
    }else
    {
        if(_detailType)
        {
            NSInteger index = 0;
            if([resultString isEqualToString:NSLocalizedString(@"仅合作品牌可见",nil)])
            {
                index = 0;
            }else if([resultString isEqualToString:NSLocalizedString(@"公开",nil)])
            {
                index = 2;
            }
            _selectlimitValue = index;
            NSArray *arr = [_value componentsSeparatedByString:@"="];
            if(arr.count > 1)
            {
                NSArray *arrdata = [arr[1] mj_JSONObject];
                if ([_detailType isEqualToString:@"email"]){
                    
                    NSArray *valueArr = @[arrdata[0],@(_selectlimitValue)];
                    NSString *jsonStr = objArrayToJSON(valueArr);
                    _value = [NSString stringWithFormat:@"Contact_0=%@",jsonStr];
                    
                }else if ([_detailType isEqualToString:@"weixin"]){
                    
                    NSArray *valueArr = @[arrdata[0],@(_selectlimitValue)];
                    NSString *jsonStr = objArrayToJSON(valueArr);
                    _value = [NSString stringWithFormat:@"Contact_3=%@",jsonStr];
                    
                }else if ([_detailType isEqualToString:@"qq"]){
                    
                    NSArray *valueArr = @[arrdata[0],@(_selectlimitValue)];
                    NSString *jsonStr = objArrayToJSON(valueArr);
                    _value = [NSString stringWithFormat:@"Contact_2=%@",jsonStr];
                    
                }
            }
        }else
        {
            NSArray *arr = [_value componentsSeparatedByString:@"="];
            if(arr.count>1){
                
                NSArray *objArr = [arr[1] mj_JSONObject];
                if(objArr.count>1)
                {
                    NSInteger index = 0;
                    if([resultString isEqualToString:NSLocalizedString(@"仅合作品牌可见",nil)])
                    {
                        index = 0;
                    }else if([resultString isEqualToString:NSLocalizedString(@"公开",nil)])
                    {
                        index = 2;
                    }
                    _selectlimitValue = index;
                    NSString *typeStr = arr[0];
                    NSArray *valueArr = @[objArr[0],@(_selectlimitValue)];
                    NSString *jsonStr = objArrayToJSON(valueArr);
                    if([typeStr isEqualToString:@"Contact_1"])
                    {
                        //移动电话
                        _value = [NSString stringWithFormat:@"Contact_1=%@",jsonStr];
                    }else if([typeStr isEqualToString:@"Contact_4"])
                    {
                        //固定电话
                        _value = [NSString stringWithFormat:@"Contact_4=%@",jsonStr];
                    }
                }
            }
        }
    }
    NSLog(@"resultString %@",resultString);
    
    [self.tableView reloadData];
    [_limitTypePickerView removeFromSuperview];
    
}
-(void)selectLimit{
    if(self.limitTypePickerView == nil){
        NSArray *pickData = getContactLimitData();
        self.limitTypePickerView=[[YYPickView alloc] initPickviewWithArray:pickData isHaveNavControler:NO];
        [self.limitTypePickerView show:self.view];
        self.limitTypePickerView.delegate = self;
        self.limitTypePickerView.uidataType = UIDataTypeModifyLimit;
    }else
    {
        [self.limitTypePickerView show:self.view];
    }
}
-(void)selectlocal{
    if(self.localTypePickerView == nil){
        NSArray *pickData = getContactLocalData();
        self.localTypePickerView=[[YYPickView alloc] initPickviewWithArray:pickData isHaveNavControler:NO];
        [self.localTypePickerView show:self.view];
        self.localTypePickerView.delegate = self;
    }else
    {
        [self.localTypePickerView show:self.view];
    }
}

#pragma mark - Other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
