//
//  YYOrderNormalListCell.m
//  Yunejian
//
//  Created by Apple on 15/8/17.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYOrderNormalListCell.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图
#import "KAProgressLabel.h"
#import "SCGIFImageView.h"
#import "YYTypeButton.h"

// 接口

// 分类
#import "UIImage+Tint.h"
#import "UIImage+YYImage.h"
#import "UIView+UpdateAutoLayoutConstraints.h"

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYUser.h"
#import "YYOrderListItemModel.h"

@interface YYOrderNormalListCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *storeLabelWidthLayout;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderCodeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *isAppendImg;

@property (weak, nonatomic) IBOutlet SCGIFImageView *orderAlbumImageView;

@property (weak, nonatomic) IBOutlet KAProgressLabel *hasGiveMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *hasGiveMoneyTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderSendTipLabel;

@property (weak, nonatomic) IBOutlet YYTypeButton *leftOrderBtn;
@property (weak, nonatomic) IBOutlet YYTypeButton *middleOrderBtn;
@property (weak, nonatomic) IBOutlet YYTypeButton *rightOrderBtn;

@property (weak, nonatomic) IBOutlet UILabel *tranStatusLabel;

@property (weak, nonatomic) IBOutlet UIButton *connStatusTag;

@end

@implementation YYOrderNormalListCell
#pragma mark - --------------生命周期--------------
- (void)awakeFromNib {
    [super awakeFromNib];
    [self SomePrepare];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
#pragma mark - --------------SomePrepare--------------
- (void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
- (void)PrepareData{}
- (void)PrepareUI{
    _isAppendImg.image = [UIImage imageNamed:[LanguageManager isEnglishLanguage]?@"isappend_img_en":@"isappend_img"];

    _orderCodeLabel.adjustsFontSizeToFitWidth = YES;
    _priceTotalLabel.adjustsFontSizeToFitWidth = YES;

    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;

    _leftOrderBtn.layer.borderWidth = 1;
    _leftOrderBtn.layer.borderColor = [UIColor colorWithHex:@"afafaf"].CGColor;
    _leftOrderBtn.layer.cornerRadius = 2.5;
    _leftOrderBtn.layer.masksToBounds = YES;

    _middleOrderBtn.layer.borderWidth = 1;
    _middleOrderBtn.layer.borderColor = [UIColor colorWithHex:@"afafaf"].CGColor;
    _middleOrderBtn.layer.cornerRadius = 2.5;
    _middleOrderBtn.layer.masksToBounds = YES;

    _rightOrderBtn.layer.borderWidth = 1;
    _rightOrderBtn.layer.borderColor = [UIColor colorWithHex:@"afafaf"].CGColor;
    _rightOrderBtn.layer.cornerRadius = 2.5;
    _rightOrderBtn.layer.masksToBounds = YES;

    _orderAlbumImageView.layer.borderWidth = 1;
    _orderAlbumImageView.layer.borderColor = [UIColor colorWithHex:@"d3d3d3"].CGColor;
    _orderAlbumImageView.layer.cornerRadius = 2.5;
    _orderAlbumImageView.layer.masksToBounds = YES;

    [_hasGiveMoneyLabel setTrackWidth: 2.0];
    [_hasGiveMoneyLabel setProgressWidth: 2];
    [_hasGiveMoneyLabel setRoundedCornersWidth:2];

    _hasGiveMoneyLabel.fillColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
    _hasGiveMoneyLabel.trackColor = [UIColor colorWithHex:@"efefef"];
    _hasGiveMoneyLabel.progressColor = [UIColor colorWithHex:@"ed6498"];
    _hasGiveMoneyLabel.isStartDegreeUserInteractive = NO;
    _hasGiveMoneyLabel.isEndDegreeUserInteractive = NO;
    _hasGiveMoneyLabel.textColor = [UIColor colorWithHex:@"ed6498"];
}

//#pragma mark - --------------UIConfig----------------------
#pragma mark - --------------UpdateUI----------------------
- (void)updateUI{

    if([_currentOrderListItemModel.isAppend integerValue]){
        _isAppendImg.hidden = NO;
    }else{
        _isAppendImg.hidden = YES;
    }

    if (_currentOrderListItemModel) {
        _priceTotalLabel.text = [NSString stringWithFormat:@"%@%@%@",NSLocalizedString(@"建单",nil),NSLocalizedString(@"：",nil),getShowDateByFormatAndTimeInterval(@"yy/MM/dd HH:mm",[_currentOrderListItemModel.orderCreateTime stringValue])];
        _orderCodeLabel.text = [NSString stringWithFormat:@"%@%@%@",NSLocalizedString(@"单号",nil),NSLocalizedString(@"：",nil),_currentOrderListItemModel.orderCode];
        if (_currentOrderListItemModel.styleAmount
            && _currentOrderListItemModel.itemAmount) {
            _countLabel.text = [NSString stringWithFormat:NSLocalizedString(@"总计：%i款 %i件",nil),[_currentOrderListItemModel.styleAmount intValue],[_currentOrderListItemModel.itemAmount intValue]];
        }

        if (_currentOrderListItemModel.finalTotalPrice) {
            NSLog(@"**%@**",_countLabel.text);//Total: 1 Styles 1 Units
            NSString *totalstr = NSLocalizedString(@"总价",nil);
            NSInteger txtlength = _countLabel.text.length+2+totalstr.length;
            NSString *totalMoneyStr = replaceMoneyFlag([NSString stringWithFormat:@"%@ %@%@￥%.2f",_countLabel.text,NSLocalizedString(@"总价",nil),NSLocalizedString(@"：",nil),[_currentOrderListItemModel.finalTotalPrice floatValue]],[_currentOrderListItemModel.curType integerValue]);
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString: totalMoneyStr];
            [attributedStr addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:15] range: NSMakeRange(txtlength, totalMoneyStr.length-txtlength)];
            [attributedStr addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithHex:@"ed6498"] range: NSMakeRange(txtlength, totalMoneyStr.length-txtlength)];

            _countLabel.attributedText = attributedStr;
        }

        if(_currentOrderListItemModel && _currentOrderListItemModel.buyerLogo != nil){
            sd_downloadWebImageWithRelativePath(NO, _currentOrderListItemModel.buyerLogo,_orderAlbumImageView, kLogoCover, 0);
        }else{
            sd_downloadWebImageWithRelativePath(NO, @"",_orderAlbumImageView, kLogoCover, 0);
        }

        if (_currentOrderListItemModel.supplyTime
            && [_currentOrderListItemModel.supplyTime count] > 0) {
            YYOrderSupplyTimeModel *orderSupplyTimeModel = nil;
            for (YYOrderSupplyTimeModel *tmpOrderSupplyTimeModel in _currentOrderListItemModel.supplyTime) {
                if(orderSupplyTimeModel == nil || [orderSupplyTimeModel.supplyStatus integerValue] == 0){
                    orderSupplyTimeModel = tmpOrderSupplyTimeModel;
                }else{
                    if([tmpOrderSupplyTimeModel.supplyStatus integerValue] != 0 && ([tmpOrderSupplyTimeModel.dayRemains integerValue] > [orderSupplyTimeModel.dayRemains integerValue])){
                        orderSupplyTimeModel = tmpOrderSupplyTimeModel;
                    }
                }
            }
            if(orderSupplyTimeModel){
                _orderSendTipLabel.hidden = NO;
                [self addAlineView:orderSupplyTimeModel andLineIndex:0];
            }else{
                _orderSendTipLabel.hidden = YES;
            }
        }else{
            _orderSendTipLabel.hidden = YES;
        }

        NSInteger tranStatus = getOrderTransStatus(_currentOrderListItemModel.designerTransStatus,_currentOrderListItemModel.buyerTransStatus);

        //状态
        _tranStatusLabel.text = getOrderStatusName_detail(tranStatus,NO,NO);
        _tranStatusLabel.textColor = [UIColor colorWithHex:@"ed6498"];

        //等于100对应正常收全款,大于的情况归类到超额收，需退款
        BOOL hasTotalPaid = NO;
        BOOL isNeedRefund = NO;
        if([_currentOrderListItemModel.payNote floatValue] == 100){
            hasTotalPaid = YES;
        }else if([_currentOrderListItemModel.payNote floatValue] > 100){
            isNeedRefund = YES;
        }

        _leftOrderBtn.layer.borderColor = [UIColor colorWithHex:@"afafaf"].CGColor;
        _middleOrderBtn.layer.borderColor = [UIColor colorWithHex:@"afafaf"].CGColor;
        _rightOrderBtn.layer.borderColor = [UIColor colorWithHex:@"afafaf"].CGColor;
        _leftOrderBtn.type = nil;
        _middleOrderBtn.type = nil;
        _rightOrderBtn.type = nil;

        if(tranStatus == YYOrderCode_CLOSE_REQ || [_currentOrderListItemModel.closeReqStatus integerValue] == -1){
            //关闭请求
            _tranStatusLabel.textColor = [UIColor colorWithHex:@"ef4e31"];

            [_leftOrderBtn hideByWidth:YES];

            if([_currentOrderListItemModel.closeReqStatus integerValue] == -1){
                _tranStatusLabel.text = getOrderStatusName_detail(YYOrderCode_CLOSE_REQ,NO,NO);

                [_middleOrderBtn hideByWidth:NO];
                _middleOrderBtn.backgroundColor = _define_black_color;
                _middleOrderBtn.layer.borderColor = _define_black_color.CGColor;
                [_middleOrderBtn setTitleColor:_define_white_color forState:UIControlStateNormal];
                [_middleOrderBtn setTitle:NSLocalizedString(@"拒绝申请",nil) forState:UIControlStateNormal];
                _middleOrderBtn.type = @"refuseReqClose";

                [_rightOrderBtn hideByWidth:NO];
                _rightOrderBtn.backgroundColor =_define_white_color;
                [_rightOrderBtn setTitleColor:_define_black_color forState:UIControlStateNormal];
                [_rightOrderBtn setTitle:NSLocalizedString(@"同意取消",nil) forState:UIControlStateNormal];
                _rightOrderBtn.type = @"agreeReqClose";

            }else if([_currentOrderListItemModel.closeReqStatus integerValue] == 1){
                _tranStatusLabel.text = NSLocalizedString(@"已取消订单",nil);

                [_middleOrderBtn hideByWidth:YES];

                [_rightOrderBtn hideByWidth:NO];
                _rightOrderBtn.backgroundColor =_define_white_color;
                [_rightOrderBtn setTitleColor:_define_black_color forState:UIControlStateNormal];
                [_rightOrderBtn setTitle:NSLocalizedString(@"撤销申请",nil) forState:UIControlStateNormal];
                _rightOrderBtn.type = @"cancelReqClose";

            }else{
                [_leftOrderBtn hideByWidth:YES];
                [_middleOrderBtn hideByWidth:YES];
                [_rightOrderBtn hideByWidth:YES];
            }

        }else if(tranStatus == YYOrderCode_NEGOTIATION){
            //已下单

            BOOL isDesignerConfrim = [_currentOrderListItemModel isDesignerConfrim];
            BOOL isBuyerConfrim = [_currentOrderListItemModel isBuyerConfrim];

            if(!isBuyerConfrim){
                if(!isDesignerConfrim){
                    //双方都未确认
                    [_leftOrderBtn hideByWidth:NO];

                    NSInteger connectStatus = [_currentOrderListItemModel.connectStatus integerValue];
                    if(connectStatus == YYOrderConnStatusLinked || connectStatus == YYOrderConnStatusNotFound){
                        //关联成功 || 未入驻
                        _leftOrderBtn.backgroundColor = _define_black_color;
                        _leftOrderBtn.layer.borderColor = _define_black_color.CGColor;
                        [_leftOrderBtn setTitleColor:_define_white_color forState:UIControlStateNormal];
                        [_leftOrderBtn setTitle:NSLocalizedString(@"确认订单",nil) forState:UIControlStateNormal];
                        _leftOrderBtn.type = @"confirmOrder";
                    }else{
                        //关联失败 || 关联中
                        _leftOrderBtn.backgroundColor = [UIColor colorWithHex:@"d3d3d3"];
                        _leftOrderBtn.layer.borderColor = [UIColor colorWithHex:@"d3d3d3"].CGColor;
                        [_leftOrderBtn setTitleColor:_define_white_color forState:UIControlStateNormal];
                        [_leftOrderBtn setTitle:NSLocalizedString(@"确认订单",nil) forState:UIControlStateNormal];
                        _leftOrderBtn.type = @"unconfirmOrder";
                    }

                    [_middleOrderBtn hideByWidth:NO];
                    _middleOrderBtn.backgroundColor =_define_white_color;
                    [_middleOrderBtn setTitleColor:_define_black_color forState:UIControlStateNormal];
                    [_middleOrderBtn setTitle:NSLocalizedString(@"取消订单_short",nil) forState:UIControlStateNormal];
                    _middleOrderBtn.type = @"cancelOrder";

                    [_rightOrderBtn hideByWidth:NO];
                    _rightOrderBtn.backgroundColor =_define_white_color;
                    [_rightOrderBtn setTitleColor:_define_black_color forState:UIControlStateNormal];
                    [_rightOrderBtn setTitle:NSLocalizedString(@"修改订单_short",nil) forState:UIControlStateNormal];
                    _rightOrderBtn.type = @"modifyOrder";

                }else{
                    //买手未确认
                    [_leftOrderBtn hideByWidth:YES];

                    [_middleOrderBtn hideByWidth:YES];
                    
                    [_rightOrderBtn hideByWidth:NO];
                    _rightOrderBtn.backgroundColor = [UIColor colorWithHex:@"d3d3d3"];
                    _rightOrderBtn.layer.borderColor = [UIColor colorWithHex:@"d3d3d3"].CGColor;
                    [_rightOrderBtn setTitleColor:_define_white_color forState:UIControlStateNormal];
                    [_rightOrderBtn setTitle:NSLocalizedString(@"待买手确认",nil) forState:UIControlStateNormal];
                }
            }else{
                if(!isDesignerConfrim){
                    //设计师未确认

                    [_leftOrderBtn hideByWidth:NO];
                    _leftOrderBtn.backgroundColor = _define_white_color;
                    _leftOrderBtn.layer.borderColor = _define_white_color.CGColor;
                    [_leftOrderBtn setTitleColor:_define_black_color forState:UIControlStateNormal];
                    [_leftOrderBtn setTitle:NSLocalizedString(@"买手已确认", nil) forState:UIControlStateNormal];

                    [_middleOrderBtn hideByWidth:NO];
                    _middleOrderBtn.backgroundColor =_define_white_color;
                    [_middleOrderBtn setTitleColor:_define_black_color forState:UIControlStateNormal];
                    [_middleOrderBtn setTitle:NSLocalizedString(@"拒绝确认",nil) forState:UIControlStateNormal];
                    _middleOrderBtn.type = @"refuseOrder";

                    [_rightOrderBtn hideByWidth:NO];

                    NSInteger connectStatus = [_currentOrderListItemModel.connectStatus integerValue];
                    if(connectStatus == YYOrderConnStatusLinked || connectStatus == YYOrderConnStatusNotFound){
                        //关联成功 || 未入驻
                        _rightOrderBtn.backgroundColor =_define_white_color;
                        [_rightOrderBtn setTitleColor:_define_black_color forState:UIControlStateNormal];
                        [_rightOrderBtn setTitle:NSLocalizedString(@"确认订单",nil) forState:UIControlStateNormal];
                        _rightOrderBtn.type = @"confirmOrder";
                    }else{
                        //关联失败 || 关联中
                        _rightOrderBtn.backgroundColor = [UIColor colorWithHex:@"d3d3d3"];
                        _rightOrderBtn.layer.borderColor = [UIColor colorWithHex:@"d3d3d3"].CGColor;
                        [_rightOrderBtn setTitleColor:_define_white_color forState:UIControlStateNormal];
                        [_rightOrderBtn setTitle:NSLocalizedString(@"确认订单",nil) forState:UIControlStateNormal];
                        _rightOrderBtn.type = @"unconfirmOrder";
                    }
                    
                }else{
                    //理论上不存在这种情况
                    [_leftOrderBtn hideByWidth:YES];
                    [_middleOrderBtn hideByWidth:YES];
                    [_rightOrderBtn hideByWidth:YES];
                }
            }

        }else if(tranStatus == YYOrderCode_NEGOTIATION_DONE || tranStatus == YYOrderCode_CONTRACT_DONE){
            //已确认

            [_leftOrderBtn hideByWidth:YES];

            if(hasTotalPaid){
                [_middleOrderBtn hideByWidth:YES];

                [_rightOrderBtn hideByWidth:NO];
                _rightOrderBtn.backgroundColor = _define_black_color;
                _rightOrderBtn.layer.borderColor = _define_black_color.CGColor;
                [_rightOrderBtn setTitleColor:_define_white_color forState:UIControlStateNormal];
                [_rightOrderBtn setTitle:NSLocalizedString(@"已生产",nil) forState:UIControlStateNormal];
                _rightOrderBtn.type = @"status";
            }else{
                [_middleOrderBtn hideByWidth:NO];
                _middleOrderBtn.backgroundColor = _define_black_color;
                _middleOrderBtn.layer.borderColor = _define_black_color.CGColor;
                [_middleOrderBtn setTitleColor:_define_white_color forState:UIControlStateNormal];
                [_middleOrderBtn setTitle:NSLocalizedString(@"已生产",nil) forState:UIControlStateNormal];
                _middleOrderBtn.type = @"status";

                [_rightOrderBtn hideByWidth:NO];
                if(isNeedRefund){
                    _rightOrderBtn.backgroundColor =_define_black_color;
                    _rightOrderBtn.layer.borderColor = _define_black_color.CGColor;
                    [_rightOrderBtn setTitleColor:_define_white_color forState:UIControlStateNormal];
                    [_rightOrderBtn setTitle:NSLocalizedString(@"退款",nil) forState:UIControlStateNormal];
                }else{
                    _rightOrderBtn.backgroundColor =_define_white_color;
                    [_rightOrderBtn setTitleColor:_define_black_color forState:UIControlStateNormal];
                    [_rightOrderBtn setTitle:NSLocalizedString(@"添加收款记录",nil) forState:UIControlStateNormal];
                }
                _rightOrderBtn.type = @"paylog";
            }

        }else if(tranStatus == YYOrderCode_MANUFACTURE){
            //已生产

            [_leftOrderBtn hideByWidth:YES];

            if(hasTotalPaid){
                [_middleOrderBtn hideByWidth:YES];

                [_rightOrderBtn hideByWidth:NO];
                _rightOrderBtn.backgroundColor = _define_black_color;
                _rightOrderBtn.layer.borderColor = _define_black_color.CGColor;
                [_rightOrderBtn setTitleColor:_define_white_color forState:UIControlStateNormal];
                if([_currentOrderListItemModel.connectStatus integerValue] == YYOrderConnStatusLinked){
                    //已入驻
                    [_rightOrderBtn setTitle:NSLocalizedString(@"发货",nil) forState:UIControlStateNormal];
                    _rightOrderBtn.type = @"delivery";
                }else{
                    //未入驻
                    [_rightOrderBtn setTitle:NSLocalizedString(@"完成发货",nil) forState:UIControlStateNormal];
                    _rightOrderBtn.type = @"status";
                }
            }else{
                [_middleOrderBtn hideByWidth:NO];
                _middleOrderBtn.backgroundColor = _define_black_color;
                _middleOrderBtn.layer.borderColor = _define_black_color.CGColor;
                [_middleOrderBtn setTitleColor:_define_white_color forState:UIControlStateNormal];
                if([_currentOrderListItemModel.connectStatus integerValue] == YYOrderConnStatusLinked){
                    //已入驻
                    [_middleOrderBtn setTitle:NSLocalizedString(@"发货",nil) forState:UIControlStateNormal];
                    _middleOrderBtn.type = @"delivery";
                }else{
                    //未入驻
                    [_middleOrderBtn setTitle:NSLocalizedString(@"完成发货",nil) forState:UIControlStateNormal];
                    _middleOrderBtn.type = @"status";
                }

                [_rightOrderBtn hideByWidth:NO];
                if(isNeedRefund){
                    _rightOrderBtn.backgroundColor =_define_black_color;
                    _rightOrderBtn.layer.borderColor = _define_black_color.CGColor;
                    [_rightOrderBtn setTitleColor:_define_white_color forState:UIControlStateNormal];
                    [_rightOrderBtn setTitle:NSLocalizedString(@"退款",nil) forState:UIControlStateNormal];
                }else{
                    _rightOrderBtn.backgroundColor =_define_white_color;
                    [_rightOrderBtn setTitleColor:_define_black_color forState:UIControlStateNormal];
                    [_rightOrderBtn setTitle:NSLocalizedString(@"添加收款记录",nil) forState:UIControlStateNormal];
                }
                _rightOrderBtn.type = @"paylog";
            }

        }else if(tranStatus == YYOrderCode_DELIVERING){
            //发货中

            [_leftOrderBtn hideByWidth:YES];

            if(hasTotalPaid){
                [_middleOrderBtn hideByWidth:YES];

                [_rightOrderBtn hideByWidth:NO];
                NSInteger awaitDeliveryAmount = [_currentOrderListItemModel.itemAmount integerValue] - [_currentOrderListItemModel.packageStat.sentAmount integerValue];//待发货数

                if([_currentOrderListItemModel.itemAmount integerValue] == [_currentOrderListItemModel.packageStat.receivedAmount integerValue]){

                    _rightOrderBtn.backgroundColor = _define_black_color;
                    _rightOrderBtn.layer.borderColor = _define_black_color.CGColor;
                    [_rightOrderBtn setTitleColor:_define_white_color forState:UIControlStateNormal];
                    [_rightOrderBtn setTitle:NSLocalizedString(@"完成发货",nil) forState:UIControlStateNormal];
                    _rightOrderBtn.type = @"status";

                }else{

                    if(awaitDeliveryAmount > 0){

                        _rightOrderBtn.backgroundColor = _define_black_color;
                        _rightOrderBtn.layer.borderColor = _define_black_color.CGColor;
                        [_rightOrderBtn setTitleColor:_define_white_color forState:UIControlStateNormal];
                        [_rightOrderBtn setTitle:NSLocalizedString(@"继续发货",nil) forState:UIControlStateNormal];
                        _rightOrderBtn.type = @"delivery";

                    }else{

                        _rightOrderBtn.backgroundColor = [UIColor colorWithHex:@"d3d3d3"];
                        _rightOrderBtn.layer.borderColor = [UIColor colorWithHex:@"d3d3d3"].CGColor;
                        [_rightOrderBtn setTitleColor:_define_white_color forState:UIControlStateNormal];
                        [_rightOrderBtn setTitle:NSLocalizedString(@"继续发货",nil) forState:UIControlStateNormal];
                        _rightOrderBtn.type = @"delivery_tip";
                    }
                }

            }else{
                [_middleOrderBtn hideByWidth:NO];

                NSInteger awaitDeliveryAmount = [_currentOrderListItemModel.itemAmount integerValue] - [_currentOrderListItemModel.packageStat.sentAmount integerValue];//待发货数

                if([_currentOrderListItemModel.itemAmount integerValue] == [_currentOrderListItemModel.packageStat.receivedAmount integerValue]){

                    _middleOrderBtn.backgroundColor = _define_black_color;
                    _middleOrderBtn.layer.borderColor = _define_black_color.CGColor;
                    [_middleOrderBtn setTitleColor:_define_white_color forState:UIControlStateNormal];
                    [_middleOrderBtn setTitle:NSLocalizedString(@"完成发货",nil) forState:UIControlStateNormal];
                    _middleOrderBtn.type = @"status";

                }else{

                    if(awaitDeliveryAmount > 0){

                        _middleOrderBtn.backgroundColor = _define_black_color;
                        _middleOrderBtn.layer.borderColor = _define_black_color.CGColor;
                        [_middleOrderBtn setTitleColor:_define_white_color forState:UIControlStateNormal];
                        [_middleOrderBtn setTitle:NSLocalizedString(@"继续发货",nil) forState:UIControlStateNormal];
                        _middleOrderBtn.type = @"delivery";

                    }else{

                        _middleOrderBtn.backgroundColor = [UIColor colorWithHex:@"d3d3d3"];
                        _middleOrderBtn.layer.borderColor = [UIColor colorWithHex:@"d3d3d3"].CGColor;
                        [_middleOrderBtn setTitleColor:_define_white_color forState:UIControlStateNormal];
                        [_middleOrderBtn setTitle:NSLocalizedString(@"继续发货",nil) forState:UIControlStateNormal];
                        _middleOrderBtn.type = @"delivery_tip";
                    }
                }

                [_rightOrderBtn hideByWidth:NO];
                if(isNeedRefund){
                    _rightOrderBtn.backgroundColor =_define_black_color;
                    _rightOrderBtn.layer.borderColor = _define_black_color.CGColor;
                    [_rightOrderBtn setTitleColor:_define_white_color forState:UIControlStateNormal];
                    [_rightOrderBtn setTitle:NSLocalizedString(@"退款",nil) forState:UIControlStateNormal];
                }else{
                    _rightOrderBtn.backgroundColor =_define_white_color;
                    [_rightOrderBtn setTitleColor:_define_black_color forState:UIControlStateNormal];
                    [_rightOrderBtn setTitle:NSLocalizedString(@"添加收款记录",nil) forState:UIControlStateNormal];
                }
                _rightOrderBtn.type = @"paylog";
            }

        }else if(tranStatus == YYOrderCode_DELIVERY){
            //已发货

            [_leftOrderBtn hideByWidth:YES];

            if(hasTotalPaid){
                [_middleOrderBtn hideByWidth:YES];

                if([_currentOrderListItemModel.connectStatus integerValue] == YYOrderConnStatusLinked){
                    //已入驻
                    [_rightOrderBtn hideByWidth:YES];
                }else{
                    //未入驻
                    [_rightOrderBtn hideByWidth:NO];
                    _rightOrderBtn.backgroundColor = _define_black_color;
                    _rightOrderBtn.layer.borderColor = _define_black_color.CGColor;
                    [_rightOrderBtn setTitleColor:_define_white_color forState:UIControlStateNormal];
                    [_rightOrderBtn setTitle:NSLocalizedString(@"确认收货",nil) forState:UIControlStateNormal];
                    _rightOrderBtn.type = @"confirm_delivery";
                }
            }else{
                if([_currentOrderListItemModel.connectStatus integerValue] == YYOrderConnStatusLinked){
                    //已入驻
                    [_middleOrderBtn hideByWidth:YES];
                }else{
                    //未入驻
                    [_middleOrderBtn hideByWidth:NO];
                    _middleOrderBtn.backgroundColor = _define_black_color;
                    _middleOrderBtn.layer.borderColor = _define_black_color.CGColor;
                    [_middleOrderBtn setTitleColor:_define_white_color forState:UIControlStateNormal];
                    [_middleOrderBtn setTitle:NSLocalizedString(@"确认收货",nil) forState:UIControlStateNormal];
                    _middleOrderBtn.type = @"confirm_delivery";
                }

                [_rightOrderBtn hideByWidth:NO];
                if(isNeedRefund){
                    _rightOrderBtn.backgroundColor =_define_black_color;
                    _rightOrderBtn.layer.borderColor = _define_black_color.CGColor;
                    [_rightOrderBtn setTitleColor:_define_white_color forState:UIControlStateNormal];
                    [_rightOrderBtn setTitle:NSLocalizedString(@"退款",nil) forState:UIControlStateNormal];
                }else{
                    _rightOrderBtn.backgroundColor =_define_white_color;
                    [_rightOrderBtn setTitleColor:_define_black_color forState:UIControlStateNormal];
                    [_rightOrderBtn setTitle:NSLocalizedString(@"添加收款记录",nil) forState:UIControlStateNormal];
                }
                _rightOrderBtn.type = @"paylog";
            }

        }else if(tranStatus == YYOrderCode_RECEIVED){
            //已收货

            [_leftOrderBtn hideByWidth:YES];

            [_middleOrderBtn hideByWidth:YES];

            if(hasTotalPaid){
                [_rightOrderBtn hideByWidth:YES];
            }else{
                [_rightOrderBtn hideByWidth:NO];
                if(isNeedRefund){
                    _rightOrderBtn.backgroundColor =_define_black_color;
                    _rightOrderBtn.layer.borderColor = _define_black_color.CGColor;
                    [_rightOrderBtn setTitleColor:_define_white_color forState:UIControlStateNormal];
                    [_rightOrderBtn setTitle:NSLocalizedString(@"退款",nil) forState:UIControlStateNormal];
                }else{
                    _rightOrderBtn.backgroundColor =_define_white_color;
                    [_rightOrderBtn setTitleColor:_define_black_color forState:UIControlStateNormal];
                    [_rightOrderBtn setTitle:NSLocalizedString(@"添加收款记录",nil) forState:UIControlStateNormal];
                }
                _rightOrderBtn.type = @"paylog";
            }

        }else if(tranStatus == YYOrderCode_CANCELLED || tranStatus == YYOrderCode_CLOSED){
            //已取消

            _tranStatusLabel.textColor = [UIColor colorWithHex:@"ef4e31"];

            [_leftOrderBtn hideByWidth:YES];

            [_middleOrderBtn hideByWidth:NO];
            _middleOrderBtn.backgroundColor = _define_black_color;
            _middleOrderBtn.layer.borderColor = _define_black_color.CGColor;
            [_middleOrderBtn setTitleColor:_define_white_color forState:UIControlStateNormal];
            [_middleOrderBtn setTitle:NSLocalizedString(@"重新建立订单",nil) forState:UIControlStateNormal];
            _middleOrderBtn.type = @"reBuildOrder";


            [_rightOrderBtn hideByWidth:NO];
            _rightOrderBtn.backgroundColor =_define_white_color;
            [_rightOrderBtn setTitleColor:_define_black_color forState:UIControlStateNormal];
            [_rightOrderBtn setTitle:NSLocalizedString(@"删除",nil) forState:UIControlStateNormal];
            _rightOrderBtn.type = @"delete";

        }else {

            [_leftOrderBtn hideByWidth:YES];
            [_middleOrderBtn hideByWidth:NO];
            [_rightOrderBtn hideByWidth:NO];

        }

        //收款
        [self updateorderPayUI];
        //关联状态
        [self updateOrderConnStatusUI];

        if(_leftOrderBtn.hidden == NO){
            NSString *btnTxt = _leftOrderBtn.currentTitle;
            CGSize txtSize = [btnTxt sizeWithAttributes:@{NSFontAttributeName:_leftOrderBtn.titleLabel.font}];
            NSInteger btnWidth = MAX(80, (txtSize.width+20));
            [_leftOrderBtn setConstraintConstant:btnWidth forAttribute:NSLayoutAttributeWidth];
        }
        if(_middleOrderBtn.hidden == NO){
            NSString *btnTxt = _middleOrderBtn.currentTitle;
            CGSize txtSize = [btnTxt sizeWithAttributes:@{NSFontAttributeName:_middleOrderBtn.titleLabel.font}];
            NSInteger btnWidth = MAX(80, (txtSize.width+20));
            [_middleOrderBtn setConstraintConstant:btnWidth forAttribute:NSLayoutAttributeWidth];
        }
        if(_rightOrderBtn.hidden == NO){
            NSString *btnTxt = _rightOrderBtn.currentTitle;
            CGSize txtSize = [btnTxt sizeWithAttributes:@{NSFontAttributeName:_middleOrderBtn.titleLabel.font}];
            NSInteger btnWidth = MAX(80, (txtSize.width+20));
            [_rightOrderBtn setConstraintConstant:btnWidth forAttribute:NSLayoutAttributeWidth];

        }
    }

    CGFloat _width = getWidthWithHeight(20, _titleLabel.text, _titleLabel.font);
    CGFloat max_w = IsPhone6_gt?150:100;
    if(_width>max_w){
        _storeLabelWidthLayout.constant = max_w;
    }else{
        _storeLabelWidthLayout.constant = _width;
    }

}
-(void)updateorderPayUI{

    NSString *totalPayMoneyStr = [NSString stringWithFormat:@"%@ %.2lf%@",NSLocalizedString(@"已收款",nil),[_currentOrderListItemModel.payNote floatValue],@"%"];
    NSInteger txtlength = [NSString stringWithFormat:@"%.2lf%@",[_currentOrderListItemModel.payNote floatValue],@"%"].length;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalPayMoneyStr];
    [attributedStr addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithHex:@"ed6498"] range: NSMakeRange(totalPayMoneyStr.length-txtlength,txtlength)];
    [attributedStr addAttribute: NSFontAttributeName value: [UIFont boldSystemFontOfSize:12] range: NSMakeRange(totalPayMoneyStr.length-txtlength,txtlength)];
    _hasGiveMoneyTipLabel.attributedText = attributedStr;
    [_hasGiveMoneyLabel setProgress:[_currentOrderListItemModel.payNote floatValue]/100];

}

-(void)updateOrderConnStatusUI{
    _titleLabel.text = _currentOrderListItemModel.buyerName;
    NSInteger tranStatus = getOrderTransStatus(_currentOrderListItemModel.designerTransStatus, _currentOrderListItemModel.buyerTransStatus);

    if(_currentOrderListItemModel && tranStatus != YYOrderCode_CANCELLED && tranStatus != YYOrderCode_CLOSED){
        _connStatusTag.hidden = NO;
        NSInteger _currentOrderConnStatus = [_currentOrderListItemModel.connectStatus integerValue];
        NSString *orderConnStutas = @"";
        orderConnStutas = getOrderConnStatusName_brand(_currentOrderConnStatus,NO);
        CGSize connStatusTxtsize = [orderConnStutas sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
        [_connStatusTag setConstraintConstant:connStatusTxtsize.width+15 forAttribute:NSLayoutAttributeWidth];
        [_connStatusTag setTitle:orderConnStutas forState:UIControlStateNormal];
        UIImage *bgImage = [[UIImage imageNamed:@"tagbg_img"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0,0)];
        NSString *tintColorStr;
        [_connStatusTag setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if(_currentOrderConnStatus == YYOrderConnStatusNotFound){
            tintColorStr = @"ef4e31";
        }else  if(_currentOrderConnStatus == YYOrderConnStatusUnconfirmed){
            tintColorStr = @"efefef";
            [_connStatusTag setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        }else if(_currentOrderConnStatus == YYOrderConnStatusLinked){
            tintColorStr = @"58c776";
            _connStatusTag.hidden = YES;

        }else{
            tintColorStr = @"ef4e31";
        }
        bgImage = [bgImage imageWithTintColor:[UIColor colorWithHex:tintColorStr]];
        [_connStatusTag setBackgroundImage:bgImage forState:UIControlStateNormal];
    }else{
        _connStatusTag.hidden = YES;
    }
}

#pragma mark - --------------自定义响应----------------------
- (IBAction)leftOrderHandler:(YYTypeButton *)sender {
    [self threeButtonClickWithType:sender.type];
}
- (IBAction)middleOrderHandler:(YYTypeButton *)sender {
   [self threeButtonClickWithType:sender.type];
}
- (IBAction)rightOrderHandler:(YYTypeButton *)sender {
    [self threeButtonClickWithType:sender.type];
}
-(void)threeButtonClickWithType:(NSString *)Type{
    if(![NSString isNilOrEmpty:Type]){
        if([Type isEqualToString:@"unconfirmOrder"]){
            //关联失败 || 关联中
            [YYToast showToastWithTitle:NSLocalizedString(@"该订单未关联成功，无法确认",nil) andDuration:kAlertToastDuration];
        }else{
            if(self.delegate){
                [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:@[Type]];
            }
        }
    }
}
//去买手详情页
- (IBAction)showBuyerInfoView:(id)sender {
    if(self.delegate){
        [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:@[@"buyerInfo"]];
    }
}

#pragma mark - --------------自定义方法----------------------
- (void)addAlineView:(YYOrderSupplyTimeModel *)orderSupplyTimeModel andLineIndex:(int)lineIndex{
    NSString *endDay = NSLocalizedString(@"无",nil);
    if ([orderSupplyTimeModel.supplyStatus intValue] == 0) {
        endDay = NSLocalizedString(@"有现货，可马上发货",nil);
        _orderSendTipLabel.text = endDay;
    }else{
        endDay = [NSString stringWithFormat:NSLocalizedString(@"距本次最晚发货日还有%@天",nil),[orderSupplyTimeModel.dayRemains stringValue]];
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString: endDay];
        NSRange rang = [endDay rangeOfString:[orderSupplyTimeModel.dayRemains stringValue]];
        if(rang.location != NSNotFound){
            [attributedStr addAttribute: NSFontAttributeName value: [UIFont boldSystemFontOfSize:12] range:rang];
            [attributedStr addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithHex:@"ed6498"] range: rang];

        }
        _orderSendTipLabel.attributedText = attributedStr;

    }
    _orderSendTipLabel.adjustsFontSizeToFitWidth = YES;
}

+(float)cellHeight:(YYOrderListItemModel *)orderListItemModel{
    return 221;
}

#pragma mark - --------------other----------------------

@end
