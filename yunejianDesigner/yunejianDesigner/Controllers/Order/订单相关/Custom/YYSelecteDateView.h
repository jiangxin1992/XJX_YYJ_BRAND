//
//  YYSelecteDateView.h
//  Yunejian
//
//  Created by yyj on 15/8/19.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYOrderOneInfoModel.h"

typedef void (^SelectDateButtonClicked)(BOOL isBeginDate,UIView *clickedView,YYOrderOneInfoModel *orderOneInfoModel);

@interface YYSelecteDateView : UIView



@property(nonatomic,strong) SelectDateButtonClicked selectDateButtonClicked;

@property(nonatomic,strong) YYOrderOneInfoModel *orderOneInfoModel;

- (void)updateUI;

@end
