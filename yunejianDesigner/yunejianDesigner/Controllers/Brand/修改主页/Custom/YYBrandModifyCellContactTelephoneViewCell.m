//
//  YYBuyerModifyCellContactTelephoneViewCell.m
//  YunejianBuyer
//
//  Created by Apple on 16/12/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYBrandModifyCellContactTelephoneViewCell.h"
#import "YYBrandHomeUpdateModel.h"
#import "regular.h"

@implementation YYBrandModifyCellContactTelephoneViewCell{
    NSInteger limitValue;
    NSInteger localValue;
}
#pragma mark - awakeFromNib
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_valueAreaInput];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_valueNumberInput];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_valueExtensionInput];
}
#pragma mark - updateUI
-(void)updateUI{
    
    if(_selectlimitValue == -1){
        BOOL havelimit = NO;
        if(![NSString isNilOrEmpty:_value]){
            YYBrandHomeUpdateModel *model = [YYBrandHomeUpdateModel createUploadCertModel:@[_value]];
            //+82 020-62158093-001
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
                                    _valueAreaInput.text = @"";
                                    _valueNumberInput.text = @"";
                                    _valueExtensionInput.text = @"";
                                    NSArray *numArr = [moblieArr[1] componentsSeparatedByString:@"-"];
                                    [numArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                        if(idx == 0){
                                            _valueAreaInput.text = obj;
                                        }else if(idx == 1){
                                            _valueNumberInput.text = obj;
                                        }else if(idx == 2){
                                            _valueExtensionInput.text = obj;
                                        }
                                    }];
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
        _valueAreaInput.text = @"";
        _valueNumberInput.text = @"";
        _valueExtensionInput.text = @"";
//        localValue = 86;
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
    NSArray *valueArr = @[[[NSString alloc] initWithFormat:@"+%ld %@-%@-%@",localValue,_valueAreaInput.text,_valueNumberInput.text,_valueExtensionInput.text],@(_selectlimitValue)];
    NSString *jsonStr = objArrayToJSON(valueArr);
    [self.delegate btnClick:0 section:0 andParmas:@[@"modify",[NSString stringWithFormat:@"Contact_4=%@",jsonStr]]];
    
}
#pragma mark - Other
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UITextFieldTextDidChangeNotification"
                                                  object:_valueAreaInput];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UITextFieldTextDidChangeNotification"
                                                  object:_valueNumberInput];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UITextFieldTextDidChangeNotification"
                                                  object:_valueExtensionInput];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
