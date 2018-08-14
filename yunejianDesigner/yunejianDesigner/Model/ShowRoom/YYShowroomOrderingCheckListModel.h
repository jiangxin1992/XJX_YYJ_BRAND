//
//  YYShowroomOrderingCheckListModel.h
//  yunejianDesigner
//
//  Created by yyj on 2018/3/12.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "YYPageInfoModel.h"
#import "YYShowroomOrderingCheckModel.h"

@interface YYShowroomOrderingCheckListModel : JSONModel

@property (strong, nonatomic) NSArray<YYShowroomOrderingCheckModel,Optional, ConvertOnDemand>* result;
@property (strong, nonatomic) YYPageInfoModel <Optional>*pageInfo;

@end
