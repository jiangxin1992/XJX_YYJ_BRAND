//
//  NSString+extra.m
//  OneBox
//
//  Created by 顾鹏 on 15/3/4.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "NSString+extra.h"

@implementation NSString (extra)
+ (BOOL )isNilOrEmpty:(NSString *)str;
{
    if (str && ![str isEqualToString:@""])
    {
        //去掉两端的空格
        if(![[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
            //string is all whitespace
            return YES;
        }else{
            return NO;
        }
    }

    return YES;
}

- (NSString *)transformToPinyin
{
    NSMutableString *mutableString = [NSMutableString stringWithString:self];

    CFStringTransform((CFMutableStringRef)mutableString,NULL,kCFStringTransformToLatin,false);

    mutableString=(NSMutableString*)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];

    return mutableString;
}

+ (NSNumber *)covertToNumber:(NSString *)numberString {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    return [formatter numberFromString:numberString];
}
- (BOOL)containsString:(NSString *)str{
    NSRange range = [self rangeOfString:str];
    if (range.location != NSNotFound) {//有@“心”
        //ios7系统下也适用
        return YES;
    }
    return NO;
}
@end
