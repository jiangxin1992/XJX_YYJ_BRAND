//
//  CommonHelper.h
//  CMNewspaper
//
//  Created by xuy on 13-12-30.
//  Copyright (c) 2013年 xuy. All rights reserved.
//
#import <UIKit/UIKit.h>
//图片下载
void sd_downloadWebImageWithRelativePath(BOOL isShowPlaceholder,NSString *imageRelativePath,id target, NSString *size, UIViewContentMode contentMode);

//别调用
void sd_downloadWebImageWithRelativePath_noLoading(NSString *imageRelativePath,id target, NSString *size, UIViewContentMode contentMode);

void sd_downloadWebImageWithRelativePath_Loading(NSString *imageRelativePath,id target, NSString *size, UIViewContentMode contentMode);

