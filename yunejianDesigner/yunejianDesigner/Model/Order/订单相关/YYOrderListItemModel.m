//
//  YYOrderListItemModel.m
//  Yunejian
//
//  Created by yyj on 15/8/25.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYOrderListItemModel.h"

@implementation YYOrderListItemModel

-(BOOL )isDesignerConfrim{
    BOOL isDesignerConfrim = NO;
    if(self){
        if([self.designerTransStatus integerValue] == YYOrderCode_NEGOTIATION_DONE || [self.designerTransStatus integerValue] == YYOrderCode_CONTRACT_DONE){
            isDesignerConfrim = YES;
        }
    }
    return isDesignerConfrim;
}

-(BOOL )isBuyerConfrim{
    BOOL isBuyerConfrim = NO;
    if(self){
        if([self.buyerTransStatus integerValue] == YYOrderCode_NEGOTIATION_DONE || [self.buyerTransStatus integerValue] == YYOrderCode_CONTRACT_DONE){
            isBuyerConfrim = YES;
        }
    }
    return isBuyerConfrim;
}

@end
