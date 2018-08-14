//
//  YYOrderMessageContentModel.h
//  Yunejian
//
//  Created by Apple on 15/10/30.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"

@interface YYOrderMessageContentModel : JSONModel

@property (strong, nonatomic) NSString <Optional> *styleNum;
@property (strong, nonatomic) NSString <Optional> *totalAmount;
@property (strong, nonatomic) NSString <Optional> *buyerName;
@property (strong, nonatomic) NSString <Optional> *totalPrice;
@property (strong, nonatomic) NSString <Optional> *logo;
@property (strong, nonatomic) NSString <Optional> *orderCode;
@property (strong, nonatomic) NSString <Optional> *email;
@property (strong, nonatomic) NSNumber <Optional> *orderCreateTime;
@property (strong, nonatomic) NSString <Optional> *city;
@property (strong, nonatomic) NSString <Optional> *reason;//拒绝理由
@property (strong, nonatomic) NSString <Optional> *op;//| op   | string | need_confirm: 确认订单的消息; order_rejected 拒绝订单的消息 |

@property (strong, nonatomic) NSString <Optional> *buyerProvince;
@property (strong, nonatomic) NSString <Optional> *buyerEmail;
@property (strong, nonatomic) NSString <Optional> *designerBrandLogo;
@property (strong, nonatomic) NSString <Optional> *designerBrandName;
@property (strong, nonatomic) NSNumber <Optional> *fromId;

@property (strong, nonatomic) NSString <Optional> *buyerLogo;
@property (strong, nonatomic) NSString <Optional> *buyerCity;
@property (strong, nonatomic) NSString <Optional> *designerEmail;
@property (strong, nonatomic) NSString <Optional> *brandName;
@property (strong, nonatomic) NSNumber <Optional> *curType;//货币类型

@property (strong, nonatomic) NSNumber <Optional> *buyerId;
@property (strong, nonatomic) NSString <Optional> *logisticsName;
@property (strong, nonatomic) NSNumber <Optional> *packageId;
@property (strong, nonatomic) NSString <Optional> *LogisticsCode;

@end
