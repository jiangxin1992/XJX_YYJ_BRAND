//
//  YYBuyerModifyInfoViewController.h
//  YunejianBuyer
//
//  Created by Apple on 16/12/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

@class YYBrandHomeInfoModel;

#import <UIKit/UIKit.h>

@interface YYBrandModifyInfoViewController : UIViewController

@property(nonatomic,copy) void (^block)(NSString *type);

@property (nonatomic,strong)CancelButtonClicked cancelButtonClicked;
@property (nonatomic,strong)YYBrandHomeInfoModel *homeInfoModel;

/** 保存成功 */
@property (nonatomic,copy) void (^blockSaveSuccess)(YYBrandHomeInfoModel *homeInfoModel);

@end
