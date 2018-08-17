//
//  YYPaymentNoteListModel.m
//  Yunejian
//
//  Created by Apple on 15/11/30.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "YYPaymentNoteListModel.h"

@implementation YYPaymentNoteListModel

-(void)setTotalPercent:(double)finalTotalPrice{
    if(self){

        double hasGiveMoney = 0.f;//已经支付比例
        CGFloat hasGiveRate = 0.f;//已经支付金额
        double pendingMoney = 0.f;//待审核金额
        CGFloat pendingRate = 0.f;//待审核金额
        if(![NSArray isNilOrEmpty:self.result]){
            for (YYPaymentNoteModel *paymentNoteModel in self.result) {
                if([paymentNoteModel.payStatus integerValue] == 1){
                    //支付成功
                    hasGiveMoney += [paymentNoteModel.amount floatValue];
                }else if([paymentNoteModel.payStatus integerValue] == 0){
                    //待审核
                    pendingMoney += [paymentNoteModel.amount floatValue];
                }
            }
        }

        if(hasGiveMoney == finalTotalPrice){
            //全付清了
            hasGiveRate = 100.f;
        }else{
            //未付清
            hasGiveRate = (hasGiveMoney/finalTotalPrice)*100.f;
        }

        if(pendingMoney == finalTotalPrice){
            //全部在审核中
            pendingRate = 100.f;
        }else{
            //部分在审核中
            pendingRate = (pendingMoney/finalTotalPrice)*100.f;
        }


        self.hasGiveMoney = @(hasGiveMoney);
        self.hasGiveRate = @(hasGiveRate);
        self.pendingMoney = @(pendingMoney);
        self.pendingRate = @(pendingRate);
    }
}

@end
