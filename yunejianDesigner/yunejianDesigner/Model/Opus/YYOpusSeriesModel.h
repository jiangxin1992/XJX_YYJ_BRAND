//
//  YYOpusSeriesModel.h
//  Yunejian
//
//  Created by yyj on 15/7/23.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"

@protocol YYOpusSeriesModel @end

@interface YYOpusSeriesModel : JSONModel

@property (strong, nonatomic) NSNumber <Optional>*designerId;
@property (strong, nonatomic) NSNumber <Optional>*year;
@property (strong, nonatomic) NSString <Optional>*albumImg;
@property (strong, nonatomic) NSNumber <Optional>*styleAmount;
@property (strong, nonatomic) NSString <Optional>*description;
@property (strong, nonatomic) NSString <Optional>*orderDueTime;
@property (strong, nonatomic) NSNumber <Optional>*supplyStatus;

@property (strong, nonatomic) NSNumber <Optional>*supplyEndTime;
@property (strong, nonatomic) NSNumber <Optional>*supplyStartTime;
@property (strong, nonatomic) NSString <Optional>*modifyTime;

@property (strong, nonatomic) NSString <Optional>*name;
@property (strong, nonatomic) NSString <Optional>*season;
@property (strong, nonatomic) NSNumber <Optional>*id;
@property (strong, nonatomic) NSNumber <Optional>*authType;
@property (strong, nonatomic) NSNumber <Optional>*whiteAuthCount;
@property (strong,nonatomic) NSNumber <Optional>*lookBookId;
@property (strong,nonatomic) NSNumber <Optional>*status;//系列发布状态0 publish, 2, draft
@property (strong, nonatomic) NSNumber <Optional>*dateRangeAmount;
@property (strong,nonatomic) NSNumber <Optional>*orderAmountMin;
@end
