//
//  YYOrderColseProgressCell.h
//  YunejianBuyer
//
//  Created by Apple on 16/4/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYOrderColseProgressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel3;
@property (weak, nonatomic) IBOutlet UIView *progressLine1;
@property (weak, nonatomic) IBOutlet UIView *progressLine2;
@property (weak, nonatomic) IBOutlet UILabel *progressNumLabel1;
@property (weak, nonatomic) IBOutlet UILabel *progressNumLabel2;
@property (weak, nonatomic) IBOutlet UILabel *progressNumLabel3;
@property (nonatomic,retain) NSArray *titleArr;
@property (nonatomic,assign) NSInteger progressValue;
-(void)updateUI;
@end
