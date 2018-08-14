//
//  SCLoopItem.m
//
//  Created by ShiCang on 15/5/8.
//  Copyright (c) 2015年 ShiCang. All rights reserved.
//

#import "SCLoopItem.h"

#import <SDWebImageManager.h>

#define RequestTimeOut  10

#pragma mark - NSString Categroy
@interface NSString (SCLoopItem)
- (BOOL)isValid;
@end

@implementation NSString (SCLoopItem)
/**
 *  判断是否为一个可用字符串
 */
- (BOOL)isValid {
    BOOL valid = YES;
    if (![self isKindOfClass:[NSString class]] || !self || [self isEqualToString:@""] || [[self pathExtension] isEqualToString:@""]) {
        valid = NO;
    }
    return valid;
}
@end


#pragma mark - NSDate Categroy
@interface NSDate (SCLoopItem)
- (BOOL)isImageData;
@end

@implementation NSData (SCLoopItem)
/**
 *  判断此二进制数据是否为图片数据
 */
- (BOOL)isImageData {
    UIImage *image = [UIImage imageWithData:self];
    return [image isKindOfClass:[UIImage class]];
}
@end


#pragma mark - SCLoopItem Implementation
typedef void(^DataBlock)(NSData *data);
typedef void(^ItemBlock)(SCLoopItem *item);

@implementation SCLoopItem {
    ItemBlock _itemBlock;
}

#pragma mark - Init Methods
- (instancetype)initWithUrl:(NSString *)url index:(NSInteger)index {
    self = [super init];
    if (self) {
        NSArray *tmpArr = [url componentsSeparatedByString:@"|"];
        _url  = [tmpArr objectAtIndex:0];
        _storePath = [tmpArr objectAtIndex:1];
        _index = index;
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image index:(NSInteger)index {
    self = [super init];
    if (self) {
        _data   = UIImagePNGRepresentation(image);
        _index = index;
    }
    return self;
}

#pragma mark - Public Methods
- (void)request:(void(^)(SCLoopItem *item))block {
    _itemBlock = block;
    if ([_data isImageData]) {
        __weak typeof(self)weakSelf = self;
        if (_itemBlock) {
            _itemBlock(weakSelf);
        }
    } else {
        [self loadImageWithUrl:_url];
    }
}

#pragma mark - Private Methods
/**
 *  获取图片数据
 *
 *  @param url 图片链接
 */
- (void)loadImageWithUrl:(NSString *)url {
    if ([url isValid]) {
        __weak typeof(self)weakSelf = self;
        [self getImageDataWithUrl:url block:^(NSData *data) {
            _data = data;
            if (_itemBlock) {
                _itemBlock(weakSelf);
            }
        }];
    }
}

/**
 *  从网络异步请求图片
 *
 *  @param url   图片链接
 *  @param block 请求成功后的回调
 */
- (void)getImageDataWithUrl:(NSString *)url block:(DataBlock)block {
    if (block) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        NSURL *imageUrl = [NSURL URLWithString:url];
        [manager loadImageWithURL:imageUrl options:SDWebImageRetryFailed|SDWebImageLowPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            if(image){
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSData *imageData = UIImagePNGRepresentation(image);
                    block(imageData);
                });
            }
        }];
    }
}

@end
