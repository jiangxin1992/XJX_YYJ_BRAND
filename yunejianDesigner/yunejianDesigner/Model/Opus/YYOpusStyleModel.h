//
//  YYOpusStyleModel.h
//  Yunejian
//
//  Created by yyj on 15/7/27.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"

#import "YYColorModel.h"
#import "YYDateRangeModel.h"
#import "YYStyleInfoModel.h"
#import "YYSizeModel.h"

@protocol YYOpusStyleModel @end

@interface YYOpusStyleModel : JSONModel

@property (strong, nonatomic) NSString <Optional>*albumImg;
@property (strong, nonatomic) NSString <Optional>*category;
@property (strong, nonatomic) NSNumber <Optional>*modifyTime;
@property (strong, nonatomic) NSString <Optional>*name;
@property (strong, nonatomic) NSString <Optional>*seriesName;
@property (strong, nonatomic) NSString <Optional>*styleCode;
@property (strong, nonatomic) NSString <Optional>*region;
@property (strong, nonatomic) NSNumber <Optional>*tradePrice;
@property (strong, nonatomic) NSNumber <Optional>*originalPrice;
@property (strong, nonatomic) NSNumber <Optional>*seriesId;
@property (strong, nonatomic) NSNumber <Optional>*retailPrice;
@property (strong, nonatomic) NSNumber <Optional>*id;

@property (strong, nonatomic) NSArray<Optional,YYColorModel, ConvertOnDemand>* color;
@property (strong, nonatomic) NSArray<Optional,YYSizeModel, ConvertOnDemand>*sizeList;
@property (strong, nonatomic) NSNumber <Optional>*curType;//货币类型
@property (strong, nonatomic) NSNumber <Optional>*dateRangeId;//波段
@property (strong, nonatomic) YYDateRangeModel <Optional>*dateRange;
@property (strong, nonatomic) NSNumber <Optional>*supportAdd;// 是否支持补货
@property (strong, nonatomic) NSNumber <Optional>*orderAmountMin;
@property (strong, nonatomic) NSString <Optional>*orderDueTime;

-(YYStyleInfoModel *)toStyleInfoModel;

@end
