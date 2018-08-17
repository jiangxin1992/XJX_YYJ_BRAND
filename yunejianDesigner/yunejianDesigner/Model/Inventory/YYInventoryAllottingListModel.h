//
//  YYInventoryAllottingListModel.h
//  yunejianDesigner
//
//  Created by Apple on 16/8/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "YYInventoryAllottingModel.h"
#import "YYPageInfoModel.h"
@interface YYInventoryAllottingListModel : JSONModel
@property (strong, nonatomic) NSArray<YYInventoryAllottingModel,Optional, ConvertOnDemand>* result;
@property (strong, nonatomic) YYPageInfoModel <Optional>*pageInfo;
@end
