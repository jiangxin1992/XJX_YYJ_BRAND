//
//  YYBuyerInfoRemarkCell.h
//  Yunejian
//
//  Created by Apple on 15/10/26.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYBuyerInfoRemarkCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderCodeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderCodeWidthLayout;
@property (weak, nonatomic) IBOutlet UILabel *orderCreateTimerLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderCreateWidthLayout;
@property (weak, nonatomic) IBOutlet UILabel *orderRemarkLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderRemarkWidthLayout;
@property (weak, nonatomic) IBOutlet UILabel *orderCreatePersonLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderCreatePersonWidthLayout;
@property (weak, nonatomic) IBOutlet UILabel *orderCreateOccasionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderCreateOccasionWidthLayout;
-(void)updateUI:(NSArray*)info;
+(NSInteger)getCellHeight:(NSString *)desc;
@end
