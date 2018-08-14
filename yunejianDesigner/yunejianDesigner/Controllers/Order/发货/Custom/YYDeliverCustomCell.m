//
//  YYDeliverCustomCell.m
//  yunejianDesigner
//
//  Created by yyj on 2018/6/19.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "YYDeliverCustomCell.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图

// 接口

// 分类
#import "UIImage+Tint.h"

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYDeliverModel.h"

#import "YYVerifyTool.h"

@interface YYDeliverCustomCell()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *deliverTitleLabel;
@property (nonatomic, strong) UITextField *deliverTextField;
@property (nonatomic, strong) UIButton *deliverRightButton;

@property(nonatomic,copy) void (^deliverCustomCellBlock)(NSString *type, NSString *value);

@end

@implementation YYDeliverCustomCell

#pragma mark - --------------生命周期--------------
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithBlock:(void(^)(NSString *type, NSString *value))block{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _deliverCustomCellBlock = block;
        [self SomePrepare];
        [self UIConfig];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
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
    self.contentView.backgroundColor = _define_white_color;
}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{

    WeakSelf(ws);

    UIView *bottomLine = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"EFEFEF"]];
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(15.5);
        make.right.mas_equalTo(-15.5);
    }];

    _deliverTitleLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:14.f WithTextColor:_define_black_color WithSpacing:0];
    [self.contentView addSubview:_deliverTitleLabel];
    [_deliverTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(bottomLine.mas_top).with.offset(0);
        make.width.mas_equalTo(100);
    }];

    _deliverTextField = [UITextField getTextFieldWithPlaceHolder:nil WithAlignment:2 WithFont:14.f WithTextColor:_define_black_color WithLeftWidth:0 WithRightWidth:0 WithSecureTextEntry:NO HaveBorder:NO WithBorderColor:nil];
    [self.contentView addSubview:_deliverTextField];
    [_deliverTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-41);
        make.left.mas_equalTo(ws.deliverTitleLabel.mas_right).with.offset(5);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(bottomLine.mas_top).with.offset(0);
    }];
    _deliverTextField.delegate = self;
    _deliverTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _deliverTextField.returnKeyType = UIReturnKeyDone;

    _deliverRightButton = [UIButton getCustomImgBtnWithImageStr:nil WithSelectedImageStr:nil];
    [self.contentView addSubview:_deliverRightButton];
    [_deliverRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(ws.contentView).with.offset(-0.5);
        make.height.mas_equalTo(44);
        make.left.mas_equalTo(ws.deliverTextField.mas_right).with.offset(0);
    }];
    [_deliverRightButton addTarget:self action:@selector(scanAction) forControlEvents:UIControlEventTouchUpInside];
    _deliverRightButton.userInteractionEnabled = NO;
}

#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{
    NSString *deliverTitleStr = nil;
    NSString *deliverPlaceholderStr = nil;
    NSString *deliverFieldStr = nil;
    UIImage *deliverRightImg = nil;
    if(_deliverCellType == YYDeliverCellTypeReceiverAddress){
        //收件地址
        deliverTitleStr = NSLocalizedString(@"收件地址 *", nil);
        if([_buyerStockEnabled boolValue]){
            deliverPlaceholderStr = NSLocalizedString(@"请选择收件地址", nil);
        }else{
            deliverPlaceholderStr = NSLocalizedString(@"请编辑收件地址", nil);
        }
        deliverRightImg = [[UIImage imageNamed:@"right_arrow"] imageWithTintColor:[UIColor colorWithHex:@"AFAFAF"]];
        _deliverTextField.userInteractionEnabled = NO;
        _deliverRightButton.userInteractionEnabled = NO;
    }else if(_deliverCellType == YYDeliverCellTypeLogisticsName){
        //物流公司
        deliverTitleStr = NSLocalizedString(@"物流公司 *", nil);
        deliverPlaceholderStr = NSLocalizedString(@"请选择物流公司", nil);
        deliverRightImg = [[UIImage imageNamed:@"right_arrow"] imageWithTintColor:[UIColor colorWithHex:@"AFAFAF"]];
        deliverFieldStr = _deliverModel.logisticsName;
        _deliverTextField.userInteractionEnabled = NO;
        _deliverRightButton.userInteractionEnabled = NO;
    }else if(_deliverCellType == YYDeliverCellTypeLogisticsCode){
        //物流单号
        deliverTitleStr = NSLocalizedString(@"物流单号 *", nil);
        deliverPlaceholderStr = IsPhone6_gt?NSLocalizedString(@"请填写或扫描物流单号", nil):NSLocalizedString(@"请填写或扫描物流单号_short", nil);
        deliverRightImg = [UIImage imageNamed:@"scan_deliver_icon"];
        deliverFieldStr = _deliverModel.logisticsCode;
        _deliverTextField.userInteractionEnabled = YES;
        _deliverRightButton.userInteractionEnabled = YES;
    }

    CGFloat titleWidth = getWidthWithHeight(30, deliverTitleStr, getFont(14.f));
    [_deliverTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(titleWidth);
    }];
    _deliverTitleLabel.text = deliverTitleStr;
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:deliverPlaceholderStr attributes:
                                      @{NSForegroundColorAttributeName:[UIColor colorWithHex:@"AFAFAF"],
                                        NSFontAttributeName:_deliverTitleLabel.font
                                        }];
    _deliverTextField.attributedPlaceholder = attrString;
    _deliverTextField.text = deliverFieldStr;
    [_deliverRightButton setImage:deliverRightImg forState:UIControlStateNormal];

}

#pragma mark - --------------系统代理----------------------
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(_deliverCellType == YYDeliverCellTypeReceiverAddress){
        //收件地址
        return NO;
    }else if(_deliverCellType == YYDeliverCellTypeLogisticsName){
        //物流公司
        return NO;
    }else if(_deliverCellType == YYDeliverCellTypeLogisticsCode){
        //物流单号
        return YES;
    }
    return NO;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_deliverTextField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    BOOL returnValue = NO;
    NSString *message = NSLocalizedString(@"您输入的快递单号有误！",nil);
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if (![NSString isNilOrEmpty:str]) {
        if([YYVerifyTool inputShouldLetterOrNum:str]){
            return YES;
        }
    }else{
        message = nil;
        textField.text = nil;
    }
    if (![NSString isNilOrEmpty:message] && !returnValue) {
        [YYToast showToastWithView:self title:message andDuration:kAlertToastDuration];
    }
    return returnValue;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{

    if(_deliverCustomCellBlock){
        _deliverCustomCellBlock(@"logisticsCode",textField.text);
    }

}
#pragma mark - --------------自定义响应----------------------
-(void)scanAction{
    if(_deliverCustomCellBlock){
        _deliverCustomCellBlock(@"scan",nil);
    }
}

#pragma mark - --------------自定义方法----------------------


#pragma mark - --------------other----------------------


@end
