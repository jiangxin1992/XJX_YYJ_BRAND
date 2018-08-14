//
//  YYWarehouseListModel.h
//  yunejianDesigner
//
//  Created by yyj on 2018/6/22.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "YYPageInfoModel.h"
#import "YYWarehouseModel.h"

@interface YYWarehouseListModel : JSONModel

@property (strong, nonatomic) NSArray<YYWarehouseModel, Optional,ConvertOnDemand>* result;
@property (strong, nonatomic) YYPageInfoModel <Optional>*pageInfo;

@end
