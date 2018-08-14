//
//  YYOrderOperateLogModel.h
//  Yunejian
//
//  Created by Apple on 15/10/30.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"
@protocol YYOrderOperateLogModel @end
@interface YYOrderOperateLogModel : JSONModel
@property (strong, nonatomic) NSNumber <Optional> *createTime;
@property (strong, nonatomic) NSNumber <Optional> *operateType;
@property (strong, nonatomic) NSNumber <Optional> *status;
@property (strong, nonatomic) NSNumber <Optional> *createType;
@property (strong, nonatomic) NSString <Optional> *orderCode;
@property (strong, nonatomic) NSString <Optional> *createName;
@end
