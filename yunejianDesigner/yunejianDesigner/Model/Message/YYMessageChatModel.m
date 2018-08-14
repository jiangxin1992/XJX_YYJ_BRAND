//
//  ChatModel.m
//  AutoLayoutCellDemo
//
//  Created by siping ruan on 16/10/9.
//  Copyright © 2016年 Rasping. All rights reserved.
//

#import "YYMessageChatModel.h"

@implementation YYMessageChatModel

+ (instancetype)modelWithIcon:(NSString *)icon time:(NSString *)time message:(NSString *)message type:(ChatType)type charType:(NSString *)chatType
{
    YYMessageChatModel *model = [[YYMessageChatModel alloc] init];
    model.icon       = icon;
    model.time       = time;
    model.message    = message;
    model.type       = type;
    model.chatType   = chatType;
    return model;
}

@end
