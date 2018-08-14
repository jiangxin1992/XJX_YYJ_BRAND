//
//  YYParcelExceptionDetailViewController.h
//  yunejianDesigner
//
//  Created by yyj on 2018/7/3.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYParcelExceptionDetailViewController : UIViewController

@property (nonatomic, strong) NSNumber *packageId;//装箱单id

@property (nonatomic, strong) CancelButtonClicked cancelButtonClicked;

@end
