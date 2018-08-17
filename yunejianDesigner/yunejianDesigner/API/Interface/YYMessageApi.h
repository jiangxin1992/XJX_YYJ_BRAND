//
//  YYMessageApi.h
//  yunejianDesigner
//
//  Created by Apple on 16/10/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import "YYRspStatusAndMessage.h"
#import "YYMessageUserChatListModel.h"
#import "YYMessageTalkListModel.h"
#import "YYSkuMessageListModel.h"

@interface YYMessageApi : NSObject
//获取合作买手店
+ (void)getUserChatListPageIndex:(int)pageIndex pageSize:(int)pageSize andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYMessageUserChatListModel *chatListModel,NSError *error))block;

//删除会话
+(void)deleteMessageUserChat:(NSString *)oppositeEmail andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error))block;

//会话已读
+(void)markAsReadMessageUserChatWithOppositeId:(NSNumber *)oppositeId andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSInteger num, NSError *error))block;

//消息历史记录
+ (void)getMessageTalkHistoryWithOppositeId:(NSNumber *)oppositeId pageIndex:(int)pageIndex pageSize:(int)pageSize andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYMessageTalkListModel *talkListModel,NSError *error))block;

//发送私信
+(void)sendTalkWithOppositeId:(NSNumber *)oppositeId content:(NSString*)content charType:(NSString *)charType andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error))block;

//获取库存消息列表
+ (void)getSkuMessageListAtPageIndex:(NSNumber *)pageIndex complete:(void (^) (YYRspStatusAndMessage *rspStatusAndMessage, YYSkuMessageListModel *skuMessageListModel, NSError *error))completeBlock;

//标记库存消息为已读
+ (void)markSkuAsRead:(void (^) (YYRspStatusAndMessage *rspStatusAndMessage, NSError *error))completeBlock;

@end
