//
//  YYOrderStatusCell.m
//  Yunejian
//
//  Created by Apple on 15/11/25.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "YYNewOrderStatusCell.h"
#import "UIColor+KTUtilities.h"
#import "YYOrderApi.h"
#import "CommonHelper.h"
#import "YYUser.h"
#import "YYYellowPanelManage.h"
#import "YYOrderApi.h"
#import "UIView+UpdateAutoLayoutConstraints.h"
@implementation YYNewOrderStatusCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)opreteBtnHandler:(id)sender {
    NSInteger tranStatus = [self.currentYYOrderTransStatusModel.transStatus integerValue];
    
    if(self.delegate){
        if(tranStatus == kOrderCode13){
//            if([_currentYYOrderInfoModel.closeReqStatus integerValue]== -1){//对方
//                [self.delegate btnClick:0 section:0 andParmas:@[@"refuseReqClose"]];
//                
//            }else if([_currentYYOrderInfoModel.closeReqStatus integerValue]== 1){
//                [self.delegate btnClick:0 section:0 andParmas:@[@"cancelReqClose"]];
//                
//            }
        }else if(tranStatus == kOrderCode10){
            [self.delegate btnClick:0 section:0 andParmas:@[@"reBuildOrder"]];
        }else{
            [self.delegate btnClick:0 section:0 andParmas:@[@"status"]];
        }
    }
}

- (IBAction)opreteBtnHandler1:(id)sender {
    NSInteger tranStatus = [self.currentYYOrderTransStatusModel.transStatus integerValue];
    
    if(self.delegate){
        if(tranStatus == kOrderCode13){
            [self.delegate btnClick:0 section:0 andParmas:@[@"agreeReqClose"]];
        }
    }
}
- (IBAction)showOprateView:(id)sender {
    NSInteger tranStatus = [self.currentYYOrderTransStatusModel.transStatus integerValue];
    
    if(self.delegate){
        if(tranStatus == kOrderCode13 || [_currentYYOrderInfoModel.closeReqStatus integerValue]== -1){
            if([_currentYYOrderInfoModel.closeReqStatus integerValue]== -1){//对方
                [self.delegate btnClick:0 section:0 andParmas:@[@"orderCloseReqDeal"]];

                //
            }else{
                [self.delegate btnClick:0 section:0 andParmas:@[@"cancelReqClose"]];
            }
        }
    }
    
}

- (IBAction)helpBtnHandler:(id)sender {
    if(self.delegate){
        [self.delegate btnClick:0 section:0 andParmas:@[@"orderHelp"]];
    }
}




-(void)updateUI{
//    statusView.hidden = NO;
    //_caneltip.hidden = YES;
    //_cancelView.hidden = YES;
    _statusStartTipView.hidden = YES;
    _getBtn.layer.cornerRadius = 2.5;
    _getBtn.layer.masksToBounds = YES;
    _getBtn.hidden = YES;
    _statusTipLabel.text = @"";
    _oprateTimerLabel.text = @"";
    _helpBtn.hidden = NO;
    _helpBtn.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:_helpBtn.titleLabel.text attributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
    _dealCloseBtn.hidden = YES;
    _statusTipLayoutConstraint.constant = 40;
    _statusTipLabel.font = [UIFont systemFontOfSize:12];
    self.contentView.backgroundColor = [UIColor colorWithHex:@"F8F8F8"];
    _statusTipLabel.textColor = [UIColor colorWithHex:@"919191"];
    _statusNameLabel.textColor = [UIColor colorWithHex:@"ed6498"];
    //_statusStartTipLabel.hidden = YES;
    //_statusStartTipLabel.backgroundColor = [UIColor colorWithHex:@"58c776"];
//    _statusViewContainer.backgroundColor = [UIColor clearColor];
//    [_statusStartTipView hideByHeight:YES];
//    if(statusView == nil){
//        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"YYOrderStatusView" owner:nil options:nil];
//        Class   targetClass = NSClassFromString(@"YYOrderStatusView");
//        for (UIView *view in views) {
//            if ([view isMemberOfClass:targetClass]) {
//                statusView =  (YYOrderStatusView *)view;
//                //statusView.hidden = YES;
//                
//                [_statusViewContainer addSubview:statusView];
//                break;
//            }
//        }
//    }
    
//    NSInteger showIndex = 0;
//    NSInteger showNum = 0;
    NSInteger tranStatus = [self.currentYYOrderInfoModel.orderStatus integerValue];
    NSInteger nextTransStatus = getOrderNextStatus(tranStatus);

    if(tranStatus == kOrderCode13 || [_currentYYOrderInfoModel.closeReqStatus integerValue]== -1){//交易申请 [_currentYYOrderInfoModel.closeReqStatus integerValue]== -1
        if([_currentYYOrderInfoModel.closeReqStatus integerValue]== -1){//对方
            //statusView.titleArray = @[@"对方申请交易关闭",@"处理中",@"交易关闭"];
            _statusNameLabel.text = @"处理中";
            [_dealCloseBtn setTitle:@"立刻处理" forState:UIControlStateNormal];
            [_dealCloseBtn setConstraintConstant:80 forAttribute:NSLayoutAttributeWidth];
        }else{
            //statusView.titleArray = @[@"申请交易关闭",@"对方处理中",@"交易关闭"];
            _statusNameLabel.text = @"对方处理中";
            [_dealCloseBtn setTitle:@"撤销交易关闭" forState:UIControlStateNormal];
            [_dealCloseBtn setConstraintConstant:108 forAttribute:NSLayoutAttributeWidth];
        }
//        statusView.progressTintColor=@"afafaf";
//        showIndex = 0;
//        showNum = 3;
//        progress = 1;
        self.contentView.backgroundColor = [UIColor colorWithHex:@"FFFFFF"];
        _statusTipLabel.font = [UIFont systemFontOfSize:14];
        _statusTipLayoutConstraint.constant = 20;
        //_oprateTimerLabel.text = [NSString stringWithFormat:@"标记于%@",getShowDateByFormatAndTimeInterval(@"YYYY/MM/dd HH:mm",[_currentYYOrderTransStatusModel.operationTime stringValue])];
        _helpBtn.hidden = YES;
        _dealCloseBtn.hidden = NO;
        _dealCloseBtn.layer.borderColor = [UIColor colorWithHex:@"919191"].CGColor;
        _dealCloseBtn.layer.borderWidth = 1;
        _dealCloseBtn.layer.cornerRadius = 2.5;
        _dealCloseBtn.layer.masksToBounds = YES;
        
        if([_currentYYOrderInfoModel.autoCloseHoursRemains integerValue]>0){
            NSInteger day = [_currentYYOrderInfoModel.autoCloseHoursRemains integerValue]/24;
            NSInteger hours = [_currentYYOrderInfoModel.autoCloseHoursRemains integerValue]%24;
            NSString *timerStr = [NSString stringWithFormat:@"%ld天%ld小时",(long)day,(long)hours];
            NSString *tipStr = nil;//[NSString stringWithFormat:@"剩余 %@，对方未处理，交易将自动关闭",timerStr];
            if([_currentYYOrderInfoModel.closeReqStatus integerValue]== -1){//对方
                tipStr = [NSString stringWithFormat:@"剩余 %@，若不予处理，则交易自动关闭",timerStr];
            }else{
                tipStr = [NSString stringWithFormat:@"剩余 %@，对方未处理，交易将自动关闭",timerStr];
            }
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString: tipStr];
            for (id numStr in @[@(day),@(hours)]) {
                NSRange range = [tipStr rangeOfString:[numStr stringValue]];
                if (range.location != NSNotFound) {
                    [attributedStr addAttribute:  NSForegroundColorAttributeName value: [UIColor colorWithHex:@"ed6498"] range:range];
                }
            }
            [_statusTipLabel setAdjustsFontSizeToFitWidth:YES];
            _statusTipLabel.attributedText = attributedStr;
            //_timerTipLabel.text =
        }else{
            _statusTipLabel.text = @"";
        }
        nextTransStatus=kOrderCode13;
        
//        if([_currentYYOrderInfoModel.autoCloseHoursRemains integerValue]>0){
//            NSInteger day = [_currentYYOrderInfoModel.autoCloseHoursRemains integerValue]/24;
//            NSInteger hours = [_currentYYOrderInfoModel.autoCloseHoursRemains integerValue]%24;
//            _statusTipLabel.text = [NSString stringWithFormat:@"剩余%ld天%ld小时，交易将自动关闭",(long)day,(long)hours];
//        }
    }else if(tranStatus == kOrderCode11){//交易关闭
//        statusView.titleArray = @[@"申请交易关闭",@"对方处理中",@"交易关闭"];
//        //_statusStartTipLabel.backgroundColor = [UIColor colorWithHex:@"58c776"];
//        statusView.progressTintColor=@"afafaf";
//        showIndex = 0;
//        showNum = 3;
//        progress = 2;
        self.contentView.backgroundColor = [UIColor colorWithHex:@"FFFFFF"];
        _statusNameLabel.text = getOrderStatusName(tranStatus,YES);
        _oprateTimerLabel.text = [NSString stringWithFormat:@"标记于%@",getShowDateByFormatAndTimeInterval(@"YYYY/MM/dd HH:mm",[_currentYYOrderTransStatusModel.operationTime stringValue])];
        nextTransStatus=tranStatus;
    }else if(tranStatus == kOrderCode10){//取消
//       statusView.hidden = YES;
        //_cancelView.hidden = NO;
        _getBtn.hidden = NO;
        NSString *orderBtnName = getOrderStatusBtnName(tranStatus,YES);
        [_getBtn setTitle:orderBtnName forState:UIControlStateNormal];
        [_getBtn setConstraintConstant:106 forAttribute:NSLayoutAttributeWidth];
        //_caneltip.hidden = NO;
        //_statusStartTipLabel.hidden = NO;
        //_statusStartTipLabel.backgroundColor = [UIColor colorWithHex:@"818181"];
        
        _statusNameLabel.text = getOrderStatusName(tranStatus,YES);
        _oprateTimerLabel.text = [NSString stringWithFormat:@"标记于%@",getShowDateByFormatAndTimeInterval(@"YYYY/MM/dd HH:mm",[_currentYYOrderTransStatusModel.operationTime stringValue])];
        _statusTipLabel.text = getOrderStatusDesignerTip(tranStatus);
        _statusNameLabel.textColor = [UIColor colorWithHex:@"ef4e31"];

        
        nextTransStatus=tranStatus;
    }else{
        if(tranStatus == kOrderCode5 || tranStatus== kOrderCode4){
            _statusStartTipView.hidden = NO;
            //[_statusStartTipView hideByHeight:NO];
        }
        //_statusNameLabel.text = getOrderStatusName(tranStatus,YES);
        NSString *statusNameStr = getOrderStatusName(tranStatus,YES);
        if(statusNameStr.length > 0){
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString: statusNameStr];
            [attributedStr addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:13] range: NSMakeRange(0, 1)];
            [attributedStr addAttribute: NSBaselineOffsetAttributeName value: @(0) range: NSMakeRange(0, 1)];
            _statusNameLabel.attributedText = attributedStr;
        }else{
            _statusNameLabel.text = @"";
        }
        
        _oprateTimerLabel.text = [NSString stringWithFormat:@"标记于%@",getShowDateByFormatAndTimeInterval(@"YYYY/MM/dd HH:mm",[_currentYYOrderTransStatusModel.operationTime stringValue])];
        if(tranStatus == kOrderCode8){
//            _getBtn.hidden = NO;
//            NSString *orderBtnName = getOrderStatusBtnName(nextTransStatus);
//            [_getBtn setTitle:orderBtnName forState:UIControlStateNormal];
//            [_getBtn setConstraintConstant:90 forAttribute:NSLayoutAttributeWidth];
            NSString *timerStr = nil;
            if([_currentYYOrderInfoModel.autoReceivedHoursRemains integerValue]>-1){
                NSInteger day = [_currentYYOrderInfoModel.autoReceivedHoursRemains integerValue]/24;
                NSInteger hours = [_currentYYOrderInfoModel.autoReceivedHoursRemains integerValue]%24;
                timerStr = [NSString stringWithFormat:@"%ld天%ld小时",(long)day,(long)hours];
            }
            if(timerStr){
                _statusTipLabel.text =[NSString stringWithFormat:getOrderStatusDesignerTip(tranStatus),timerStr] ;
            }
        }else{
            _getBtn.hidden = NO;
            _statusTipLabel.text = getOrderStatusDesignerTip(tranStatus);
        }
        if(tranStatus == kOrderCode9){
            _statusTipLabel.textColor = [UIColor colorWithHex:@"ed6498"];
        }else{
            _statusTipLabel.textColor = [UIColor colorWithHex:@"919191"];
        }
        if(nextTransStatus == kOrderCode12){
            _getBtn.hidden = YES;
        }else{
            NSString *orderBtnName = getOrderStatusBtnName(nextTransStatus,YES);
            [_getBtn setTitle:orderBtnName forState:UIControlStateNormal];
            [_getBtn setConstraintConstant:90 forAttribute:NSLayoutAttributeWidth];
        }
//        statusView.titleArray = @[@"协商中",@"协商完毕",@"合同已签",@"生产中",@"已发货",@"已收货"];
//        statusView.progressTintColor=@"ed6498";
//        //NSInteger tmpCount = [statusView.titleArray count];
//        progress = tranStatus-kOrderCode4;
//
//        showIndex = -1;
//        showNum = 3;
    }
    CGSize nameSize = [_statusNameLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25]}];
    [_statusNameLabel setConstraintConstant:nameSize.width forAttribute:NSLayoutAttributeWidth];
    
//    if(statusView != nil &&  statusView.hidden == NO){
//        statusView.showIndex = showIndex;
//        statusView.showNum = showNum;
//        statusView.curProgressValue = progress;
//        statusView.timerLabel.text = getShowDateByFormatAndTimeInterval(@"YYYY/MM/dd HH:mm",[_currentYYOrderTransStatusModel.operationTime stringValue]);
//        [statusView updateUI];
//        statusView.hidden = NO;
//    }
    //if(nextTransStatus != kOrderCode13){
    //    _statusTipLabel.text = @"";//getOrderStatusBuyerTip(nextTransStatus);
    //}
           //    YYUser *user = [[YYUser alloc] init];
    //按钮
//    NSString *orderBtnName = getOrderStatusBtnName(nextTransStatus);
//    
//    [_oprateBtn setTitle:orderBtnName forState:UIControlStateNormal];
//
//    _statusTipLabel.text = getOrderStatusDesignerTip(nextTransStatus);
//    _oprateBtn1.hidden = YES;
//    _oprateBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
//    _oprateBtn1.titleLabel.adjustsFontSizeToFitWidth = YES;
//    if(nextTransStatus == kOrderCode13){
//        if([_currentYYOrderInfoModel.closeReqStatus integerValue]== -1){//对方
//            _oprateBtn1.hidden = NO;
//            _oprateBtn.hidden = NO;
//            [_oprateBtn1 setTitle:@"同意关闭交易" forState:UIControlStateNormal];
//            [_oprateBtn setTitle:@"我方交易继续" forState:UIControlStateNormal];
//        }else if([_currentYYOrderInfoModel.closeReqStatus integerValue]== 1){//自己
//            _oprateBtn.hidden = NO;
//            [_oprateBtn setTitle:@"撤销交易关闭申请" forState:UIControlStateNormal];
//        }else{
//            _oprateBtn.hidden = YES;
//        }
//        
//        _statusTipLabel.hidden = NO;
//        if([_currentYYOrderInfoModel.autoCloseHoursRemains integerValue]>0){
//            NSInteger day = [_currentYYOrderInfoModel.autoCloseHoursRemains integerValue]/24;
//            NSInteger hours = [_currentYYOrderInfoModel.autoCloseHoursRemains integerValue]%24;
//            _statusTipLabel.text = [NSString stringWithFormat:@"剩余%ld天%ld小时，交易将自动关闭",(long)day,(long)hours];
//        }
//    }else if(nextTransStatus == kOrderCode12){
//        _oprateBtn.hidden = YES;
//        _statusTipLabel.hidden = NO;
//    }else if( nextTransStatus == kOrderCode9){
//        _oprateBtn.hidden = NO;
//        _statusTipLabel.hidden = NO;
//    }else{
//        _oprateBtn.hidden = YES;
//        _statusTipLabel.hidden = NO;
//    }
}
+(float)cellHeight:(NSInteger)tranStatus{
    if(tranStatus < kOrderCode10){
        return 111;
    }else if(tranStatus == kOrderCode10){
        return 111;
    }else if(tranStatus == kOrderCode13){
        return 98;
    }else if(tranStatus == kOrderCode11){
        return 88;
    }else{
        return 111;
    }
}
@end
