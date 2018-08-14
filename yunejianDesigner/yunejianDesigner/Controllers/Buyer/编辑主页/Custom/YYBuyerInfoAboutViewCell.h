//
//  YYBuyerInfoAboutTableViewCell.h
//  YunejianBuyer
//
//  Created by Apple on 16/12/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYBuyerHomeInfoModel.h"
@interface YYBuyerInfoAboutViewCell : UITableViewCell
@property (strong,nonatomic) YYBuyerHomeInfoModel *homeInfoModel;
-(void)updateUI;
+(float)cellHeight:(YYBuyerHomeInfoModel *)homeInfoModel;
@end
