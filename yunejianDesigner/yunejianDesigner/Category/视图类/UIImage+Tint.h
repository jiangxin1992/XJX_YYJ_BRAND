//
//  UIImage+Tint.h
//  Yunejian
//
//  Created by Apple on 15/11/19.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tint)

/**
 改变image图片的颜色

 @param tintColor 填充的颜色值
 @return image
 */
- (UIImage *)imageWithTintColor:(UIColor *)tintColor;

/**
 给图片加一层该颜色的蒙版

 @param tintColor 填充的颜色值
 @return image
 */
- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor;

/**
 调整方向

 @param aImage aImage
 @return image
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage;

@end
