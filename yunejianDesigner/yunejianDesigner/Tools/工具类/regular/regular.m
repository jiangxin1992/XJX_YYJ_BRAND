//
//  regular.m
//  yunejianDesigner
//
//  Created by yyj on 2017/2/21.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "regular.h"

@implementation regular

//图片压缩到指定大小
+ (NSData*)getImageForSize:(CGFloat)size WithImage:(UIImage *)image
{
    NSData *tempData = UIImageJPEGRepresentation(image, 1);
    NSLog(@"原图大小=%lu %lfM",(unsigned long)tempData.length,[regular getSizeMWithBytes:tempData.length]);
    if([regular getSizeMWithBytes:tempData.length]<size)
    {
        return tempData;
    }else
    {
        NSArray *tempArr = @[@(0.9),@(0.8),@(0.7),@(0.6),@(0.5),@(0.4),@(0.3),@(0.2),@(0.1)];
        for (int i=0; i<tempArr.count; i++) {
            NSData *tempData1 = UIImageJPEGRepresentation(image, [[tempArr objectAtIndex:i] floatValue]);
            NSLog(@"处理%d次后的大小%lu %lfM",i+1,(unsigned long)tempData1.length,[regular getSizeMWithBytes:tempData1.length]);
            if([regular getSizeMWithBytes:tempData1.length]<size)
            {
                return tempData1;
            }
        }
        return UIImageJPEGRepresentation(image, 0.1);
    }
}
+(CGFloat )getSizeMWithBytes:(long)bytes
{
    return (bytes/1024.0f)/1024.0f;
}
+(void)dismissKeyborad
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

+(UIAlertController *)getAlertWithFirstActionTitle:(NSString *)firstTitle FirstActionBlock:(void (^)())firstActionBlock SecondActionTwoTitle:(NSString *)secondTitle SecondActionBlock:(void (^)())secondActionBlock;
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消",nil) style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *copyAction = [UIAlertAction actionWithTitle:secondTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        secondActionBlock();
    }];
    
    UIAlertAction *openAction = [UIAlertAction actionWithTitle:firstTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        firstActionBlock();
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:openAction];
    [alertController addAction:copyAction];
    return alertController;
}

+(UIAlertController *)alertTitleCancel_Simple:(NSString *)title WithBlock:(void(^)())block
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        block();
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"") style:UIAlertActionStyleCancel handler:nil];

    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    return alertController;
}


@end
