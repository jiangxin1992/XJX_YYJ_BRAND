//
//  YYBrandSeriesToCartTempModel.h
//  yunejianDesigner
//
//  Created by yyj on 2018/1/8.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "YYSizeModel.h"
#import "YYOrderOneColorModel.h"

@class YYStyleInfoModel,YYOpusSeriesModel,YYOrderInfoModel;

@interface YYBrandSeriesToCartTempModel : JSONModel

@property (nonatomic, assign) BOOL isModifyOrder;
@property (strong, nonatomic) YYStyleInfoModel <Optional>*styleInfoModel;
@property (strong, nonatomic) YYOpusSeriesModel <Optional>*opusSeriesModel;
@property (strong, nonatomic) YYOrderInfoModel <Optional>*tempOrderInfoModel;
@property (strong, nonatomic) NSNumber <Optional>*isOnlyColor;
@property (strong, nonatomic) NSMutableArray <Optional>*selectColorArr;
@property (strong, nonatomic) NSArray<YYSizeModel, Optional,ConvertOnDemand>* sizeNameArr;
@property (strong, nonatomic) NSArray<YYOrderOneColorModel, Optional,ConvertOnDemand>* amountSizeArr;

@end

