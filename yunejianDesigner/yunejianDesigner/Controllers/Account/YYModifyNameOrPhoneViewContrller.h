//
//  YYModifyNameOrPhoneViewContrller.h
//  Yunejian
//
//  Created by yyj on 15/7/16.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYUserInfo.h"
#import "YYUserInfoCell.h"

@interface YYModifyNameOrPhoneViewContrller : UIViewController


@property(nonatomic,strong)ModifySuccess modifySuccess;
@property(nonatomic,strong)CancelButtonClicked cancelButtonClicked;

@property(nonatomic,strong)YYUserInfo *userInfo;
@property(nonatomic,assign)ShowType currentShowType;

@end
