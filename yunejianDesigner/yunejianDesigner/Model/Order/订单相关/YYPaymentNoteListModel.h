//
//  YYPaymentNoteListModel.h
//  Yunejian
//
//  Created by Apple on 15/11/30.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"

#import "YYPaymentNoteModel.h"

@interface YYPaymentNoteListModel : JSONModel

@property (nonatomic, strong) NSArray<YYPaymentNoteModel,Optional, ConvertOnDemand>* result;

-(void)setTotalPercent:(double)finalTotalPrice;

@property (nonatomic, strong) NSNumber<Optional>* hasGiveRate;//已经支付比例 CGFloat
@property (nonatomic, strong) NSNumber<Optional>* hasGiveMoney;//已经支付金额 double

@property (nonatomic, strong) NSNumber<Optional>* pendingRate;//待审核金额 CGFloat
@property (nonatomic, strong) NSNumber<Optional>* pendingMoney;//待审核金额 double

@end
