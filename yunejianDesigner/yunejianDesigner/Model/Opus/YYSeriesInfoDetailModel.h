//
//  YYSeriesInfoDetailModel.h
//  Yunejian
//
//  Created by Apple on 15/12/3.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"

#import "YYDateRangeModel.h"

@class YYSeriesInfoModel,YYOpusSeriesModel;

@interface YYSeriesInfoDetailModel : JSONModel

@property (strong, nonatomic) NSArray <Optional, ConvertOnDemand>* authBuyerIdList;
@property (strong, nonatomic) NSString <Optional>*brandName;
@property (strong, nonatomic) NSString <Optional>*brandDescription;
@property (strong, nonatomic) NSNumber <Optional>*lookBookId;
@property (strong, nonatomic) NSArray <Optional, YYDateRangeModel>*dateRanges;//时间波段
@property (strong, nonatomic) YYSeriesInfoModel <Optional>*series;

- (YYOpusSeriesModel *)toOpusSeriesModel;

@end
