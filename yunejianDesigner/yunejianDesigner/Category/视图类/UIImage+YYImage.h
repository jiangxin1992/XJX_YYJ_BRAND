//
//  UIImage+YYImage.h
//  Yunejian
//
//  Created by yyj on 15/7/15.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YYImage)

- (UIImage *)imageByApplyingAlpha:(CGFloat) alpha;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end
