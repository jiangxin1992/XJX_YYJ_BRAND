//
//  YYUserBrandInfoCell.h
//  yunejianDesigner
//
//  Created by Apple on 16/7/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYUserInfo.h"
typedef void (^BrandVerifyButtonClicked)(YYUserInfo *userInfo);

@interface YYUserBrandInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *modifyButton;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
//@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@property(nonatomic,strong)YYUserInfo *userInfo;

@property(nonatomic,strong)BrandVerifyButtonClicked modifyButtonClicked;

- (void)updateUI;
@end
