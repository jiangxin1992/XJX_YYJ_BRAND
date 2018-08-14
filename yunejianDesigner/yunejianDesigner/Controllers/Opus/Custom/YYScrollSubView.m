//
//  YYScrollSubView.m
//  Yunejian
//
//  Created by yyj on 15/7/29.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYScrollSubView.h"

@interface YYScrollSubView ()

@property(nonatomic,strong) UIViewController *retainViewController;

@end

@implementation YYScrollSubView

- (void)addYYScrollSubViewByViewController:(UIViewController *)retainViewController{
    self.retainViewController = retainViewController;
    [self addSubview:retainViewController.view];
}


- (void)clearSubview{
    if (_retainViewController) {
        [self.retainViewController.view removeFromSuperview];
        self.retainViewController = nil;
    }
}

@end
