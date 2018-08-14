//
//  YYBuyerAddressListModel.h
//  Yunejian
//
//  Created by Apple on 15/10/28.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"
#import "YYPageInfoModel.h"
#import "YYOrderBuyerAddress.h"
@interface YYBuyerAddressListModel : JSONModel
@property (strong, nonatomic) NSArray<YYOrderBuyerAddress,Optional, ConvertOnDemand>* result;
@property (strong, nonatomic) YYPageInfoModel <Optional>*pageInfo;
@end
