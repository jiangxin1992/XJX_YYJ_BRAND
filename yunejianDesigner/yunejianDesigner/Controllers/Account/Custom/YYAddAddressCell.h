//
//  YYAddAddressCell.h
//  YunejianBuyer
//
//  Created by Apple on 16/2/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface YYAddAddressCell : UITableViewCell
@property (weak,nonatomic) id<YYTableCellDelegate>  delegate;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

- (IBAction)addBtnHandler:(id)sender;
-(void)updateUI;
@end
