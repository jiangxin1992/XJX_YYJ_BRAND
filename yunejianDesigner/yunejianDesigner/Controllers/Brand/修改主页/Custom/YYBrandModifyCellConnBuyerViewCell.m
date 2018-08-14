//
//  YYBuyerModifyCellConnBrandViewCell.m
//  YunejianBuyer
//
//  Created by Apple on 16/12/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYBrandModifyCellConnBuyerViewCell.h"

#import "regular.h"
#import "YYBrandHomeUpdateModel.h"
@interface YYBrandModifyCellConnBuyerViewCell()<UITextFieldDelegate>

@end
@implementation YYBrandModifyCellConnBuyerViewCell
#pragma mark - awakeFromNib
- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:nil];
}

#pragma mark - updateUI
-(void)updateUI{
    YYBrandHomeUpdateModel *model = [YYBrandHomeUpdateModel createUploadCertModel:@[_value]];
    if(model.retailerName)
    {
        for (int i = 0; i < 3; i++) {
            UITextField *connBrandInputText = [self valueForKey:[NSString stringWithFormat:@"connBrandInputText%d",(i+1)]];
            connBrandInputText.returnKeyType = UIReturnKeyDone;
            connBrandInputText.delegate=self;
            if(i < [model.retailerName count]){
                if (i == 6) {
                    NSArray *tmpArray = [model.retailerName subarrayWithRange:NSMakeRange(i, [model.retailerName count]-i)];
                    connBrandInputText.text = [tmpArray componentsJoinedByString:@"，"];
                }else{
                    connBrandInputText.text = [model.retailerName objectAtIndex:i];
                }
            }else{
                connBrandInputText.text = nil;
            }
        }
    }
}
#pragma mark - textFiled
-(void)textFiledEditChanged:(NSNotification *)obj{
    NSMutableArray *tmpStrArray =[[NSMutableArray alloc] init];
    for (int i = 0; i < 3; i++) {
        UITextField *connBrandInputText = [self valueForKey:[NSString stringWithFormat:@"connBrandInputText%d",(i+1)]];
        if(connBrandInputText.text && connBrandInputText.text.length > 0){
            NSString *valueStr = [connBrandInputText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if(valueStr.length > 0){
                if(i==6){
                    NSArray *valueArr = [valueStr componentsSeparatedByString:@"，"];
                    [tmpStrArray addObjectsFromArray:valueArr];
                }else{
                    [tmpStrArray addObject:valueStr];
                }
            }
        }
    }
    NSString *jsonStr = @"";
    if([tmpStrArray count] > 0){
        jsonStr = objArrayToJSON(tmpStrArray);
    }
    NSString *paramsStr = [NSString stringWithFormat:@"retailerName=%@",jsonStr];
    [self.delegate btnClick:0 section:0 andParmas:@[@"modify",paramsStr]];
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [regular dismissKeyborad];
    return YES;
}
#pragma mark - Other
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UITextFieldTextDidChangeNotification"
                                                  object:nil];
}

@end
