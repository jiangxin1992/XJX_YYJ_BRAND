//
//  YYOrderSupplyTimeModel.h
//  Yunejian
//
//  Created by yyj on 15/8/25.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"

@protocol YYOrderSupplyTimeModel @end

@interface YYOrderSupplyTimeModel : JSONModel

@property (strong, nonatomic) NSNumber <Optional>*supplyStartTime;//交货最早日期
@property (strong, nonatomic) NSNumber <Optional>*supplyEndTime;//交货最早晚期

@property (strong, nonatomic) NSNumber <Optional>*supplyStatus;//供应状态
@property (strong, nonatomic) NSNumber <Optional>*dayPass;//超过发货日期的天数，没超过或无开始日期，值为为0
@property (strong, nonatomic) NSNumber <Optional>*dayRemains;//离发货截止日期的天数，已超过或无截止日期，值为0

@end
