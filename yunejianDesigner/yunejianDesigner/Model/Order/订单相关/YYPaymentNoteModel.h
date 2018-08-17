//
//  YYPaymentNoteModel.h
//  Yunejian
//
//  Created by Apple on 15/11/30.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"

#import "YYPaymentNoteOnlinePayDetailModel.h"

@protocol YYPaymentNoteModel @end

@interface YYPaymentNoteModel : JSONModel

/**
 * 支付状态(线上) 0:未支付（用户已支付，但服务端还未收到支付宝回调） 1：支付成功（用户已支付，且服务端已收到支付宝回调） 2：支付失败
 * 支付状态(线下) 0:待确认（买手添加付款，品牌还未确认） 1：成功到账（品牌已确认、品牌添加的收款记录） 2：已作废(买手作废待确认付款记录)
 */
@property (strong, nonatomic) NSNumber <Optional>*payStatus;

@property (strong, nonatomic) NSNumber <Optional>*id;
@property (strong, nonatomic) NSNumber <Optional>*amount;
@property (strong, nonatomic) NSNumber <Optional>*createTime;
@property (strong, nonatomic) NSNumber <Optional>*modifyTime;
@property (strong, nonatomic) NSString <Optional>*note;
@property (strong, nonatomic) NSNumber <Optional>*payType;//支付类型 0:线下 1:线上    	 |
@property (strong, nonatomic) NSString <Optional>*orderCode;//":"11410409524288 ",
@property (strong, nonatomic) NSString <Optional>*outTradeNo;//":"12333",
@property (strong, nonatomic) NSNumber <Optional>*ownerRole;//代表这条记录属于谁的 设计师或者买手
@property (strong, nonatomic) NSNumber <Optional>*realPercent;//表示真实的付款百分比(订单强制发货后，金额发生变化，先前的百分比也变了) float
@property (strong, nonatomic) YYPaymentNoteOnlinePayDetailModel <Optional>*onlinePayDetail;

@property (strong, nonatomic) NSNumber <Optional>*tmpPercent;//已经支付

@end
