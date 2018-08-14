//
//  YYBuyerModifyCellSocialViewCell.m
//  YunejianBuyer
//
//  Created by Apple on 16/12/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYBrandModifyCellSocialViewCell.h"
#import "YYBrandHomeUpdateModel.h"
@implementation YYBrandModifyCellSocialViewCell
#pragma mark - updateUI
-(void)updateUI{
    [_valueInput becomeFirstResponder];
    if([_detailType isEqualToString:@"social_weburl"]){
        _valueInput.placeholder = NSLocalizedString(@"请输入品牌网站",nil);
    }else if ([_detailType isEqualToString:@"social_weixin"]){
        _valueInput.placeholder = NSLocalizedString(@"请输入微信公众号",nil);
    }else if ([_detailType isEqualToString:@"social_sina"]){
        _valueInput.placeholder = NSLocalizedString(@"请输入新浪账号",nil);
    }else if ([_detailType isEqualToString:@"social_instagram"]){
        _valueInput.placeholder = NSLocalizedString(@"请输入Instagram账号",nil);
    }else if ([_detailType isEqualToString:@"social_facebook"]){
        _valueInput.placeholder = NSLocalizedString(@"请输入Facebook账号",nil);
    }
    
    if([_detailType isEqualToString:@"social_weburl"])
    {
        if(![NSString isNilOrEmpty:_value]){
            YYBrandHomeUpdateModel *model = [YYBrandHomeUpdateModel createUploadCertModel:@[_value]];
            _valueInput.text = model.webUrl;
        }else
        {
            _valueInput.text = @"";
        }
    }else
    {
        if(![NSString isNilOrEmpty:_value]){
            YYBrandHomeUpdateModel *model = [YYBrandHomeUpdateModel createUploadCertModel:@[_value]];
            if(model.userSocialInfos)
            {
                if(model.userSocialInfos.count)
                {
                    YYBuyerSocialInfoModel *socialmodel = model.userSocialInfos[0];
                    _valueInput.text = socialmodel.socialName;
                }else
                {
                    _valueInput.text = @"";
                }
            }else
            {
                _valueInput.text = @"";
            }
        }else
        {
            _valueInput.text = @"";
        }
    }
}
#pragma mark - textFiled
-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    //    if([NSString isNilOrEmpty:textField.text]){
    //        return;
    //    }
    //[self.delegate btnClick:_indexPath.row AndSection:_indexPath.section andParmas:@[_valueInput.text,@(0)]];Social
    if([_detailType isEqualToString:@"social_weburl"]){
        [self.delegate btnClick:0 section:0 andParmas:@[@"modify",[NSString stringWithFormat:@"webUrl=%@",textField.text]]];
    }else if ([_detailType isEqualToString:@"social_weixin"]){//Social_
        [self.delegate btnClick:0 section:0 andParmas:@[@"modify",[NSString stringWithFormat:@"Social_1=%@",textField.text]]];
    }else if ([_detailType isEqualToString:@"social_sina"]){
        [self.delegate btnClick:0 section:0 andParmas:@[@"modify",[NSString stringWithFormat:@"Social_0=%@",textField.text]]];
    }else if ([_detailType isEqualToString:@"social_instagram"]){
        [self.delegate btnClick:0 section:0 andParmas:@[@"modify",[NSString stringWithFormat:@"Social_3=%@",textField.text]]];
    }else if ([_detailType isEqualToString:@"social_facebook"]){
        [self.delegate btnClick:0 section:0 andParmas:@[@"modify",[NSString stringWithFormat:@"Social_2=%@",textField.text]]];
    }
}

#pragma mark - Other
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:_valueInput];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UITextFieldTextDidChangeNotification"
                                                  object:_valueInput];
}
@end
