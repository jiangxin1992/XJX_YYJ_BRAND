//
//  YYOrderAmountModel.h
//  Yunejian
//
//  Created by yyj on 15/8/20.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"

@interface YYOrderAmountModel : JSONModel

@property (strong, nonatomic) NSNumber <Optional>*quantity;//起订量
@property (strong, nonatomic) NSNumber <Optional>*unitPrice;//起订价格

@end
