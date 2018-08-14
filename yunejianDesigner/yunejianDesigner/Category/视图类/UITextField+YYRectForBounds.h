//
//  UITextField+YYRectForBounds.h
//  Yunejian
//
//  Created by yyj on 15/7/22.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (YYRectForBounds)

- (CGRect)textRectForBounds:(CGRect)bounds;

- (CGRect)editingRectForBounds:(CGRect)bounds;

@end
