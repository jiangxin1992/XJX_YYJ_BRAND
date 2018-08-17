//
//  YYSelectRoleViewController.h
//  Yunejian
//
//  Created by yyj on 15/7/12.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RoleButtonType) {
    RoleButtonTypeDesigner = 60000,
    RoleButtonTypeBuyer = 60001,
    RoleButtonTypeCancel = 60002
};

typedef void (^RoleButtonClicked)(RoleButtonType buttonType);

@interface YYSelectRoleViewController : UIViewController

@property(nonatomic,strong) RoleButtonClicked roleButtonClicked;

-(void)updateLogoIcon:(NSInteger)height;
@end
