//
//  ChatModel.h
//  AutoLayoutCellDemo
//
//  Created by siping ruan on 16/10/9.
//  Copyright © 2016年 Rasping. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  聊天消息类型
 */
typedef NS_ENUM(NSInteger, ChatType) {
    /**
     *  别人发的
     */
    ChatTypeOther,
    /**
     *  自己发的
     */
    ChatTypeSelf
};

@interface YYMessageChatModel : NSObject

@property (copy, nonatomic) NSString *icon;
@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSString *message;
@property (assign, nonatomic) ChatType type;
/** 消息类型 */
@property (nonatomic, copy) NSString *chatType;
/** 图片 */
@property (nonatomic, strong) UIImage *locationImage;
/** sign标记 */
@property (nonatomic, strong) NSString *sign;
/** 是否上传成功 */
@property (nonatomic, assign) BOOL isUploadSuccess;

+ (instancetype)modelWithIcon:(NSString *)icon
                         time:(NSString *)time
                      message:(NSString *)message
                         type:(ChatType)type
                     charType:(NSString *)chatType;

@end
