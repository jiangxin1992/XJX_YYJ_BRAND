//
//  YYBuyerModifyInfoTxtViewCell.h
//  YunejianBuyer
//
//  Created by Apple on 16/12/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYBuyerModifyInfoTxtViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIView *downline;

@property(copy, nonatomic) SelectedValue selectedValue;
-(void)downlineIsHide:(BOOL )ishide;
@end
