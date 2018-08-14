//
//  YYOpusStyleListModel.h
//  Yunejian
//
//  Created by yyj on 15/7/27.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"
#import "YYOpusStyleModel.h"
#import "YYPageInfoModel.h"

@interface YYOpusStyleListModel : JSONModel

@property (strong, nonatomic) NSArray<YYOpusStyleModel, Optional,ConvertOnDemand>* result;
@property (strong, nonatomic) YYPageInfoModel <Optional>*pageInfo;

@end
