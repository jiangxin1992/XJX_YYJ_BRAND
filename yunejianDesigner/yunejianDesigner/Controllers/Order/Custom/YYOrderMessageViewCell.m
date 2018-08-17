//
//  YYOrderMessageViewCell.m
//  Yunejian
//
//  Created by Apple on 15/10/27.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "YYOrderMessageViewCell.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图

// 接口
#import "YYOrderApi.h"

// 分类
#import "UIImage+YYImage.h"
#import "UIView+UpdateAutoLayoutConstraints.h"

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYOrderMessageInfoModel.h"

@interface YYOrderMessageViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *messageTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageTimerLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageTimerLabelWidthLayout;
@property (weak, nonatomic) IBOutlet UIImageView *oprateTipIcon;
@property (weak, nonatomic) IBOutlet UILabel *oprateTipLabel;
@property (weak, nonatomic) IBOutlet UIView *oprateTipLine;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipLabelWidthLayout;
@property (weak, nonatomic) IBOutlet UILabel *buyerLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimerLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderRefuseReasonLabel;

@property (weak, nonatomic) IBOutlet UIButton *refuseBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

@end

@implementation YYOrderMessageViewCell

#pragma mark - --------------生命周期--------------

- (void)awakeFromNib {
    [super awakeFromNib];
    [self SomePrepare];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
#pragma mark - --------------SomePrepare--------------
- (void)SomePrepare{
    [self PrepareData];
    [self PrepareUI];
}
- (void)PrepareData{}
- (void)PrepareUI{
    _tipLabelWidthLayout.constant = [LanguageManager isEnglishLanguage]?115:80;
    self.refuseBtn.layer.borderColor = [UIColor colorWithHex:@"efefef"].CGColor;
    self.refuseBtn.layer.borderWidth = 1;
    self.refuseBtn.layer.cornerRadius = 2.5;
    self.refuseBtn.layer.masksToBounds = YES;
    self.agreeBtn.layer.cornerRadius = 2.5;
    self.agreeBtn.layer.masksToBounds = YES;
    _bottomView.layer.cornerRadius = CGRectGetWidth(_bottomView.frame)/2;
    _bottomView.layer.masksToBounds = YES;
    _oprateTipLabel.adjustsFontSizeToFitWidth = YES;

}
#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{

    if(_msgInfoModel.isRead == NO){
        _bottomView.hidden = NO;
    }else{
        _bottomView.hidden = YES;
    }

    _messageTitleLabel.text = [NSString stringWithFormat:@"%@ %@",_msgInfoModel.msgTitle ,([_msgInfoModel.isAppendOrder integerValue]?NSLocalizedString(@"(追单)",nil):@"")];
    _messageTimerLabel.text = getShowDateByFormatAndTimeInterval(@"MM/dd HH:mm",[_msgInfoModel.sendTime stringValue]);
    _messageTimerLabelWidthLayout.constant = getWidthWithHeight(19, _messageTimerLabel.text, _messageTimerLabel.font);
    if(_msgInfoModel.msgContent){
        _buyerLabel.text =  [NSString stringWithFormat:@"%@%@",_msgInfoModel.msgContent.brandName ,([_msgInfoModel.isAppendOrder integerValue]?NSLocalizedString(@"(追单)",nil):@"")];
    }else{
        _buyerLabel.text = @"";
    }
    _orderCodeLabel.text =  [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"订单号：",nil),_msgInfoModel.msgContent.orderCode ];//
    _orderTimerLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"建单时间：",nil),getShowDateByFormatAndTimeInterval(@"yyyy/MM/dd  HH:mm",[_msgInfoModel.msgContent.orderCreateTime stringValue])];

    NSInteger moneyType = (_msgInfoModel.msgContent.curType!=nil?[_msgInfoModel.msgContent.curType integerValue]:0);
    _orderPriceLabel.text = replaceMoneyFlag([NSString stringWithFormat:replaceMoneyFlag(@"%@：%@ %@ %@ %@ ￥%@",moneyType),NSLocalizedString(@"共计",nil),_msgInfoModel.msgContent.styleNum,NSLocalizedString(@"款",nil),_msgInfoModel.msgContent.totalAmount,NSLocalizedString(@"件",nil),_msgInfoModel.msgContent.totalPrice],moneyType);


    BOOL isCount = NO;//是否是倒计时

    [_oprateTipIcon hideByHeight:YES];
    [_oprateTipLine hideByHeight:YES];
    [_oprateTipLabel hideByHeight:YES];

    _orderRefuseReasonLabel.text = @"";

    if(_msgInfoModel.msgContent && ![NSString isNilOrEmpty:_msgInfoModel.msgContent.op]){
        if([_msgInfoModel.msgContent.op isEqualToString:@"need_confirm"]){
            _tipLabel.hidden = YES;
            if([_msgInfoModel.dealStatus integerValue] == -1){
                if(_msgInfoModel.orderTransStatus && [_msgInfoModel.orderTransStatus integerValue] != 4){
                    //双方都已确认
                    _agreeBtn.hidden = YES;
                    _refuseBtn.hidden = YES;
                }else{
                    //我待确认(对方已确认)
                    _agreeBtn.hidden = NO;
                    _refuseBtn.hidden = NO;
                    [_agreeBtn setTitle:NSLocalizedString(@"确认",nil) forState:UIControlStateNormal];
                    [_refuseBtn setTitle:NSLocalizedString(@"拒绝",nil) forState:UIControlStateNormal];
                }
            }else if([_msgInfoModel.dealStatus integerValue] == 1){
                //我已确认
                _agreeBtn.hidden = YES;
                _refuseBtn.hidden = YES;
            }if([_msgInfoModel.dealStatus integerValue] == 2){
                //我已拒绝
                _agreeBtn.hidden = YES;
                _refuseBtn.hidden = YES;
            }
        }else if([_msgInfoModel.msgContent.op isEqualToString:@"order_rejected"]){
            //对方已拒绝
            _agreeBtn.hidden = YES;
            _refuseBtn.hidden = YES;
            NSString *reason = [[NSString alloc] initWithFormat:NSLocalizedString(@"拒绝理由：%@",nil),_msgInfoModel.msgContent.reason];
            _orderRefuseReasonLabel.text = reason;
        }
    }else{
        if(_msgInfoModel.isPlainMsg == NO){
            if([_msgInfoModel.dealStatus integerValue] == -1){
                _tipLabel.hidden = YES;
                _agreeBtn.hidden = NO;
                _refuseBtn.hidden = NO;
                [_agreeBtn setTitle:NSLocalizedString(@"同意",nil) forState:UIControlStateNormal];
                [_refuseBtn setTitle:NSLocalizedString(@"拒绝",nil) forState:UIControlStateNormal];
            }else{
                _agreeBtn.hidden = YES;
                _refuseBtn.hidden = YES;
                if([_msgInfoModel.msgType integerValue] == 1){
                    //订单消息
                    _tipLabel.hidden = NO;
                    if([_msgInfoModel.dealStatus integerValue] == 1){
                        _tipLabel.text = NSLocalizedString(@"已同意关联",nil);
                    }else if([_msgInfoModel.dealStatus integerValue] == 2){
                        _tipLabel.text = NSLocalizedString(@"已拒绝关联",nil);
                    }else if([_msgInfoModel.dealStatus integerValue] == 3){
                        _tipLabel.text = NSLocalizedString(@"已撤回关联",nil);
                    }
                }else{
                    _tipLabel.hidden = YES;
                }
            }
        }else{
            _agreeBtn.hidden = YES;
            _refuseBtn.hidden = YES;
            _tipLabel.hidden = YES;
            if([_msgInfoModel.autoCloseHoursRemains integerValue] > 0){
                NSInteger day = [_msgInfoModel.autoCloseHoursRemains integerValue]/24;
                NSInteger hours = [_msgInfoModel.autoCloseHoursRemains integerValue]%24;
                _oprateTipLabel.text = [NSString stringWithFormat:NSLocalizedString(@"剩余%ld天%ld小时，交易将自动取消",nil),(long)day,(long)hours];
                isCount = YES;
            }
        }
    }

    if((!_agreeBtn.hidden && !_refuseBtn.hidden) || isCount){
        [_oprateTipIcon hideByHeight:NO];
        [_oprateTipLine hideByHeight:NO];
        [_oprateTipLabel hideByHeight:NO];
    }

    [self updateConstraintsIfNeeded];
}

#pragma mark - --------------自定义响应----------------------
- (IBAction)agreeHandler:(id)sender {
    if(_msgInfoModel.msgContent && ![NSString isNilOrEmpty:_msgInfoModel.msgContent.op]){
        if([_msgInfoModel.msgContent.op isEqualToString:@"need_confirm"]){
            _tipLabel.hidden = YES;
            if([_msgInfoModel.dealStatus integerValue] == -1){
                if(_msgInfoModel.orderTransStatus && [_msgInfoModel.orderTransStatus integerValue] != 4){
                    //双方都已确认
                }else{
                    //确认订单
                    [self confirmOrder];
                }
            }
        }
    }else{
        if(_msgInfoModel.isPlainMsg == NO){
            if([_msgInfoModel.dealStatus integerValue] == -1){
                //请求关联订单
                [self requestOrderConn];
            }
        }
    }
}

- (IBAction)refuseHandler:(id)sender {
    if(_msgInfoModel.msgContent && ![NSString isNilOrEmpty:_msgInfoModel.msgContent.op]){
        if([_msgInfoModel.msgContent.op isEqualToString:@"need_confirm"]){
            _tipLabel.hidden = YES;
            if([_msgInfoModel.dealStatus integerValue] == -1){
                if(_msgInfoModel.orderTransStatus && [_msgInfoModel.orderTransStatus integerValue] != 4){
                    //双方都已确认
                }else{
                    //拒绝确认订单
                    [self refuseOrder];
                }
            }
        }
    }else{
        if(_msgInfoModel.isPlainMsg == NO){
            if([_msgInfoModel.dealStatus integerValue] == -1){
                //拒绝订单关联
                [self refuseOrderConn];
            }
        }
    }
}

#pragma mark - --------------自定义方法----------------------
//确认订单
-(void)confirmOrder{
    NSLog(@"confirmOrder");
    WeakSelf(ws);
    CMAlertView *alertView = [[CMAlertView alloc] initWithTitle:NSLocalizedString(@"确认此订单？", nil) message:NSLocalizedString(@"确认后将无法修改订单，是否确认该订单？",nil) needwarn:NO delegate:nil cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:@[NSLocalizedString(@"确认",nil)]];
    [alertView setAlertViewBlock:^(NSInteger selectedIndex){
        if (selectedIndex == 1) {
            [YYOrderApi confirmOrderByOrderCode:_msgInfoModel.msgContent.orderCode andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
                if(rspStatusAndMessage.status == kCode100){
                    ws.msgInfoModel.msgContent.op = @"need_confirm";
                    ws.msgInfoModel.dealStatus = @(1);
                    [YYToast showToastWithTitle:NSLocalizedString(@"订单已确认", nil) andDuration:kAlertToastDuration];
                    if(ws.delegate){
                        [ws.delegate btnClick:0 section:0 andParmas:@[@"reload"]];
                    }
                }else{
                    [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
                }
            }];
        }
    }];
    [alertView show];
}
//拒绝确认订单
-(void)refuseOrder{
    NSLog(@"refuseOrder");
    WeakSelf(ws);
    CMAlertView *alertView = [[CMAlertView alloc] initRefuseOrderReasonWithTitle:NSLocalizedString(@"请填写拒绝原因", nil) message:nil otherButtonTitles:@[NSLocalizedString(@"提交",nil)]];
    [alertView setAlertViewSubmitBlock:^(NSString *reson) {
        NSLog(@"准备提交");
        [YYOrderApi refuseOrderByOrderCode:_msgInfoModel.msgContent.orderCode reason:reson andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
            if(rspStatusAndMessage.status == kCode100){
                ws.msgInfoModel.msgContent.op = @"need_confirm";
                ws.msgInfoModel.dealStatus = @(2);
                [YYToast showToastWithTitle:NSLocalizedString(@"已提交", nil) andDuration:kAlertToastDuration];
                if(ws.delegate){
                    [ws.delegate btnClick:0 section:0 andParmas:@[@"reload"]];
                }
            }else{
                [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
            }
        }];
    }];
    [alertView show];
}
//请求关联订单
-(void)requestOrderConn{
    WeakSelf(ws);
    [YYOrderApi setOpWithOrderConn:_msgInfoModel.msgContent.orderCode opType:1 andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
        if(rspStatusAndMessage.status == kCode100){
            ws.msgInfoModel.dealStatus = [[NSNumber alloc] initWithInt:1];
            [ws updateUI];
            [YYToast showToastWithTitle:NSLocalizedString(@"同意邀请成功！",nil)  andDuration:kAlertToastDuration];
        }else{
            [YYToast showToastWithTitle:rspStatusAndMessage.message  andDuration:kAlertToastDuration];
        }
    }];
}
//拒绝订单关联
-(void)refuseOrderConn{
    WeakSelf(ws);
    CMAlertView *alertView = [[CMAlertView alloc] initWithTitle:NSLocalizedString(@"确认拒绝订单关联吗？",nil) message:NSLocalizedString(@"拒绝订单关联将不能查看订单",nil) needwarn:NO delegate:nil cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:@[NSLocalizedString(@"拒绝订单关联",nil)]];
    [alertView setAlertViewBlock:^(NSInteger selectedIndex){
        if (selectedIndex == 1) {
            [YYOrderApi setOpWithOrderConn:_msgInfoModel.msgContent.orderCode opType:2 andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
                if(rspStatusAndMessage.status == kCode100){
                    ws.msgInfoModel.dealStatus = [[NSNumber alloc] initWithInt:2];
                    [ws updateUI];
                    [YYToast showToastWithTitle:NSLocalizedString(@"拒绝邀请成功！",nil)  andDuration:kAlertToastDuration];

                }else{
                    [YYToast showToastWithTitle:rspStatusAndMessage.message  andDuration:kAlertToastDuration];
                }
            }];

        }
    }];

    [alertView show];
}

#pragma mark - --------------other----------------------


@end
