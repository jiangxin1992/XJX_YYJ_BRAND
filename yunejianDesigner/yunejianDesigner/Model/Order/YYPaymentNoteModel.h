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
@property (strong, nonatomic) NSNumber <Optional>*id;
@property (strong, nonatomic) NSNumber <Optional>*amount;
@property (strong, nonatomic) NSNumber <Optional>*createTime;
@property (strong, nonatomic) NSNumber <Optional>*modifyTime;
@property (strong, nonatomic) NSNumber <Optional>*percent;
@property (strong, nonatomic) NSString <Optional>*note;
@property (strong, nonatomic) NSNumber <Optional>*payType;//支付类型 0:线下 1:线上    	 |
@property (strong, nonatomic) NSNumber <Optional>*payStatus;// 支付状态 0:未支付 1：支付成功 2：支付失败|
@property (strong, nonatomic) NSString <Optional>*orderCode;//":"11410409524288 ",
@property (strong, nonatomic) NSString <Optional>*outTradeNo;//":"12333",
@property (strong, nonatomic) NSNumber <Optional>*ownerRole;//代表这条记录属于谁的 设计师或者买手
@property (strong, nonatomic) YYPaymentNoteOnlinePayDetailModel <Optional>*onlinePayDetail;

@property (strong, nonatomic) NSNumber <Optional>*tmpPercent;//已经支付

@end
