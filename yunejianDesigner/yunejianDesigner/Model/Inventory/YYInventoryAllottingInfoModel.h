//
//  YYInventoryAllottingInfoModel.h
//  yunejianDesigner
//
//  Created by Apple on 16/8/26.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "YYInventoryBuyerModel.h"
#import "YYInventoryStyleDemandModel.h"

@interface YYInventoryAllottingInfoModel : JSONModel
@property (strong, nonatomic) NSArray<YYInventoryBuyerModel,Optional, ConvertOnDemand>* buyers;//
@property (strong, nonatomic) NSArray<YYInventoryStyleDemandModel,Optional, ConvertOnDemand>* demands;//
@property (strong, nonatomic) NSArray<YYInventoryStyleDemandModel,Optional, ConvertOnDemand>* inventories;//
@end
