//
//  JRPhoneDelegate.m
//  parking
//
//  Created by chjsun on 2016/12/22.
//  Copyright © 2016年 chjsun. All rights reserved.
//

#import "JRPhoneDelegate.h"

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>


static JRPhoneDelegate *phoneDelegate;

@interface JRPhoneDelegate()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>

@end

@implementation JRPhoneDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    switch (self.imagePickerType) {
        case 1:{
            if (buttonIndex != 1) {
                // 相机
                [self imagePickerControllerSourceTypeCamera];
            }
        }
            break;

        case 2:{
            if (buttonIndex != 1) {
                // 相册
                [self imagePickerControllerSourceTypePhotoLibrary];
            }
        }
            break;

        case 3:{
            if (buttonIndex != 2) {

                if (buttonIndex == 0) {
                    // 拍照
                    [self imagePickerControllerSourceTypeCamera];
                } else {
                    // 相册
                    [self imagePickerControllerSourceTypePhotoLibrary];
                }
            }
        }
            break;

        default:{
            if (buttonIndex != 2) {

                if (buttonIndex == 0) {

                } else {

                }
            }
        }
            break;
    }

}

// 拍照
- (void)imagePickerControllerSourceTypeCamera{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    if (self.isEditing == 1) {
        picker.allowsEditing = YES;
    }else{
        picker.allowsEditing = NO;
    }
    //拍摄照片
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];

    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请在设备的“设置-隐私-相机”中允许访问相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return;
    }else{
        [self.pushController presentViewController:picker animated:YES completion:nil];
    }
}

// 相册选取
- (void)imagePickerControllerSourceTypePhotoLibrary{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    if (self.isEditing == 1) {
        picker.allowsEditing = YES;
    }else{
        picker.allowsEditing = NO;
    }

    //从相册选取
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
    if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied){
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请在设备的“设置-隐私-照片”中允许访问照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];

        return;
    }else{
        picker.view.backgroundColor = [UIColor whiteColor];
        [self.pushController presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark - 当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //关闭相册界面
    WeakSelf(ws);
    [picker dismissViewControllerAnimated:YES completion:^{
        StrongSelf(ws);
        if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"]) {//当选择的类型是图片
            if ([strongSelf.delegate respondsToSelector:@selector(JRPhotoData:sign:)]) {
                if (self.isEditing != 1) {
                    [strongSelf.delegate JRPhotoData:UIImageJPEGRepresentation(info[@"UIImagePickerControllerOriginalImage"], 0.5) sign:self.sign];

                }else{
                    [strongSelf.delegate JRPhotoData:UIImageJPEGRepresentation(info[@"UIImagePickerControllerEditedImage"], 0.5) sign:self.sign];
                }

            }
        }
    }];
}

#pragma mark - alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    // 跳转到设置, ios8
    NSURL *SettingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:SettingURL]) {
        [[UIApplication sharedApplication] openURL:SettingURL];
    }
}

#pragma mark - 单例设计模式
+ (id)sharePhoneDelegate{
    if (phoneDelegate == nil){
        @synchronized(self){
            if (phoneDelegate == nil){
                phoneDelegate = [[self alloc] init];
            }
        }
    }
    return phoneDelegate;
}
//重写alloc方法，保证在使用alloc、new 去创建对象时，不产生新的对象
+ (id)allocWithZone:(NSZone *)zone{
    if (phoneDelegate == nil) {
        phoneDelegate = [[super allocWithZone:zone] init];
    }
    return phoneDelegate;
}

//重写copy方法，避免复制时，产生新对象
- (id)copyWithZone:(NSZone *)zone{
    return phoneDelegate;
}

//重写mutablecopy方法，避免深拷贝
- (id)mutableCopyWithZone:(NSZone *)zone{
    return phoneDelegate;
}

@end
