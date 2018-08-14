//
//  YYOrderPayLogViewCell.m
//  YunejianBuyer
//
//  Created by Apple on 16/7/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYOrderPayLogViewCell.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图

// 接口

// 分类
#import "UIImage+Tint.h"
#import "UIView+UpdateAutoLayoutConstraints.h"

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYPaymentNoteModel.h"

@interface YYOrderPayLogViewCell()

@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIButton *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusBtn;
@property (weak, nonatomic) IBOutlet UIView *redDotView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleBtnWidthLayout;
@property (nonatomic, strong) UIImage *statusImage;

@end

@implementation YYOrderPayLogViewCell

-(void)updateUI{

    if(IsPhone6_gt){
        _titleBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
    }else{
        _titleBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _titleLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *preTitleStr = nil;
    NSInteger statusValue = [_noteModel.payStatus integerValue];
    _redDotView.hidden = YES;
    [_redDotView setConstraintConstant:0 forAttribute:NSLayoutAttributeWidth];
    NSString *titleLabelTextColor = @"000000";
    if([_noteModel.payType integerValue] == 0){
        _titleBtnWidthLayout.constant = 110;
        preTitleStr = NSLocalizedString(@"线下收款",nil);
        [_titleBtn setTitle:preTitleStr forState:UIControlStateNormal];
        [_titleBtn setImage:nil forState:UIControlStateNormal];
        [_titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _titleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        
        if(statusValue == 0){//支付状态(线下) 0:待确认 1：成功到账 2：已作废
            [_statusLabel setImage:nil forState:UIControlStateNormal];
            [_statusLabel setTitleColor:[UIColor colorWithHex:@"ef4e31"] forState:UIControlStateNormal];
            [_statusLabel setTitle:NSLocalizedString(@"待确认",nil) forState:UIControlStateNormal];
            _redDotView.layer.cornerRadius = 3;
            _redDotView.hidden = NO;
            [_redDotView setConstraintConstant:6 forAttribute:NSLayoutAttributeWidth];
            [_titleBtn setTitleColor:[UIColor colorWithHex:@"919191"] forState:UIControlStateNormal];
            titleLabelTextColor = @"919191";
        }else if(statusValue == 1){
            [_statusLabel setImage:nil forState:UIControlStateNormal];
            [_statusLabel setTitleColor:[UIColor colorWithHex:@"58c776"] forState:UIControlStateNormal];
            [_statusLabel setTitle:NSLocalizedString(@"成功到账",nil) forState:UIControlStateNormal];
        }else if(statusValue == 2){
            [_statusLabel setImage:[[UIImage imageNamed:@"cancel"] imageWithTintColor:[UIColor colorWithHex:@"919191"]] forState:UIControlStateNormal];
            [_statusLabel setTitleColor:[UIColor colorWithHex:@"919191"] forState:UIControlStateNormal];
            [_statusLabel setTitle:NSLocalizedString(@"已作废",nil) forState:UIControlStateNormal];
            [_titleBtn setTitleColor:[UIColor colorWithHex:@"919191"] forState:UIControlStateNormal];
            titleLabelTextColor = @"919191";
        }
    }else{
        _titleBtnWidthLayout.constant = 80;
        preTitleStr = NSLocalizedString(@"收款",nil);
        [_titleBtn setTitle:preTitleStr forState:UIControlStateNormal];
        [_titleBtn setImage:[UIImage imageNamed:@"alipay_small_icon"] forState:UIControlStateNormal];
        [_titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _titleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
        
        [_statusLabel setImage:nil forState:UIControlStateNormal];
        [_statusLabel setTitleColor:[UIColor colorWithHex:@"58c776"] forState:UIControlStateNormal];
        [_statusLabel setTitle:NSLocalizedString(@"货款审核中",nil) forState:UIControlStateNormal];
        if([_noteModel.payStatus integerValue] == 1 && _noteModel.onlinePayDetail && [_noteModel.onlinePayDetail.transStatus integerValue] == 2){
            if(_noteModel.onlinePayDetail.accountTime !=nil){
                [_statusLabel setTitle:NSLocalizedString(@"成功到账",nil) forState:UIControlStateNormal];
            }else{
                [_statusLabel setTitle:@"" forState:UIControlStateNormal];
            }
        }else{
        }
    }
    NSString *percent = [NSString stringWithFormat:@"%.2lf%@",[_noteModel.realPercent floatValue],@"%"];//;
    NSString *titleStr = [NSString stringWithFormat:@"%@ ￥%.2lf",percent,[_noteModel.amount floatValue]];
    _titleLabel.textColor = [UIColor colorWithHex:titleLabelTextColor];
    NSRange range = [titleStr rangeOfString:percent];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:titleStr];
    if(range.location != NSNotFound){
        if([titleLabelTextColor isEqualToString:@"000000"]){
            [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"ed6498"] range:range];
        }else{
            [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:titleLabelTextColor] range:range];
        }
        if(IsPhone6_gt){
            [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:range];
        }else{
            [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:range];
        }
    }
    _titleLabel.attributedText = attrStr;
    CGSize titleSize = [titleStr sizeWithAttributes:@{NSFontAttributeName:_titleLabel.font}];
    [_titleLabel setConstraintConstant:titleSize.width+1 forAttribute:NSLayoutAttributeWidth];
    _timerLabel.text = getShowDateByFormatAndTimeInterval(@"yyyy-MM-dd HH:mm:ss",[_noteModel.createTime stringValue]);
}
#pragma mark - Other
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
