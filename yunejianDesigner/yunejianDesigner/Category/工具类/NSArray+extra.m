//
//  NSArray+extra.m
//  YunejianBuyer
//
//  Created by yyj on 2017/11/8.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "NSArray+extra.h"

@implementation NSArray (extra)

- (BOOL )isNilOrEmpty{
    if (self)
    {
        if(self.count){
            return NO;
        }
    }
    return YES;
}

@end
