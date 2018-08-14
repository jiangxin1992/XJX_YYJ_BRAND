//
//  YYBrandInfoView.m
//  YunejianBuyer
//
//  Created by Apple on 16/4/1.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYBrandInfoView.h"

@implementation YYBrandInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)updateUI:(NSArray *)infoArr{
    UILabel *phoneLabel = [self viewWithTag:10001];
    UILabel *emailLabel = [self viewWithTag:10002];
    UILabel *qqLabel = [self viewWithTag:10003];
    UILabel *weixinLabel = [self viewWithTag:10004];
    phoneLabel.adjustsFontSizeToFitWidth = YES;
    emailLabel.adjustsFontSizeToFitWidth = YES;
    qqLabel.adjustsFontSizeToFitWidth = YES;
    weixinLabel.adjustsFontSizeToFitWidth = YES;
    phoneLabel.text = [infoArr objectAtIndex:0];
    emailLabel.text = [infoArr objectAtIndex:1];
    qqLabel.text = [infoArr objectAtIndex:2];
    weixinLabel.text = [infoArr objectAtIndex:3];
}
@end
