//
//  NSMutableArray+extra.h
//  yunejianDesigner
//
//  Created by yyj on 2017/10/13.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (extra)

/**
 判断当前字符串是否为空（尽量用这个）

 @return 是否为空(nil/no count)
 */
- (BOOL )isNilOrEmpty;

@end
