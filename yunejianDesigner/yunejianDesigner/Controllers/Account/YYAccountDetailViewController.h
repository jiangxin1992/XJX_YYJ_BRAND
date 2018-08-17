//
//  YYAccountDetailViewController.h
//  Yunejian
//
//  Created by yyj on 15/7/12.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYAccountDetailViewController : UIViewController

-(void) checkUserIdentity;

@property (nonatomic, strong) CancelButtonClicked cancelButtonClicked;

@property (nonatomic, strong) ModifySuccess modifySuccess;

@end
