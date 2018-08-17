//
//  YYInventoryDetailStyleBuyerInfoCell.h
//  yunejianDesigner
//
//  Created by Apple on 16/8/30.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYInventoryStyleDemandModel.h"

@interface YYInventoryDetailStyleBuyerInfoCell : UITableViewCell

@property(nonatomic,copy)NSIndexPath * indexPath;
@property (nonatomic,weak)id<YYTableCellDelegate> delegate;
@property(nonatomic,strong)YYInventoryStyleDemandModel *styleDemandModel;
@property(nonatomic,assign)BOOL isShow;

-(void)updateUI;
@end
