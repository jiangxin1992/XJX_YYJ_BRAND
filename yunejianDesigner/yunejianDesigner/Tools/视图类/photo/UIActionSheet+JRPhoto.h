//
//  UIActionSheet+JRPhoto.h
//  parking
//
//  Created by chjsun on 2016/12/22.
//  Copyright © 2016年 chjsun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRPhoneDelegate.h"

typedef NS_ENUM(NSInteger, photoType) {
    /** 相机 */
    photoTypeCamera = 1,
    /** 相册 */
    photoTypeAlbum = 1 << 1,
};

//是否需要黑色遮盖
typedef NS_ENUM(NSInteger, needBlackView) {
    /** 需要 */
    need,
    /** 不需要 */
    noNeed,
};

//是否可编辑
typedef NS_ENUM(NSInteger,  isEditing) {
    /** 需要 */
    Yes,
    /** 不需要 */
    No,
};
@class UIActionSheet;
@protocol JRPhotoDelegate <NSObject>


@optional
- (void)JRPhotoView:(UIActionSheet *)ActionSheet PhotoData:(NSData *)data;

@end

@interface UIActionSheet (JRPhoto)

/**
 * controller为弹出的根
 * sign 唯一标示，原样返回，无逻辑处理，只是在多个拍照的时候可以有区分
 */

+ (void)SheetPhotoControl:(UIViewController *)controller WithDelegate:(id<JRPhotoImageDelegate>)delegate photoType:(photoType)photoType isEditing:(isEditing)isEditing  sign:(NSString *)sign;


@end
