//
//  YYNewsListModel.h
//  YunejianBuyer
//
//  Created by Apple on 16/9/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "JSONModel.h"
#import "YYNewsInfoModel.h"
#import "YYPageInfoModel.h"

@interface YYNewsListModel : JSONModel
@property (strong, nonatomic) NSArray<YYNewsInfoModel,Optional, ConvertOnDemand>* result;
@property (strong, nonatomic) YYPageInfoModel <Optional>*pageInfo;
@end
