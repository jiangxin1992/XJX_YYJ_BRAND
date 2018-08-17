//
//  YYPackingListDetailModel.h
//  yunejianDesigner
//
//  Created by yyj on 2018/6/13.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "YYExpressInfoModel.h"
#import "YYPackingListStyleModel.h"

@interface YYPackingListDetailModel : JSONModel

@property (strong, nonatomic) NSNumber <Optional>*buyerId;//买手店id
@property (strong, nonatomic) NSString <Optional>*buyerName;//买手店名称
@property (strong, nonatomic) NSNumber <Optional>*connStatus;//关联状态: 1 关联成功 3 未入驻
@property (strong, nonatomic) NSNumber <Optional>*designerId;//设计师id
@property (strong, nonatomic) NSString <Optional>*orderCode;//订单号
@property (strong, nonatomic) NSNumber <Optional>*orderCreateTime;//建单时间
@property (strong, nonatomic) NSNumber <Optional>*orderId;//订单id
@property (strong, nonatomic) NSArray <YYPackingListStyleModel, Optional,ConvertOnDemand>*styleColors;//款式颜色明细.一个颜色是一行
@property (strong, nonatomic) NSNumber <Optional>*buyerStockEnabled;//此单的买手店库存是否已经开通 bool
@property (strong, nonatomic) NSNumber <Optional>*hasException;//是否存在异常 bool 

//下面这些详情中会用到
@property (strong, nonatomic) NSString <Optional>*logisticsCode;//物流编号
@property (strong, nonatomic) NSString <Optional>*logisticsName;//物流公司名称
@property (strong, nonatomic) NSNumber <Optional>*packageId;//装箱单id. 为空时表示新建、不为空时表示修改
@property (strong, nonatomic) NSNumber <Optional>*abnormalAmount;//异常数量
@property (strong, nonatomic) NSString <Optional>*status;//状态(ON_THE_WAY,// 在途中  RECEIVED,// 已收货 TO_DELIVER//等待发货)

@property (strong, nonatomic) NSString <Optional>*receiver;//收件人名称
@property (strong, nonatomic) NSString <Optional>*receiverPhone;//收件人电话
@property (strong, nonatomic) NSString <Optional>*receiverAddress;//收件人地址

@property (strong, nonatomic) YYExpressInfoModel <Optional>*express;

@end
