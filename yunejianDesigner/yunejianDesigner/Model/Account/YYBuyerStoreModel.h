//
//  YYBuyerStoreModel.h
//  Yunejian
//
//  Created by yyj on 15/7/15.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"

@interface YYBuyerStoreModel : JSONModel

@property (strong, nonatomic) NSString <Optional>*contactEmail;
@property (strong, nonatomic) NSString <Optional>*contactName;
@property (strong, nonatomic) NSString <Optional>*name;
@property (strong, nonatomic) NSString <Optional>*contactPhone;
@property (strong, nonatomic) NSString <Optional>*foundYear;
@property (strong, nonatomic) NSString <Optional>*logoPath;

@property (strong, nonatomic) NSArray<Optional, ConvertOnDemand>*businessBrands;
@property (strong, nonatomic) NSNumber <Optional>*priceMin;
@property (strong, nonatomic) NSNumber <Optional>*priceMax;

@property (strong, nonatomic) NSString <Optional>*nation;
@property (strong, nonatomic) NSString <Optional>*province;//省
@property (strong, nonatomic) NSString <Optional>*city;//城市

@property (strong, nonatomic) NSString <Optional>*nationEn;
@property (strong, nonatomic) NSString <Optional>*provinceEn;
@property (strong, nonatomic) NSString <Optional>*cityEn;

@property (strong, nonatomic) NSNumber <Optional>*nationId;
@property (strong, nonatomic) NSNumber <Optional>*provinceId;
@property (strong, nonatomic) NSNumber <Optional>*cityId;

@end
