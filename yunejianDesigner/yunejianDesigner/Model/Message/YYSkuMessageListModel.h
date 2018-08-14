//
//  YYSkuMessageListModel.h
//  yunejianDesigner
//
//  Created by Victor on 2018/3/15.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "YYPageInfoModel.h"
#import "YYSkuMessageModel.h"

@interface YYSkuMessageListModel : JSONModel

@property (nonatomic, strong) YYPageInfoModel <Optional>*pageInfo;
@property (nonatomic, strong) NSArray<YYSkuMessageModel, Optional> *result;

@end
