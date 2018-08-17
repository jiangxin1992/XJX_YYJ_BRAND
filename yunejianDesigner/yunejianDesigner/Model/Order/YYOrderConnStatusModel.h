//
//  YYOrderConnStatusModel.h
//  Yunejian
//
//  Created by Apple on 15/11/9.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"

@interface YYOrderConnStatusModel : JSONModel
@property (strong, nonatomic) NSNumber <Optional>*designerId;
@property (strong, nonatomic) NSNumber <Optional>*modifyTime;
@property (strong, nonatomic) NSNumber <Optional>*createTime;
@property (strong, nonatomic) NSNumber <Optional>*fromUserId;
@property (strong, nonatomic) NSString <Optional> *orderCode;
@property (strong, nonatomic) NSNumber <Optional>*toUserType;
@property (strong, nonatomic) NSNumber <Optional>*fromUserType;
@property (strong, nonatomic) NSNumber <Optional>*buyerId;
@property (strong, nonatomic) NSNumber <Optional>*toUserId;
@property (strong, nonatomic) NSNumber <Optional>*status;//status:0, 未确认，1，已确认，2，已拒绝, 3: 已解除合作
@end
