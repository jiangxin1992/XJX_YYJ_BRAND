//
//  YYBuyerHomePageViewController.h
//  YunejianBuyer
//
//  Created by yyj on 2017/1/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYBuyerHomePageViewController : UIViewController

@property (nonatomic, assign) NSInteger buyerId;
@property (nonatomic, strong) NSString *previousTitle;

@property (nonatomic, assign) BOOL isHomePage;

@property (nonatomic, copy) void (^readblock)(NSString *type);

@property (nonatomic, strong) ModifySuccess modifySuccess;
@property (nonatomic, strong) CancelButtonClicked cancelButtonClicked;

@end
