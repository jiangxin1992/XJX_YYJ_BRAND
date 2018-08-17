//
//  YYOrderMessageInfoModel.h
//  Yunejian
//
//  Created by Apple on 15/10/30.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"

#import "YYOrderMessageContentModel.h"

@protocol YYOrderMessageInfoModel @end

@interface YYOrderMessageInfoModel : JSONModel

@property (strong, nonatomic) NSNumber <Optional> *dealStatus;//当是订单消息时: 1: 同意邀请
@property (strong, nonatomic) NSNumber <Optional> *id;//消息id
@property (assign, nonatomic) BOOL isPlainMsg;//true: 普通消息; false: 非普通消息
@property (assign, nonatomic) BOOL isRead;// true: 已读; false 未读
@property (strong, nonatomic) YYOrderMessageContentModel <Optional> *msgContent;//消息详细信息
@property (strong, nonatomic) NSString <Optional> *msgTitle;//消息标题
@property (strong, nonatomic) NSNumber <Optional> *msgType;//0: 合作消息; 1 订单消息
@property (strong, nonatomic) NSNumber <Optional> *receiverId;
@property (strong, nonatomic) NSNumber <Optional> *sendTime;//发送时间
@property (strong, nonatomic) NSNumber <Optional> *senderId;//消息发送人id
@property (strong, nonatomic) NSNumber <Optional> *isAppendOrder;//是否是追单
@property (strong, nonatomic) NSString <Optional> *appendOrderCode;//追单订单号
@property (strong, nonatomic) NSNumber <Optional> *userStatus;
@property (strong, nonatomic) NSNumber <Optional> *orderTransStatus;//订单状态
@property (strong, nonatomic) NSString <Optional> *originOrderCode;//原始订单号

@end
