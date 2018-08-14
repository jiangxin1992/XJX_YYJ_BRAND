//
//  YYMessageUserChatModel.h
//  yunejianDesigner
//
//  Created by Apple on 16/10/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol YYMessageUserChatModel @end
@interface YYMessageUserChatModel : JSONModel
@property (strong, nonatomic) NSString <Optional>*content;//":"测试内容",
@property (strong, nonatomic) NSString <Optional>*chatType;//":"测试内容",
@property (strong, nonatomic) NSNumber <Optional>*createTime;//":1476862849000,
@property (strong, nonatomic) NSNumber <Optional>*oppositeId;//":114,
@property (strong, nonatomic) NSString <Optional>*oppositeName;//":"Jordan",
@property (strong, nonatomic) NSString <Optional>*oppositeURL;//":"http://cdn.ycosystem.com/ufile/20160712/83d3ecb0abdf474abc41eba49c81a13c",
@property (strong, nonatomic) NSNumber <Optional>*unreadCount;//":7
@property (strong, nonatomic) NSString <Optional>*oppositeEmail;
@end
