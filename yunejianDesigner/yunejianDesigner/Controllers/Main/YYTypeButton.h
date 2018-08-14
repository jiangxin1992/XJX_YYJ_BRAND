//
//  YYTypeButton.h
//  Yunejian
//
//  Created by yyj on 2017/1/1.
//  Copyright © 2017年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYTypeButton : UIButton

//类型
@property (nonatomic,strong) NSString *type;

@property (nonatomic,strong) id value;

/**
 * 创建带title 的自定义 btn
 */
+(YYTypeButton *)getCustomTitleBtnWithAlignment:(NSInteger )_alignment WithFont:(CGFloat )_font WithSpacing:(CGFloat )_spacing WithNormalTitle:(NSString *)_normalTitle WithNormalColor:(UIColor *)_normalColor WithSelectedTitle:(NSString *)_selectedTitle WithSelectedColor:(UIColor *)_selectedColor;

+(YYTypeButton *)getCustomImgBtnWithImageStr:(NSString *)_normalImageStr WithSelectedImageStr:(NSString *)_selectedImageStr;

@end
