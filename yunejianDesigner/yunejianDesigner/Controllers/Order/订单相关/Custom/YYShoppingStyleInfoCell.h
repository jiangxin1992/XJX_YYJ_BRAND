//
//  YYShoppingStyleInfoCell.h
//  YunejianBuyer
//
//  Created by Apple on 16/2/26.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYStyleInfoModel,YYOpusStyleModel,YYOpusSeriesModel,SCGIFImageView;

@interface YYShoppingStyleInfoCell : UITableViewCell

@property (nonatomic,copy) void (^changeChooseStyle)();

@property (nonatomic, assign) BOOL isOnlyColor;
@property (nonatomic, assign) BOOL isModifyOrder;

@property (nonatomic, strong) YYOpusSeriesModel *opusSeriesModel;
@property (nonatomic, strong) YYOpusStyleModel *opusStyleModel;
@property (nonatomic, strong) YYStyleInfoModel *styleInfoModel;

-(void)updateUI;

@end
