//
//  YYOrderHelpNumTextCell.h
//  YunejianBuyer
//
//  Created by Apple on 16/4/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYOrderHelpNumTextCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceLayoutConstriant;
-(void)updateCellInfo:(NSArray*)info;
+(float)heightCell:(NSArray*)info;
@end
