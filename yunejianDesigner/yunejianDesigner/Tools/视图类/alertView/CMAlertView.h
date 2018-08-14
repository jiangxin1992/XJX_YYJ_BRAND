//
//  CMAlertView.h
//  CMRead-iPhone
//
//  Created by Yrl on 14-10-24.
//  Copyright (c) 2014年 CMRead. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NoLongerRemindBrand @"NoLongerRemindBrand"

typedef void (^CMAlertViewBlock)(NSInteger selectedIndex);

typedef void (^CMAlertViewSubmitBlock)(NSString *reson);

@protocol CMAlertViewDelegate <NSObject>

- (void)alertView:(UIView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface CMAlertView : UIView
{
    UIView *specialParentView;
}

@property (nonatomic, assign)BOOL select;
@property (nonatomic, strong)NSString *noLongerRemindKey;
@property (nonatomic, strong)UIView *specialParentView;
@property (nonatomic, strong)NSArray *buttonList;

@property (nonatomic, strong)CMAlertViewBlock alertViewBlock;
@property (nonatomic, strong)CMAlertViewSubmitBlock alertViewSubmitBlock;

- (id)initWithTitle:(NSString *)title message:(NSString *)message needwarn:(BOOL)needwarn delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelBT otherButtonTitles:(NSArray *)otherButtonTitles otherBtnBackColor:(NSString *)color;

- (id)initWithTitle:(NSString *)title message:(NSString *)message needwarn:(BOOL)needwarn delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelBT otherButtonTitles:(NSArray *)otherButtonTitles;

- (id)initWithTitle:(NSString *)title message:(NSString *)message needwarn:(BOOL)needwarn delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelBT otherButtonTitles:(NSArray *)otherButtonTitles bgClose:(BOOL)isClose;

//填写拒绝订单理由页面
- (id)initRefuseOrderReasonWithTitle:(NSString *)title message:(NSString *)message otherButtonTitles:(NSArray *)otherButtonTitles;

- (id)initWithImage:(UIImage *)image imageFrame:(CGRect)frame cancelButtonTitle:(NSString *)cancelBT bgClose:(BOOL)isClose;

- (id)initWithViews:(NSArray *)uis imageFrame:(CGRect)frame  bgClose:(BOOL)isClose;

- (id)init;

- (void)show;

- (void)show:(UIView *)parentView;

-(void)OnTapBg:(UITapGestureRecognizer *)sender;

@end
