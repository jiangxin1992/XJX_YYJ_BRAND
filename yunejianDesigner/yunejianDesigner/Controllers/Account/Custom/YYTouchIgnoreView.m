//
//  YYTouchIgnoreView.m
//  Yunejian
//
//  Created by yyj on 15/7/21.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYTouchIgnoreView.h"

@implementation YYTouchIgnoreView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitview = [super hitTest:point withEvent:event];
    if (hitview==self) {
        return nil;
    }else {
        return hitview;
    }
}

@end
