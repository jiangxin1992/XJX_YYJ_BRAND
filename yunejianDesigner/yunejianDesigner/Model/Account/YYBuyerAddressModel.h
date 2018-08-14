//
//  YYBuyerAddressModel.h
//  Yunejian
//
//  Created by yyj on 15/8/24.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"
@protocol YYBuyerAddressModel @end
@interface YYBuyerAddressModel : JSONModel

@property (strong, nonatomic) NSString <Optional>*detailAddress;
@property (strong, nonatomic) NSString <Optional>*receiverName;
@property (strong, nonatomic) NSString <Optional>*receiverPhone;
@property (strong, nonatomic) NSString <Optional>*zipCode;
@property (strong, nonatomic) NSString <Optional>*street;

@property (strong, nonatomic) NSString <Optional>*addressId;

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
