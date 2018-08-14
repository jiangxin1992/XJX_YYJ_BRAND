//
//  JRPhoneDelegate.h
//  parking
//
//  Created by chjsun on 2016/12/22.
//  Copyright © 2016年 chjsun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JRPhoneDelegate;
@protocol JRPhotoImageDelegate <NSObject>

@optional
- (void)JRPhotoData:(NSData *)data sign:(NSString *)sign;

@end

@interface JRPhoneDelegate : NSObject<UIActionSheetDelegate>

@property(nonatomic, assign) UIViewController *pushController;
/** 照片的选择方式 */
@property(nonatomic, assign) NSInteger imagePickerType;
/** 是否需要编辑 */
@property(nonatomic, assign) NSInteger isEditing;
/** 唯一表示 */
@property (nonatomic, copy) NSString *sign;
+ (id)sharePhoneDelegate;

@property(nonatomic, assign) id<JRPhotoImageDelegate> delegate;

@end
