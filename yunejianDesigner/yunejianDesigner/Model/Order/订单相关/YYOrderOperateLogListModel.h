//
//  YYOrderOperateLogListModel.h
//  Yunejian
//
//  Created by Apple on 15/10/30.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"
#import "YYPageInfoModel.h"
#import "YYOrderOperateLogModel.h"
@interface YYOrderOperateLogListModel : JSONModel
@property (strong, nonatomic) NSArray<YYOrderOperateLogModel,Optional, ConvertOnDemand>* result;
@property (strong, nonatomic) YYPageInfoModel <Optional>*pageInfo;

@end
