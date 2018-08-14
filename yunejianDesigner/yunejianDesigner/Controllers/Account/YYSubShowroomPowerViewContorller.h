//
//  YYSubShowroomPowerViewContorller.h
//  Yunejian
//
//  Created by yyj on 17/9/13.
//  Copyright (c) 2017年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYSubShowroomPowerViewContorller : UIViewController

/** userId */
@property (nonatomic, copy) NSNumber *userId;

/**  */
@property (nonatomic, strong) NSArray *defaultPowerArray;

@property(nonatomic,strong)ModifySuccess modifySuccess;
@property(nonatomic,strong)CancelButtonClicked cancelButtonClicked;

@end
