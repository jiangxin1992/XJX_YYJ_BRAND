//
//  YYLogisticsDetailView.h
//  yunejianDesigner
//
//  Created by yyj on 2018/7/2.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYPackingListDetailModel;

@interface YYLogisticsDetailView : UIView

@property (nonatomic, strong) CancelButtonClicked cancelButtonClicked;

@property (nonatomic, strong) YYPackingListDetailModel *packingListDetailModel;

-(void)updateUI;

@end
