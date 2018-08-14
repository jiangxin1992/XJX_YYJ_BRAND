//
//  YYBuyerModifyCellContactMobileTableViewCell.m
//  YunejianBuyer
//
//  Created by Apple on 16/12/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYBuyerModifyCellContactMobileViewCell.h"
#import "YYBuyerHomeUpdateModel.h"
#import "regular.h"

@implementation YYBuyerModifyCellContactMobileViewCell{
    NSInteger limitValue;
    NSInteger localValue;
}
#pragma mark - awakeFromNib
- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_valueInput];
}
#pragma mark - updateUI
-(void)updateUI{
    
    if(_selectlimitValue == -1){
        BOOL havelimit = NO;
        if(![NSString isNilOrEmpty:_value]){
            YYBuyerHomeUpdateModel *model = [YYBuyerHomeUpdateModel createUploadCertModel:@[_value]];
            if(model.userContactInfos)
            {
                if(model.userContactInfos.count)
                {
                    YYBuyerContactInfoModel *contactmodel = model.userContactInfos[0];
                    
                    limitValue = [contactmodel.auth integerValue];
                    _limitLabel.text = getContactLimitType(limitValue);
                    _selectlimitValue = limitValue;
                    havelimit=YES;
                    if(![NSString isNilOrEmpty:contactmodel.contactValue])
                    {
                        NSArray *moblieArr = [contactmodel.contactValue componentsSeparatedByString:@" "];
                        if(moblieArr.count)
                        {
                            if(moblieArr.count>1)
                            {
                                NSString *localStr = moblieArr[0];
                                NSArray *localArr = [localStr componentsSeparatedByString:@"+"];
                                if(localArr.count>1){
                                    _valueInput.text = moblieArr[1];
                                    localValue = [localArr[1] integerValue];
                                    _localLabel.text = getContactLocalType(localValue);
                                    _selectlocalValue = localValue;
                                    return;
                                }
                            }
                        }
                    }
                }
            }
        }
        _valueInput.text = @"";
        localValue = _selectlocalValue;
        _localLabel.text = getContactLocalType(localValue);
        _selectlocalValue = localValue;
        
        if(!havelimit)
        {
            limitValue= 0;
            _selectlimitValue = limitValue;
            _limitLabel.text = getContactLimitType(_selectlimitValue);
        }
    }else{
        _limitLabel.text = getContactLimitType(_selectlimitValue);
    }
}
#pragma mark - SomeAction
- (IBAction)selectLocalBtnHandler:(id)sender {
    [regular dismissKeyborad];
    [self.delegate btnClick:0 section:0 andParmas:@[@"selectlocal",@(localValue)]];
}
- (IBAction)selectRootBtnHandler:(id)sender {
    [regular dismissKeyborad];
    [self.delegate btnClick:0 section:0 andParmas:@[@"selectlimit",@(limitValue)]];
}
-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSArray *valueArr = @[[[NSString alloc] initWithFormat:@"+%ld %@",localValue,textField.text],@(_selectlimitValue)];
    NSString *jsonStr = objArrayToJSON(valueArr);
    [self.delegate btnClick:0 section:0 andParmas:@[@"modify",[NSString stringWithFormat:@"Contact_1=%@",jsonStr]]];
}
#pragma mark - Other
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UITextFieldTextDidChangeNotification"
                                                  object:_valueInput];
}
@end
