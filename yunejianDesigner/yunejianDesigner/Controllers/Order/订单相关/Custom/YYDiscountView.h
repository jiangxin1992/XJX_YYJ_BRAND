//
//  YYDiscountView.h
//  Yunejian
//
//  Created by yyj on 15/8/7.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYDiscountView : UIView

@property(nonatomic,assign) BOOL showDiscountValue;
@property(nonatomic,assign) BOOL notShowDiscountValueTextAlignmentLeft;
@property(nonatomic,assign) NSString *fontColorStr;
@property(nonatomic,assign) BOOL bgColorIsBlack;
//上下排布
- (void)updateUIWithOriginPrice:(NSString *)originPrice fianlPrice:(NSString *)finalPrice originFont:(UIFont *)originFont finalFont:(UIFont *)finalFont;
//左右排布
- (void)updateHorizontalUIWithOriginPrice:(NSString *)originPrice fianlPrice:(NSString *)finalPrice originFont:(UIFont *)originFont finalFont:(UIFont *)finalFont;
//税收
- (void)updateUIWithTaxPrice:(NSString *)taxPrice fianlPrice:(NSString *)finalPrice taxFont:(UIFont *)taxFont finalFont:(UIFont *)finalFont;

@end
