//
//  YYBuyerListModel.h
//  Yunejian
//
//  Created by Apple on 15/10/28.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"
#import "YYBuyerModel.h"
#import "YYPageInfoModel.h"
@interface YYBuyerListModel : JSONModel
@property (strong, nonatomic) NSArray<YYBuyerModel,Optional, ConvertOnDemand>* result;
@property (strong, nonatomic) YYPageInfoModel <Optional>*pageInfo;
@end
