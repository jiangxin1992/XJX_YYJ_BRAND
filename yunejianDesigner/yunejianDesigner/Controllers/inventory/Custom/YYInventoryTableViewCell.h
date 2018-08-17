//
//  YYInventoryTableViewCell.h
//  yunejianDesigner
//
//  Created by Apple on 16/8/30.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYInventoryAllottingModel.h"
@interface YYInventoryTableViewCell : UITableViewCell
@property(nonatomic,copy)NSIndexPath * indexPath;
@property (nonatomic,weak)id<YYTableCellDelegate> delegate;
@property(nonatomic,strong)YYInventoryAllottingModel * allottingModel;
-(void)updateUI;
@end
