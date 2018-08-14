//
//  YYStyleInfoDetailModel.h
//  Yunejian
//
//  Created by yyj on 15/7/28.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"

@interface YYStyleInfoDetailModel : JSONModel

@property (strong, nonatomic) NSString <Optional>*albumImg;
@property (strong, nonatomic) NSString <Optional>*styleDescription;
@property (strong, nonatomic) NSString <Optional>*styleCode;
@property (strong, nonatomic) NSString <Optional>*materials;
@property (strong, nonatomic) NSString <Optional>*name;
@property (strong, nonatomic) NSString <Optional>*category;
@property (strong, nonatomic) NSString <Optional>*region;
@property (strong, nonatomic) NSString <Optional>*sizeCatName;
@property (strong, nonatomic) NSString <Optional>*seriesName;

@property (strong, nonatomic) NSNumber <Optional>*seriesId;
@property (strong, nonatomic) NSNumber <Optional>*orderPriceMin;
@property (strong, nonatomic) NSNumber <Optional>*orderAmountMin;
@property (strong, nonatomic) NSNumber <Optional>*id;

@property (strong, nonatomic) NSNumber <Optional>*tradePrice;
@property (strong, nonatomic) NSNumber <Optional>*retailPrice;
@property (strong, nonatomic) NSNumber <Optional>*finalPrice;//临时

@property (nonatomic,assign) NSNumber <Optional>*collect;

//还差

@property (strong, nonatomic) NSNumber <Optional>*seriesStatus;
@property (strong, nonatomic) NSNumber <Optional>*designerId;
@property (strong, nonatomic) NSNumber <Optional>*brandId;
@property (strong, nonatomic) NSString <Optional>*designerBrandLogo;
@property (strong, nonatomic) NSString <Optional>*designerBrandName;

@property (strong, nonatomic) NSString <Optional>*designerEmail;
@property (strong, nonatomic) NSString <Optional>*brandDescription;
@property (strong, nonatomic) NSString <Optional>*designerName;

//后面添加的参数

@property (strong, nonatomic) NSNumber <Optional>*modifyTime;

/*
 suplyStatus,供应类型，
 0，	可立即交货,supplyStartTIme 与 supplyEndTime 无效
 1，	时间段交货
 2，	暂不出货
 supplyStartTime, 可以开始供货日期
 supplyEndTime, 停止供货日期
 */
@property (strong, nonatomic) NSNumber <Optional>*supplyStatus;
@property (strong, nonatomic) NSNumber <Optional>*supplyStartTime;
@property (strong, nonatomic) NSNumber <Optional>*supplyEndTime;
@property (nonatomic, strong) NSString <Optional>*note;
@property (strong, nonatomic) NSNumber <Optional>*curType;//货币类型
@property (strong, nonatomic) NSNumber <Optional>*dateRangeId;
@property (strong, nonatomic) NSNumber <Optional>*supportAdd;// 是否支持补货
@end
