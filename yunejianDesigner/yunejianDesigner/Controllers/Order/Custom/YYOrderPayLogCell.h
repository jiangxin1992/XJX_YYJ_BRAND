//
//  YYOrderPayLogCell.h
//  YunejianBuyer
//
//  Created by Apple on 16/4/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYOrderPayLogCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *dotView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
-(void)updateCellInfo:(NSArray *)value;
@end
