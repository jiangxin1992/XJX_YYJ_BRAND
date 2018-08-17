//
//  YYTaxChooseViewController.h
//  yunejianDesigner
//
//  Created by yyj on 2017/6/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYTaxChooseViewController : UIViewController

//再加一个选择block
@property(nonatomic,copy) void (^selectBlock)(NSInteger selectIndex);

@property (nonatomic,strong)CancelButtonClicked cancelButtonClicked;

@property (nonatomic,strong) NSMutableArray *selectData;

@property (nonatomic,assign) NSInteger selectIndex;

@end
