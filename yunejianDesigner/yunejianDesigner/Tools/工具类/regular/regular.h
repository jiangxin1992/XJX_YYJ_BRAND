//
//  regular.h
//  yunejianDesigner
//
//  Created by yyj on 2017/2/21.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface regular : NSObject

/** 图片压缩到指定大小*/
+ (NSData*)getImageForSize:(CGFloat)size WithImage:(UIImage *)image;

/**
 * 键盘消失
 */
+(void)dismissKeyborad;

/**
 * 获取自定义下拉弹框
 */
+(UIAlertController *)getAlertWithFirstActionTitle:(NSString *)firstTitle FirstActionBlock:(void (^)())firstActionBlock SecondActionTwoTitle:(NSString *)secondTitle SecondActionBlock:(void (^)())secondActionBlock;
/**
 * 使用动画从父视图中删除
 */
//+ (void)removeFromSuperviewUseUseAnimateAndDeallocViewController:(UIViewController *)viewController WithView:(UIView *)view animateEndBlock:(void(^)())block;
/**
 * 获取alert视图
 * title标题内容
 * 点击OK回调
 * 带了个取消
 */
+(UIAlertController *)alertTitleCancel_Simple:(NSString *)title WithBlock:(void(^)())block;
@end
