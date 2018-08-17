//
//  YYStylesAndTotalPriceModel.h
//  Yunejian
//
//  Created by yyj on 15/8/18.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYStylesAndTotalPriceModel : NSObject

@property (nonatomic,assign) int totalStyles;//共几款
@property (nonatomic,assign) int totalCount;//共多少件
@property (nonatomic,assign) float originalTotalPrice;//每款打完折后算出的总价
@property (nonatomic,assign) float finalTotalPrice;//税制,折后算出的总价
@end
