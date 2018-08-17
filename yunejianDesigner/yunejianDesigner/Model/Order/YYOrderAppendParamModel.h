//
//  YYOrderAppendParamModel.h
//  Yunejian
//
//  Created by Apple on 16/8/9.
//  Copyright © 2016年 yyj. All rights reserved.
//

#import "JSONModel.h"

@interface YYOrderAppendParamModel : JSONModel
@property (strong, nonatomic) NSArray <Optional>*styleIds;//        | `object array` | Y        | 订单所包含款式id              |
@property (strong, nonatomic) NSString <Optional>*originOrderCode;// 原始订单号                    |
@property (strong, nonatomic) NSNumber <Optional>*designerId;// 买手建立/修改订单此字段为必填 |
@property (strong, nonatomic) NSNumber <Optional>*orderCreateTime;//订单创建时间戳，当前时间      |
@property (strong, nonatomic) NSString <Optional>*buyerName;// 买手名                        |
@property (strong, nonatomic) NSString <Optional>*businessCard;//				          |
@property (strong, nonatomic) NSNumber <Optional>*realBuyerId;//				          |
@property (strong, nonatomic) NSNumber <Optional>*buyerAddressId;//					          |
@property (strong, nonatomic) NSString <Optional>*finalTotalPrice ;//折后总价 ： 传0	 	          |
@property (strong, nonatomic) NSString <Optional>*totalPrice;// 总价 ： 传0			          |
@property (strong, nonatomic) NSNumber <Optional>*taxRate;//税率: 6 / 17 / null           |
@property (strong, nonatomic) NSString <Optional>*payApp;// 付款方式                	  |
@property (strong, nonatomic) NSString <Optional>*deliveryChoose;//快递方式             	      |
@property (strong, nonatomic) NSNumber <Optional>*billCreatePersonId;// 订单创建人id         	      |
@property (strong, nonatomic) NSString <Optional>*orderDescription;// 订单描述

-(NSDictionary *)toDescription;
@end
