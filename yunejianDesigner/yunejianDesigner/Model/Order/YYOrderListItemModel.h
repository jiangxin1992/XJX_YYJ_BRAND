//
//  YYOrderListItemModel.h
//  Yunejian
//
//  Created by yyj on 15/8/25.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"
#import "YYOrderSupplyTimeModel.h"
#import "YYOrderStatusMarksModel.h"

@protocol YYOrderListItemModel @end

@interface YYOrderListItemModel : JSONModel

@property (strong, nonatomic) NSNumber <Optional>*isDelivery;//是否已发货 bool值

//发货情况
@property (strong, nonatomic) NSMutableArray<YYOrderSupplyTimeModel, Optional,ConvertOnDemand>* supplyTime;

@property (strong, nonatomic) NSNumber <Optional>*finalTotalPrice;//最后成交价
@property (strong, nonatomic) NSNumber <Optional>*itemAmount;//总件数
@property (strong, nonatomic) NSNumber <Optional>*styleAmount;//款式数
@property (strong, nonatomic) NSNumber <Optional>*orderCreateTime;//订单创建时间
@property (strong, nonatomic) NSString <Optional>*orderCode;//订单号
@property (strong, nonatomic) NSString <Optional>*buyerName;//买家名称
@property (strong, nonatomic) NSString <Optional>*brandLogo;//logo
@property (strong, nonatomic) NSString <Optional>*brandName;
@property (strong, nonatomic) NSString <Optional>*buyerLogo;
@property (strong, nonatomic) NSNumber <Optional>*buyerId;
@property (strong, nonatomic) NSNumber <Optional>*payNote;//已付款的百分比

@property (strong, nonatomic) NSNumber <Optional>*designerTransStatus;//已下单 已确认 签合同 生成中  已发货 已收货
@property (strong, nonatomic) NSNumber <Optional>*buyerTransStatus;//已下单 已确认 签合同 生成中  已发货 已收货
@property (strong, nonatomic) NSNumber <Optional>*connectStatus;//| int    | 关联状态: 0 未关联；1 存在关联；2 关联失败 |
@property (strong, nonatomic) NSArray <YYOrderStatusMarksModel,Optional,ConvertOnDemand>*status;//状态，标记合同相关的

//自动关闭时间 订单关闭请求
@property (strong, nonatomic) NSNumber <Optional>*autoCloseHoursRemains;
@property (strong, nonatomic) NSNumber <Optional>*autoReceivedHoursRemains;
@property (strong, nonatomic) NSNumber <Optional>*closeReqStatus;//-1 对方 0 1自己
@property (strong, nonatomic) NSNumber <Optional>*curType;//货币类型
@property(nonatomic,strong) NSNumber <Optional>* isAppend;//是否为追单

-(BOOL )isDesignerConfrim;

-(BOOL )isBuyerConfrim;

@end
