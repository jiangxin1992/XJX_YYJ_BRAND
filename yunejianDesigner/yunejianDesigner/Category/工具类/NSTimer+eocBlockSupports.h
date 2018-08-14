//
//  NSTimer+eocBlockSupports.h
//  YunejianBuyer
//
//  Created by Apple on 16/10/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (eocBlockSupports)//类方法返回一个NSTimer的实例对象
+(NSTimer *)eocScheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval block:(void(^)()) block repeats:(BOOL)repeat;
@end
