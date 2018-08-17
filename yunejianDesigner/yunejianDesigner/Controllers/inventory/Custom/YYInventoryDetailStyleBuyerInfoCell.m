//
//  YYInventoryDetailStyleBuyerInfoCell.m
//  yunejianDesigner
//
//  Created by Apple on 16/8/30.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYInventoryDetailStyleBuyerInfoCell.h"

@interface YYInventoryDetailStyleBuyerInfoCell()
@property (weak, nonatomic) IBOutlet UILabel *styleNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *styleSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *resloveBtn;
@property (weak, nonatomic) IBOutlet UIImageView *hasResloveFlagView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneBtnLayoutLeftConstraint;
@property (weak, nonatomic) IBOutlet UIView *infoView;

@end
@implementation YYInventoryDetailStyleBuyerInfoCell

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

    _styleNumLabel.text= [NSString stringWithFormat:NSLocalizedString(@"%@ 件",nil),_styleDemandModel.amount];//
    _styleSizeLabel.text = _styleDemandModel.sizeName;
    _buyerNameLabel.text = _styleDemandModel.buyerName;
    _timerLabel.text = getShowDateByFormatAndTimeInterval(@"yyyy/MM/dd  HH:mm",[_styleDemandModel.created stringValue]);
    if([_styleDemandModel.status integerValue]){
        _hasResloveFlagView.hidden = NO;
        _styleNumLabel.textColor = [UIColor colorWithHex:@"919191"];
        _styleSizeLabel.textColor = [UIColor colorWithHex:@"919191"];
        _buyerNameLabel.textColor = [UIColor colorWithHex:@"919191"];
        _resloveBtn.hidden=YES;
        _phoneBtnLayoutLeftConstraint.constant = 23-13;
    }else{
        _hasResloveFlagView.hidden = YES;
        _styleNumLabel.textColor = [UIColor blackColor];
        _styleSizeLabel.textColor = [UIColor blackColor];
        _buyerNameLabel.textColor = [UIColor blackColor];
        _resloveBtn.hidden=NO;
        _phoneBtnLayoutLeftConstraint.constant = 121-13;
        
        _resloveBtn.layer.cornerRadius = 2.5;
        _resloveBtn.layer.borderColor = [UIColor blackColor].CGColor;
        _resloveBtn.layer.borderWidth = 1;
        _resloveBtn.layer.masksToBounds = YES;
    }
    _infoView.hidden = !_isShow;
}
- (IBAction)phoneBtnHandler:(id)sender {
    //buyerInfo
    
        if(self.delegate){
            [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:@[@"buyerInfo"]];
        }
}
- (IBAction)setStatusHandler:(id)sender {
    if(self.delegate){
        [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:@[@"SetResolve"]];
    }
}
@end
