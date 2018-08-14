//
//  YYAlert.m
//  Yunejian
//
//  Created by yyj on 15/7/9.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYToast.h"

#define KT_TOAST_PADDING_HEIGHT     14          // 内边距高
#define KT_TOAST_PADDING_WIDTH      17          // 内边距宽
#define KT_TOAST_MARGIN_BOTTOM      30          // 外边距底部
#define KT_TOAST_MAX_WIDTH          220         // 最大宽度
#define KT_TOAST_CORNER_RADIUS      0.0         // 圆角度
#define KYYAlertFadeDuration        0.25

@implementation YYToast

+ (void)showToastWithView:(UIView *)superView title:(NSString *)title andDuration:(NSUInteger)durationInMillis{

    if (!superView) {
        // 如果没有传视图，就用window
        UIApplication *application = [UIApplication sharedApplication];
        UIWindow *window = application.keyWindow;
        superView = window;
    }

    if (superView && title) {
        UILabel *toastLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        toastLabel.text = title;
        toastLabel.numberOfLines = 1000;
        toastLabel.textColor = [UIColor whiteColor];
        toastLabel.backgroundColor = [UIColor blackColor];
        toastLabel.textAlignment = NSTextAlignmentCenter;
        toastLabel.lineBreakMode = NSLineBreakByWordWrapping;
        toastLabel.font = [UIFont systemFontOfSize:14.0f];

        // 得到文本的宽高
        // resize the label based on the message length
        CGSize maximumLabelSize = CGSizeMake(KT_TOAST_MAX_WIDTH, 9999);
        NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:14.f ]};
        CGRect infoRect = [toastLabel.text boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
        CGSize expectedLabelSize = infoRect.size;

        // add the toast label to the alert (centered with padding)
        CGRect newViewFrame = CGRectZero;
        newViewFrame.size.width = expectedLabelSize.width + KT_TOAST_PADDING_WIDTH * 2;
        newViewFrame.size.height = expectedLabelSize.height + KT_TOAST_PADDING_HEIGHT * 2;

        UIView *backgroundView = [[UIView alloc] init];
        backgroundView.userInteractionEnabled = NO;
        backgroundView.backgroundColor = [UIColor clearColor];

        CGRect superViewFrame = superView.frame;

        CGFloat width = superViewFrame.size.width;
        CGFloat height = superViewFrame.size.height;

        CGFloat left = (width-newViewFrame.size.width)/2;
        CGFloat top = (height-newViewFrame.size.height)/2;

        toastLabel.frame = CGRectMake(left, top, newViewFrame.size.width, newViewFrame.size.height);

        [UIView animateWithDuration:KYYAlertFadeDuration animations:^{

            [superView addSubview:backgroundView];

            backgroundView.frame = superView.bounds;
            [backgroundView addSubview:toastLabel];

            toastLabel.alpha = 1.0f;
        }completion:^(BOOL finished) {
            CGFloat seconds = durationInMillis / 1000;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
                [backgroundView removeFromSuperview];
            });
        }];
    }
}

+ (void)showToastWithTitle:(NSString *)title andDuration:(NSUInteger)durationInMillis{
    UIApplication *application = [UIApplication sharedApplication];
    UIView *superView = application.keyWindow;

    [YYToast showToastWithView:superView title:title andDuration:durationInMillis];
}

@end
