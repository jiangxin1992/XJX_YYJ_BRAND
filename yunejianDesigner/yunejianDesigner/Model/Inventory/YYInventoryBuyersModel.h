//
//  YYInventoryBuyersModel.h
//  yunejianDesigner
//
//  Created by Apple on 16/8/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "YYInventoryBuyerModel.h"

@interface YYInventoryBuyersModel : JSONModel
@property (strong, nonatomic) NSArray<YYInventoryBuyerModel,Optional, ConvertOnDemand>* result;

@end
