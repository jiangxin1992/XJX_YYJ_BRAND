//
//  YYOrderStatusRequestCloseViewController.m
//  Yunejian
//
//  Created by Apple on 16/1/24.
//  Copyright © 2016年 yyj. All rights reserved.
//

#import "YYOrderStatusRequestCloseViewController.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图

// 接口

// 分类
#import "UIView+UpdateAutoLayoutConstraints.h"

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYOrderInfoModel.h"

@interface YYOrderStatusRequestCloseViewController (){}
@property (weak, nonatomic) IBOutlet UIView *statusViewContainer;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation YYOrderStatusRequestCloseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *yellowView = [self.view viewWithTag:10001];
    float uiWidth = MIN(325, SCREEN_WIDTH-30);
    [yellowView setConstraintConstant:uiWidth forAttribute:NSLayoutAttributeWidth];
    UIButton *cancelbtn =[self.view viewWithTag:10003];
    cancelbtn.layer.borderColor = [UIColor blackColor].CGColor;
    cancelbtn.layer.borderWidth = 1;
    UIView *circleView1 = [self.view viewWithTag:10004];
    UIView *circleView2 = [self.view viewWithTag:10005];
    circleView1.layer.cornerRadius = 6;
    circleView2.layer.cornerRadius = 6;
    
    NSString *tipStr = nil;
    if([_currentYYOrderInfoModel.isAppend integerValue] == 1){//追单
        tipStr = NSLocalizedString(@"这是一个追单订单，\n取消订单后，该追单与原始订单永久解除绑定。\n交易正式取消后，已生产此订单的数据将被剔除，款式已生产的件数可能大于订货量。",nil);
    }else{
        if([_currentYYOrderInfoModel.hasAppend integerValue]){//包含追单
            tipStr = NSLocalizedString(@"此订单包含一个追单，\n取消订单后，此订单与追单永久解除绑定；\n交易正式取消后，已生产此订单的数据将被剔除，款式已生产的件数可能大于订货量。",nil);
        }else{//普通订单
            tipStr = NSLocalizedString(@"交易正式取消后，已生产此订单的数据将被剔除，款式已生产的件数可能大于订货量。",nil);
        }
        
    }
    _tipLabel.text = tipStr;
    float needTxtHeight = getTxtHeight(uiWidth-62-8,tipStr,@{NSFontAttributeName:_tipLabel.font});
    float yellowViewHeight = 350 - 83 + needTxtHeight;
    [yellowView setConstraintConstant:yellowViewHeight forAttribute:NSLayoutAttributeHeight];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)closeBtnHandler:(id)sender {
    if (_cancelButtonClicked) {
        _cancelButtonClicked();
    }
}

- (IBAction)makeSureHandler:(id)sender {
    if (_modifySuccess) {
        _modifySuccess();
    }
}
@end
