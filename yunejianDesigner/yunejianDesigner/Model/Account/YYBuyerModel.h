//
//  YYBuyerModel.h
//  Yunejian
//
//  Created by Apple on 15/10/28.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"
@protocol YYBuyerModel @end

@interface YYBuyerModel : JSONModel
@property (strong, nonatomic) NSArray<Optional, ConvertOnDemand>*businessBrands;
@property (strong, nonatomic) NSString <Optional>* buyerFiles;
@property (strong, nonatomic) NSNumber <Optional>* buyerId;
@property (strong, nonatomic) NSString <Optional>* contactEmail;
@property (strong, nonatomic) NSString <Optional>* contactName;
@property (strong, nonatomic) NSString <Optional>* contactPhone;
@property (strong, nonatomic) NSNumber <Optional>* createId;
@property (strong, nonatomic) NSNumber <Optional>* createTime;
@property (strong, nonatomic) NSNumber <Optional>* defaulBillingAddress;
@property (strong, nonatomic) NSNumber <Optional>* defaultShippingAddress;
@property (strong, nonatomic) NSString <Optional>* foundYear;
@property (strong, nonatomic) NSNumber <Optional>* id;
@property (strong, nonatomic) NSString <Optional>* logoPath;
@property (strong, nonatomic) NSNumber <Optional>* modifyId;
@property (strong, nonatomic) NSNumber <Optional>* modifyTime;
@property (strong, nonatomic) NSString <Optional>* name;
@property (strong, nonatomic) NSString <Optional>* note;
@property (strong, nonatomic) NSNumber <Optional>* priceMax;
@property (strong, nonatomic) NSNumber <Optional>* priceMin;
@property (strong, nonatomic) NSNumber <Optional>* status;

@property (strong, nonatomic) NSString <Optional>*nation;
@property (strong, nonatomic) NSString <Optional>*province;//省
@property (strong, nonatomic) NSString <Optional>*city;//城市

@property (strong, nonatomic) NSString <Optional>*nationEn;
@property (strong, nonatomic) NSString <Optional>*provinceEn;
@property (strong, nonatomic) NSString <Optional>*cityEn;

@property (strong, nonatomic) NSNumber <Optional>*nationId;
@property (strong, nonatomic) NSNumber <Optional>*provinceId;
@property (strong, nonatomic) NSNumber <Optional>*cityId;


@property (strong, nonatomic) NSArray< Optional,ConvertOnDemand>*storeImgs;
@property (strong, nonatomic) NSString <Optional>* introduction;
@property (strong, nonatomic) NSNumber <Optional>* connectStatus;

@end
