//
//  YYOrderHelpTextCell.h
//  YunejianBuyer
//
//  Created by Apple on 16/4/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYOrderHelpTextCell : UITableViewCell
-(void)updateCellInfo:(NSArray*)info;
+(float)heightCell:(NSArray*)info;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayoutConstraint;
@end
