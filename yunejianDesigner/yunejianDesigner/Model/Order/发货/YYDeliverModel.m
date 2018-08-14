//
//  YYDeliverModel.m
//  yunejianDesigner
//
//  Created by yyj on 2018/6/21.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "YYDeliverModel.h"

#import "YYPackingListDetailModel.h"
#import "YYVerifyTool.h"

@implementation YYDeliverModel

/**
 初始化

 @param packingListDetailModel ...
 @return ...
 */
-(instancetype)initWithPackingListDetailModel:(YYPackingListDetailModel *)packingListDetailModel{
    self = [super init];
    if(self){
        self.packageId = packingListDetailModel.packageId;
        self.logisticsCode = packingListDetailModel.logisticsCode;
        self.logisticsName = packingListDetailModel.logisticsName;
        self.receiver = packingListDetailModel.receiver;
        self.receiverPhone = packingListDetailModel.receiverPhone;
        self.receiverAddress = packingListDetailModel.receiverAddress;
    }
    return self;
}
/**
 地址是否有效

 @param buyerStockEnabled 此单的买手店库存是否已经开通 bool
 @return ...
 */
-(BOOL)isValidAddressWithBuyerStockEnabled:(BOOL)buyerStockEnabled{
    BOOL isValidAddress = NO;
    if(self){
        //地址填了没
        if(buyerStockEnabled){
            //开通库存
            if(self.warehouseId
               && (![NSString isNilOrEmpty:self.receiver])
               && (![NSString isNilOrEmpty:self.warehouseName])
               && (![NSString isNilOrEmpty:self.receiverPhone])
               && (![NSString isNilOrEmpty:self.receiverAddress]))
            {
                isValidAddress = YES;
            }
        }else{
            //未开通库存
            if((![NSString isNilOrEmpty:self.receiver])
               && (![NSString isNilOrEmpty:self.receiverPhone])
               && (![NSString isNilOrEmpty:self.receiverAddress]))
            {
                isValidAddress = YES;
            }
        }
    }
    return isValidAddress;
}
/**
 是否满足发货条件

 @param buyerStockEnabled 此单的买手店库存是否已经开通 bool
 @return ...
 */
-(BOOL)canDeliverWithBuyerStockEnabled:(BOOL)buyerStockEnabled{

    if(self){
        //地址填了没
        BOOL isValidAddress = [self isValidAddressWithBuyerStockEnabled:buyerStockEnabled];

        if([YYVerifyTool inputShouldLetterOrNum:self.logisticsCode] && self.packageId && ![NSString isNilOrEmpty:self.logisticsName] && isValidAddress){
            return YES;
        }

    }
    return NO;
}

@end
