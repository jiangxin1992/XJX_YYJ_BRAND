//
//  UIActionSheet+JRPhoto.m
//  parking
//
//  Created by chjsun on 2016/12/22.
//  Copyright © 2016年 chjsun. All rights reserved.
//

#import "UIActionSheet+JRPhoto.h"

@interface UIActionSheet()<JRPhotoImageDelegate>

@end

@implementation UIActionSheet (JRPhoto)

+ (void)SheetPhotoControl:(UIViewController *)controller WithDelegate:(id<JRPhotoImageDelegate>)delegate photoType:(photoType)photoType isEditing:(isEditing)isEditing sign:(NSString *)sign{

    JRPhoneDelegate *phoneDelegate = [JRPhoneDelegate sharePhoneDelegate];

    phoneDelegate.pushController = controller;
    phoneDelegate.imagePickerType = photoType;
    phoneDelegate.delegate = delegate;
    phoneDelegate.sign = sign;

    if (isEditing == YES) {
        phoneDelegate.isEditing = 1;
    }else{
        phoneDelegate.isEditing = 0;
    }
    if (photoType == 1) {
        // 只有相机
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:phoneDelegate cancelButtonTitle:NSLocalizedString(@"取消",nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"拍照",nil), nil];
        [actionSheet showInView:controller.view];

    }else if (photoType == 2){
        // 只有相册
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:phoneDelegate cancelButtonTitle:NSLocalizedString(@"取消",nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"相册",nil), nil];

        [actionSheet showInView:controller.view];

    }else if(photoType == 3){
        // 有相机和相册
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:phoneDelegate cancelButtonTitle:NSLocalizedString(@"取消",nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"拍照",nil), NSLocalizedString(@"相册",nil), nil];
        [actionSheet showInView:controller.view];

    }else{
        // 有相机和相册
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:phoneDelegate cancelButtonTitle:NSLocalizedString(@"取消",nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"拍照",nil), NSLocalizedString(@"相册",nil), nil];
        [actionSheet showInView:controller.view];
    }
}

//+ (void)SheetPhotoControl:(UIViewController *)controller WithDelegate:(id<JRPhotoImageDelegate>)delegate{
//
//}


@end

