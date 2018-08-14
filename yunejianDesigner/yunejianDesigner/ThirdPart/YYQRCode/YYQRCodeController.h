//
//  YYQRCodeController.h
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

#import <UIKit/UIKit.h>
@class YYQRCodeController;

@interface YYQRCodeController : UIViewController

  /**
   创建对象，presentViewController

   @param block 扫描结果
   @return 对象
   */
+ (instancetype)QRCodeSuccessMessageBlock:(void(^)(YYQRCodeController *code, NSString *messageString))block;

/**
 退出界面
 */
- (void)dismissController;

/**
 重新扫描
 */
- (void)scanningAgain;

/**
 打印吐司，显示title

 @param title 需要显示的吐司
 @param block 5秒后的回调
 */
- (void)toast:(NSString *)title collback:(void(^)(YYQRCodeController *code))block;

@end
