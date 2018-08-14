//
//  YYConnBuyerModel.h
//  Yunejian
//
//  Created by Apple on 15/12/1.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"
@protocol YYConnBuyerModel @end

@interface YYConnBuyerModel : JSONModel
@property (strong, nonatomic) NSNumber <Optional>*buyerId;//":72,
@property (strong, nonatomic) NSString <Optional>*buyerName;//":"超级买手店",
@property (strong, nonatomic) NSString <Optional>*email;//":"zero_hdu@163.com",
@property (strong, nonatomic) NSNumber <Optional>*status;//":3,status:0->未确认1->已确认2->已拒绝
@property (strong, nonatomic) NSNumber <Optional>*type;//":0
@property (strong, nonatomic) NSString <Optional>*logoPath;

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
