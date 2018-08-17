//
//  YYOrderOneColorModel.m
//  Yunejian
//
//  Created by yyj on 15/8/6.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYOrderOneColorModel.h"

@implementation YYOrderOneColorModel

- (NSInteger)getTotalAmount {
    NSInteger amount = 0;
    for (int i = 0; i < self.sizes.count; ++i) {
        YYOrderSizeModel *sizeModel = self.sizes[i];
        amount = amount + ([sizeModel.amount integerValue] < 0 ? 0 : [sizeModel.amount integerValue]);
    }
    return amount;
}

@end
