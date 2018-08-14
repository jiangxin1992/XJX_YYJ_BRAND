//
//  YYBuyerModifyCellContactTxtViewCell.m
//  YunejianBuyer
//
//  Created by Apple on 16/12/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYBuyerModifyCellContactTxtViewCell.h"
#import "YYBuyerHomeUpdateModel.h"
#import "regular.h"

@implementation YYBuyerModifyCellContactTxtViewCell{
    NSInteger limitValue;
}
#pragma mark - awakeFromNib
- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:_valueInput];
}
#pragma mark - updateUI
-(void)updateUI{
    if([_detailType isEqualToString:@"email"]){
        _titleLabel.text = @"Email";
    }else if ([_detailType isEqualToString:@"weixin"]){
        _titleLabel.text = NSLocalizedString(@"微信",nil);
    }else if ([_detailType isEqualToString:@"qq"]){
        _titleLabel.text = @"QQ";
    }
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    if(_selectlimitValue == -1){
        if(![NSString isNilOrEmpty:_value]){
            YYBuyerHomeUpdateModel *model = [YYBuyerHomeUpdateModel createUploadCertModel:@[_value]];
            //            NSArray *valueArr = dictionaryWithJsonString(_value);
            if(model.userContactInfos)
            {
                if(model.userContactInfos.count)
                {
                    YYBuyerContactInfoModel *contactmodel = model.userContactInfos[0];
                    _valueInput.text = contactmodel.contactValue;
                    limitValue = [contactmodel.auth integerValue];
                    _limitLabel.text = getContactLimitType(limitValue);
                    _selectlimitValue = limitValue;
                    return;
                }
            }
        }
        
        _valueInput.text = nil;
        _limitLabel.text = @"";
        limitValue= 0;
        _selectlimitValue = limitValue;
    }else{
        _limitLabel.text = getContactLimitType(_selectlimitValue);
        
    }
    
}

#pragma mark - SomeAction
- (IBAction)selectBtnHandler:(id)sender {
    [regular dismissKeyborad];
    [self.delegate btnClick:0 section:0 andParmas:@[@"selectlimit",@(limitValue)]];
}
-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
//    if([NSString isNilOrEmpty:textField.text]){
//        return;
//    }
    NSArray *valueArr = @[textField.text,@(_selectlimitValue)];
    NSString *jsonStr = objArrayToJSON(valueArr);
    if ([_detailType isEqualToString:@"email"]){//Social_
        [self.delegate btnClick:0 section:0 andParmas:@[@"modify",[NSString stringWithFormat:@"Contact_0=%@",jsonStr]]];
    }else if ([_detailType isEqualToString:@"weixin"]){
        [self.delegate btnClick:0 section:0 andParmas:@[@"modify",[NSString stringWithFormat:@"Contact_3=%@",jsonStr]]];
    }else if ([_detailType isEqualToString:@"qq"]){
        [self.delegate btnClick:0 section:0 andParmas:@[@"modify",[NSString stringWithFormat:@"Contact_2=%@",jsonStr]]];
    }
}

#pragma mark - Other
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
