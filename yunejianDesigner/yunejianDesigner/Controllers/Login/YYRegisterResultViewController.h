//
//  YYRegisterResultViewController.h
//  Yunejian
//
//  Created by Apple on 15/9/27.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKCountDownButton.h"
@interface YYRegisterResultViewController : UIViewController
@property (nonatomic) NSInteger status;//0 成功 1等待验证 2验证失败
@property (nonatomic,strong) NSString *email;
- (IBAction)lookEmailHandler:(id)sender;
- (IBAction)dismissHandler:(id)sender;
- (IBAction)reSendEmailHandler:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIView *view1;
//@property (weak, nonatomic) IBOutlet UIView *view2;
//@property (weak, nonatomic) IBOutlet UIView *view3;
@property (nonatomic) NSInteger registerType;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet JKCountDownButton *sendBtn;
@end
