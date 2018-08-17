//
//  YYShowBuyerCardView.m
//  Yunejian
//
//  Created by yyj on 15/9/2.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYShowBuyerCardView.h"

@implementation YYShowBuyerCardView

- (id)init{
    if (self = [super init]) {
        popWindowAddBgView(self);
        UIGestureRecognizer *aGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabPiece:)];
        [self addGestureRecognizer:aGesture];
    }
    return self;
}

- (void)tabPiece:(UIPanGestureRecognizer *)gestureRecognizer
{
    [self removeFromSuperview];
}

@end
