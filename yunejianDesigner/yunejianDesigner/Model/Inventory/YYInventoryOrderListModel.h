//
//  YYInventoryOrderListModel.h
//  yunejianDesigner
//
//  Created by Apple on 16/8/26.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "YYInventoryOrderModel.h"

@interface YYInventoryOrderListModel : JSONModel
@property (strong, nonatomic) NSArray<YYInventoryOrderModel,Optional, ConvertOnDemand>* result;//

@end
