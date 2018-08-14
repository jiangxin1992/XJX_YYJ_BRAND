//
//  UIButton+EnlargeEdge.h
//  DDAY
//
//  Created by yyj on 16/7/14.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <objc/runtime.h>

@interface UIButton (EnlargeEdge)

/**
 设置交互区域

 @param size 四周交互区域扩大 size 大小
 */
- (void)setEnlargeEdge:(CGFloat)size;

/**
 设置交互区域

 @param top 顶部交互区域扩大 top 大小
 @param right 右边交互区域扩大 right 大小
 @param bottom 底部交互区域扩大 bottom 大小
 @param left 左边交互区域扩大 left 大小
 */
- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

@end

