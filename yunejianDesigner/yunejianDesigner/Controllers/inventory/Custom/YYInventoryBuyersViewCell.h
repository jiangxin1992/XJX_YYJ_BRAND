//
//  YYInventoryBuyersViewCell.h
//  yunejianDesigner
//
//  Created by Apple on 16/8/30.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYInventoryBuyerModel.h"
@interface YYInventoryBuyersViewCell : UITableViewCell
@property(nonatomic,strong)YYInventoryBuyerModel *buyerModel;
-(void)updateUI;
@end
