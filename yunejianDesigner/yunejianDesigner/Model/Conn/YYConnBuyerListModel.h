//
//  YYConnBuyerListMode.h
//  Yunejian
//
//  Created by Apple on 15/12/1.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"
#import "YYConnBuyerModel.h"
#import "YYPageInfoModel.h"
@interface YYConnBuyerListModel : JSONModel
@property (strong, nonatomic) NSArray<YYConnBuyerModel,Optional, ConvertOnDemand>* result;
@property (strong, nonatomic) YYPageInfoModel <Optional>*pageInfo;

@end
