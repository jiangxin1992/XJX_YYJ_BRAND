//
//  YYNoDataView.h
//  Yunejian
//
//  Created by Apple on 15/8/13.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYNoDataView : UIView

@property(nonatomic,strong) UILabel *tipLabel;
@property(nonatomic,strong) UILabel *titleLabel;

-(id)initWithIcon:(NSString *)iconName tipRow:(NSInteger)row topValue:(NSInteger)top;

-(id)initWithIcon:(NSString *)imageNamed offsetX:(NSInteger)offsetX;

@end
