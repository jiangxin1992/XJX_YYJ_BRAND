//
//  YYOrderSettingInfoModel.h
//  Yunejian
//
//  Created by yyj on 15/8/20.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "JSONModel.h" 
#import "YYOrderAmountModel.h"

@interface YYOrderSettingInfoModel : JSONModel

@property (strong, nonatomic) NSArray <Optional,ConvertOnDemand>* deliveryList;
@property (strong, nonatomic) NSArray <Optional,ConvertOnDemand>* payList;
@property (strong, nonatomic) NSArray <Optional,ConvertOnDemand>* occasionList;

@property (strong, nonatomic) YYOrderAmountModel <Optional> *orderAmount;

@end
