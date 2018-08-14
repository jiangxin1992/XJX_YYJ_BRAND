//
//  YYOrderAddressListCell.h
//  Yunejian
//
//  Created by Apple on 15/10/26.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYBuyerModel.h"
#import "SCGIFImageView.h"
@interface YYOrderAddressListCell : UITableViewCell
@property (nonatomic,copy) YYBuyerModel *infoModel;
@property (nonatomic,copy) YYBuyerModel *curModel;
@property (weak, nonatomic) IBOutlet SCGIFImageView *logoView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *unregisterTiplabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel1;
-(void)updateUI;
@end
