//
//  YYInventoryApi.h
//  yunejianDesigner
//
//  Created by Apple on 16/8/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYRspStatusAndMessage.h"
#import "YYInventoryBuyersModel.h"
#import "YYInventoryAllottingListModel.h"
#import "YYInventoryAllottingInfoModel.h"
#import "YYInventoryOrderListModel.h"
@interface YYInventoryApi : NSObject
//库存调拨列表
+(void)getAllottingList:(NSString *)buyerIds month:(NSInteger)month status:(NSInteger)status pageIndex:(int)pageIndex pageSize:(int)pageSize queryStr:(NSString *)queryStr andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage, YYInventoryAllottingListModel *listModel, NSError *error))block;
//获取调拨详情
+(void)getAllottingInfo:(NSInteger)styleId colorId:(NSInteger)colorId andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage, YYInventoryAllottingInfoModel *infoModel, NSError *error))block;
//单个买手店订单列表
+(void)getBuyerOrders:(NSString *)orderCodes andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage, YYInventoryOrderListModel *listModel, NSError *error))block;
//标识补货需求已解决
+(void)setDemandResolve:(NSInteger)demandId andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error))block;
//标识库存已解决
+(void)setAllottingResolve:(NSInteger)allottingId andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error))block;
//标记消息为已读
+(void)markAsReadOnMsg:(NSString *)msgIds adnBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block;

@end
