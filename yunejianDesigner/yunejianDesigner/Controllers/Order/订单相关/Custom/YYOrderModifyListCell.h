//
//  YYOrderModifyListCell.h
//  Yunejian
//
//  Created by Apple on 15/10/29.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYOrderInfoModel.h"
#import "SCGIFImageView.h"
@interface YYOrderModifyListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderCodeLabel;
@property (weak, nonatomic) IBOutlet SCGIFImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *buyerLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property(nonatomic,strong) NSString *currentOrderLogo;

-(void)updateUI;
@end
