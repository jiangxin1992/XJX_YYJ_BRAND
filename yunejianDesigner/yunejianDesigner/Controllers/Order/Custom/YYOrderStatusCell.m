//
//  YYOrderStatusCell.m
//  Yunejian
//
//  Created by Apple on 15/11/25.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "YYOrderStatusCell.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图

// 接口
#import "YYOrderApi.h"

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "UIView+UpdateAutoLayoutConstraints.h"

#import "YYUser.h"
#import "YYOrderInfoModel.h"
#import "YYOrderTransStatusModel.h"

@interface YYOrderStatusCell()

@property (weak, nonatomic) IBOutlet UILabel *statusNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *helpBtn;
@property (weak, nonatomic) IBOutlet UILabel *oprateTimerLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusTipLabel;
@property (weak, nonatomic) IBOutlet UIButton *dealCloseBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusTipLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *StatusNameWidthLayout;
@property (weak, nonatomic) IBOutlet UIButton *getBtn;
@property (weak, nonatomic) IBOutlet UIButton *operationBtn;
@property (nonatomic,strong) UILabel *statusNameTipLabel;

@end

@implementation YYOrderStatusCell

#pragma mark - --------------生命周期--------------
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self SomePrepare];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
-(void)PrepareData{}
-(void)PrepareUI{

    _statusNameLabel.font = IsPhone6_gt?[UIFont systemFontOfSize:23.0f]:[UIFont systemFontOfSize:20.0f];

    _statusNameTipLabel = [UILabel getLabelWithAlignment:0 WithTitle:NSLocalizedString(@"买家已确认", nil) WithFont:12.0f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:_statusNameTipLabel];
    [_statusNameTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_statusNameLabel);
        make.left.mas_equalTo(_statusNameTipLabel.mas_right).with.offset(5);
    }];

    _helpBtn.hidden = NO;
    [_helpBtn setTitle:NSLocalizedString(@"如何理解订单状态",nil) forState:UIControlStateNormal];
    _helpBtn.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"如何理解订单状态",nil) attributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];

    _getBtn.layer.cornerRadius = 2.5;
    _getBtn.layer.masksToBounds = YES;
    _getBtn.layer.borderWidth = 1;

    _operationBtn.layer.cornerRadius = 2.5;
    _operationBtn.layer.masksToBounds = YES;
    _operationBtn.layer.borderWidth = 1;
    [_operationBtn setTitle:NSLocalizedString(@"拒绝确认", nil) forState:UIControlStateNormal];
    _operationBtn.backgroundColor = _define_white_color;
    _operationBtn.layer.borderColor = [UIColor colorWithHex:@"ed6498"].CGColor;
    [_operationBtn setTitleColor:[UIColor colorWithHex:@"ed6498"] forState:UIControlStateNormal];
    _operationBtn.titleLabel.font = [UIFont systemFontOfSize:[LanguageManager isEnglishLanguage]?12.0f:14.0f];

}

#pragma mark - UpdateUI
-(void)updateUI{

    if(_currentYYOrderTransStatusModel && _currentYYOrderInfoModel){
        self.contentView.backgroundColor = [UIColor colorWithHex:@"F8F8F8"];

        _helpBtn.hidden = NO;
        _dealCloseBtn.hidden = YES;

        _getBtn.hidden = NO;
        _getBtn.backgroundColor = _define_white_color;
        _getBtn.layer.borderColor = [UIColor colorWithHex:@"ed6498"].CGColor;
        [_getBtn setTitleColor:[UIColor colorWithHex:@"ed6498"] forState:UIControlStateNormal];
        _getBtn.titleLabel.font = [UIFont systemFontOfSize:[LanguageManager isEnglishLanguage]?12.0f:14.0f];

        _operationBtn.hidden = YES;

        _oprateTimerLabel.text = @"";

        _statusTipLabel.text = @"";
        _statusTipLayoutConstraint.constant = 40;
        _statusTipLabel.font = [UIFont systemFontOfSize:12];
        _statusTipLabel.textColor = [UIColor colorWithHex:@"919191"];

        _statusNameLabel.textColor = [UIColor colorWithHex:@"ed6498"];
        _statusNameTipLabel.hidden = YES;

        NSInteger tranStatus = getOrderTransStatus(self.currentYYOrderTransStatusModel.designerTransStatus, self.currentYYOrderTransStatusModel.buyerTransStatus);
        if(tranStatus == kOrderCode_CLOSE_REQ || [_currentYYOrderInfoModel.closeReqStatus integerValue] == -1){
            //关闭请求

            self.contentView.backgroundColor = [UIColor colorWithHex:@"FFFFFF"];

            _getBtn.hidden = YES;

            _helpBtn.hidden = YES;

            if([_currentYYOrderInfoModel.closeReqStatus integerValue] == -1){//对方
                _statusNameLabel.text = NSLocalizedString(@"处理中",nil);
                [_dealCloseBtn setTitle:NSLocalizedString(@"立刻处理",nil) forState:UIControlStateNormal];
                [_dealCloseBtn setConstraintConstant:[LanguageManager isEnglishLanguage]?100:80 forAttribute:NSLayoutAttributeWidth];
            }else{
                _statusNameLabel.text = NSLocalizedString(@"对方处理中",nil);
                [_dealCloseBtn setTitle:NSLocalizedString(@"撤销已取消",nil) forState:UIControlStateNormal];
                [_dealCloseBtn setConstraintConstant:108 forAttribute:NSLayoutAttributeWidth];
            }

            _statusTipLabel.font = [UIFont systemFontOfSize:14];
            _statusTipLayoutConstraint.constant = 20;

            _dealCloseBtn.hidden = NO;
            _dealCloseBtn.layer.borderColor = [UIColor colorWithHex:@"919191"].CGColor;
            _dealCloseBtn.layer.borderWidth = 1;
            _dealCloseBtn.layer.cornerRadius = 2.5;
            _dealCloseBtn.layer.masksToBounds = YES;

            if([_currentYYOrderInfoModel.autoCloseHoursRemains integerValue]>0){
                NSInteger day = [_currentYYOrderInfoModel.autoCloseHoursRemains integerValue]/24;
                NSInteger hours = [_currentYYOrderInfoModel.autoCloseHoursRemains integerValue]%24;
                NSString *timerStr = [NSString stringWithFormat:NSLocalizedString(@"%ld天%ld小时",nil),(long)day,(long)hours];
                NSString *tipStr = nil;
                if([_currentYYOrderInfoModel.closeReqStatus integerValue] == -1){//对方
                    tipStr = [NSString stringWithFormat:NSLocalizedString(@"剩余 %@，若不予处理，则交易自动取消",nil),timerStr];
                }else{
                    tipStr = [NSString stringWithFormat:NSLocalizedString(@"剩余 %@，对方未处理，交易将自动取消",nil),timerStr];
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
            }else{
                _statusTipLabel.text = @"";
            }
        }else if(tranStatus == kOrderCode_NEGOTIATION){
            //已下单

            _statusTipLabel.text = getOrderStatusDesignerTip_phone(tranStatus);

            BOOL isDesignerConfrim = [_currentYYOrderInfoModel isDesignerConfrim];
            BOOL isBuyerConfrim = [_currentYYOrderInfoModel isBuyerConfrim];

            if(!isBuyerConfrim){
                if(!isDesignerConfrim){
                    //双方都未确认
                    if(_currentOrderConnStatus == kOrderStatus1 || _currentOrderConnStatus == kOrderStatus || _currentOrderConnStatus == kOrderStatus3){
                        //关联成功 || 未入驻
                        [_getBtn setTitle:NSLocalizedString(@"确认订单",nil) forState:UIControlStateNormal];
                    }else{
                        //关联失败 || 关联中
                        _getBtn.backgroundColor = [UIColor colorWithHex:@"d3d3d3"];
                        _getBtn.layer.borderColor = [UIColor colorWithHex:@"d3d3d3"].CGColor;
                        [_getBtn setTitleColor:_define_white_color forState:UIControlStateNormal];
                        [_getBtn setTitle:NSLocalizedString(@"确认订单",nil) forState:UIControlStateNormal];
                    }
                }else{
                    //买手未确认
                    _getBtn.backgroundColor = [UIColor colorWithHex:@"d3d3d3"];
                    _getBtn.layer.borderColor = [UIColor colorWithHex:@"d3d3d3"].CGColor;
                    [_getBtn setTitleColor:_define_white_color forState:UIControlStateNormal];
                    [_getBtn setTitle:NSLocalizedString(@"待买手确认",nil) forState:UIControlStateNormal];
                }
            }else{
                if(!isDesignerConfrim){
                    //设计师未确认
                    _statusNameTipLabel.hidden = NO;

                    if(_currentOrderConnStatus == kOrderStatus1 || _currentOrderConnStatus == kOrderStatus || _currentOrderConnStatus == kOrderStatus3){
                        //关联成功 || 未入驻
                        [_getBtn setTitle:NSLocalizedString(@"确认订单",nil) forState:UIControlStateNormal];
                    }else{
                        //关联失败 || 关联中
                        _getBtn.backgroundColor = [UIColor colorWithHex:@"d3d3d3"];
                        _getBtn.layer.borderColor = [UIColor colorWithHex:@"d3d3d3"].CGColor;
                        [_getBtn setTitleColor:_define_white_color forState:UIControlStateNormal];
                        [_getBtn setTitle:NSLocalizedString(@"确认订单",nil) forState:UIControlStateNormal];
                    }

                    _operationBtn.hidden = NO;
                }else{
                    //理论上不存在这种情况
                    _getBtn.hidden = YES;
                }
            }

        }else if(tranStatus == kOrderCode_NEGOTIATION_DONE || tranStatus == kOrderCode_CONTRACT_DONE){
            //已确认

            _statusTipLabel.text = getOrderStatusDesignerTip_phone(tranStatus);

            [_getBtn setTitle:NSLocalizedString(@"已生产",nil) forState:UIControlStateNormal];

        }else if(tranStatus == kOrderCode_MANUFACTURE){
            //已生产

            _statusTipLabel.text = getOrderStatusDesignerTip_phone(tranStatus);

            [_getBtn setTitle:NSLocalizedString(@"已发货",nil) forState:UIControlStateNormal];

        }else if(tranStatus == kOrderCode_DELIVERY){
            //已发货

            NSString *timerStr = nil;
            if([_currentYYOrderInfoModel.autoReceivedHoursRemains integerValue]>-1){
                NSInteger day = [_currentYYOrderInfoModel.autoReceivedHoursRemains integerValue]/24;
                NSInteger hours = [_currentYYOrderInfoModel.autoReceivedHoursRemains integerValue]%24;
                timerStr = [NSString stringWithFormat:NSLocalizedString(@"%ld天%ld小时",nil),(long)day,(long)hours];
            }
            if(timerStr){
                _statusTipLabel.text =[NSString stringWithFormat:getOrderStatusDesignerTip_phone(tranStatus),timerStr] ;
            }else{
                _statusTipLabel.text = @"";
            }

            _getBtn.backgroundColor = [UIColor clearColor];
            _getBtn.layer.borderColor = [UIColor clearColor].CGColor;
            [_getBtn setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
            [_getBtn setTitle:NSLocalizedString(@"等待对方收货",nil) forState:UIControlStateNormal];

        }else if(tranStatus == kOrderCode_RECEIVED){
            //已收货

            _statusTipLabel.text = getOrderStatusDesignerTip_phone(tranStatus);
            _statusTipLabel.textColor = [UIColor colorWithHex:@"ed6498"];

            _getBtn.hidden = YES;

            _oprateTimerLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"标记于",nil),getShowDateByFormatAndTimeInterval(@"yyyy/MM/dd HH:mm",[_currentYYOrderTransStatusModel.operationTime stringValue])];

        }else if(tranStatus == kOrderCode_CANCELLED || tranStatus == kOrderCode_CLOSED){
            //已取消

            _statusTipLabel.text = getOrderStatusDesignerTip_phone(tranStatus);

            [_getBtn setTitle:NSLocalizedString(@"重新建立订单",nil) forState:UIControlStateNormal];
            _getBtn.backgroundColor = _define_black_color;
            _getBtn.layer.borderColor = _define_black_color.CGColor;
            [_getBtn setTitleColor:_define_white_color forState:UIControlStateNormal];

            _statusNameLabel.textColor = [UIColor colorWithHex:@"ef4e31"];
            _statusNameLabel.text = getOrderStatusName_detail(tranStatus,NO);

            _oprateTimerLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"标记于",nil),getShowDateByFormatAndTimeInterval(@"yyyy/MM/dd HH:mm",[_currentYYOrderTransStatusModel.operationTime stringValue])];

        }

        //更新约束
        if(_getBtn.hidden == NO){
            NSString *btnTxt = _getBtn.currentTitle;
            CGSize txtSize = [btnTxt sizeWithAttributes:@{NSFontAttributeName:_getBtn.titleLabel.font}];
            NSInteger btnWidth = MAX(80, (txtSize.width+20));
            [_getBtn setConstraintConstant:btnWidth forAttribute:NSLayoutAttributeWidth];
        }

        //设置背景、赋值
        if(!(tranStatus == kOrderCode_CANCELLED || tranStatus == kOrderCode_CLOSED || tranStatus == kOrderCode_CLOSE_REQ)){
            NSString *statusNameStr = getOrderStatusName_detail(tranStatus,YES);
            if(statusNameStr.length > 0){
                NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString: statusNameStr];
                [attributedStr addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:13] range: NSMakeRange(0, 1)];
                [attributedStr addAttribute: NSBaselineOffsetAttributeName value: @(0) range: NSMakeRange(0, 1)];
                _statusNameLabel.attributedText = attributedStr;
            }else{
                _statusNameLabel.text = @"";
            }


            BOOL isShowArrowBg = YES;
            if(tranStatus == kOrderCode_NEGOTIATION){
                //已下单
                BOOL isDesignerConfrim = [_currentYYOrderInfoModel isDesignerConfrim];
                BOOL isBuyerConfrim = [_currentYYOrderInfoModel isBuyerConfrim];

                if(isBuyerConfrim){
                    if(!isDesignerConfrim){
                        //设计师未确认
                        isShowArrowBg = NO;
                    }
                }
            }

            if(isShowArrowBg){
                //20001
                UIImageView *arrowBg = (UIImageView *)[self.contentView viewWithTag:20001];
                if(arrowBg){
                    arrowBg.image = [[UIImage imageNamed:@"arrowbg_img"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0,0)];
                }
            }
        }

        //_statusNameLabel设置宽度
        CGSize nameSize = [_statusNameLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:IsPhone6_gt?23.0f:20.0f]}];
        [_statusNameLabel setConstraintConstant:nameSize.width+1 forAttribute:NSLayoutAttributeWidth];
    }else{

        _getBtn.hidden = YES;
        _operationBtn.hidden = YES;
        _dealCloseBtn.hidden = YES;
        _helpBtn.hidden = NO;

    }
}

#pragma mark - --------------自定义响应----------------------
- (IBAction)opreteBtnHandler:(id)sender {

    NSInteger tranStatus = getOrderTransStatus(self.currentYYOrderTransStatusModel.designerTransStatus, self.currentYYOrderTransStatusModel.buyerTransStatus);

    if(self.delegate){
        if(tranStatus == kOrderCode_NEGOTIATION){
            //已下单

            BOOL isDesignerConfrim = [_currentYYOrderInfoModel isDesignerConfrim];
            BOOL isBuyerConfrim = [_currentYYOrderInfoModel isBuyerConfrim];

            if(!isBuyerConfrim){
                if(!isDesignerConfrim){
                    //双方都未确认
                    if(_currentOrderConnStatus == kOrderStatus1 || _currentOrderConnStatus == kOrderStatus || _currentOrderConnStatus == kOrderStatus3){
                        //关联成功 || 未入驻
                        [self.delegate btnClick:0 section:0 andParmas:@[@"confirmOrder"]];
                    }else{
                        //关联失败 || 关联中
                        [YYToast showToastWithTitle:NSLocalizedString(@"该订单未关联成功，无法确认",nil) andDuration:kAlertToastDuration];
                    }
                }
            }else{
                if(!isDesignerConfrim){
                    //设计师未确认
                    if(_currentOrderConnStatus == kOrderStatus1 || _currentOrderConnStatus == kOrderStatus || _currentOrderConnStatus == kOrderStatus3){
                        //关联成功 || 未入驻
                        [self.delegate btnClick:0 section:0 andParmas:@[@"confirmOrder"]];
                    }else{
                        //关联失败 || 关联中
                        [YYToast showToastWithTitle:NSLocalizedString(@"该订单未关联成功，无法确认",nil) andDuration:kAlertToastDuration];
                    }
                }
            }
        }else if(tranStatus == kOrderCode_NEGOTIATION_DONE || tranStatus == kOrderCode_CONTRACT_DONE){
            //已确认
            [self.delegate btnClick:0 section:0 andParmas:@[@"status"]];
        }else if(tranStatus == kOrderCode_MANUFACTURE){
            //已生产
            [self.delegate btnClick:0 section:0 andParmas:@[@"status"]];
        }else if(tranStatus == kOrderCode_CANCELLED || tranStatus == kOrderCode_CLOSED){
            //已取消
            [self.delegate btnClick:0 section:0 andParmas:@[@"reBuildOrder"]];
        }
    }
}
- (IBAction)opreteBtnHandler1:(id)sender {
    NSInteger tranStatus = getOrderTransStatus(self.currentYYOrderTransStatusModel.designerTransStatus, self.currentYYOrderTransStatusModel.buyerTransStatus);

    if(self.delegate){
        if(tranStatus == kOrderCode_NEGOTIATION){
            //已下单
            BOOL isDesignerConfrim = [_currentYYOrderInfoModel isDesignerConfrim];
            BOOL isBuyerConfrim = [_currentYYOrderInfoModel isBuyerConfrim];

            if(isBuyerConfrim){
                if(!isDesignerConfrim){
                    //设计师未确认
                    [self.delegate btnClick:0 section:0 andParmas:@[@"refuseOrder"]];
                }
            }
        }
    }
}
- (IBAction)showOprateView:(id)sender {

    NSInteger tranStatus = getOrderTransStatus(self.currentYYOrderTransStatusModel.designerTransStatus, self.currentYYOrderTransStatusModel.buyerTransStatus);

    if(self.delegate){
        if(tranStatus == kOrderCode_CLOSE_REQ || [_currentYYOrderInfoModel.closeReqStatus integerValue] == -1){
            if([_currentYYOrderInfoModel.closeReqStatus integerValue] == -1){//对方
                [self.delegate btnClick:0 section:0 andParmas:@[@"orderCloseReqDeal"]];
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


#pragma mark - --------------自定义方法----------------------
+(float)cellHeight:(NSInteger)tranStatus{
    if(tranStatus < kOrderCode_CANCELLED){
        if(tranStatus<kOrderCode_RECEIVED ){
            return 140;
        }
        return 111;
    }else if(tranStatus == kOrderCode_CANCELLED || tranStatus == kOrderCode_CLOSED){
        return 111;
    }else if(tranStatus == kOrderCode_CLOSE_REQ){
        return 98;
    }else{
        return 111;
    }
}

#pragma mark - --------------other----------------------


@end
