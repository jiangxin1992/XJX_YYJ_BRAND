//
//  YYModifyDesignerBrandInfoViewController.h
//  Yunejian
//
//  Created by yyj on 15/7/20.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYBrandInfoModel.h"

@interface YYModifyDesignerBrandInfoViewController : UIViewController

@property(nonatomic,strong)ModifySuccess modifySuccess;
@property(nonatomic,strong)CancelButtonClicked cancelButtonClicked;

@property(nonatomic,strong) YYBrandInfoModel *currenDesingerBrandInfoModel;

@end
