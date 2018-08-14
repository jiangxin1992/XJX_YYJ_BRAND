//
//  YYUserInfoCell.h
//  Yunejian
//
//  Created by yyj on 15/7/16.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYShowroomInfoModel,YYUserInfo,YYShowroomInfoByDesignerModel;

typedef NS_ENUM(NSInteger, ShowType) {
    ShowTypeEmail = 60000,
    ShowTypeUsername = 60001,
    ShowTypePhone = 60002,
    ShowTypePassword = 60003,
    ShowTypeBuyer = 60004,
    ShowTypeSeller = 60005,
    ShowTypeAddress = 60006,
    ShowTypeCity = 60007,
    ShowTypeBrand = 60008,
    ShowTypeHome = 60009,
    ShowTypeContractTime = 60010,
    ShowTypeAgentShowroom = 60011
};


typedef void (^ModifyButtonClicked)(YYUserInfo *userInfo, ShowType currentShowType);
//typedef void (^SwitchClicked)(YYSeller *seller,BOOL isOn);

@interface YYUserInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *modifyButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *valueLabelTrailing;

//@property (weak, nonatomic) IBOutlet UISwitch *statusSwitch;
//@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property(nonatomic,strong)YYUserInfo *userInfo;
@property (strong, nonatomic) YYShowroomInfoModel *ShowroomModel;
@property(strong, nonatomic) YYShowroomInfoByDesignerModel *showroomInfoByDesignerModel;
//@property(nonatomic,strong)YYSeller *seller;

@property(nonatomic,strong)ModifyButtonClicked modifyButtonClicked;
//@property(nonatomic,strong)SwitchClicked switchClicked;

- (void)updateUIWithShowType:(ShowType )showType;
//- (void)setLabelStatus:(float)alpha;
-(void)hideBottomLine:(BOOL)isHide;
-(void)hideTipLabel:(BOOL)isHide;
@end
