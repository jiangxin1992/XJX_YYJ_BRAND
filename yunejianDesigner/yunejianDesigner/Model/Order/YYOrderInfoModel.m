//
//  YYOrderInfoModel.m
//  Yunejian
//
//  Created by yyj on 15/8/6.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYOrderInfoModel.h"

#import "YYStylesAndTotalPriceModel.h"

@implementation YYOrderInfoModel
-(BOOL )isDesignerConfrim{
    BOOL isDesignerConfrim = NO;
    if(self){
        if([self.designerOrderStatus integerValue] == kOrderCode_NEGOTIATION_DONE || [self.designerOrderStatus integerValue] == kOrderCode_CONTRACT_DONE){
            isDesignerConfrim = YES;
        }
    }
    return isDesignerConfrim;
}

-(BOOL )isBuyerConfrim{
    BOOL isBuyerConfrim = NO;
    if(self){
        if([self.buyerOrderStatus integerValue] == kOrderCode_NEGOTIATION_DONE || [self.buyerOrderStatus integerValue] == kOrderCode_CONTRACT_DONE){
            isBuyerConfrim = YES;
        }
    }
    return isBuyerConfrim;
}
+(NSInteger)getOrderSizeTotalAmountWidthDictionary:(NSDictionary*)dict{
    NSInteger num = 0;
    if([dict objectForKey:@"groups"]){
        for (NSDictionary *groupDic in [dict objectForKey:@"groups"]) {
            for (NSDictionary *styleDic in [groupDic objectForKey:@"styles"]) {
                for (NSDictionary *colorDic in [styleDic objectForKey:@"colors"]) {
                    BOOL isColorSelect = [[colorDic objectForKey:@"isColorSelect"] boolValue];
                    if(isColorSelect){
                        num += 1;
                    }else{
                        for (NSDictionary *sizeDic in [colorDic objectForKey:@"sizes"]) {
                            if([sizeDic objectForKey:@"amount"]){
                                num += [[sizeDic objectForKey:@"amount"] integerValue];
                            }
                        }
                    }
                }
            }
        }
    }
    return num;
}
+(NSInteger)getOrderStyleTotalNumWidthDictionary:(NSDictionary*)dict{
    NSInteger num = 0;
    if([dict objectForKey:@"groups"]){
        for (NSDictionary *groupDic in [dict objectForKey:@"groups"]) {
            if([groupDic objectForKey:@"styles"]){
                num += [[groupDic objectForKey:@"styles"] count];
            }
        }
    }
    return num;
}
-(YYStylesAndTotalPriceModel *)getTotalValueByOrderInfo:(BOOL )isEdit{
    YYStylesAndTotalPriceModel *stylesAndTotalPriceModel = nil;
    
    if (self) {
        stylesAndTotalPriceModel = [[YYStylesAndTotalPriceModel alloc] init];
        
        int tempTotalStyles = 0;
        int tempTotalCount = 0;
        double tempOriginalTotalPrice = 0.0;
        if (self && self.groups && [self.groups count] > 0) {
            for (int i=0; i<[self.groups count]; i++) {
                YYOrderOneInfoModel *orderOneInfoModel = [self.groups objectAtIndex:i];
                if(orderOneInfoModel && orderOneInfoModel.styles){
                    tempTotalStyles += [orderOneInfoModel.styles count];
                    for (YYOrderStyleModel *orderStyleModel in orderOneInfoModel.styles) {
                        if (orderStyleModel && orderStyleModel.colors && [orderStyleModel.colors count] > 0) {
                            tempOriginalTotalPrice += [orderStyleModel getTotalOriginalPrice];
                            for (YYOrderOneColorModel *orderOneColorModel in orderStyleModel.colors) {
                                if (orderOneColorModel && orderOneColorModel.sizes && [orderOneColorModel.sizes count] > 0) {
                                    BOOL isColorSelect = [orderOneColorModel.isColorSelect boolValue];
                                    if(isColorSelect && !isEdit){
                                        tempTotalCount += 1;
                                    }else{
                                        for (YYOrderSizeModel *orderSizeModel in orderOneColorModel.sizes) {
                                            if([orderSizeModel.amount intValue] > 0){
                                                tempTotalCount += [orderSizeModel.amount intValue];
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        stylesAndTotalPriceModel.totalStyles = tempTotalStyles;
        stylesAndTotalPriceModel.totalCount = tempTotalCount;
        stylesAndTotalPriceModel.originalTotalPrice = tempOriginalTotalPrice;
        
        double taxRate = [self.taxRate doubleValue]/100;
        double finalTotalPrice = tempOriginalTotalPrice*(1+taxRate);
        if(self.discount !=nil){
            if([LanguageManager isEnglishLanguage]){
                finalTotalPrice = finalTotalPrice*(100 - [self.discount doubleValue])/100;
            }else{
                finalTotalPrice = finalTotalPrice*[self.discount doubleValue]/100;
            }
        }
        
        stylesAndTotalPriceModel.finalTotalPrice = finalTotalPrice;
    }
    
    
    return stylesAndTotalPriceModel;
}
@end
