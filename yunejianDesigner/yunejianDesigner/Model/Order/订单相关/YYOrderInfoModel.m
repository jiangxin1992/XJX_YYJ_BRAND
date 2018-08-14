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
        if([self.designerOrderStatus integerValue] == YYOrderCode_NEGOTIATION_DONE || [self.designerOrderStatus integerValue] == YYOrderCode_CONTRACT_DONE){
            isDesignerConfrim = YES;
        }
    }
    return isDesignerConfrim;
}

-(BOOL )isBuyerConfrim{
    BOOL isBuyerConfrim = NO;
    if(self){
        if([self.buyerOrderStatus integerValue] == YYOrderCode_NEGOTIATION_DONE || [self.buyerOrderStatus integerValue] == YYOrderCode_CONTRACT_DONE){
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
-(YYStylesAndTotalPriceModel *)getNowTotalValueByOrderInfo{

    YYStylesAndTotalPriceModel *stylesAndTotalPriceModel = nil;

    if (self) {

        stylesAndTotalPriceModel = [[YYStylesAndTotalPriceModel alloc] init];

        NSInteger tempTotalStyles = 0;
        NSInteger tempTotalCount = 0;
        double tempOriginalTotalPrice = 0.0;
        if (self && self.groups && [self.groups count] > 0) {
            for (int i=0; i<[self.groups count]; i++) {
                YYOrderOneInfoModel *orderOneInfoModel = [self.groups objectAtIndex:i];
                if(orderOneInfoModel && orderOneInfoModel.styles){
                    for (YYOrderStyleModel *orderStyleModel in orderOneInfoModel.styles) {
                        NSInteger styleTotalCount = 0;
                        if (orderStyleModel && orderStyleModel.colors && [orderStyleModel.colors count] > 0) {
                            for (YYOrderOneColorModel *orderOneColorModel in orderStyleModel.colors) {
                                if (orderOneColorModel && orderOneColorModel.sizes && [orderOneColorModel.sizes count] > 0) {
                                    for (YYOrderSizeModel *orderSizeModel in orderOneColorModel.sizes) {
                                        if([orderSizeModel.received intValue] > 0){
                                            tempTotalCount += [orderSizeModel.received integerValue];
                                            styleTotalCount += [orderSizeModel.received integerValue];
                                            tempOriginalTotalPrice += [orderOneColorModel.originalPrice floatValue] * [orderSizeModel.received integerValue];
                                        }
                                    }
                                }
                            }
                        }
                        if(styleTotalCount){
                            tempTotalStyles++;
                        }
                    }
                }
            }
        }

        stylesAndTotalPriceModel.totalStyles = tempTotalStyles;//共几款
        stylesAndTotalPriceModel.totalCount = tempTotalCount;//共多少件
        stylesAndTotalPriceModel.originalTotalPrice = tempOriginalTotalPrice;//每款打完折后算出的总价

        double taxRate = [self.taxRate doubleValue]/100;
        double finalTotalPrice = tempOriginalTotalPrice*(1+taxRate);
        if(self.discount !=nil){
            if([LanguageManager isEnglishLanguage]){
                finalTotalPrice = finalTotalPrice*(100 - [self.discount doubleValue])/100;
            }else{
                finalTotalPrice = finalTotalPrice*[self.discount doubleValue]/100;
            }
        }

        stylesAndTotalPriceModel.finalTotalPrice = finalTotalPrice;//税制,折后算出的总价
    }


    return stylesAndTotalPriceModel;
}
//获得提前发货完成的款式
-(NSArray *)getUndeliveredStylesInDelivering{
    NSMutableArray *undeliveredStylesArray = [[NSMutableArray alloc] init];
    if (self) {
        YYOrderInfoModel *tmpOrderInfoModel = [self copy];
        if (tmpOrderInfoModel && tmpOrderInfoModel.groups && [tmpOrderInfoModel.groups count] > 0) {
            for (int i = 0; i < [tmpOrderInfoModel.groups count]; i++) {
                YYOrderOneInfoModel *orderOneInfoModel = [tmpOrderInfoModel.groups objectAtIndex:i];
                if(orderOneInfoModel && orderOneInfoModel.styles){
                    for (YYOrderStyleModel *orderStyleModel in orderOneInfoModel.styles) {
                        if (orderStyleModel && orderStyleModel.colors && [orderStyleModel.colors count] > 0) {
                            //style
                            BOOL isStyleUndeliveredStyles = NO;
                            NSMutableArray *colorArray = [[NSMutableArray alloc] init];
                            for (YYOrderOneColorModel *orderOneColorModel in orderStyleModel.colors) {
                                if (orderOneColorModel && orderOneColorModel.sizes && [orderOneColorModel.sizes count] > 0) {
                                    //color
                                    BOOL isColorUndeliveredStyles = NO;
                                    NSMutableArray *sizeArray = [[NSMutableArray alloc] init];
                                    for (YYOrderSizeModel *orderSizeModel in orderOneColorModel.sizes) {
                                        //size
                                        NSInteger amount = [orderSizeModel.amount integerValue];
                                        NSInteger received = [orderSizeModel.received integerValue];
                                        if((amount > 0) && (amount > received)){
                                            isStyleUndeliveredStyles = YES;
                                            isColorUndeliveredStyles = YES;
                                            [sizeArray insertObject:orderSizeModel atIndex:0];//size写入
                                        }
                                        //size
                                    }
                                    orderOneColorModel.sizes = [sizeArray copy];//size更新
                                    if(isColorUndeliveredStyles){
                                        [colorArray addObject:orderOneColorModel];//color写入
                                    }
                                    //color
                                }
                            }
                            orderStyleModel.colors = [colorArray copy];//color更新
                            if(isStyleUndeliveredStyles){
                                [undeliveredStylesArray addObject:orderStyleModel];//style更新
                            }
                            //style
                        }
                    }
                }
            }
        }
    }
    return [undeliveredStylesArray copy];
}
//获得提前发货完成的款式(发货后的状态)
-(NSArray *)getUndeliveredStylesAfterDelivering{
    NSMutableArray *undeliveredStylesArray = [[NSMutableArray alloc] init];
    if (self) {
        YYOrderInfoModel *tmpOrderInfoModel = [self copy];
        if (tmpOrderInfoModel && tmpOrderInfoModel.groups && [tmpOrderInfoModel.groups count] > 0) {
            for (int i = 0; i < [tmpOrderInfoModel.groups count]; i++) {
                YYOrderOneInfoModel *orderOneInfoModel = [tmpOrderInfoModel.groups objectAtIndex:i];
                if(orderOneInfoModel && orderOneInfoModel.styles){
                    for (YYOrderStyleModel *orderStyleModel in orderOneInfoModel.styles) {
                        if (orderStyleModel && orderStyleModel.colors && [orderStyleModel.colors count] > 0) {
                            //style
                            BOOL isStyleUndeliveredStyles = NO;
                            NSMutableArray *colorArray = [[NSMutableArray alloc] init];
                            for (YYOrderOneColorModel *orderOneColorModel in orderStyleModel.colors) {
                                if (orderOneColorModel && orderOneColorModel.sizes && [orderOneColorModel.sizes count] > 0) {
                                    //color
                                    BOOL isColorUndeliveredStyles = NO;
                                    NSMutableArray *sizeArray = [[NSMutableArray alloc] init];
                                    for (YYOrderSizeModel *orderSizeModel in orderOneColorModel.sizes) {
                                        //size
                                        NSInteger amount = [orderSizeModel.amount integerValue];//现在的
                                        NSInteger prevAmount = [orderSizeModel.prevAmount integerValue];//原来的
                                        if((prevAmount > 0) && (prevAmount > amount)){
                                            isStyleUndeliveredStyles = YES;
                                            isColorUndeliveredStyles = YES;
                                            orderSizeModel.amount = @(prevAmount);
                                            orderSizeModel.received = @(amount);
                                            [sizeArray insertObject:orderSizeModel atIndex:0];//size写入
                                        }
                                        //size
                                    }
                                    orderOneColorModel.sizes = [sizeArray copy];//size更新
                                    if(isColorUndeliveredStyles){
                                        [colorArray addObject:orderOneColorModel];//color写入
                                    }
                                    //color
                                }
                            }
                            orderStyleModel.colors = [colorArray copy];//color更新
                            if(isStyleUndeliveredStyles){
                                [undeliveredStylesArray addObject:orderStyleModel];//style更新
                            }
                            //style
                        }
                    }
                }
            }
        }
    }
    return [undeliveredStylesArray copy];
}
-(void)toPreData{
    if(self){
        self.totalPrice = self.prevTotalPrice;
        self.finalTotalPrice = self.prevFinalTotalPrice;
        if (self && self.groups && [self.groups count] > 0) {
            for (int i = 0; i < [self.groups count]; i++) {
                YYOrderOneInfoModel *orderOneInfoModel = [self.groups objectAtIndex:i];
                if(orderOneInfoModel && orderOneInfoModel.styles){
                    for (YYOrderStyleModel *orderStyleModel in orderOneInfoModel.styles) {
                        if (orderStyleModel && orderStyleModel.colors && [orderStyleModel.colors count] > 0) {
                            for (YYOrderOneColorModel *orderOneColorModel in orderStyleModel.colors) {
                                if (orderOneColorModel && orderOneColorModel.sizes && [orderOneColorModel.sizes count] > 0) {
                                    for (YYOrderSizeModel *orderSizeModel in orderOneColorModel.sizes) {
                                        if(!orderSizeModel.prevAmount){
                                            orderSizeModel.amount = @(0);
                                        }else{
                                            orderSizeModel.amount = @([orderSizeModel.prevAmount integerValue]);
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
}
@end
