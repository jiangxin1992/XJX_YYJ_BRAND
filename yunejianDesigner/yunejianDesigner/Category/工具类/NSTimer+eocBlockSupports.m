//
//  NSTimer+eocBlockSupports.m
//  YunejianBuyer
//
//  Created by Apple on 16/10/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "NSTimer+eocBlockSupports.h"

@implementation NSTimer (eocBlockSupports)
+(NSTimer *)eocScheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval block:(void(^)()) block repeats:(BOOL)repeat{
    return  [self scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(startTimer:) userInfo:[block copy] repeats:repeat];
}
//定时器所执行的方法
+(void)startTimer:(NSTimer *)timer{
    void(^block)() = timer.userInfo;
    if (block) {
        block();
    }
    
}
@end
