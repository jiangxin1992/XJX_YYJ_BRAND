//
//  SJScanningView.m
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

#import "SJScanningView.h"

#define kSJQRCodeTipString              NSLocalizedString(@"请将二维码放入框内", nil)
#define kSJQRCodeUnRestrictedTipString  NSLocalizedString(@"请在设备的“设置-隐私-相机”中允许访问相机", nil)

static CGRect scanningRect;

// 手机端的尺寸
static const CGFloat kSJQRCodeRectPhoneX = 52.5;
static const CGFloat kSJQRCodeRectPhoneY = 153;

// pad端的尺寸
static const CGFloat kSJQRCodeRectPadX = 312;
static const CGFloat kSJQRCodeRectPadY = 184.5;

@interface SJScanningView ()

/** 是否授权 */
@property (nonatomic, assign) BOOL isRestrict;
@property (nonatomic, assign) CGRect cleanRect;
@property (nonatomic, assign) CGRect scanningRect;
@property (nonatomic, strong) UILabel *QRCodeTipLabel;
@property (nonatomic, strong) UIImageView *scanningImageView;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preViewLayer;

@end

@implementation SJScanningView

+ (Class)layerClass {
    return [AVCaptureVideoPreviewLayer class];
}

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];

        self.cleanRect = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetWidth(frame));
    }
    return self;
}

#pragma mark - Propertys
- (UIImageView *)scanningImageView {
    if (!_scanningImageView) {

        CGFloat paddingX;
        CGFloat paddingY;
        // 不同设备适配
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            // 手机
            paddingX = kSJQRCodeRectPhoneX;
            paddingY = kSJQRCodeRectPhoneY + (kIPhoneX?34.f:0.f);
        }else{
            // pad
            paddingX = kSJQRCodeRectPadX;
            paddingY = kSJQRCodeRectPadY;
        }

        _scanningImageView = [[UIImageView alloc] initWithFrame:CGRectMake(paddingX, paddingY, CGRectGetWidth(self.bounds) - paddingX * 2, 3)];
        _scanningImageView.image = [UIImage imageNamed:@"iPad-scan-line"];
        scanningRect  = _scanningImageView.frame;
    }
    return _scanningImageView;
}

- (UILabel *)QRCodeTipLabel {
    if (!_QRCodeTipLabel) {
        _QRCodeTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.cleanRect), CGRectGetWidth(self.bounds) - 20, 20)];
        _QRCodeTipLabel.font = [UIFont systemFontOfSize:13];
        _QRCodeTipLabel.backgroundColor = [UIColor clearColor];
        _QRCodeTipLabel.textAlignment = NSTextAlignmentCenter;
        _QRCodeTipLabel.textColor = [UIColor colorWithRed:0.569 green:0.569 blue:0.569 alpha:1];
        _QRCodeTipLabel.numberOfLines = 0;
    }
    return _QRCodeTipLabel;
}

#pragma mark - Public Event

- (void)setupView {
    self.isRestrict = YES;
    self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500];
    
    [self addSubview:self.scanningImageView];
    [self addSubview:self.QRCodeTipLabel];
    [self QRCodeQRCodeTipLabelString];
    [self drawBarBottomItems];
}

- (AVCaptureSession *)session {
    return self.preViewLayer.session;
}

- (void)setSession:(AVCaptureSession *)session {
    self.preViewLayer.session = session;
}

- (AVCaptureVideoPreviewLayer *)previewLayer {
    return (AVCaptureVideoPreviewLayer *)self.layer;
}

#pragma mark - According authorized and unauthorized show different tip string

- (void )QRCodeQRCodeTipLabelString {
    if (self.isRestrict) {
        self.QRCodeTipLabel.text = kSJQRCodeTipString;
    } else {
        NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
        if (!appName) appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
        self.QRCodeTipLabel.text = kSJQRCodeUnRestrictedTipString;
    }
}

- (void)scanning {

    CGFloat paddingX;
    CGFloat paddingY;
    CGFloat time;

    // 不同设备适配
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // 手机
        paddingX = kSJQRCodeRectPhoneX;
        paddingY = kSJQRCodeRectPhoneY + (kIPhoneX?34.f:0.f);
        time = 2.5;
    }else{
        // pad
        paddingX = kSJQRCodeRectPadX;
        paddingY = kSJQRCodeRectPadY;
        time = 3;
    }

    // 创建动画
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    rotationAnimation.fromValue = @(paddingY);
    rotationAnimation.toValue = @((CGRectGetWidth(self.frame) - paddingX * 2) + paddingY);
    rotationAnimation.duration = time; // 一次动画时间
    rotationAnimation.cumulative = NO; // 是否累加
    rotationAnimation.repeatCount = HUGE_VALF;//INFINITY; // 循环多少圈
    rotationAnimation.removedOnCompletion = NO; // home之后，再进来，仍然可以执行
    [self.scanningImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

#pragma mark - Remove ScaningImageViAnimations

- (void)removeScanningAnimations {
    [self.scanningImageView.layer removeAllAnimations];
};

#pragma mark - Setup BarBottomItem

- (void)drawBarBottomItems {
    // [UIImage imageNamed:@"qrcode_scan_back_nor"]
    UIButton *exitBtn = [self createButtonNormalImage:[UIImage imageNamed:@"qrcode_scan_back_nor"] selectImage:[UIImage imageNamed:@"qrcode_scan_back_nor"] scanningViewButton:SJSCanningViewButtonExit];

    [self addSubview:exitBtn];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = NSLocalizedString(@"扫码", nil);
    titleLabel.font = [UIFont systemFontOfSize:17];
    [titleLabel sizeToFit];
    titleLabel.center = CGPointMake(CGRectGetWidth(self.bounds)/2, 42 + (kIPhoneX?24.f:0.f));

    [self addSubview:titleLabel];
}

- (UIButton *)createButtonNormalImage:(UIImage *)normalImage selectImage:(UIImage *)selectImage scanningViewButton:(SJSCanningViewButton)btnTag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = btnTag;
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:selectImage forState:UIControlStateSelected];
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];

    button.frame = CGRectMake(17, 33 + (kIPhoneX?24.f:0.f), 20, 20);

    return button;
}

#pragma mark - Button Action

- (void)clickButton:(UIButton *)btn {
    [self.scanningDelegate scanningViewClickBarButtonItem:btn.tag];
}

- (void)drawRect:(CGRect)rect {
  
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, self.backgroundColor.CGColor);
    CGContextFillRect(contextRef, rect);
    CGRect clearRect;

    CGFloat paddingX;
    CGFloat paddingY;

    // 不同设备适配
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // 手机
        paddingX = kSJQRCodeRectPhoneX;
        paddingY = kSJQRCodeRectPhoneY + (kIPhoneX?34.f:0.f);
    }else{
        // pad
        paddingX = kSJQRCodeRectPadX;
        paddingY = kSJQRCodeRectPadY;
    }

    CGFloat tipLabelPadding = 10.0f;
    clearRect = CGRectMake(paddingX, paddingY, CGRectGetWidth(rect) - paddingX * 2, CGRectGetWidth(rect) - paddingX * 2);
    self.cleanRect = clearRect;
    
    CGRect QRCodeTipLabelFrame = self.QRCodeTipLabel.frame;
    QRCodeTipLabelFrame.origin.y = CGRectGetMaxY(self.cleanRect) + tipLabelPadding;
    self.QRCodeTipLabel.frame = QRCodeTipLabelFrame;
    
    CGContextClearRect(contextRef, self.cleanRect);
    CGContextSaveGState(contextRef);
    
    UIImage *topLeftImage = [UIImage imageNamed:@"ScanQR1"];
    UIImage *topRightImage = [UIImage imageNamed:@"ScanQR2"];
    UIImage *bottomLeftImage = [UIImage imageNamed:@"ScanQR3"];
    UIImage *bottomRightImage = [UIImage imageNamed:@"ScanQR4"];
    
    [topLeftImage drawInRect:CGRectMake(_cleanRect.origin.x, _cleanRect.origin.y, topLeftImage.size.width, topLeftImage.size.height)];
    [topRightImage drawInRect:CGRectMake(CGRectGetMaxX(_cleanRect) - topRightImage.size.width, _cleanRect.origin.y, topRightImage.size.width, topRightImage.size.height)];
    [bottomLeftImage drawInRect:CGRectMake(_cleanRect.origin.x, CGRectGetMaxY(_cleanRect) - bottomLeftImage.size.height, bottomLeftImage.size.width, bottomLeftImage.size.height)];
    [bottomRightImage drawInRect:CGRectMake(CGRectGetMaxX(_cleanRect) - bottomRightImage.size.width, CGRectGetMaxY(_cleanRect) - bottomRightImage.size.height, bottomRightImage.size.width, bottomRightImage.size.height)];
    
    CGFloat padding = 0.5;
    CGContextMoveToPoint(contextRef, CGRectGetMinX(_cleanRect) - padding, CGRectGetMinY(_cleanRect) - padding);
    CGContextAddLineToPoint(contextRef, CGRectGetMaxX(_cleanRect) + padding, CGRectGetMinY(_cleanRect) + padding);
    CGContextAddLineToPoint(contextRef, CGRectGetMaxX(_cleanRect) + padding, CGRectGetMaxY(_cleanRect) + padding);
    CGContextAddLineToPoint(contextRef, CGRectGetMinX(_cleanRect) - padding, CGRectGetMaxY(_cleanRect) + padding);
    CGContextAddLineToPoint(contextRef, CGRectGetMinX(_cleanRect) - padding, CGRectGetMinY(_cleanRect) - padding);
    CGContextSetLineWidth(contextRef, padding);
    CGContextSetStrokeColorWithColor(contextRef, [UIColor whiteColor].CGColor);
    CGContextStrokePath(contextRef);
}
@end
