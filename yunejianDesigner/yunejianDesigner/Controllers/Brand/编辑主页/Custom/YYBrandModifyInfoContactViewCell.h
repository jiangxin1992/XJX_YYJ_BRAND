//
//  YYBuyerModifyInfoContactViewCell.h
//  YunejianBuyer
//
//  Created by Apple on 16/12/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYBrandModifyInfoContactViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
@property (weak, nonatomic) IBOutlet UIView *downline;
@property(copy, nonatomic) SelectedValue selectedValue;
@property (strong,nonatomic) NSArray *conractArr;
@property (assign,nonatomic) NSInteger conractType;
-(void)updateUI;
-(void)downlineIsHide:(BOOL )ishide;
@end
