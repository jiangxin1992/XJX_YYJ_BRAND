//
//  YYAddressListModel.h
//  Yunejian
//
//  Created by yyj on 15/7/15.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"
#import "YYAddressModel.h"
@interface YYAddressListModel : JSONModel

@property (strong, nonatomic) NSArray<YYAddressModel,Optional, ConvertOnDemand>* result;
@end
