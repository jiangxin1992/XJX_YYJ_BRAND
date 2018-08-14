//
//  YYBuyerDetailModel.h
//  Yunejian
//
//  Created by Apple on 15/12/11.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"

@interface YYBuyerDetailModel : JSONModel
@property (strong, nonatomic) NSNumber <Optional>* buyerId;
@property (strong, nonatomic) NSString <Optional>* logoPath;
@property (strong, nonatomic) NSNumber <Optional>* priceMax;
@property (strong, nonatomic) NSNumber <Optional>* priceMin;
@property (strong, nonatomic) NSString <Optional>* wechatNumber;//": "",
@property (strong, nonatomic) NSString <Optional>* webUrl;//": "",
@property (strong, nonatomic) NSString <Optional>* name;//": "草鱼",
@property (strong, nonatomic) NSArray<Optional, ConvertOnDemand>* storeFiles;
@property (strong, nonatomic) NSString <Optional>* introduction;//":
@property (strong, nonatomic) NSNumber <Optional>* connectStatus;
@property (strong, nonatomic) NSArray<Optional, ConvertOnDemand>* businessBrands;
@property (strong, nonatomic) NSString <Optional>*contactEmail;

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
