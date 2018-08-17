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
@property (strong, nonatomic) NSArray<YYPaymentNoteModel,Optional, ConvertOnDemand>* result;
@end
