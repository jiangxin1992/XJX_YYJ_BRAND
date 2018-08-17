//
//  YYOrderDetailViewController.h
//  Yunejian
//
//  Created by yyj on 15/8/6.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYOrderDetailViewController : UIViewController

@property(nonatomic,strong) NSString *currentOrderCode;

@property(nonatomic,strong) NSString *currentOrderLogo;

@property(nonatomic,assign) NSInteger currentOrderConnStatus;

@property(nonatomic,strong) CancelButtonClicked cancelButtonClicked;

@end
