//
//  YYOrderOneInfoModel.h
//  Yunejian
//
//  Created by yyj on 15/8/6.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"
#import "YYOrderStyleModel.h"
#import "YYDateRangeModel.h"
@protocol YYOrderOneInfoModel @end

@interface YYOrderOneInfoModel : JSONModel

@property (strong, nonatomic) YYDateRangeModel <Optional>*dateRange;
//所购买的款式列表
@property (strong, nonatomic) NSMutableArray<YYOrderStyleModel, Optional,ConvertOnDemand>* styles;

- (BOOL)isInStock;//是否是现货

@end
