//
//  YYTypeTextView.h
//  Yunejian
//
//  Created by yyj on 2016/12/30.
//  Copyright © 2016年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYTypeTextView : UITextView

//类型
@property (nonatomic,strong) NSString *type;

@property (nonatomic,strong) id value;

+(YYTypeTextView *)getCustomTextViewWithStr:(NSString *)content WithFont:(CGFloat )font WithTextColor:(UIColor *)color;

@end
