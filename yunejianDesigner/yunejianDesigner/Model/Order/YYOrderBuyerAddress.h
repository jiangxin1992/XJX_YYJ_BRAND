//
//  YYOrderBuyerAddress.h
//  Yunejian
//
//  Created by yyj on 15/8/6.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"

@protocol YYOrderBuyerAddress @end
@interface YYOrderBuyerAddress : JSONModel

@property (strong, nonatomic) NSNumber <Optional>*addressId;//地址ID
@property (strong, nonatomic) NSString <Optional>*detailAddress;//详细地址
@property (strong, nonatomic) NSString <Optional>*receiverName;//收货人
@property (strong, nonatomic) NSString <Optional>*receiverPhone;//收货电话
@property (strong, nonatomic) NSString <Optional>*street;//街道

@property (strong, nonatomic) NSString <Optional>*town;//镇
@property (strong, nonatomic) NSString <Optional>*zipCode;//邮编

@property (strong, nonatomic) NSNumber <Optional>*defaultShippingAddress;
@property (strong, nonatomic) NSNumber <Optional>*defaultShipping;

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
