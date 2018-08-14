//
//  YYMessageTalkModel.h
//  yunejianDesigner
//
//  Created by Apple on 16/10/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol YYMessageTalkModel @end
@interface YYMessageTalkModel : JSONModel
@property (strong, nonatomic) NSString <Optional>*content;//":"回复",
@property (strong, nonatomic) NSNumber <Optional>*createTime;//":1476864564000,
@property (strong, nonatomic) NSNumber <Optional>*id;//":25,
@property (strong, nonatomic) NSNumber <Optional>*isRead;//":1,
@property (strong, nonatomic) NSNumber <Optional>*isOwner;//":1,
@property (strong, nonatomic) NSString <Optional>*chatType;//消息类型: 取值: PLAIN_TEXT 简单消息; RICH_TEXT 富文本消息; IMAGE 图片消息
@property (strong, nonatomic) NSDictionary <Optional>*user;/*":{
                                                            "id":114,
                                                            "name":"Jordan",
                                                            "type":0,
                                                            "url":"http://cdn.ycosystem.com/ufile/20160712/83d3ecb0abdf474abc41eba49c81a13c"
                                                            },*/
/*@property (strong, nonatomic) NSDictionary <Optional>*sender;":{
 "id":130,
 "name":"刘天琪-买手",
 "type":1,
 "url":"http://cdn.ycosystem.com/ufile/20160907/66bbb0fdaf854051b37a1bf6a5839929"
 }*/

@end
