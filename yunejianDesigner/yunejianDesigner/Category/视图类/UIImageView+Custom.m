//
//  UIImageView+Custom.m
//  DDAY
//
//  Created by yyj on 16/7/14.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "UIImageView+Custom.h"

#import "UIImageView+CornerRadius.h"

@implementation UIImageView (Custom)


+(UIImageView *)getImgWithImageStr:(NSString *)imageStr
{
    UIImageView *imageview = [[UIImageView alloc] init];
    imageview.userInteractionEnabled = YES;
    if(![imageStr isNilOrEmpty]){
        imageview.image = [UIImage imageNamed:imageStr];
    }
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    return imageview;
}

+(UIImageView *)getMaskImageView
{
    UIImageView *mengban = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH , SCREEN_HEIGHT)];
    mengban.userInteractionEnabled = YES;
    mengban.contentMode = UIViewContentModeScaleToFill;
    mengban.image = [UIImage imageNamed:@"System_Mask"];
    return mengban;
}

+(UIImageView *)getCustomImg
{
    UIImageView *img = [[UIImageView alloc] init];
    img.contentMode = UIViewContentModeScaleAspectFit;
    return img;
}

+(UIImageView *)getCornerRadiusImg
{
    UIImageView *imageView = [[UIImageView alloc] initWithRoundingRectImageView];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    return imageView;
}

@end
