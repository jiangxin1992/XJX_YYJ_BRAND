//
//  YYParcelExceptionDetailModel.h
//  yunejianDesigner
//
//  Created by yyj on 2018/7/9.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "YYParcelExceptionModel.h"

@interface YYParcelExceptionDetailModel : JSONModel

@property (strong, nonatomic) NSString <Optional>*logisticsName;//物流公司名称
@property (strong, nonatomic) NSString <Optional>*logisticsCode;//物流号
@property (strong, nonatomic) NSString <Optional>*orderCode;//订单号
@property (strong, nonatomic) NSNumber <Optional>*buyerId;//买手id
@property (strong, nonatomic) NSArray <YYParcelExceptionModel, Optional,ConvertOnDemand>*skus;//异常详情

@end
