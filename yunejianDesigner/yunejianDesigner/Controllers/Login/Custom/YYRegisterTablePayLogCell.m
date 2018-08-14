//
//  YYRegisterTablePayLogCell.m
//  YunejianBuyer
//
//  Created by Apple on 16/7/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYRegisterTablePayLogCell.h"

#import "UIImage+Tint.h"

@implementation YYRegisterTablePayLogCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)updateCellInfo:(NSArray *)info{
    
    if([LanguageManager isEnglishLanguage]){
        _curTitleLabelWidthLayout1.constant = 150;
        _curTitleLabelWidthLayout2.constant = 150;
        _curTitleLabelWidthLayout3.constant = 150;
        _curTitleLabelWidthLayout4.constant = 150;
        _curTitleLabelWidthLayout5.constant = 150;
    }else{
        _curTitleLabelWidthLayout1.constant = 95;
        _curTitleLabelWidthLayout2.constant = 95;
        _curTitleLabelWidthLayout3.constant = 95;
        _curTitleLabelWidthLayout4.constant = 95;
        _curTitleLabelWidthLayout5.constant = 95;
    }
    
    _makeSureBtn.layer.cornerRadius = 2.5;
    _cancelBtn.layer.borderWidth = 1;
    _cancelBtn.layer.borderColor = [UIColor blackColor].CGColor;
    _cancelBtn.layer.cornerRadius = 2.5;
    //_deleteBtn.layer.borderWidth = 1;
    //_deleteBtn.layer.borderColor = [UIColor colorWithHex:@"ef4e31"].CGColor;
    _deleteBtn.layer.cornerRadius = 2.5;
    [_deleteBtn setImage:[[UIImage imageNamed:@"delete1"] imageWithTintColor:[UIColor colorWithHex:@"ef4e31"]] forState:UIControlStateNormal];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    YYRegisterTableCellInfoModel *infoModel1 = [info objectAtIndex:0];
    //NSArray *valueArr = [infoModel1.value componentsSeparatedByString:@"|"];
    UILabel *label1 = [self.contentView viewWithTag:10001];
    UILabel *label2 = [self.contentView viewWithTag:10002];
    UILabel *label3 = [self.contentView viewWithTag:10003];
    UILabel *label4 = [self.contentView viewWithTag:10004];
    UILabel *label5 = [self.contentView viewWithTag:10005];
    label5.font = [UIFont systemFontOfSize:12];

    //    if(valueArr && [valueArr count] >=4){
    //        label1.text = [valueArr objectAtIndex:0];
    //        label2.text = [valueArr objectAtIndex:1];
    //        label3.text = [valueArr objectAtIndex:2];
    //        label4.text = [valueArr objectAtIndex:3];
    //        label5.text = [valueArr objectAtIndex:4];
    //
    //    }
    
    _makeSureBtn.hidden = YES;
    _makeSureBtn.enabled = YES;
    _makeSureBtn.backgroundColor = [UIColor blackColor];
    _cancelBtn.hidden = YES;
    _deleteBtn.hidden = YES;
    if( [_noteModel.payType integerValue] == 0){
        _curTitleLabel2.text = NSLocalizedString(@"支付方式",nil);
        _curTitleLabel3.text = NSLocalizedString(@"交易单号",nil);
        _curTitleLabel4.text = NSLocalizedString(@"添加时间",nil);
        _curTitleLabel5.text = NSLocalizedString(@"确认时间",nil);
        if([_noteModel.payStatus integerValue] == 0){
            _makeSureBtn.hidden = NO;
            if(([_noteModel.tmpPercent integerValue] + [_noteModel.percent integerValue]) >100){
                _makeSureBtn.enabled = NO;
                _makeSureBtn.backgroundColor = [UIColor colorWithHex:@"d3d3d3"];

            }
            _cancelBtn.hidden = NO;
            label5.text = @"";//getShowDateByFormatAndTimeInterval(@"yyyy-MM-dd HH:mm:ss",[_noteModel.modifyTime stringValue]);

        }else if([_noteModel.payStatus integerValue] == 2){
            _deleteBtn.hidden = NO;
            _curTitleLabel5.text = NSLocalizedString(@"作废时间",nil);
            label5.text = getShowDateByFormatAndTimeInterval(@"yyyy-MM-dd HH:mm:ss",[_noteModel.modifyTime stringValue]);;

        }else{
            label5.text = getShowDateByFormatAndTimeInterval(@"yyyy-MM-dd HH:mm:ss",[_noteModel.modifyTime stringValue]);
        }
        label1.text = _noteModel.orderCode;
        label2.text = NSLocalizedString(@"线下支付",nil);
        label3.text = _noteModel.outTradeNo;
        label4.text = getShowDateByFormatAndTimeInterval(@"yyyy-MM-dd HH:mm:ss",[_noteModel.createTime stringValue]);
    }else{
        _curTitleLabel2.text = NSLocalizedString(@"交易单号",nil);
        _curTitleLabel3.text = NSLocalizedString(@"支付宝流水号",nil);
        _curTitleLabel4.text = NSLocalizedString(@"付款时间",nil);
        _curTitleLabel5.text = NSLocalizedString(@"到账时间",nil);
        NSString *payTimer = @"";
        if(_noteModel.onlinePayDetail.payTime){
            payTimer = getShowDateByFormatAndTimeInterval(@"yyyy-MM-dd HH:mm:ss",_noteModel.onlinePayDetail.payTime);
        }
        NSString *getTimer = @"";
        if(_noteModel.onlinePayDetail.accountTime){
            getTimer = getShowDateByFormatAndTimeInterval(@"yyyy-MM-dd HH:mm:ss",_noteModel.onlinePayDetail.accountTime);
        }else{
            getTimer = NSLocalizedString(@"请耐心等待2-3个工作日到账",nil);
            label5.font =  [UIFont boldSystemFontOfSize:12];
        }
        label1.text = _noteModel.orderCode;
        label2.text = _noteModel.outTradeNo;
        label3.text = _noteModel.onlinePayDetail.tradeNo;
        label4.text = payTimer;
        label5.text = getTimer;
    }
    
}
- (IBAction)makeSureBtnHandler:(id)sender {
    if(self.delegate){
        [self.delegate selectClick:_indexPath.row AndSection:_indexPath.section andParmas:@[@"makesure",@(-1)]];
    }
}
- (IBAction)deleteBtnHandler:(id)sender {
    if(self.delegate){
        [self.delegate selectClick:_indexPath.row AndSection:_indexPath.section andParmas:@[@"delete",@(-1)]];
    }
}
- (IBAction)cancel:(id)sender {
    if(self.delegate){
        [self.delegate selectClick:_indexPath.row AndSection:_indexPath.section andParmas:@[@"cancel",@(-1)]];
    }
}
@end
