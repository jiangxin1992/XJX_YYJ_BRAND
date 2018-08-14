//
//  YYBuyerModifyCellConnBrandViewCell.m
//  YunejianBuyer
//
//  Created by Apple on 16/12/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYBuyerModifyCellConnBrandViewCell.h"

#import "regular.h"
#import "YYBuyerHomeUpdateModel.h"
@interface YYBuyerModifyCellConnBrandViewCell()<UITextFieldDelegate>

@end
@implementation YYBuyerModifyCellConnBrandViewCell
#pragma mark - awakeFromNib
- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:nil];
}

#pragma mark - updateUI
-(void)updateUI{
    YYBuyerHomeUpdateModel *model = [YYBuyerHomeUpdateModel createUploadCertModel:@[_value]];

    if(model.copBrands)
    {
        for (int i = 0; i < 7; i++) {
            UITextField *connBrandInputText = [self valueForKey:[NSString stringWithFormat:@"connBrandInputText%d",(i+1)]];
            connBrandInputText.returnKeyType = UIReturnKeyDone;
            connBrandInputText.delegate=self;
            if(i < [model.copBrands count]){
                if (i == 6) {
                    NSArray *tmpArray = [model.copBrands subarrayWithRange:NSMakeRange(i, [model.copBrands count]-i)];
                    connBrandInputText.text = [tmpArray componentsJoinedByString:@"，"];
                }else{
                    connBrandInputText.text = [model.copBrands objectAtIndex:i];
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
    for (int i = 0; i < 7; i++) {
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
    NSString *paramsStr = [NSString stringWithFormat:@"copBrands=%@",jsonStr];
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
