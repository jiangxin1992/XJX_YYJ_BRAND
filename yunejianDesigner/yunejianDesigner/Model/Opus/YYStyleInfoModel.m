//
//  YYStyleInfoModel.m
//  Yunejian
//
//  Created by yyj on 15/7/28.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYStyleInfoModel.h"

#import "YYStyleOneColorModel.h"
#import "YYOpusStyleModel.h"

@implementation YYStyleInfoModel


-(NSString *)getSizeDes{
    NSString * sizeValue = @"";
    if (self.size
        && [self.size count] > 0) {
        for (YYSizeModel *sizeModel in self.size) {
            if (sizeValue && [sizeValue length] > 0) {
                sizeValue = [sizeValue stringByAppendingString:@" "];
            }
            sizeValue = [sizeValue stringByAppendingString:sizeModel.value];
        }
    }
    return sizeValue;
}

- (CGFloat)getMinTradePrice {
    NSArray *array = nil;
    if ([self.colorImages isKindOfClass:[NSArray class]]) {
        array = self.colorImages;
    } else {
        array = [self.colorImages forwardingTargetForSelector:nil];
    }
    return [[array valueForKeyPath:@"@min.tradePrice"] floatValue];
}

- (CGFloat)getMaxTradePrice {
    NSArray *array = nil;
    if ([self.colorImages isKindOfClass:[NSArray class]]) {
        array = self.colorImages;
    } else {
        array = [self.colorImages forwardingTargetForSelector:nil];
    }
    return [[array valueForKeyPath:@"@max.tradePrice"] floatValue];
}

/**
 模型转换

 @return ...
 */
-(YYStyleOneColorModel *)transformToStyleOneColorModel{
    YYStyleOneColorModel *infoModel = [[YYStyleOneColorModel alloc] init];
    infoModel.designerId = self.style.designerId;
    infoModel.brandName = self.style.designerBrandName;
    infoModel.brandLogo = self.style.designerBrandLogo;
    infoModel.seriesName = self.style.seriesName;
    infoModel.albumImg = self.style.albumImg;
    infoModel.styleName = self.style.name;
    infoModel.styleId = self.style.id;
    infoModel.seriesId = self.style.seriesId;
    infoModel.orderAmountMin = self.style.orderAmountMin;
    infoModel.supplyStatus = self.style.supplyStatus;
    infoModel.seriesStatus = self.style.seriesStatus;
    return infoModel;
}

- (YYOpusSeriesModel *)transformToOpusSeriesModel {
    YYOpusSeriesModel *seriesModel = [[YYOpusSeriesModel alloc] init];
    seriesModel.designerId = self.style.designerId;
    seriesModel.albumImg = self.style.albumImg;
    seriesModel.supplyStatus = self.style.supplyStatus;
    seriesModel.supplyEndTime = self.style.supplyEndTime;
    seriesModel.supplyStartTime = self.style.supplyStartTime;
    seriesModel.modifyTime = [NSString stringWithFormat:@"%@", self.style.modifyTime];
    seriesModel.name = self.style.seriesName;
    seriesModel.id = self.style.seriesId;
    seriesModel.status = self.style.seriesStatus;
    seriesModel.orderAmountMin = self.style.orderAmountMin;
    return seriesModel;
}

- (YYOpusStyleModel *)transformToOpusStyleModel {
    YYOpusStyleModel *styleModel = [[YYOpusStyleModel alloc] init];
    styleModel.albumImg = self.style.albumImg;
    styleModel.category = self.style.category;
    styleModel.modifyTime = self.style.modifyTime;
    styleModel.name = self.style.name;
    styleModel.seriesName = self.style.seriesName;
    styleModel.styleCode = self.style.styleCode;
    styleModel.region = self.style.region;
    styleModel.tradePrice = self.style.tradePrice;
    styleModel.seriesId = self.style.seriesId;
    styleModel.retailPrice = self.style.retailPrice;
    styleModel.id = self.style.id;
    styleModel.color = self.colorImages;
    styleModel.sizeList = self.size;
    styleModel.curType = self.style.curType;
    styleModel.dateRangeId = self.style.dateRangeId;
    styleModel.dateRange = self.dateRange;
    styleModel.supportAdd = self.style.supportAdd;
    styleModel.orderAmountMin = self.style.orderAmountMin;
    return styleModel;
}

@end
