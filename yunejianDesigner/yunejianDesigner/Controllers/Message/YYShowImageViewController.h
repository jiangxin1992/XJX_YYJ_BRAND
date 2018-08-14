//
//  YYShowImageViewController.H
//  parking
//
//  Created by chjsun on 2017/2/8.
//  Copyright © 2017年 chjsun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYShowImageViewController : UIViewController
/** 展示图片的URL，可以根据一个url展示一张图 */
@property(nonatomic, copy) NSString *imageUrl;
/** 展示的图片 可以根据一个uiimage展示一张图 */
@property(nonatomic, strong) UIImage *imageImage;
@end
