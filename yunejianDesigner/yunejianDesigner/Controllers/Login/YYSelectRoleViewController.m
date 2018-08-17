//
//  YYSelectRoleViewController.m
//  Yunejian
//
//  Created by yyj on 15/7/12.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYSelectRoleViewController.h"

#import "UIView+UpdateAutoLayoutConstraints.h"

@implementation YYSelectRoleViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    UIButton *loginBtn = [self.view viewWithTag:RoleButtonTypeCancel];
    UIButton *registerBtn = [self.view viewWithTag:RoleButtonTypeBuyer];
  
    loginBtn.layer.cornerRadius = 2.5;
    loginBtn.layer.masksToBounds = YES;
    registerBtn.layer.borderColor = [UIColor colorWithHex:@"919191"].CGColor;
    registerBtn.layer.borderWidth = 1;
    registerBtn.layer.cornerRadius = 2.5;
    registerBtn.layer.masksToBounds = YES;
    //    UIView *tempView = [[UIView alloc] init];
//    tempView.backgroundColor = [UIColor whiteColor];
//    tempView.alpha = 0.6;
//    
//    [self.view insertSubview:tempView atIndex:0];
//    __weak UIView *_weakView = self.view;
//    [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_weakView.mas_top);
//        make.left.equalTo(_weakView.mas_left);
//        make.bottom.equalTo(_weakView.mas_bottom);
//        make.right.equalTo(_weakView.mas_right);
//        
//    }];
//    
//    UIGestureRecognizer *aGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabPiece:)];
//    [tempView addGestureRecognizer:aGesture];
 
}

-(void)updateLogoIcon:(NSInteger)height{
    UIImageView *logoImage =  [self.view viewWithTag:60004];
    [logoImage setConstraintConstant:height forAttribute:NSLayoutAttributeHeight];

}

- (void)tabPiece:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (self.roleButtonClicked) {
        self.roleButtonClicked(RoleButtonTypeCancel);
    }
}

- (IBAction)buttonAction:(id)sender{
    UIButton *button = (UIButton *)sender;
    if (self.roleButtonClicked) {
        self.roleButtonClicked(button.tag);
    }
    
}



@end
