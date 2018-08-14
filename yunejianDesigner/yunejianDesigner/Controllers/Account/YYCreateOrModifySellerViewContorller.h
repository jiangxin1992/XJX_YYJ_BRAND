//
//  YYCreateOrModifySellerViewContorller.h
//  Yunejian
//
//  Created by yyj on 15/7/17.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CreateSuccess)(NSNumber *userId);

@interface YYCreateOrModifySellerViewContorller : UIViewController

@property(nonatomic,strong)CreateSuccess modifySuccess;
@property(nonatomic,strong)CancelButtonClicked cancelButtonClicked;

@end
