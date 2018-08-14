//
//  YYSeriesInfoModel.h
//  Yunejian
//
//  Created by Apple on 15/12/3.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"
#import "YYDateRangeModel.h"

@interface YYSeriesInfoModel : JSONModel
@property (strong, nonatomic) NSNumber <Optional>*designerId;
@property (strong, nonatomic) NSString <Optional>*designerBrandLogo;

@property (strong, nonatomic) NSNumber <Optional>*year;
@property (strong, nonatomic) NSString <Optional>*albumImg;
@property (strong, nonatomic) NSNumber <Optional>*styleAmount;
//@property (strong, nonatomic) NSString <Optional>*description;
@property (strong, nonatomic) NSString <Optional>*orderDueTime;
@property (strong, nonatomic) NSNumber <Optional>*supplyStatus;
@property (nonatomic, strong) NSNumber <Optional>*orderPriceMin;
@property (nonatomic, strong) NSNumber <Optional>*orderPriceCurType;

@property (strong, nonatomic) NSNumber <Optional>*supplyEndTime;
@property (strong, nonatomic) NSNumber <Optional>*supplyStartTime;
@property (strong, nonatomic) NSString <Optional>*modifyTime;

@property (strong, nonatomic) NSString <Optional>*name;
@property (strong, nonatomic) NSString <Optional>*season;
@property (strong, nonatomic) NSNumber <Optional>*id;
@property (strong, nonatomic) NSNumber <Optional>*authType;
@property (strong, nonatomic) NSNumber <Optional>*orderAmountMin;
@property (strong, nonatomic) NSArray< Optional,YYDateRangeModel>*dateRanges;//时间波段
@property (nonatomic,strong)NSNumber <Optional>*lookBookId;

@property (nonatomic,assign) NSNumber <Optional>*collect;

//相对 opusseriesmodel
@property (strong, nonatomic) NSNumber <Optional>*createId;//":19,
@property (strong, nonatomic) NSNumber <Optional>*createTime;//":1441272262000,
@property (strong, nonatomic) NSString <Optional>*designerBrandName;//":"",
@property (strong, nonatomic) NSNumber <Optional>*modifyId;//":19,
@property (strong, nonatomic) NSString <Optional>*note;//":"",
@property (strong, nonatomic) NSNumber <Optional>*status;//":0,
@property (strong, nonatomic) NSString <Optional>*introduction;
@end
