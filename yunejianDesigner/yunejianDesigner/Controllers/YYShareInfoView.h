//
//  YYShareInfoView.h
//  Yunejian
//
//  Created by yyj on 2017/4/17.
//  Copyright © 2017年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YYBrandHomeInfoModel.h"

typedef NS_ENUM(NSInteger, EShareViewType)
{
    EShareViewSeries,
    EShareViewOrder
};

@interface YYShareInfoView : UIView

-(instancetype)initWithShareViewType:(EShareViewType )shareViewType;

@property (nonatomic,strong) YYBrandHomeInfoModel *homePageModel;
@property (nonatomic,strong) UITextField *emailTextField;
@property (nonatomic,strong) UIButton *emailTipButton;

/**
 type(edit/hide/send)
 */
@property (nonatomic,copy) void (^shareViewBlock)(NSString *type);

@property (nonatomic,assign) EShareViewType shareViewType;

@end
