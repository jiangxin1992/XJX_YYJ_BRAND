//
//  YYBuyerModifyCellPriceViewCell.m
//  YunejianBuyer
//
//  Created by Apple on 16/12/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYBuyerModifyCellPriceViewCell.h"
#import "YYBuyerHomeUpdateModel.h"

@implementation YYBuyerModifyCellPriceViewCell
#pragma mark - awakeFromNib
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_valueInput1];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_valueInput2];
}
#pragma mark - updateUI
-(void)updateUI{
    NSArray *priceArr = [_value componentsSeparatedByString:@"&"];
    if([priceArr count] >= 2){
        YYBuyerHomeUpdateModel *modelMin = [YYBuyerHomeUpdateModel createUploadCertModel:@[priceArr[0]]];
        YYBuyerHomeUpdateModel *modelMax = [YYBuyerHomeUpdateModel createUploadCertModel:@[priceArr[1]]];
        NSInteger value1 = [modelMin.priceMin integerValue];
        NSInteger value2 = [modelMax.priceMax integerValue];
        
        _valueInput1.text = [NSString stringWithFormat:@"%ld",(long)value1];
        _valueInput2.text = [NSString stringWithFormat:@"%ld",(long)value2];
        
    }else{
        _valueInput1.text = nil;
        _valueInput2.text = nil;
    }
    
}
#pragma mark - textFiled
-(void)textFiledEditChanged:(NSNotification *)obj{
    //    UITextField *textField = (UITextField *)obj.object;
    ////    if([NSString isNilOrEmpty:textField.text]){
    ////        return;
    ////    }
    NSInteger value1 = [_valueInput1.text integerValue];
    NSInteger value2 = [_valueInput2.text integerValue];
    NSString *valueStr = [NSString stringWithFormat:@"priceMin=%ld&priceMax=%ld",value1,value2];
    [self.delegate btnClick:0 section:0 andParmas:@[@"modify",valueStr]];
}


#pragma mark - Other

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UITextFieldTextDidChangeNotification"
                                                  object:_valueInput1];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UITextFieldTextDidChangeNotification"
                                                  object:_valueInput2];
}
@end
