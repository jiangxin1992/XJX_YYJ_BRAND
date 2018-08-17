//
//  YYSeriesCollectionViewCell.m
//  Yunejian
//
//  Created by yyj on 15/9/4.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYSeriesCollectionViewCell.h"

#import "UIImage+YYImage.h"
#import "YYOpusApi.h"
#import "Main.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "YYPopoverArrowBackgroundView.h"
#import "YYMenuPopView.h"
#import "SCGIFImageView.h"

#import "YYUser.h"
#import "YYSubShowroomUserPowerModel.h"

@interface YYSeriesCollectionViewCell ()


@property (weak, nonatomic) IBOutlet SCGIFImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UILabel *styleAmountLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLableHeightLayoutConstraint;

@property (weak, nonatomic) IBOutlet UILabel *outTimeFlagView2;
@property (nonatomic, weak) IBOutlet UILabel *deliveryLabel;

@property (weak, nonatomic) IBOutlet UIImageView *statusDraftImage;
@end

@implementation YYSeriesCollectionViewCell


#pragma menu
-(void)menuBtnHandler:(NSInteger)sender{
    NSInteger type = sender;

        if(_indexPath && self.delegate && [self.delegate respondsToSelector:@selector(operateHandler:androw:type:)]){

            [self.delegate operateHandler:type androw:_indexPath.row type:@"updateAuthType"];
        }
}


- (void)updateUI{
    NSString *imgStr = @"";
    
    if([LanguageManager isEnglishLanguage]){
        imgStr = @"draftflag_en_img";
    }else{
        imgStr = @"draftflag_img";
    }
    [_statusDraftImage setImage:[UIImage imageNamed:imgStr]];
    
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
    if (_title) {
        _titleLabel.text = _title;
    }
    if (_styleAmount) {
        _styleAmountLabel.text = _styleAmount;
    }
    if (_order) {
        _orderLabel.text = _order;
    }
    if(_compareResult == NSOrderedAscending){
        _outTimeFlagView2.hidden = NO;
    }else{
        _outTimeFlagView2.hidden = YES;
    }
    
    if (self.supplyStatus == 0) {
        self.deliveryLabel.text = NSLocalizedString(@"现货", nil);
    }else {
        self.deliveryLabel.text = NSLocalizedString(@"期货", nil);
    }

    _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    _coverImageView.backgroundColor = [UIColor colorWithHex:kDefaultImageColor];
    _coverImageView.layer.cornerRadius = 5;
    _coverImageView.layer.masksToBounds = YES;

    if (_imageRelativePath) {
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
        sd_downloadWebImageWithRelativePath(YES, _imageRelativePath, _coverImageView, kSeriesCover, UIViewContentModeScaleAspectFit);
    }
    _startBtn.hidden = NO;
    [_startBtn setTitleColor:[UIColor colorWithHex:@"000000"] forState:UIControlStateNormal];
    if(_status == YYOpusCheckAuthDraft){
        _statusDraftImage.hidden = NO;
        [_startBtn setImage:[UIImage imageNamed:@"opuspublish_icon"] forState:UIControlStateNormal];
        [_startBtn setTitle:NSLocalizedString(@"发布作品",nil) forState:UIControlStateNormal];
        [_startBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    }else{
        _statusDraftImage.hidden = YES;
        [_startBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];

        if(_authType == YYOpusAuthBuyer){
            [_startBtn setImage:[UIImage imageNamed:@"menu_pub_status_buyer1"] forState:UIControlStateNormal];
            [_startBtn setTitle:NSLocalizedString(@"合作买手店可见",nil) forState:UIControlStateNormal];
        }else if (_authType == YYOpusAuthMe){
            [_startBtn setImage:[UIImage imageNamed:@"menu_pub_status_me1"] forState:UIControlStateNormal];
            [_startBtn setTitle:NSLocalizedString(@"仅自己可见",nil) forState:UIControlStateNormal];
        }else if(_authType == YYOpusAuthAll){
            [_startBtn setImage:[UIImage imageNamed:@"menu_pub_status_all1"] forState:UIControlStateNormal];
            [_startBtn setTitle:NSLocalizedString(@"公开",nil) forState:UIControlStateNormal];
        }else if(_authType >= YYOpusAuthDefined){
            [_startBtn setImage:[UIImage imageNamed:@"menu_pub_status_defined1"] forState:UIControlStateNormal];
            if(_authType == YYOpusAuthDefined){
                [_startBtn setTitle:[NSString stringWithFormat:NSLocalizedString(@"%@个买手店可见",nil),_whiteAuthCount] forState:UIControlStateNormal];
            }else if (_authType == YYOpusAuthDefinedOther){
                [_startBtn setTitle:NSLocalizedString(@"已设置黑名单",nil) forState:UIControlStateNormal];
            }else{
                [_startBtn setTitle:NSLocalizedString(@"自定义查看权限" ,nil) forState:UIControlStateNormal];
            }
        }
    }

    [YYMenuPopView hiden:NO];
}

- (IBAction)startDownloadImgs:(id)sender {

    YYUser *user = [YYUser currentUser];
    // 获取subshowroom的权限列表, 首先是判断showroom子账号
    if (user.userType == YYUserTypeShowroomSub) {
        // 如果没有品牌操作权限，就不能操作
        YYSubShowroomUserPowerModel *subShowroom = [YYSubShowroomUserPowerModel shareModel];
        if (!subShowroom.isBrandAction) {
            [YYToast showToastWithTitle:NSLocalizedString(@"您的账号没有该操作权限！", nil) andDuration:kAlertToastDuration];
            return;
        }
    }

    if(_status == YYOpusCheckAuthPublish){

        WeakSelf(ws);
        
        NSInteger menuUIWidth = CGRectGetWidth(self.frame);
        NSInteger menuUIHeight = 160;
        NSArray *menuData;
        NSArray *menuIconData;
        menuData = @[NSLocalizedString(@"合作买手店可见",nil),NSLocalizedString(@"仅自己可见",nil),NSLocalizedString(@"公开",nil),NSLocalizedString(@"自定义查看权限",nil)];
        menuIconData = @[@"menu_pub_status_buyer",@"menu_pub_status_me",@"menu_pub_status_all",@"menu_pub_status_defined"];
        if(_authType == YYOpusAuthBuyer){
            menuIconData = @[@"menu_pub_status_buyer1",@"menu_pub_status_me",@"menu_pub_status_all",@"menu_pub_status_defined"];
        }else if (_authType == YYOpusAuthMe){
            menuIconData = @[@"menu_pub_status_buyer",@"menu_pub_status_me1",@"menu_pub_status_all",@"menu_pub_status_defined"];
        }else if(_authType == YYOpusAuthAll){
            menuIconData = @[@"menu_pub_status_buyer",@"menu_pub_status_me",@"menu_pub_status_all1",@"menu_pub_status_defined"];
        }else if(_authType >= YYOpusAuthDefined){
            menuIconData = @[@"menu_pub_status_buyer",@"menu_pub_status_me",@"menu_pub_status_all",@"menu_pub_status_defined1"];
        }
        
        CGPoint p =  CGPointMake(0, CGRectGetHeight(self.frame)-menuUIHeight);
        [YYMenuPopView addPellTableViewSelectWithWindowFrame:CGRectMake(p.x, p.y, menuUIWidth, menuUIHeight) selectData:menuData images:menuIconData displayData:@{@"fontSize":@(12),@"textAlignment":@(0),@"separatorInset":@(5),@"checkSelectEnable":@[@"connBuyers",@(3)]} action:^(NSInteger index) {
            if(index > -1)
            [ws menuBtnHandler:index];
        } animated:YES parentView:self];
    }else{
        if(_indexPath && self.delegate && [self.delegate respondsToSelector:@selector(operateHandler:androw:type:)]){
            [self.delegate operateHandler:_indexPath.section androw:_indexPath.row type:@"updatePubStatus"];
        }
    }
}

//383  447  363  337
+ (float)cellHeight:(NSInteger) cellWidth{
    float picSpace = 5;
    return 447 -337 + cellWidth-picSpace*2;
}
@end
