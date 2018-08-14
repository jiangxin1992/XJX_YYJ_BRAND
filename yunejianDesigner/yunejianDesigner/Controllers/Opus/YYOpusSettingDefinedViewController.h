//
//  YYOpusSettingDefinedViewController.h
//  yunejianDesigner
//
//  Created by Apple on 16/11/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface YYOpusSettingDefinedViewController : UIViewController

@property(nonatomic,strong)SelectedValue selectedValue;
@property(nonatomic,strong)CancelButtonClicked cancelButtonClicked;

@property(nonatomic,assign)NSInteger seriesId;
@property(nonatomic,assign)NSInteger authType;
@end
