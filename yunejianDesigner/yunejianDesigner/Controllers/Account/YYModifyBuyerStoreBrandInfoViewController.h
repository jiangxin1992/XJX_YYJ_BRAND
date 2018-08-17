//
//  YYModifyBuyerStoreBrandInfoViewController.h
//  Yunejian
//
//  Created by yyj on 15/7/20.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYBuyerStoreModel.h"

@interface YYModifyBuyerStoreBrandInfoViewController : UIViewController

@property(nonatomic,strong)ModifySuccess modifySuccess;
@property(nonatomic,strong)CancelButtonClicked cancelButtonClicked;

@property(nonatomic,strong) YYBuyerStoreModel *currenBuyerStoreModel;

@end
