//
//  YYZbarCodeView.h
//  YunejianBuyer
//
//  Created by yyj on 2017/7/22.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYZbarCodeView : UIView

-(instancetype)initWithImageUrl:(NSString *)imageUrl WithNameStr:(NSString *)nameStr WithSuperViewController:(UIViewController *)currentVC;

@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *nameStr;
@property (nonatomic, strong) UIViewController *currentVC;

@end
