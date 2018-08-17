//
//  YYSupplyStatusView.h
//  Yunejian
//
//  Created by yyj on 15/8/25.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYOrderSupplyTimeModel.h"

@interface YYSupplyStatusView : UIView

@property (nonatomic,strong) YYOrderSupplyTimeModel *orderSupplyTimeModel;
//@property (nonatomic,assign) BOOL hiddenEndSupplyTipsLabel;

- (void)updateUI;

@end
