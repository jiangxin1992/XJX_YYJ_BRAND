//
//  YYConnInfoListCell.h
//  Yunejian
//
//  Created by Apple on 15/12/1.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYConnBuyerModel.h"
#import "SCGIFImageView.h"
@interface YYConnInfoListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet SCGIFImageView *buyerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLable;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIButton *oprateBtn;

- (IBAction)oprateBtnHandler:(id)sender;
@property (nonatomic,strong)YYConnBuyerModel *buyermodel;
@property (weak,nonatomic) id<YYTableCellDelegate>  delegate;
@property (nonatomic,strong) NSIndexPath *indexPath;
-(void)updateUI;
@end
