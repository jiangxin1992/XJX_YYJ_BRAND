//
//  YYTypeTextView.m
//  Yunejian
//
//  Created by yyj on 2016/12/30.
//  Copyright © 2016年 yyj. All rights reserved.
//

#import "YYTypeTextView.h"

@implementation YYTypeTextView

+(YYTypeTextView *)getCustomTextViewWithStr:(NSString *)content WithFont:(CGFloat )font WithTextColor:(UIColor *)color
{
    YYTypeTextView *textview=[[YYTypeTextView alloc] init];
    if(color){
        textview.textColor=color;
    }else
    {
        textview.textColor=_define_black_color;
    }
    
    if(font){
        textview.font=getFont(font);
    }

    if(![NSString isNilOrEmpty:content])
    {
        textview.text=content;
    }
    return textview;
}

@end
