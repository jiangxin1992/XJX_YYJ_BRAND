//
//  YYInventoryNewTipViewCell.h
//  YunejianBuyer
//
//  Created by Apple on 16/8/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface YYInventoryNewTipViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *cellBtn;


@property(nonatomic,copy)NSIndexPath * indexPath;
@property (nonatomic,weak)id<YYTableCellDelegate> delegate;
@property(nonatomic,assign) int currentType;
-(void)updateUI;
@end
