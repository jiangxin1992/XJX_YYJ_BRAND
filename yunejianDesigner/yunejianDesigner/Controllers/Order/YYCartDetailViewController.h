//
//  YYCartDetailViewController.h
//  Yunejian
//
//  Created by lixuezhi on 15/8/17.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^GoBackButtonClicked)();
typedef void (^ToOrderList)();

@interface YYCartDetailViewController : UIViewController

@property (strong, nonatomic) GoBackButtonClicked goBackButtonClicked;
@property (strong, nonatomic) ToOrderList toOrderList;

@end
