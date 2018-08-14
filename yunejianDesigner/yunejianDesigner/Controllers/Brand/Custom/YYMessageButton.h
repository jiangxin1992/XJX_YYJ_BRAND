//
//  YYMessageButton.h
//  Yunejian
//
//  Created by Apple on 15/10/29.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYMessageButton : UIControl
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *numberLabel;
@property (nonatomic,strong)UIImageView *imageView;
- (void)initButton:(NSString *)title;
- (void)initBackButton;
- (void)updateButtonNumber:(NSString *)nowNumber;
@end
