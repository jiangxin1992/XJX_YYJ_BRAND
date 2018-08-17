//
//  YYOrderOneInfoModel.m
//  Yunejian
//
//  Created by yyj on 15/8/6.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYOrderOneInfoModel.h"

@implementation YYOrderOneInfoModel

- (BOOL)isInStock {
    return self.dateRange.start ? NO : YES;
}

@end
