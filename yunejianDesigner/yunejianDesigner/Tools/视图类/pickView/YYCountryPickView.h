//
//  YYCustomPickView.h
//  YunejianBuyer
//
//  Created by Apple on 16/3/17.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YYCountryPickViewType) {
    CountryPickView = 50000,
    SubCountryPickView = 50001,
};

@class YYCountryPickView;

@protocol YYCountryPickViewDelegate <NSObject>

@optional

-(void)toobarDonBtnHaveCountryClick:(YYCountryPickView *)pickView resultString:(NSString *)resultString;

@end

@interface YYCountryPickView : UIView
@property(nonatomic,strong)NSArray *plistArray;//数据
@property(nonatomic,weak) id<YYCountryPickViewDelegate> delegate;
@property (nonatomic,strong)CancelButtonClicked cancelButtonClicked;

/**
 *  通过plistName添加一个pickView
 *
 *  @param array              需要显示的数组
 *  @param isHaveNavControler 是否在NavControler之内
 *  @param plistType 选择器类型 country sub_country
 *
 *  @return 带有toolbar的pickview
 */
-(instancetype)initPickviewWithCountryArray:(NSArray *)array WithPlistType:(YYCountryPickViewType )plistType isHaveNavControler:(BOOL)isHaveNavControler;


/**
 *   移除本控件
 */
-(void)removeNoBlock;
/**
 *  显示本控件
 */
-(void)show:(UIView *)specialParentView;
/**
 *  设置PickView的颜色
 */
-(void)setPickViewColer:(UIColor *)color;
/**
 *  设置toobar的文字颜色
 */
-(void)setTintColor:(UIColor *)color;
/**
 *  设置toobar的背景颜色
 */
-(void)setToolbarTintColor:(UIColor *)color;

-(void)selectPickerRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)anim;
@end

