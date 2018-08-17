//
//  YYOrderInfoModel.h
//  Yunejian
//
//  Created by yyj on 15/8/6.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"

#import "YYOrderBuyerAddress.h"
#import "YYOrderOneInfoModel.h"
#import "YYOrderSeriesModel.h"
#import "YYOrderPackageStatModel.h"

@class YYStylesAndTotalPriceModel;

@interface YYOrderInfoModel : JSONModel

@property (strong, nonatomic) NSString <Optional>*orderCode;//订单号
@property (strong, nonatomic) NSNumber <Optional>*totalPrice;//原始总价
@property (strong, nonatomic) NSNumber <Optional>*finalTotalPrice;//最后价格
@property (strong, nonatomic) NSNumber <Optional>*prevTotalPrice;//原单的总价
@property (strong, nonatomic) NSNumber <Optional>*prevFinalTotalPrice;//原单的折后总价
@property (strong, nonatomic) NSNumber <Optional>*curType;//货币类型
@property (strong, nonatomic) NSNumber <Optional>*taxRate;//税率: 6 / 16 / null
@property (strong, nonatomic) NSNumber <Optional>*discount;//折扣: 0到100之间的整数
@property (nonatomic, strong) NSNumber <Optional>*stockEnabled;//是否使用库存管理
//购买的系列列表
@property (strong, nonatomic) NSMutableArray<YYOrderOneInfoModel, Optional,ConvertOnDemand> *groups;
@property (strong, nonatomic) NSMutableDictionary<YYOrderSeriesModel, Optional,ConvertOnDemand> *seriesMap;
@property (strong, nonatomic) NSNumber <Optional>*designerOrderStatus;//已下单 已确认 签合同 生成中  已发货 已收货
@property (strong, nonatomic) NSNumber <Optional>*buyerOrderStatus;//已下单 已确认 签合同 生成中  已发货 已收货
@property (strong, nonatomic) NSNumber <Optional>*autoReceivedHoursRemains;
@property (strong, nonatomic) NSNumber <Optional>*closeReqStatus;//-1 对方0 1自己
@property (assign, nonatomic) BOOL addressModifAvailable;//可否修改地址
@property (strong, nonatomic) NSString <Optional>*buyerName;//购买者名称
@property (strong, nonatomic) NSString <Optional>*buyerEmail;//购买者邮箱
@property (strong, nonatomic) NSString <Optional>*buyerLogo;
@property (strong, nonatomic) NSString <Optional>*deliveryChoose;//送货方式
@property (strong, nonatomic) NSNumber <Optional>*buyerAddressId;//购买者的地址ID
@property (strong, nonatomic) YYOrderBuyerAddress <Optional>*buyerAddress;//购买人的地址信息
@property (strong, nonatomic) NSString <Optional>*occasion;//下单场合
@property (strong, nonatomic) NSString <Optional>*orderDescription;//订单描述
@property (strong, nonatomic) NSString <Optional>*payApp;//付款方式
@property (strong, nonatomic) NSNumber <Optional>*orderCreateTime;//订单创建时间
@property (strong, nonatomic) NSString <Optional>*brandLogo;//logo
@property (strong, nonatomic) NSString <Optional>*brandName;//logo
@property (strong, nonatomic) NSString <Optional>*businessCard;//客户名片图片地址
@property (strong, nonatomic) NSNumber <Optional>*packageId;//未发货的包裹单id. 只对发货中的订单有效
@property (strong, nonatomic) NSNumber <Optional>*buyerStockEnabled;//此单的买手店库存是否已经开通 bool
@property (strong, nonatomic) NSNumber <Optional>*isForcedDelivery;//true表示是提前发货的订单；否则不是 bool

@property(nonatomic,strong) NSNumber <Optional>* orderConnStatus;//互联状态
//追单
@property(nonatomic,strong) NSNumber <Optional>* isAppend;//是否为追单
@property(nonatomic,strong) NSNumber <Optional>* hasAppend;//是否含有追单
@property(nonatomic,strong) NSString <Optional>* originalOrderCode;//原单订单号
@property(nonatomic,strong) NSString <Optional>* appendOrderCode;//追单订单号
//可能要移除的
@property (strong, nonatomic) NSNumber <Optional>*billCreatePersonId;//创建订单者的ID
@property (strong, nonatomic) NSString <Optional>*billCreatePersonName;//创建订单者的name
@property (strong, nonatomic) NSNumber <Optional>*billCreatePersonType;//创建订单者的type
@property (strong, nonatomic) NSNumber <Optional>*realBuyerId;//购买者名称
@property (strong, nonatomic) NSNumber <Optional>*designerId;//设计师的ID

@property (strong, nonatomic) NSString <Optional>*type;//订单类型

@property (strong, nonatomic) YYOrderPackageStatModel <Optional>*packageStat;

-(BOOL )isDesignerConfrim;

-(BOOL )isBuyerConfrim;

//中间临时使用的变量，只是本地用用
@property (strong, nonatomic) NSString <Optional>*shareCode;//临时订单号，离线创建订单时使用

+(NSInteger)getOrderSizeTotalAmountWidthDictionary:(NSDictionary*)dict;

+(NSInteger)getOrderStyleTotalNumWidthDictionary:(NSDictionary*)dict;

//计算一个订单的总款数，总件数和总价
-(YYStylesAndTotalPriceModel *)getTotalValueByOrderInfo:(BOOL )isEdit;

//计算一个提前完成发货订单的总款数，总件数和总价
-(YYStylesAndTotalPriceModel *)getNowTotalValueByOrderInfo;

//获得提前发货完成的款式
-(NSArray *)getUndeliveredStylesInDelivering;

//获得提前发货完成的款式(发货后的状态)
-(NSArray *)getUndeliveredStylesAfterDelivering;

//pre数据写入非pre
-(void)toPreData;

@end



