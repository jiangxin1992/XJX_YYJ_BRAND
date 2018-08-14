//
//  YYOrderMoneyLogCell.m
//  Yunejian
//
//  Created by Apple on 15/11/25.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "YYOrderMoneyLogCell.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图

// 接口

// 分类
#import "UIView+UpdateAutoLayoutConstraints.h"

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYOrderInfoModel.h"
#import "YYPaymentNoteListModel.h"
#import "YYOrderTransStatusModel.h"

@interface YYOrderMoneyLogCell()

@property (weak, nonatomic) IBOutlet UIButton *addLogBtn;
@property (weak, nonatomic) IBOutlet UILabel *hasMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *paylistShowBtn;

@property (nonatomic, strong) NSArray *reversedArray;

@end

@implementation YYOrderMoneyLogCell

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
    self.hasMoneyLabel.font = [UIFont systemFontOfSize:IsPhone6_gt?33.f:18.f];

    self.addLogBtn.layer.cornerRadius = 2.5;
    self.addLogBtn.layer.masksToBounds = YES;
    setBorderCustom(self.addLogBtn, 1, [UIColor colorWithHex:@"d3d3d3"]);
}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{
}

#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{
    if(self.isPaylistShow == 0){
        self.paylistShowBtn.selected = NO;
    }else{
        self.paylistShowBtn.selected = YES;
    }

    NSInteger tranStatus = getOrderTransStatus(self.currentYYOrderTransStatusModel.designerTransStatus, self.currentYYOrderTransStatusModel.buyerTransStatus);
    NSString *hasMoneycolorStr = nil;
    if(tranStatus == YYOrderCode_CLOSE_REQ || [self.currentYYOrderInfoModel.closeReqStatus integerValue] == -1){
        tranStatus = YYOrderCode_CLOSE_REQ;
        hasMoneycolorStr = kDefaultBorderColor;
    }else{
        hasMoneycolorStr = @"ed6498";
    }

    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.paragraphSpacingBefore = 10;
    paraStyle.firstLineHeadIndent = 10;
    if(_paymentNoteList == nil || [_paymentNoteList.result count] == 0){
        self.paylistShowBtn.hidden = YES;
        _reversedArray = nil;
    }else{
        NSMutableArray *infoLogArr = [[NSMutableArray alloc] init];
        for (YYPaymentNoteModel *noteModel in _paymentNoteList.result) {
            [infoLogArr addObject:replaceMoneyFlag([NSString stringWithFormat:NSLocalizedString(@"%@ %@%.2lf%@ ￥%.2f",nil),getShowDateByFormatAndTimeInterval(@"yyyy/MM/dd HH:mm",[noteModel.createTime stringValue]),NSLocalizedString(@"收款",nil),[noteModel.realPercent floatValue],@"%",[noteModel.amount floatValue]],[_currentYYOrderInfoModel.curType integerValue])];
        }
        _reversedArray = [[infoLogArr reverseObjectEnumerator] allObjects];
        if([infoLogArr count] > 1){
            self.paylistShowBtn.hidden = NO;
        }else{
            self.paylistShowBtn.hidden = YES;
        }
    }

    CGFloat progressValue = [_paymentNoteList.hasGiveRate floatValue];
    NSString *btnTxt = NSLocalizedString(@"查看详情",nil);
    NSInteger txtlength = [NSString stringWithFormat:@"%.2lf",progressValue].length-3;
    NSInteger btnTxtlength = btnTxt.length;
    NSString *payStr = [NSString stringWithFormat:@"%.2lf%@%@ %@",progressValue,@"% ",NSLocalizedString(@"货款已收",nil),btnTxt];

    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:payStr];
    [attributedStr addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:IsPhone6_gt?13.0f:12.0f] range: NSMakeRange(txtlength, payStr.length-txtlength)];
    [attributedStr addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithHex:hasMoneycolorStr] range: NSMakeRange(0, txtlength+1+3)];
    [attributedStr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(payStr.length - btnTxtlength, btnTxtlength)];
    self.hasMoneyLabel.attributedText = attributedStr;

    CGSize hasMoneyTxtSize = [payStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:IsPhone6_gt?13.0f:12.0f]}];
    [self.hasMoneyLabel setConstraintConstant:(hasMoneyTxtSize.width + txtlength*21) forAttribute:NSLayoutAttributeWidth];

    self.addLogBtn.hidden = NO;
    if(tranStatus == 0 || progressValue == 100 || tranStatus == YYOrderCode_CANCELLED || tranStatus == YYOrderCode_CLOSED || tranStatus == YYOrderCode_CLOSE_REQ || tranStatus == YYOrderCode_NEGOTIATION){//
        self.addLogBtn.enabled = NO;
    }else{
        self.addLogBtn.enabled = YES;
    }

    if(self.addLogBtn.enabled == YES){
        if(progressValue > 100){
            self.addLogBtn.backgroundColor = _define_black_color;
            [self.addLogBtn setTitleColor:_define_white_color forState:UIControlStateNormal];
            [self.addLogBtn setTitle:NSLocalizedString(@"退款",nil) forState:UIControlStateNormal];
        }else{
            self.addLogBtn.backgroundColor = [UIColor clearColor];
            [self.addLogBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.addLogBtn setTitle:NSLocalizedString(@"添加线下收款记录",nil) forState:UIControlStateNormal];
        }
    }else{
        self.addLogBtn.backgroundColor = [UIColor colorWithHex:@"d3d3d3"];
        [self.addLogBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.addLogBtn setTitle:NSLocalizedString(@"添加线下收款记录",nil) forState:UIControlStateNormal];
    }

    NSString *tmpbtnTxt = self.addLogBtn.currentTitle;
    CGSize txtSize = [tmpbtnTxt sizeWithAttributes:@{NSFontAttributeName:self.addLogBtn.titleLabel.font}];
    NSInteger btnWidth = MAX(80, (txtSize.width+20));
    [self.addLogBtn setConstraintConstant:btnWidth forAttribute:NSLayoutAttributeWidth];
}

#pragma mark - --------------系统代理----------------------

#pragma mark - --------------自定义响应----------------------
- (IBAction)showMoneyLogView:(id)sender {
    if(!self.addLogBtn.enabled){//
        return;
    }
    if(self.delegate){
        [self.delegate btnClick:0 section:0 andParmas:@[@"paylog"]];
    }
}
- (IBAction)showMoneyLogDetail:(id)sender {
    if(_reversedArray == nil || [_reversedArray count] == 0){
        [YYToast showToastWithTitle:NSLocalizedString(@"无收款记录",nil) andDuration:kAlertToastDuration];
        return;
    }
    if(self.delegate){
        [self.delegate btnClick:0 section:0 andParmas:@[@"payloglist"]];
    }
}
- (IBAction)showPaylistVIew:(id)sender {
    if(self.delegate){
        [self.delegate btnClick:0 section:0 andParmas:@[@"paylistShow",]];
    }
}

#pragma mark - --------------自定义方法----------------------
+(float)cellHeight:(NSArray *)payNoteList tranStatus:(NSInteger)tranStatus isPaylistShow:(NSInteger)isPaylistShow{
    return 71;
}

#pragma mark - --------------other----------------------


@end
