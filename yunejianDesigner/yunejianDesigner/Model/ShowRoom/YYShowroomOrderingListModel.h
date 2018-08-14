//
//  YYShowroomOrderingListModel.h
//  yunejianDesigner
//
//  Created by yyj on 2018/3/8.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "YYPageInfoModel.h"
#import "YYShowroomOrderingModel.h"

@interface YYShowroomOrderingListModel : JSONModel

@property (strong, nonatomic) NSArray<YYShowroomOrderingModel,Optional, ConvertOnDemand>* result;
@property (strong, nonatomic) YYPageInfoModel <Optional>*pageInfo;

@end
