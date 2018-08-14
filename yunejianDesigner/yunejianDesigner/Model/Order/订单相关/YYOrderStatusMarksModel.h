//
//  YYOrderStatusMarksModel.h
//  Yunejian
//
//  Created by yyj on 15/8/26.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"

@protocol YYOrderStatusMarksModel @end

@interface YYOrderStatusMarksModel : JSONModel

@property (strong, nonatomic) NSNumber <Optional>*modifyTime;//修改时间，暂时不需要用
@property (strong, nonatomic) NSNumber <Optional>*statusType;//
@property (strong, nonatomic) NSNumber <Optional>*isChecked;//bool 值

@end
