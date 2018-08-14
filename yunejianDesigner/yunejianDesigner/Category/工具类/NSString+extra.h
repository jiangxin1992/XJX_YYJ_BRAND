//
//  NSString+extra.h
//  OneBox
//
//  Created by 顾鹏 on 15/3/4.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (extra)

/**
 判断传入字符串是否为空

 @param str 传入字符串
 @return 是否为空(nil/@""/nsnull)
 */
+ (BOOL )isNilOrEmpty:(NSString *)str;

/**
 字符串转拼音

 @return 转义后的拼音字符串
 */
- (NSString *)transformToPinyin;

+ (NSNumber *)covertToNumber:(NSString *)numberString;

- (BOOL)containsString:(NSString *)str;

@end
