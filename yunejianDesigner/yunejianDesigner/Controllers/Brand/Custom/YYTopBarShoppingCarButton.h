//
//  YYTopBarShoppingCarButton.h
//  Yunejian
//
//  Created by yyj on 15/7/24.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYTopBarShoppingCarButton : UIButton

- (void)initButton;

- (void)initCircleButton;

- (void)updateButtonNumber:(NSString *)nowNumber;

@property (nonatomic,assign) BOOL isRight;

@end
