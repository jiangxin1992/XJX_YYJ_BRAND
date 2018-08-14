//
//  YYBuyerModifyInfoContactViewCell.m
//  YunejianBuyer
//
//  Created by Apple on 16/12/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYBuyerModifyInfoContactViewCell.h"
#import "YYBuyerContactInfoModel.h"
@implementation YYBuyerModifyInfoContactViewCell{
    NSInteger limitValue;
}
-(void)downlineIsHide:(BOOL )ishide
{
    _downline.hidden = ishide;
}
#pragma mark - awakeFromNib
- (void)awakeFromNib {
    [super awakeFromNib];
    [_titleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];

}
#pragma mark - updateUI
-(void)updateUI{
    self.valueLabel.text = @"";
    self.limitLabel.text = @"";
    limitValue = 0;
    for (YYBuyerContactInfoModel *contactInfoModel in _conractArr) {
        if([contactInfoModel.contactType integerValue] == _conractType){
            if(_conractType == 1)
            {
                NSArray *phoneArr = [contactInfoModel.contactValue componentsSeparatedByString:@" "];
                if(phoneArr.count>1)
                {
                    limitValue = [contactInfoModel.auth integerValue];
                    if(![NSString isNilOrEmpty:phoneArr[1]])
                    {
                        self.valueLabel.text = contactInfoModel.contactValue;
                        self.limitLabel.text = getContactLimitType([contactInfoModel.auth integerValue]);
                    }
                }
            }else if(_conractType == 4)
            {
                NSArray *phoneArr = [contactInfoModel.contactValue componentsSeparatedByString:@" "];
                if(phoneArr.count>1)
                {
                    limitValue = [contactInfoModel.auth integerValue];
                    NSArray *numArr = [phoneArr[1] componentsSeparatedByString:@"-"];
                    NSMutableArray *tempNumArr = [[NSMutableArray alloc] init];
                    [numArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if(![NSString isNilOrEmpty:obj])
                        {
                            [tempNumArr addObject:obj];
                        }
                    }];
                    
                    if(tempNumArr.count)
                    {
                        NSString *contactValue = [tempNumArr componentsJoinedByString:@"-"];
                        self.valueLabel.text = [[NSString alloc] initWithFormat:@"%@ %@",phoneArr[0],contactValue];
                        self.limitLabel.text = getContactLimitType([contactInfoModel.auth integerValue]);
                    }
                }
            }else
            {
                limitValue = [contactInfoModel.auth integerValue];
                if(![NSString isNilOrEmpty:contactInfoModel.contactValue])
                {
                    self.valueLabel.text = contactInfoModel.contactValue;
                    self.limitLabel.text = getContactLimitType([contactInfoModel.auth integerValue]);
                }
            }
            break;
        }
    }
}
#pragma mark - SomeAction
- (IBAction)selectHandler:(id)sender {
//    if(self.selectedValue){
//        NSArray *valueArr = @[self.valueLabel.text,@(limitValue)];
//        NSString *valueStr = objArrayToJSON(valueArr);
//        self.selectedValue(valueStr);
//    }
    if(self.selectedValue){
        __block NSString *contactValue = @"";
        [_conractArr enumerateObjectsUsingBlock:^(YYBuyerContactInfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(_conractType == [obj.contactType integerValue])
            {
                contactValue = obj.contactValue;
                *stop = YES;
            }
        }];
        NSArray *valueArr = @[contactValue,@(limitValue)];
        NSString *jsonStr = objArrayToJSON(valueArr);
        NSString *valueStr = @"";
        if(valueArr.count>1)
        {
            valueStr = [NSString stringWithFormat:@"Contact_%ld=%@",_conractType,jsonStr];
            self.selectedValue(valueStr);
        }
    }
}


#pragma mark - Other
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
