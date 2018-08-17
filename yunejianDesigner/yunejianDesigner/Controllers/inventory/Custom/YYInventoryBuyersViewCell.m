//
//  YYInventoryBuyersViewCell.m
//  yunejianDesigner
//
//  Created by Apple on 16/8/30.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYInventoryBuyersViewCell.h"
#import "SCGIFImageView.h"
@interface YYInventoryBuyersViewCell()
@property (weak, nonatomic) IBOutlet SCGIFImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *buyerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderCountLabel;

@end
@implementation YYInventoryBuyersViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *imageRelativePath = _buyerModel.buyerLogo;
    sd_downloadWebImageWithRelativePath(NO, imageRelativePath, _logoImageView, kLogoCover, 0);
    _buyerNameLabel.text = _buyerModel.buyerName;
    _orderCountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"共%ld个订单",nil),[_buyerModel.orderCodes count]];
}
@end
