//
//  YYNewsTableViewCell.h
//  YunejianBuyer
//
//  Created by Apple on 16/9/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYNewsInfoModel;

@interface YYNewsTableViewCell : UITableViewCell

@property (nonatomic,strong) YYNewsInfoModel *infoModel;

-(void)updateUI;

@end

