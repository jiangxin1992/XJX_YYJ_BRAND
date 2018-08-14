//
//  YYRequestHelp.h
//  Yunejian
//
//  Created by yyj on 15/7/3.
//  Copyright (c) 2015年 yyj. All rights reserved.
//
//这一块有过AFNetworking 2.0 -3.0的迁移，冗余代码可能比较多。（可优化）
#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@class AFURLConnectionOperation;
@class YYRspStatusAndMessage;
@class AFHTTPRequestOperation;

@interface YYRequestHelp : NSObject
/**
 请求
 
 @param isPost isPost
 @param headers tbPhoneDesignerAppVersion、token、lang等参数
 @param requestUrl 完整请求url
 @param requestCount 当前是第几次请求 默认为0
 @param requestBody 请求参数
 @param block 回调
 @return operation
 */
+ (void )POST:(NSDictionary *)headers requestUrl:(NSString *)requestUrl requestCount:(int)requestCount requestBody:(NSData *)requestBody andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage, id responseObject, NSError* error, id httpResponse))block;
+ (void )GET:(NSDictionary *)headers requestUrl:(NSString *)requestUrl requestCount:(int)requestCount requestBody:(NSData *)requestBody andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage, id responseObject, NSError* error, id httpResponse))block;
+ (void )PUT:(NSDictionary *)headers requestUrl:(NSString *)requestUrl requestCount:(int)requestCount requestBody:(NSData *)requestBody andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage, id responseObject, NSError* error, id httpResponse))block;
+ (void )DELETE:(NSDictionary *)headers requestUrl:(NSString *)requestUrl requestCount:(int)requestCount requestBody:(NSData *)requestBody andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage, id responseObject, NSError* error, id httpResponse))block;

/**
 上传图片

 @param url ...
 @param image ...
 @param size 尺寸
 @param block ...
 @return ...
 */
+ (AFHTTPRequestOperation *)uploadImageWithUrl:(NSString *)url
                                         image:(UIImage *)image
                                         size:(CGFloat )size
                                      andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage, id responseObject, NSError* error, id httpResponse))block;

/**
 上传图片 带进度

 @param url ...
 @param image ...
 @param size 尺寸
 @param block ...
 @param progress ...
 @return ...
 */
+ (void)uploadImageWithUrl:(NSString *)url
                                         image:(UIImage *)image
                                          size:(CGFloat )size
                                      progress:(void(^)(float percent))progress
                                      andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage, NSString *imageUrl, NSError *error))block;
@end
