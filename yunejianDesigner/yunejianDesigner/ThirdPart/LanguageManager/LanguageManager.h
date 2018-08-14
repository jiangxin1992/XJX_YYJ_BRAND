//
//  LanguageManager.h
//  ios_language_manager
//
//  Created by Maxim Bilan on 12/23/14.
//  Copyright (c) 2014 Maxim Bilan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYUserApi;

@interface LanguageManager : NSObject
//当前语言环境是否是英文
+(BOOL)isEnglishLanguage;
//设置系统语言  中文-英文  英文-中文
+ (void)setupCurrentLanguage;
//获取系统语言数组
+ (NSArray *)languageStrings;
//获取当前语言
+ (NSString *)currentLanguageString;
//获取当前语言code
+ (NSString *)currentLanguageCode;
//获取当前语言index
+ (NSInteger)currentLanguageIndex;
//保存语言
+ (void)saveLanguageByIndex:(NSInteger)index;
+ (BOOL)isCurrentLanguageRTL;

/**
 * 切换语言 保存到服务器
 * 服务端根据保存的字段 区分推送的语言类型
 * 在语言切换／用户登陆时候调用
 */
+ (void)setLanguageToServer;

@end
