//
//  YYBrandInfoModel.h
//  Yunejian
//
//  Created by yyj on 15/7/15.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"

@interface YYBrandInfoModel : JSONModel

@property (strong, nonatomic) NSString <Optional>*brandName;
@property (strong, nonatomic) NSString <Optional>*logoPath;


@property (strong, nonatomic) NSNumber <Optional>*annualSales;
@property (strong, nonatomic) NSString <Optional>*webUrl;
@property (strong, nonatomic) NSNumber <Optional>*brandId;
@property (strong, nonatomic) NSArray <Optional>*retailerName;
@property (strong, nonatomic) NSNumber <Optional>*underlinePartnerCount;

@end
