//
//  UIImageView+Custom.h
//  DDAY
//
//  Created by yyj on 16/7/14.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Custom)

/**
 返回仅初始化的imageView | contentMode = UIViewContentModeScaleAspectFit
 
 @return imageView
 */
+(UIImageView *)getCustomImg;

/**
 返回圆形的imageView | contentMode = UIViewContentModeScaleAspectFit
 
 @return imageView
 */
+(UIImageView *)getCornerRadiusImg;

/**
 返回默认蒙版 | contentMode = UIViewContentModeScaleToFill
 
 @return 蒙版
 */
+(UIImageView *)getMaskImageView;

/**
 返回带图片的imageView | contentMode = UIViewContentModeScaleAspectFit

 @param imageStr 设定的图片名 | 不传为nil
 @return imageView
 */
+(UIImageView *)getImgWithImageStr:(NSString *)imageStr;

@end
