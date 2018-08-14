//
//  YYConnBrandInfoListModel.h
//  Yunejian
//
//  Created by Apple on 15/12/2.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"
#import "YYConnBrandInfoModel.h"
#import "YYPageInfoModel.h"
@interface YYConnBrandInfoListModel : JSONModel
@property (strong, nonatomic) NSArray<YYConnBrandInfoModel,Optional, ConvertOnDemand>* result;
@property (strong, nonatomic) YYPageInfoModel <Optional>*pageInfo;

@end
