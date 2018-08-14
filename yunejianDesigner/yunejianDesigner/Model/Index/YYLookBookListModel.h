//
//  YYLookBookListModel.h
//  Yunejian
//
//  Created by Apple on 15/9/15.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"
#import "YYPageInfoModel.h"
#import "YYLookBookModel.h"
@interface YYLookBookListModel : JSONModel
@property (strong, nonatomic) NSArray<YYLookBookModel, Optional,ConvertOnDemand>* result;
@property (strong, nonatomic) YYPageInfoModel <Optional>*pageInfo;

@end
