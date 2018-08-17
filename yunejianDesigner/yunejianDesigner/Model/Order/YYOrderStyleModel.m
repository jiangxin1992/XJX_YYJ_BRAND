//
//  YYOrderStyleModel.m
//  Yunejian
//
//  Created by yyj on 15/8/6.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYOrderStyleModel.h"

@implementation YYOrderStyleModel

- (CGFloat)getMinOriginalPrice {
    NSArray *array = nil;
    if ([self.colors isKindOfClass:[NSArray class]]) {
        array = self.colors;
    } else {
        array = [self.colors forwardingTargetForSelector:nil];
    }
    return [[array valueForKeyPath:@"@min.originalPrice"] floatValue];
}

- (CGFloat)getMaxOriginalPrice {
    NSArray *array = nil;
    if ([self.colors isKindOfClass:[NSArray class]]) {
        array = self.colors;
    } else {
        array = [self.colors forwardingTargetForSelector:nil];
    }
    return [[array valueForKeyPath:@"@max.originalPrice"] floatValue];
}

- (CGFloat)getTotalOriginalPrice {
    float costMeoney = 0;
    for (YYOrderOneColorModel *orderOneColorModel in self.colors) {
        NSInteger amount = [orderOneColorModel getTotalOriginalPrice];
        costMeoney += [orderOneColorModel.originalPrice floatValue] * amount;
    }
    return costMeoney;
}

@end
