//
//  YYPackingListSizeModel.h
//  yunejianDesigner
//
//  Created by yyj on 2018/6/13.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol YYPackingListSizeModel @end

@interface YYPackingListSizeModel : JSONModel

@property (strong, nonatomic) NSNumber <Optional>*sizeId;//尺码id
@property (strong, nonatomic) NSString <Optional>*sizeName;//尺码名称
@property (strong, nonatomic) NSNumber <Optional>*orderItemId;//对应的订单id
@property (strong, nonatomic) NSNumber <Optional>*orderAmount;//订单数量
@property (strong, nonatomic) NSNumber <Optional>*remainingAmount;//待发数量
@property (strong, nonatomic) NSNumber <Optional>*sentAmount;//本次发货数量
@property (strong, nonatomic) NSNumber <Optional>*abnormalAmount;//异常数
@property (strong, nonatomic) NSNumber <Optional>*receivedAmount;//确认收货

@end
