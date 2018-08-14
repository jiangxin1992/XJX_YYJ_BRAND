//
//  YYOrderListModel.h
//  Yunejian
//
//  Created by yyj on 15/8/25.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"
#import "YYPageInfoModel.h"
#import "YYOrderListItemModel.h"

@interface YYOrderListModel : JSONModel

@property (strong, nonatomic) NSArray<YYOrderListItemModel, Optional,ConvertOnDemand>* result;
@property (strong, nonatomic) YYPageInfoModel <Optional>*pageInfo;

@end
