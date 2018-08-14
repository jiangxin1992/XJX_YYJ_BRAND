//
//  YYQRCodeController.m
// Copyright (c) 2011–2017 Alamofire Software Foundation
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "YYQRCodeController.h"
#import "SJScanningView.h"
#import "SJCameraViewController.h"

typedef void(^successMessageBlock)(YYQRCodeController *code, NSString *messageString);
typedef void(^collback)(YYQRCodeController *code);

#define kIsAuthorizedString NSLocalizedString(@"请在设备的“设置-隐私-相机”中允许访问相机", nil)

#define kiOS8 [[UIDevice currentDevice].systemVersion integerValue]

@interface YYQRCodeController  ()<SJCameraControllerDelegate,SJScanningViewDelegate,UINavigationControllerDelegate, UIAlertViewDelegate>// UIImagePickerControllerDelegate

@property (nonatomic, strong) UIView *preview;
@property (nonatomic, strong) SJScanningView *scanningView;
@property (nonatomic, strong) SJCameraViewController *cameraController;
@property (nonatomic, copy) successMessageBlock block;

/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;
// toast回调
@property (nonatomic, copy) collback collbackBlock;

@end

@implementation YYQRCodeController

#pragma mark - 懒加载
- (SJScanningView *)scanningView {
    if (_scanningView == nil) {
        _scanningView = [[SJScanningView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
        _scanningView.scanningDelegate = self;
        
    }
    return _scanningView;
}

- (UIView *)preview {
    if (!_preview) {
        _preview = [[UIView alloc] initWithFrame:self.view.bounds];
    }
    return _preview;
}

- (SJCameraViewController *)cameraController {
    if (!_cameraController) {
        _cameraController = [[SJCameraViewController alloc] init];
        _cameraController.delegate = self;
    }
    return _cameraController;
}

#pragma mark - Life Cycle

+ (instancetype)QRCodeSuccessMessageBlock:(void (^)(YYQRCodeController *, NSString *))block{
    YYQRCodeController *codeController = [[YYQRCodeController alloc] init];
    codeController.block = block;
    return codeController;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor grayColor];

    [self setNeedsStatusBarAppearanceUpdate];
    [self prefersStatusBarHidden];
}

- (BOOL)prefersStatusBarHidden {
    return YES;//隐藏为YES，显示为NO
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self isCameraIsAuthorized]) {
        [self setupView];
        // 根据设备旋转
        [self rotateLayer];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:kIsAuthorizedString delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
        alert.tag = 886;
        [alert show];
    }
}

#pragma mark - SetUp View

- (void)setupView {
    [self.view addSubview:self.preview];
    [self.view addSubview:self.scanningView];
    [self.cameraController showCaptureOnView:self.preview];
    [self.scanningView scanning];
}

#pragma mark - The Camera is Authorized

- (BOOL)isCameraIsAuthorized {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusDenied){
        return NO;
    } else if (authStatus == AVAuthorizationStatusAuthorized) {
        return YES;
    }
    return YES;
}

#pragma mark - SJScanningViewDelegate BarButtonItem Click Event

- (void)scanningViewClickBarButtonItem:(SJSCanningViewButton)btn {
    [self.scanningView removeScanningAnimations];

    [self.cameraController stopSession];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - SJCameraControllerDelegate

- (void)cameraControllerDidDetectCodes:(NSString *)codesString {
    if (self.block) {
        self.block(self, codesString);
        // 自定义
        // [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)dismissController{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];

}

// 重新扫描
- (void)scanningAgain{
    if ([self isCameraIsAuthorized]) {
        [self.cameraController startSession];
    } else {
        UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:kIsAuthorizedString delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
        alert.tag = 886;
        [alert show];
    }
}

#pragma mark - UIImagePickerControllerDelegate
//  相册方法
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info; {
//    UIImage *pickerImage= [info objectForKey:UIImagePickerControllerOriginalImage];
//    if (kiOS8 >= 8.0) {
//      NSString *resultString = [self.cameraController readAlbumQRCodeImage:pickerImage];
//      if (self.block) {
//            [self dismissViewControllerAnimated:YES completion:nil];
//            self.block(self, resultString);
//
//        }
//    }
//}

#pragma mark - pad旋转
- (void)rotateLayer{
    AVCaptureVideoPreviewLayer *stuckview = self.cameraController.captureVideoPreviewLayer;
    CGRect layerRect = self.view.layer.bounds;
    // 不同设备适配
    UIDeviceOrientation orientation =[[UIDevice currentDevice]orientation];
    switch (orientation) {
        case UIDeviceOrientationLandscapeLeft:
            // 270 degrees
            //旋转270度和90度的效果是一样的，设备旋转之后，屏幕宽和高对换了，那么摄像头的layer的宽高也应该对换
            stuckview.affineTransform = CGAffineTransformMakeRotation(M_PI+ M_PI_2);
            [stuckview setBounds:CGRectMake(0, 0, layerRect.size.height, layerRect.size.width)];
            break;
        case UIDeviceOrientationLandscapeRight:
            stuckview.affineTransform = CGAffineTransformMakeRotation(M_PI_2); // 90 degrees
            [stuckview setBounds:CGRectMake(0, 0, layerRect.size.height, layerRect.size.width)];
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            stuckview.affineTransform = CGAffineTransformMakeRotation(M_PI); // 180 degrees
            break;
        default:
            break;
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (alertView.tag == 886) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];

        // 跳转到设置, ios8
        NSURL *SettingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if([[UIApplication sharedApplication] canOpenURL:SettingURL]) {
            [[UIApplication sharedApplication] openURL:SettingURL];
        }
    }
}

#pragma mark - 自定义对外暴漏方法
- (void)toast:(NSString *)title collback:(void (^)(YYQRCodeController *))block{
    if (block) {
        self.collbackBlock = block;

        CGFloat time;
        // 不同设备适配
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            // 手机
            time = 2.0f;
        }else{
            // pad
            time = 2.0f;
        }
        [YYToast showToastWithTitle:title andDuration:time * 1000];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(collback:) userInfo:nil repeats:NO];

    }
}

- (void)collback:(NSTimer *)timer{
    self.collbackBlock(self);
}
- (void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}

@end
