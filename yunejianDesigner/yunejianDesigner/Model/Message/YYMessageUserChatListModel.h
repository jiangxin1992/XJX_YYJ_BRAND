//
//  YYMessageUserChatListModel.h
//  yunejianDesigner
//
//  Created by Apple on 16/10/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "YYPageInfoModel.h"
#import "YYMessageUserChatModel.h"
@interface YYMessageUserChatListModel : JSONModel
@property (strong, nonatomic) NSArray<YYMessageUserChatModel,Optional, ConvertOnDemand>* result;
@property (strong, nonatomic) YYPageInfoModel <Optional>*pageInfo;
@end
