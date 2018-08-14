//
//  YYPackageListModel.h
//  yunejianDesigner
//
//  Created by yyj on 2018/6/28.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "YYPageInfoModel.h"
#import "YYPackageModel.h"

@interface YYPackageListModel : JSONModel

@property (strong, nonatomic) NSArray<YYPackageModel, Optional,ConvertOnDemand>* result;
@property (strong, nonatomic) YYPageInfoModel <Optional>*pageInfo;

@end
