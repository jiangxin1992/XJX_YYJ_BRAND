//
//  YYShowroomMainNoDataView.h
//  yunejianDesigner
//
//  Created by yyj on 2017/3/11.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYShowroomMainNoDataView : UIView

-(instancetype)initWithSuperView:(UIView *)superView Block:(void(^)(NSString *type))block;

-(instancetype)initNoDataSearchWithSuperView:(UIView *)superView;

@property (nonatomic,copy) void (^block)(NSString *type);
@property (nonatomic,strong) UIView *superView;

@end
