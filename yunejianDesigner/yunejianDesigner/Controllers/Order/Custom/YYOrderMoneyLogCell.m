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
#import "YYOrderPayLogCell.h"

// 接口

// 分类
#import "UIView+UpdateAutoLayoutConstraints.h"

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）

@implementation YYOrderMoneyLogCell{
    NSArray* reversedArray;
    UITableView *payListTableView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)updateUI{
    self.addLogBtn.layer.borderColor = [UIColor colorWithHex:@"D3d3d3"].CGColor;
    self.addLogBtn.layer.borderWidth = 1;
    self.addLogBtn.layer.cornerRadius = 2.5;
    self.addLogBtn.layer.masksToBounds = YES;
    if(self.isPaylistShow == 0){
        self.paylistShowBtn.selected = NO;
    }else{
        self.paylistShowBtn.selected = YES;
    }
    
    NSInteger tranStatus = getOrderTransStatus(self.currentYYOrderTransStatusModel.designerTransStatus, self.currentYYOrderTransStatusModel.buyerTransStatus);
    NSString *hasMoneycolorStr = nil;
    if(tranStatus == kOrderCode_CLOSE_REQ || [self.currentYYOrderInfoModel.closeReqStatus integerValue] == -1){
        tranStatus = kOrderCode_CLOSE_REQ;
        hasMoneycolorStr = kDefaultBorderColor;
    }else{
        hasMoneycolorStr = @"ed6498";
    }
    
    float rndValue =  0;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.paragraphSpacingBefore = 10;
    paraStyle.firstLineHeadIndent = 10;
    if(_paymentNoteList == nil || [_paymentNoteList.result count] == 0){
        self.paylistShowBtn.hidden = YES;
        reversedArray = nil;
    }else{
        NSMutableArray *infoLogArr = [[NSMutableArray alloc] init];
        for (YYPaymentNoteModel *noteModel in _paymentNoteList.result) {
            [infoLogArr addObject:replaceMoneyFlag([NSString stringWithFormat:NSLocalizedString(@"%@ %@%d%@ ￥%.2f",nil),getShowDateByFormatAndTimeInterval(@"yyyy/MM/dd HH:mm",[noteModel.createTime stringValue]),NSLocalizedString(@"收款",nil),[noteModel.percent integerValue],@"%",[noteModel.amount floatValue]],[_currentYYOrderInfoModel.curType integerValue])];
            if([noteModel.payType integerValue] == 0 && ([noteModel.payStatus integerValue] == 0 || [noteModel.payStatus integerValue] == 2)){
            }else{
            rndValue += [noteModel.percent floatValue];
            }
        }
        reversedArray = [[infoLogArr reverseObjectEnumerator] allObjects];
        if([infoLogArr count] > 1){
            self.paylistShowBtn.hidden = NO;
        }else{
            self.paylistShowBtn.hidden = YES;
        }
        rndValue = rndValue/100;
    }


    NSInteger progressValue= rndValue*100;
    NSString *btnTxt = NSLocalizedString(@"查看详情",nil);
    NSInteger txtlength = [NSString stringWithFormat:@"%ld",(long)progressValue].length;
    NSInteger btnTxtlength = btnTxt.length;
    NSString *payStr = [NSString stringWithFormat:@"%ld%@%@ %@",(long)progressValue,@"% ",NSLocalizedString(@"货款已收",nil),btnTxt];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString: payStr];
    [attributedStr addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:IsPhone6_gt?13.0f:12.0f] range: NSMakeRange(txtlength, payStr.length-txtlength)];
    [attributedStr addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithHex:hasMoneycolorStr] range: NSMakeRange(0, txtlength+1)];
    [attributedStr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(payStr.length - btnTxtlength, btnTxtlength)];
    self.hasMoneyLabel.attributedText = attributedStr;
    CGSize hasMoneyTxtSize = [payStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:IsPhone6_gt?13.0f:12.0f]}];
    [self.hasMoneyLabel setConstraintConstant:(hasMoneyTxtSize.width + txtlength*21) forAttribute:NSLayoutAttributeWidth];
    self.addLogBtn.hidden = NO;
    if(tranStatus == 0 || tranStatus == kOrderCode_CANCELLED || tranStatus == kOrderCode_CLOSED || tranStatus == kOrderCode_CLOSE_REQ || tranStatus == kOrderCode_NEGOTIATION){//
        self.addLogBtn.enabled = NO;
    }else{
        self.addLogBtn.enabled = YES;
    }
    if(self.addLogBtn.enabled == YES){
        self.addLogBtn.backgroundColor = [UIColor clearColor];
        [self.addLogBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        self.addLogBtn.backgroundColor = [UIColor colorWithHex:@"d3d3d3"];
        [self.addLogBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    }
}

- (IBAction)showMoneyLogView:(id)sender {
    if(self.delegate){
        [self.delegate btnClick:0 section:0 andParmas:@[@"paylog"]];
    }
}
- (IBAction)showMoneyLogDetail:(id)sender {
    if(reversedArray == nil || [reversedArray count] == 0){
        [YYToast showToastWithTitle:NSLocalizedString(@"无收款记录",nil) andDuration:kAlertToastDuration];
        return;
    }
    
    if(self.delegate){
        [self.delegate btnClick:0 section:0 andParmas:@[@"payloglist"]];
    }
    
}

+(float)cellHeight:(NSArray *)payNoteList tranStatus:(NSInteger)tranStatus isPaylistShow:(NSInteger)isPaylistShow{
    return 71;

}
- (IBAction)showPaylistVIew:(id)sender {
    if(self.delegate){
        [self.delegate btnClick:0 section:0 andParmas:@[@"paylistShow",]];
    }
}


@end
