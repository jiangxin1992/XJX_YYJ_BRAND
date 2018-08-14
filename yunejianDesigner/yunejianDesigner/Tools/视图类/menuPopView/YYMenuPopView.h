//
//  YYMenuPopView.h
//  YunejianBuyer
//
//  Created by Apple on 16/1/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYMenuPopView : UIView

/**
 *  创建一个弹出下拉控件
 *
 *  @param frame      尺寸
 *  @param selectData 选择控件的数据源
 *  @param action     点击回调方法
 *  @param animate    是否动画弹出
 */
+ (void)addPellTableViewSelectWithWindowFrame:(CGRect)frame
                                   selectData:(NSArray *)selectData
                                       images:(NSArray *)images
                                       action:(void(^)(NSInteger index))action animated:(BOOL)animate arrowImage:(BOOL)need arrowPositionInfo:(NSArray*)arrowPositionInfo;

+ (void)addPellTableViewSelectWithWindowFrame:(CGRect)frame
                                   selectData:(NSArray *)selectData
                                       images:(NSArray *)images
                                textAlignment:(NSTextAlignment)textAlignment
                                       action:(void(^)(NSInteger index))action animated:(BOOL)animate arrowImage:(BOOL)need arrowPositionInfo:(NSArray*)arrowPositionInfo;

+ (void)addPellTableViewSelectWithWindowFrame:(CGRect)frame
                                   selectData:(NSArray *)selectData
                                       images:(NSArray *)images
                                    displayData:(NSDictionary *)displayData
                                       action:(void(^)(NSInteger index))action animated:(BOOL)animate parentView:(UIView*)view;

/**
 *  手动隐藏
 */
+ (void)hiden:(BOOL)force;
@end
