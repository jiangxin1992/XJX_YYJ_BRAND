//
//  YYSeriesInfoDetailModel.m
//  Yunejian
//
//  Created by Apple on 15/12/3.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "YYSeriesInfoDetailModel.h"

@implementation YYSeriesInfoDetailModel

- (YYOpusSeriesModel *)toOpusSeriesModel{
    YYOpusSeriesModel *opusSeriesModel = nil;
    if(self){
        opusSeriesModel = [[YYOpusSeriesModel alloc] init];
        opusSeriesModel.designerId = self.series.designerId;
        opusSeriesModel.year = self.series.year;
        opusSeriesModel.albumImg = self.series.albumImg;
        opusSeriesModel.styleAmount = self.series.styleAmount;
        opusSeriesModel.orderDueTime = self.series.orderDueTime;
        opusSeriesModel.supplyStatus = self.series.supplyStatus;
        opusSeriesModel.supplyEndTime = self.series.supplyEndTime;
        opusSeriesModel.supplyStartTime = self.series.supplyStartTime;
        opusSeriesModel.modifyTime = self.series.modifyTime;
        opusSeriesModel.name = self.series.name;
        opusSeriesModel.season = self.series.season;
        opusSeriesModel.id = self.series.id;
        opusSeriesModel.authType = self.series.authType;
        opusSeriesModel.lookBookId = self.series.lookBookId;
        opusSeriesModel.status = self.series.status;
        opusSeriesModel.dateRangeAmount = @(self.series.dateRanges.count);
        opusSeriesModel.orderAmountMin = self.series.orderAmountMin;
    }
    return opusSeriesModel;
}

@end


