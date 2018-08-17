//
//  YYUserCheckAlertViewController.h
//  Yunejian
//
//  Created by Apple on 15/12/9.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYUserCheckAlertViewController : UIViewController

@property (nonatomic) NSTextAlignment textAlignment;
@property (nonatomic,assign) BOOL needCloseBtn;
@property (nonatomic,strong) NSString *titelStr;
@property (nonatomic,strong) NSString *iconStr;
@property (nonatomic,strong) NSString *msgStr;
@property (nonatomic,strong) NSString *btnStr;
@property (nonatomic,assign) NSArray *funArray;

@property (nonatomic,strong) ModifySuccess modifySuccess;
@property (nonatomic,strong) CancelButtonClicked cancelButtonClicked;

@end
