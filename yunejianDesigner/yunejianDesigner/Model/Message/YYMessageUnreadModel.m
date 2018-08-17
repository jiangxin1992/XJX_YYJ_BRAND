//
//  YYMessageUnreadModel.m
//  yunejianDesigner
//
//  Created by Victor on 2018/3/28.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "YYMessageUnreadModel.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图
#import "YYMessageButton.h"

// 接口

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYUser.h"

@implementation YYMessageUnreadModel

- (void)cleanUnreadMessageAmount {
    self.orderAmount = @(0);
    self.connAmount = @(0);
    self.newsAmount = @(0);
    self.personalMessageAmount = @(0);
    self.skuAmount = @(0);
}

- (void)setUnreadMessageAmount:(YYMessageButton *)messageButton{
    if(messageButton){
        if([YYUser isShowroomToBrand])
        {
            NSInteger msgAmount = [self.orderAmount integerValue] + [self.connAmount integerValue];
            if(msgAmount > 0){
                [messageButton updateButtonNumber:[NSString stringWithFormat:@"%ld",msgAmount]];
            }else{
                [messageButton updateButtonNumber:@""];
            }
        }else
        {
            NSInteger msgAmount = [self.orderAmount integerValue] + [self.connAmount integerValue] + [self.personalMessageAmount integerValue] + [self.skuAmount integerValue];
            if(msgAmount > 0 || [self.newsAmount integerValue] > 0){
                if(msgAmount > 0 ){
                    [messageButton updateButtonNumber:[NSString stringWithFormat:@"%ld",(long)msgAmount]];
                }else{
                    [messageButton updateButtonNumber:@"dot"];
                }
            }else{
                [messageButton updateButtonNumber:@""];
            }
        }
    }
}

@end
