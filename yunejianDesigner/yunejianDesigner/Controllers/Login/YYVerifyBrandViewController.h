//
//  YYVerifyBrandViewController.h
//  yunejianDesigner
//
//  Created by Victor on 2017/12/21.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYVerifyBrandViewController : UIViewController

//品牌审核
@property(nonatomic,assign) NSInteger uploadImgType;
@property(nonatomic,strong) UIImage *uploadImg1;
@property(nonatomic,strong) UIImage *uploadImg2;

@property(nonatomic,assign) int registerType;

@end
