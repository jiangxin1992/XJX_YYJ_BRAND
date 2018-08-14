//
//  YYBuyerInfoConactViewCell.h
//  YunejianBuyer
//
//  Created by Apple on 16/12/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYBuyerHomeInfoModel.h"
@interface YYBuyerInfoConactViewCell : UITableViewCell
@property(nonatomic, strong)YYBuyerHomeInfoModel *homeInfoModel;
-(void)updateUI;
@end
