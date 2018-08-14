//
//  YYBuyerModifyInfoSocialViewCell.h
//  YunejianBuyer
//
//  Created by Apple on 16/12/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYBuyerModifyInfoSocialViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property(copy, nonatomic) SelectedValue selectedValue;
@property (strong,nonatomic) NSArray *socialArr;
@property (assign, nonatomic)NSInteger socialType;
-(void)updateUI;
@end
