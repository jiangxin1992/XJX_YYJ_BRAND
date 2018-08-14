//
//  YYPageInfoModel.h
//  Yunejian
//
//  Created by yyj on 15/7/23.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"

@interface YYPageInfoModel : JSONModel

@property (strong, nonatomic) NSNumber <Optional>*recordTotalAmount;
@property (strong, nonatomic) NSNumber <Optional>*pagesAmount;
@property (strong, nonatomic) NSNumber <Optional>*recordAmount;
@property (strong, nonatomic) NSNumber <Optional>*pageIndex;
@property (assign, nonatomic) BOOL isLastPage;
@property (strong, nonatomic) NSNumber <Optional>*pageSize;
@property (assign, nonatomic) BOOL isFirstPage;

@end
