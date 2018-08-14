//
//  YYPackageDetailViewController.h
//  yunejianDesigner
//
//  Created by yyj on 2018/6/28.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYPackageModel;

@interface YYPackageDetailViewController : UIViewController

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) YYPackageModel *packageModel;

@property (nonatomic, strong) NSString *packageName;

@property (nonatomic, strong) CancelButtonClicked cancelButtonClicked;

@end
