//
//  YYOrderUseAddressCell.h
//  YunejianBuyer
//
//  Created by Apple on 16/3/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYOrderBuyerAddress.h"
@interface YYOrderUseAddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak,nonatomic) id<YYTableCellDelegate>  delegate;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (strong, nonatomic) YYOrderBuyerAddress *buyerAddress;//新增地址

-(void)updateUI;
@end
