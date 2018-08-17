//
//  YYDiscountView.m
//  Yunejian
//
//  Created by yyj on 15/8/7.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYDiscountView.h"

@implementation YYDiscountView

- (void)updateUIWithOriginPrice:(NSString *)originPrice fianlPrice:(NSString *)finalPrice originFont:(UIFont *)originFont finalFont:(UIFont *)finalFont{
    
    NSArray *array = self.subviews;
    if (array
        && [array count] > 0) {
        for (UIView *view in array) {
            [view removeFromSuperview];
        }
    }

    
    if (_showDiscountValue) {
        
        UILabel *beforeLabel = [[UILabel alloc] init];
        beforeLabel.adjustsFontSizeToFitWidth = YES;
        beforeLabel.backgroundColor = [UIColor clearColor];
        beforeLabel.textColor = [UIColor blackColor];
        if (_bgColorIsBlack) {
            beforeLabel.textColor = [UIColor lightGrayColor];
        }
        beforeLabel.text = originPrice;
        beforeLabel.textAlignment = NSTextAlignmentCenter;
        beforeLabel.font = originFont;
        
        [self addSubview:beforeLabel];
        __weak UIView *weakContainer = self;
        
        [beforeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakContainer.mas_top);
            make.left.mas_equalTo(weakContainer.mas_left);
            make.right.mas_equalTo(weakContainer.mas_right);
            make.height.mas_equalTo(15);
            
        }];
        
        UILabel *lineLabel = [[UILabel alloc] init];
        lineLabel.backgroundColor = [UIColor blackColor];
        if (_bgColorIsBlack) {
            lineLabel.backgroundColor = [UIColor whiteColor];
        }
        
        [beforeLabel addSubview:lineLabel];
        __weak UIView *weakView = beforeLabel;
        
        [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakView.mas_left).with.offset(-1);
            make.right.mas_equalTo(weakView.mas_right).with.offset(1);
            make.height.mas_equalTo(1);
            make.center.mas_equalTo(weakView.center);
            
        }];


        UILabel *afterLabel = [[UILabel alloc] init];
        afterLabel.backgroundColor = [UIColor clearColor];
        afterLabel.textColor = [UIColor redColor];
        afterLabel.adjustsFontSizeToFitWidth = YES;
        if (_bgColorIsBlack) {
            afterLabel.textColor = [UIColor whiteColor];
        }
        
        afterLabel.textAlignment = NSTextAlignmentCenter;
        afterLabel.text = finalPrice;
        afterLabel.font = finalFont;
        
        [self addSubview:afterLabel];
        
        [afterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakView.mas_bottom);
            make.left.mas_equalTo(weakContainer.mas_left);
            make.right.mas_equalTo(weakContainer.mas_right);
            make.height.mas_equalTo(15);
            
        }];
        
    }else{
        UILabel *beforeLabel = [[UILabel alloc] init];
        beforeLabel.adjustsFontSizeToFitWidth = YES;
        beforeLabel.backgroundColor = [UIColor clearColor];
        beforeLabel.textColor = ((_fontColorStr!= nil)?[UIColor colorWithHex:_fontColorStr]:[UIColor blackColor]);
        if (_bgColorIsBlack) {
            beforeLabel.textColor = [UIColor whiteColor];
        }
        beforeLabel.text = originPrice;
        if (_notShowDiscountValueTextAlignmentLeft) {
            beforeLabel.textAlignment = NSTextAlignmentLeft;
        }else{
            beforeLabel.textAlignment = NSTextAlignmentCenter;
        }
        beforeLabel.font = originFont;
        
        [self addSubview:beforeLabel];
        __weak UIView *weakContainer = self;
        
        [beforeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(weakContainer);
        }];
    }
  
}

- (void)updateHorizontalUIWithOriginPrice:(NSString *)originPrice fianlPrice:(NSString *)finalPrice originFont:(UIFont *)originFont finalFont:(UIFont *)finalFont{
    
    NSArray *array = self.subviews;
    if (array
        && [array count] > 0) {
        for (UIView *view in array) {
            [view removeFromSuperview];
        }
    }
    
    
    if (_showDiscountValue) {
        
        UILabel *beforeLabel = [[UILabel alloc] init];
        beforeLabel.adjustsFontSizeToFitWidth = YES;
        beforeLabel.backgroundColor = [UIColor clearColor];
        beforeLabel.textColor = [UIColor blackColor];
        if (_bgColorIsBlack) {
            beforeLabel.textColor = [UIColor lightGrayColor];
        }
        beforeLabel.text = originPrice;
        beforeLabel.textAlignment = NSTextAlignmentCenter;
        beforeLabel.font = originFont;
        
        [self addSubview:beforeLabel];
        __weak UIView *weakContainer = self;
        
        [beforeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakContainer.mas_top);
            make.left.mas_equalTo(weakContainer.mas_left);
            make.right.mas_equalTo(weakContainer.mas_right);
            make.height.mas_equalTo(15);
            
        }];
        
        UILabel *lineLabel = [[UILabel alloc] init];
        lineLabel.backgroundColor = [UIColor blackColor];
        if (_bgColorIsBlack) {
            lineLabel.backgroundColor = [UIColor whiteColor];
        }
        
        [beforeLabel addSubview:lineLabel];
        __weak UIView *weakView = beforeLabel;
        
        CGSize lineSize = [originPrice sizeWithAttributes:@{NSFontAttributeName:originFont}];
        [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.left.mas_equalTo(weakView.mas_left).with.offset(10);
            //            make.right.mas_equalTo(weakView.mas_right).with.offset(-10);
            make.width.mas_equalTo(lineSize.width);
            make.height.mas_equalTo(1);
            make.center.mas_equalTo(weakView.center);
            
        }];
        
        
        UILabel *afterLabel = [[UILabel alloc] init];
        afterLabel.backgroundColor = [UIColor clearColor];
        afterLabel.textColor = [UIColor colorWithHex:@"ef4e31"];
        afterLabel.adjustsFontSizeToFitWidth = YES;
        if (_bgColorIsBlack) {
            afterLabel.textColor = [UIColor whiteColor];
        }
        
        afterLabel.textAlignment = NSTextAlignmentCenter;
        afterLabel.text = finalPrice;
        afterLabel.font = finalFont;
        
        [self addSubview:afterLabel];
        
        [afterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakView.mas_bottom);
            make.left.mas_equalTo(weakContainer.mas_left);
            make.right.mas_equalTo(weakContainer.mas_right);
            make.height.mas_equalTo(15);
        }];
        
    }else{
        UILabel *beforeLabel = [[UILabel alloc] init];
        beforeLabel.adjustsFontSizeToFitWidth = YES;
        beforeLabel.backgroundColor = [UIColor clearColor];
        beforeLabel.textColor =  ((_fontColorStr!= nil)?[UIColor colorWithHex:_fontColorStr]:[UIColor blackColor]);;
        if (_bgColorIsBlack) {
            beforeLabel.textColor = [UIColor whiteColor];
        }
        beforeLabel.text = originPrice;
        if (_notShowDiscountValueTextAlignmentLeft) {
            beforeLabel.textAlignment = NSTextAlignmentLeft;
        }else{
            beforeLabel.textAlignment = NSTextAlignmentCenter;
        }
        beforeLabel.font = originFont;
        
        [self addSubview:beforeLabel];
        __weak UIView *weakContainer = self;
        
        [beforeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakContainer.mas_top);
            make.left.mas_equalTo(weakContainer.mas_left);
            make.right.mas_equalTo(weakContainer.mas_right);
            make.bottom.mas_equalTo(weakContainer.mas_bottom);
        }];
    }
    
}

- (void)updateUIWithTaxPrice:(NSString *)taxPrice fianlPrice:(NSString *)finalPrice taxFont:(UIFont *)taxFont finalFont:(UIFont *)finalFont{
    NSArray *array = self.subviews;
    if (array
        && [array count] > 0) {
        for (UIView *view in array) {
            [view removeFromSuperview];
        }
    }
    
    
    if (_showDiscountValue) {
        
        UILabel *beforeLabel = [[UILabel alloc] init];
        beforeLabel.adjustsFontSizeToFitWidth = YES;
        beforeLabel.backgroundColor = [UIColor clearColor];
        beforeLabel.textColor = ((_fontColorStr!= nil)?[UIColor colorWithHex:_fontColorStr]:[UIColor blackColor]);
        if (_bgColorIsBlack) {
            beforeLabel.textColor = [UIColor whiteColor];
        }
        beforeLabel.text = finalPrice;
        beforeLabel.textAlignment = NSTextAlignmentCenter;
        beforeLabel.font = finalFont;
        
        [self addSubview:beforeLabel];
        __weak UIView *weakContainer = self;
        
        [beforeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakContainer.mas_top);
            make.left.mas_equalTo(weakContainer.mas_left);
            make.right.mas_equalTo(weakContainer.mas_right);
            make.height.mas_equalTo(15);
            
        }];
        
        __weak UIView *weakView = beforeLabel;
        
        
        UILabel *afterLabel = [[UILabel alloc] init];
        afterLabel.backgroundColor = [UIColor clearColor];
        afterLabel.textColor = [UIColor colorWithHex:@"919191"];
        afterLabel.adjustsFontSizeToFitWidth = YES;
        if (_bgColorIsBlack) {
            afterLabel.textColor = [UIColor whiteColor];
        }
        
        afterLabel.textAlignment = NSTextAlignmentCenter;
        afterLabel.text = taxPrice;
        afterLabel.font = taxFont;
        
        [self addSubview:afterLabel];
        
        [afterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakView.mas_bottom);
            make.left.mas_equalTo(weakContainer.mas_left);
            make.right.mas_equalTo(weakContainer.mas_right);
            make.height.mas_equalTo(15);
            
        }];
        
    }else{
        UILabel *beforeLabel = [[UILabel alloc] init];
        beforeLabel.adjustsFontSizeToFitWidth = YES;
        beforeLabel.backgroundColor = [UIColor clearColor];
        beforeLabel.textColor = ((_fontColorStr!= nil)?[UIColor colorWithHex:_fontColorStr]:[UIColor blackColor]);
        if (_bgColorIsBlack) {
            beforeLabel.textColor = [UIColor whiteColor];
        }
        beforeLabel.text = finalPrice;
        if (_notShowDiscountValueTextAlignmentLeft) {
            beforeLabel.textAlignment = NSTextAlignmentLeft;
        }else{
            beforeLabel.textAlignment = NSTextAlignmentCenter;
        }
        beforeLabel.font = finalFont;
        
        [self addSubview:beforeLabel];
        __weak UIView *weakContainer = self;
        
        [beforeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakContainer.mas_top);
            make.left.mas_equalTo(weakContainer.mas_left);
            make.right.mas_equalTo(weakContainer.mas_right);
            make.bottom.mas_equalTo(weakContainer.mas_bottom);
        }];
    }
}

@end
