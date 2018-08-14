//
//  YYOpusStyleModel.m
//  Yunejian
//
//  Created by yyj on 15/7/27.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYOpusStyleModel.h"

@implementation YYOpusStyleModel

-(YYStyleInfoModel *)toStyleInfoModel{
    YYStyleInfoModel *tempStyleInfoModel = nil;
    if(self){
        YYStyleInfoModel *convertStyleInfoModel = [[YYStyleInfoModel alloc] init];
        //尺寸部份
        convertStyleInfoModel.size = self.sizeList;
        //颜色部份
        convertStyleInfoModel.colorImages = self.color;
        //款式详情部份
        YYStyleInfoDetailModel *styleInfoDetailModel = [[YYStyleInfoDetailModel alloc] init];
        styleInfoDetailModel.albumImg = self.albumImg;
        styleInfoDetailModel.styleCode = self.styleCode;
        styleInfoDetailModel.name = self.name;
        styleInfoDetailModel.orderAmountMin = self.orderAmountMin;
        styleInfoDetailModel.id = self.id;
        styleInfoDetailModel.finalPrice = nil;
        styleInfoDetailModel.tradePrice = self.tradePrice;
        styleInfoDetailModel.retailPrice = self.retailPrice;
        styleInfoDetailModel.modifyTime = self.modifyTime;
        styleInfoDetailModel.curType= self.curType;
        styleInfoDetailModel.seriesId = self.seriesId;
        styleInfoDetailModel.supportAdd = self.supportAdd;
        convertStyleInfoModel.dateRange = self.dateRange;
        convertStyleInfoModel.style = styleInfoDetailModel;
        tempStyleInfoModel = convertStyleInfoModel;
    }
    return tempStyleInfoModel;
}

@end
