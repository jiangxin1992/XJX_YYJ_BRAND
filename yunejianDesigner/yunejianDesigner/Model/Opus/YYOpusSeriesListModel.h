//
//  YYOpusSeriesListModel.h
//  Yunejian
//
//  Created by yyj on 15/7/23.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"
#import "YYOpusSeriesModel.h"
#import "YYPageInfoModel.h"

@interface YYOpusSeriesListModel : JSONModel

@property (strong, nonatomic) NSArray<YYOpusSeriesModel, Optional,ConvertOnDemand>* result;
@property (strong, nonatomic) YYPageInfoModel <Optional>*pageInfo;

@end
