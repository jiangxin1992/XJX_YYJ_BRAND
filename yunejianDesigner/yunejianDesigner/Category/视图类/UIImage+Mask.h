//
//  UIImage+Mask.h
//  GuideDemo
//
//  Created by 李剑钊 on 15/7/24.
//  Copyright (c) 2015年 sunli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Mask)

/**
 获得蒙版

 @param maskColor 蒙板颜色
 @return maskImage
 */
- (UIImage *)maskImage:(UIColor *)maskColor;

@end
