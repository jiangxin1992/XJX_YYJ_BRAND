//
//  YYOrderApi.h
//  Yunejian
//
//  Created by yyj on 15/8/6.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYRspStatusAndMessage.h"
#import "YYOrderInfoModel.h"
#import "YYOrderSettingInfoModel.h"
#import "YYAddress.h"
#import "YYBuyerAddressModel.h"
#import "YYOrderListModel.h"
#import "YYOrderOperateLogListModel.h"
#import "YYOrderMessageInfoListModel.h"
#import "YYOrderConnStatusModel.h"
#import "YYOrderTransStatusModel.h"
#import <UIKit/UIKit.h>
#import "YYPaymentNoteListModel.h"
#import "YYOrderStyleModifyReslutModel.h"
#import "YYOrderSimpleStyleList.h"
#import "YYOrderAppendParamModel.h"
#import "YYMessageUnreadModel.h"
@interface YYOrderApi : NSObject
/**
 *
 * 确认订单
 *
 */
+ (void)confirmOrderByOrderCode:(NSString *)orderCode andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block;
/**
 *
 * 拒绝订单
 *
 */
+(void)refuseOrderByOrderCode:(NSString *)orderCode reason:(NSString *)reason andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block;

/**
 *
 * 获取订单列表信息
 *
 */
+ (void)getOrderInfoListWithPayType:(int)payType orderStatus:(NSString *)orderStatus queryStr:(NSString *)queryStr pageIndex:(NSInteger )pageIndex pageSize:(NSInteger )pageSize andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYOrderListModel *orderListModel,NSError *error))block;

/**
 *
 * 获取订单列表单条信息
 *
 */
+ (void)getOrderInfoListItemWithOrderCode:(NSString *)orderCode andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYOrderListItemModel *orderListItemModel,NSError *error))block;

/**
 *
 * 获取订单信息
 * isForReBuildOrder ---->获取订单信息是否为了重新创建订单
 */
+ (void)getOrderByOrderCode:(NSString *)orderCode isForReBuildOrder:(BOOL)isForReBuildOrder andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYOrderInfoModel *orderInfoModel,NSError *error))block;

/**
 *
 * 获取订单设置信息
 *
 */
+ (void)getOrderSettingInfoWithBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYOrderSettingInfoModel *orderSettingInfoModel,NSError *error))block;
+ (void)getOrderUnitPrice:(NSUInteger)designerId moneyType:(NSInteger)moneyType andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSUInteger orderUnitPrice,NSError *error))block;

/**
 *
 * 创建或修改订单
 *
 */
+ (void)createOrModifyOrderByJsonData:(NSData *)jsonData actionRefer:(NSString*)actionRefer realBuyerId:(NSInteger)realBuyerId andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSString *orderCode,NSError *error))block;
/**
 *
 * 创建或修改买家地址
 *
 */
+ (void)createOrModifyAddress:(YYAddress *)address orderCode:(NSString*)orderCode andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYBuyerAddressModel *addressModel, NSError *error))block;

/**
 *
 * 上传图片
 *
 */
+ (void)uploadImage:(UIImage *)image size:(CGFloat)size andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSString *imageUrl,NSError *error))block;

/**
 *
 * 上传图片 带进度
 * sign 标记，会原样返回，处理多个上传时使用
 */
+ (void)uploadImage:(UIImage *)image size:(CGFloat)size sign:(NSString *)sign indexpath:(NSIndexPath *)indexpath uploadProgress:(void(^)(float uploadProgress, NSIndexPath *indexpath))uploadProgress andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage, NSString *sign, NSIndexPath *indexpath, NSString *imageUrl, NSError *error))block;


/**
 *
 * opType 取消订单1，恢复订单2，删除订单3
 *
 *
 */
+ (void)updateOrderWithOrderCode:(NSString *)orderCode opType:(int)opType andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block;

/**
 *
 * 单个订单的操作记录(分页)
 *
 */
+ (void)getsingleOrderInfoDynamicsList:(NSString *)orderCode pageIndex:(NSInteger )pageIndex pageSize:(NSInteger )pageSize andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYOrderOperateLogListModel *orderListModel,NSError *error))block;


/**
 *
 *获取通知消息列表
 *
 */
+ (void)getNotifyMsgList:(NSString *)msgType pageIndex:(NSInteger )pageIndex pageSize:(NSInteger )pageSize andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYOrderMessageInfoListModel *msgListModel,NSError *error))block;

/**
 *
 *未读消息条数查询
 *
 */
+ (void)getUnreadNotifyMsgAmount:(NSString *)msgType andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage, YYMessageUnreadModel *messageUnreadModel, NSError *error))block;


/**
 *
 *买手操作订单关联请求
 *
 */
+ (void)setOpWithOrderConn:(NSString *)orderCode opType:(NSInteger)opType andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block;

/**
 *
 *标记同一类型通知消息为已读
 *
 */
+ (void)markAsRead:(NSInteger)msgType andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block;

/**
 *
 *获取某个订单的分享状态信息
 *
 */
+ (void)getOrderConnStatus:(NSString *)orderCode andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYOrderConnStatusModel* statusModel,NSError *error))block;

/**
 *
 *更新订单流转状态
 *
 */
+ (void)updateTransStatus:(NSString *)orderCode  statusCode:(NSInteger)statusCode andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block;

/**
 *
 *当前订单流转状态
 *
 */
+ (void)getOrderTransStatus:(NSString *)orderCode  andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYOrderTransStatusModel* transStatusModel,NSError *error))block;

/**
 *
 *添加付款（收款）记录
 *
 */
+ (void)addPaymentNote:(NSString *)orderCode  percent:(NSInteger)percent amount:(float)amount andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block;

/**
 *
 *订单收款记录
 *
 */
+ (void)getPaymentNoteList:(NSString *)orderCode andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYPaymentNoteListModel *noteList,NSError *error))block;

/**
 *
 *关闭订单请求(买手,设计师)
 *
 */
+ (void)setOrderCloseRequest:(NSString *)orderCode andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block;

/**
 *
 *处理关闭订单请求(买手,设计师)
 *
 */
+ (void)dealOrderCloseRequest:(NSString *)orderCode isAgree:(NSString*)isAgree andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block;

/**
 *
 *撤销关闭订单请求(买手,设计师)
 *
 */
+ (void)revokeOrderCloseRequest:(NSString *)orderCode  andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block;

/**
 *
 *款式是否过期
 *
 */
+ (void)isStyleModify:(NSString *)styleMap  andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYOrderStyleModifyReslutModel *styleModifyReslut,NSError *error))block;


/**
 *
 *查看对方是否订单关闭
 *
 */
+ (void)getOrderCloseStatus:(NSString *)orderCode  andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSInteger isclose,NSError *error))block;

/**
 *
 *关闭订单
 *
 */
+ (void)closeOrder:(NSString *)orderCode  andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block;
/**
 *
 *开启或关闭补货
 *
 */
+ (void)getOrderSimpleStyleList:(NSString *)orderCode  andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYOrderSimpleStyleList *styleList,NSError *error))block;

/**
 *
 *追单初始化创建
 *
 */
+ (void)appendOrder:(YYOrderAppendParamModel *)model  andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSString *orderCode,NSError *error))block;
/**
 *
 *废弃付款记录
 *
 */
+ (void)discardPayment:(NSInteger )payId  andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block;

/**
 *
 *确认付款记录
 *
 */
+ (void)confirmPayment:(NSInteger )payId  andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block;
/**
 *
 *删除付款记录
 *
 */
+ (void)deletePayment:(NSInteger )payId  andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block;

@end
