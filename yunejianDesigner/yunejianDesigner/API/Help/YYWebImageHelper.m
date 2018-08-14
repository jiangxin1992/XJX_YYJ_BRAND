//
//  CommonHelper.m
//  CMNewspaper
//
//  Created by zhu on 13-12-30.
//  Copyright (c) 2013年 zhu. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "UIImage+GIF.h"

#import "SCGIFImageView.h"
#import "SCGIFButtonView.h"

//图片下载
void sd_downloadWebImageWithRelativePath(BOOL isShowPlaceholder,NSString *imageRelativePath,id target, NSString *size, UIViewContentMode contentMode){
    if(isShowPlaceholder){
        sd_downloadWebImageWithRelativePath_Loading(imageRelativePath,target,size,contentMode);
    }else{
        sd_downloadWebImageWithRelativePath_noLoading(imageRelativePath,target,size,contentMode);
    }
}

void sd_downloadWebImageWithRelativePath_noLoading(NSString *imageRelativePath,id target, NSString *size, UIViewContentMode contentMode){
    if([target isKindOfClass:[SCGIFButtonView class]] || [target isKindOfClass:[SCGIFImageView class]]){
        if(![NSString isNilOrEmpty:imageRelativePath]){
            //开始置空
            NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageRelativePath,size]];

            if([target isKindOfClass:[SCGIFImageView class]]){
                //SCGIFImageView
                SCGIFImageView *targetObj=((SCGIFImageView *)target);
                targetObj.imageRelativePath = imageRelativePath;
                [targetObj sd_setImageWithURL:imageUrl placeholderImage:nil options:SDWebImageRetryFailed|SDWebImageLowPriority];
            }else{
                //SCGIFButtonView
                SCGIFButtonView *targetObj=((SCGIFButtonView *)target);
                targetObj.imageRelativePath = imageRelativePath;
                [targetObj sd_setImageWithURL:imageUrl forState:UIControlStateNormal placeholderImage:nil options:SDWebImageRetryFailed|SDWebImageLowPriority];
            }
        }else{
            if([target isKindOfClass:[SCGIFImageView class]]){
                //SCGIFImageView
                SCGIFImageView *targetObj=((SCGIFImageView *)target);
                [targetObj setImage:nil];
            }else{
                //SCGIFButtonView
                SCGIFButtonView *targetObj=((SCGIFButtonView *)target);
                [targetObj setImage:nil forState:UIControlStateNormal];
            }
        }

    }
}

void sd_downloadWebImageWithRelativePath_Loading(NSString *imageRelativePath,id target, NSString *size, UIViewContentMode contentMode){
    if([target isKindOfClass:[SCGIFButtonView class]] || [target isKindOfClass:[SCGIFImageView class]]){
        if(![NSString isNilOrEmpty:imageRelativePath]){
            //开始置空
            NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageRelativePath,size]];

            NSString* filePath = [[NSBundle mainBundle] pathForResource:@"loading.gif" ofType:nil];
            NSData *gifImageData = [NSData dataWithContentsOfFile:filePath];
            UIImage *gifImage = [UIImage sd_animatedGIFWithData:gifImageData];

            if([target isKindOfClass:[SCGIFImageView class]]){
                //SCGIFImageView
                SCGIFImageView *targetObj=((SCGIFImageView *)target);
                targetObj.imageRelativePath = imageRelativePath;
                targetObj.contentMode = UIViewContentModeCenter;
                __weak SCGIFImageView *weaktarget = targetObj;
                [targetObj sd_setImageWithURL:imageUrl placeholderImage:gifImage options:SDWebImageRetryFailed|SDWebImageLowPriority completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    if([weaktarget.imageRelativePath isEqualToString:imageRelativePath]){
                        weaktarget.contentMode = contentMode;
                    }
                }];
            }else{
                //SCGIFButtonView
                SCGIFButtonView *targetObj=((SCGIFButtonView *)target);
                targetObj.imageRelativePath = imageRelativePath;
                targetObj.imageView.contentMode = UIViewContentModeCenter;
                __weak SCGIFButtonView *weaktarget = targetObj;
                [targetObj sd_setImageWithURL:imageUrl forState:UIControlStateNormal placeholderImage:gifImage options:SDWebImageRetryFailed|SDWebImageLowPriority completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    if([weaktarget.imageRelativePath isEqualToString:imageRelativePath]){
                        weaktarget.imageView.contentMode = contentMode;
                    }
                }];
            }
        }else{
            if([target isKindOfClass:[SCGIFImageView class]]){
                //SCGIFImageView
                SCGIFImageView *targetObj=((SCGIFImageView *)target);
                targetObj.contentMode = contentMode;
                [targetObj setImage:nil];
            }else{
                //SCGIFButtonView
                SCGIFButtonView *targetObj=((SCGIFButtonView *)target);
                targetObj.imageView.contentMode = contentMode;
                [targetObj setImage:nil forState:UIControlStateNormal];
            }
        }
    }
}

