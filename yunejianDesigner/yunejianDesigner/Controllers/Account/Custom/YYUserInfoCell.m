//
//  YYUserInfoCell.m
//  Yunejian
//
//  Created by yyj on 15/7/16.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYUserInfoCell.h"

#import "YYUser.h"
#import "YYShowroomInfoModel.h"
#import "YYUserInfo.h"
#import "YYShowroomInfoByDesignerModel.h"

@interface YYUserInfoCell ()


@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIButton *infoIconImage;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UIImageView *newimage;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIView *tipView;
@property (nonatomic,assign)ShowType currentShowType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ValueLabelWidthLayout;

@end

@implementation YYUserInfoCell

- (IBAction)buttonClicked:(id)sender{
    if (_modifyButtonClicked) {
        
        _modifyButtonClicked(_userInfo,_currentShowType);
    }
}
- (void)updateReadState{
    YYUser *user = [YYUser currentUser];
    if(user.userType != 5)
    {
        NSString *CFBundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        if([CFBundleVersion integerValue] == 17)
        {
            _newimage.hidden = [YYUser getNewsReadStateWithType:2];
        }else
        {
            _newimage.hidden = YES;
        }
    }
}

- (IBAction)switchClicked:(id)sender{
   // UISwitch *tempSwitch = (UISwitch *)sender;
    //BOOL isOn = tempSwitch.isOn;
    //if (_switchClicked) {
    //    _switchClicked(_seller,isOn);
    //}
}

//- (void)setLabelStatus:(float)alpha{
//    self.keyLabel.alpha = alpha;
//    self.valueLabel.alpha = alpha;
//}

-(void)hideBottomLine:(BOOL)isHide{
    _bottomLine.hidden = isHide;
}
-(void)hideTipLabel:(BOOL)isHide{
    _tipLabel.hidden = isHide;
}

- (void)updateUIWithShowType:(ShowType )showType{
    
    if ([YYCurrentNetworkSpace isNetwork]
        && _userInfo) {
        _modifyButton.enabled = YES;
        [_modifyButton setTitleColor:[UIColor colorWithHex:@"47a3dc"] forState:UIControlStateNormal];
    }else{
        _modifyButton.enabled = NO;
        [_modifyButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    
 //   _statusSwitch.transform = CGAffineTransformMakeScale(1, 0.9);
    _newimage.hidden = YES;
    _modifyButton.titleLabel.textAlignment = NSTextAlignmentRight;
    _modifyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _modifyButton.contentEdgeInsets = UIEdgeInsetsMake(0,0, 0, 10);
    //_tipLabel.text = @"";

        if (!_userInfo) {
            return;
        }
    
    
    self.currentShowType = showType;
    _modifyButton.hidden = NO;
    _valueLabelTrailing.constant = 37;
    _tipView.hidden = YES;
    switch (showType) {
        case ShowTypeEmail:{
            [_infoIconImage setImage:[UIImage imageNamed:@"infoemail_icon"] forState:UIControlStateNormal];
            _keyLabel.text = NSLocalizedString(@"登录邮箱",nil);
            _valueLabel.text = _userInfo.email;
            _modifyButton.hidden = YES;
            _valueLabelTrailing.constant = 13;
        }
            break;
        case ShowTypeUsername:{
            [_infoIconImage setImage:[UIImage imageNamed:@"infopeople_icon"] forState:UIControlStateNormal];
            _keyLabel.text = NSLocalizedString(@"用户名",nil);
            _valueLabel.text = _userInfo.username;
            
            //[_modifyButton setTitle:@"修改" forState:UIControlStateNormal];
        }
            break;
        case ShowTypePhone:{
            [_infoIconImage setImage:[UIImage imageNamed:@"infophone_icon"] forState:UIControlStateNormal];

            _keyLabel.text = NSLocalizedString(@"电话",nil);
            _valueLabel.text = _userInfo.phone;
            //[_modifyButton setTitle:@"修改" forState:UIControlStateNormal];
        }
            break;
        case ShowTypePassword:{
            [_infoIconImage setImage:[UIImage imageNamed:@"infopwd_icon"] forState:UIControlStateNormal];

            _keyLabel.text = NSLocalizedString(@"登录密码",nil);
            _valueLabel.text =  NSLocalizedString(@"修改密码",nil);


        }
            break;
        case ShowTypeBuyer:{
            _keyLabel.text = NSLocalizedString(@"买手店",nil);
            _valueLabel.text = _userInfo.brandName;
        }
            break;
        case ShowTypeSeller:{//
            
            YYUser *user = [YYUser currentUser];
            if(user.userType == 5)
            {
                [_infoIconImage setImage:[UIImage imageNamed:@"user_icon"] forState:UIControlStateNormal];
                _keyLabel.text = NSLocalizedString(@"Showroom子账号",nil);
                _valueLabel.text = [NSString stringWithFormat:@"%ld",[self getNormalNum]];//;
            }else
            {
                [_infoIconImage setImage:[UIImage imageNamed:@"infoseller_icon"] forState:UIControlStateNormal];
                _keyLabel.text = NSLocalizedString(@"销售代表",nil);
                _valueLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[_userInfo.sellersArray count]];//;
            }
            
        }
            break;
        case ShowTypeAddress:{
            [_infoIconImage setImage:[UIImage imageNamed:@"infoaddress_icon"] forState:UIControlStateNormal];
            _keyLabel.text = NSLocalizedString(@"收件地址",nil);
            _valueLabel.text = NSLocalizedString(@"管理收件地址_short",nil);
            //[_modifyButton setTitle:@"地址管理" forState:UIControlStateNormal];

        }
            break;
        case ShowTypeCity:{
            [_infoIconImage setImage:[UIImage imageNamed:@"infoposition_icon"] forState:UIControlStateNormal];
            _keyLabel.text = NSLocalizedString(@"所在地",nil);
            
            NSString *_nation = [LanguageManager isEnglishLanguage]?_userInfo.nationEn:_userInfo.nation;
            NSString *_province = [LanguageManager isEnglishLanguage]?_userInfo.provinceEn:_userInfo.province;
            NSString *_city = [LanguageManager isEnglishLanguage]?_userInfo.cityEn:_userInfo.city;
            _valueLabel.text = [[NSString alloc] initWithFormat:NSLocalizedString(@"%@ %@%@",nil),_nation,_province,_city];

        }
            break;
        case ShowTypeHome:{
            YYUser *user = [YYUser currentUser];

            if(user.userType == 0||user.userType == 1)
            {
                _keyLabel.text = NSLocalizedString(@"我的品牌主页",nil);
            }else
            {
                _keyLabel.text = NSLocalizedString(@"我的Showroom主页",nil);
            }

            [_infoIconImage setImage:[UIImage imageNamed:@"home_icon"] forState:UIControlStateNormal];
            _valueLabel.text = @"";
            [self updateReadState];
        }
            break;
        case ShowTypeBrand:{
                        NSString *titleStr = NSLocalizedString(@"品牌",nil);
                        NSString *btnStr = NSLocalizedString(@"验证品牌信息",nil);
                        NSString *btnWaitingStr = NSLocalizedString(@"品牌审核中",nil);
                        //NSString *tipStr = @"请在30天内完成品牌信息验证，未验证的品牌账号将被锁定";
                        NSString *rufuseTipStr = NSLocalizedString(@"审核被拒,请重新验证品牌信息",nil);

                        _keyLabel.text = titleStr;
                        _valueLabel.text = _userInfo.brandName;
                        //_userInfo.status = @"305";
                        if([_userInfo.status integerValue] == kCode305){
                            //_modifyButton.hidden = NO;
                        }else{
                            //_modifyButton.hidden = YES;
                        }
                        //_valueLabel.hidden = YES;
                        if([_userInfo.status integerValue] == kCode305){
                            [_valueLabel setAdjustsFontSizeToFitWidth:YES];
                            _valueLabel.text = btnStr;
                            _valueLabel.hidden = NO;
                        }else if([_userInfo.status integerValue] == kCode300){
                            [_valueLabel setAdjustsFontSizeToFitWidth:YES];
                            _valueLabel.text = btnWaitingStr;
                            _valueLabel.hidden = NO;
                        }else if([_userInfo.status integerValue] == kCode301){
                            [_valueLabel setAdjustsFontSizeToFitWidth:YES];
                            _valueLabel.text = rufuseTipStr;
                            _valueLabel.hidden = NO;
                        }
        }
            break;
        case ShowTypeContractTime:{
            
            _modifyButton.hidden = YES;
            _valueLabelTrailing.constant = 13;
            _keyLabel.text = NSLocalizedString(@"合同起止时间",nil);
            [_infoIconImage setImage:[UIImage imageNamed:@"contractTime_icon"] forState:UIControlStateNormal];
            NSString *formatter = @"yyyy.MM.dd";
            if(_ShowroomModel)
            {
                if(_ShowroomModel.showroomInfo.contractEndTime&&_ShowroomModel.showroomInfo.contractStartTime)
                {
                    _valueLabel.text = [[NSString alloc] initWithFormat:@"%@ - %@",getTimeStr([_ShowroomModel.showroomInfo.contractStartTime longLongValue]/1000, formatter),getTimeStr([_ShowroomModel.showroomInfo.contractEndTime longLongValue]/1000, formatter)];
                }else
                {
                    _valueLabel.text = @"";
                }
            }else
            {
                _valueLabel.text = @"";
            }
        }
            break;
        case ShowTypeAgentShowroom:{

            _keyLabel.text = NSLocalizedString(@"代理Showroom",nil);
            [_infoIconImage setImage:[UIImage imageNamed:@"infoseller_icon"] forState:UIControlStateNormal];
            _valueLabel.text = @"";
            if(_showroomInfoByDesignerModel)
            {
                if(_showroomInfoByDesignerModel.status)
                {
                    if([_showroomInfoByDesignerModel.status isEqualToString:@"AGREE"]){
                        //已同意(代理中)
                        _valueLabel.text = _showroomInfoByDesignerModel.showroomName;
                    }else if([_showroomInfoByDesignerModel.status isEqualToString:@"INIT"]){
                        //待同意
                        _valueLabel.text = NSLocalizedString(@"待同意",nil);
                        _tipView.hidden = NO;
                        _tipView.layer.masksToBounds = YES;
                        _tipView.layer.cornerRadius = 3;
                    }
                }else
                {
                    //暂无代理
                    _valueLabel.text = NSLocalizedString(@"暂无代理",nil);
                    _modifyButton.hidden = YES;
                    _valueLabelTrailing.constant = 13;
                }
            }
        }
            break;
        default:
            break;
    }
    
    _ValueLabelWidthLayout.constant = SCREEN_WIDTH - 50 - _valueLabelTrailing.constant - getWidthWithHeight(20, _keyLabel.text, [UIFont systemFontOfSize:14.0f]) - 20;
    
}
-(NSInteger )getNormalNum
{
    
    if(_ShowroomModel)
    {
        if(_ShowroomModel.subList)
        {
            return _ShowroomModel.subList.count;
        }
    }
    return 0;
}
//-(NSInteger )getNormalNum
//{
//    
//    if(_ShowroomModel)
//    {
//        if(_ShowroomModel.subList)
//        {
//            NSInteger normalNum = 0;
//            for (YYShowroomSubModel *model in _ShowroomModel.subList) {
//                if([model.status isEqualToString:@"NORMAL"])
//                {
//                    normalNum++;
//                }
//            }
//            return normalNum;
//        }
//    }
//    return 0;
//}

@end
