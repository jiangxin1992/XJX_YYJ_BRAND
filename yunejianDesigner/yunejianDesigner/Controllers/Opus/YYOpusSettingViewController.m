//
//  YYOpusSettingViewController.m
//  Yunejian
//
//  Created by Apple on 16/6/7.
//  Copyright © 2016年 yyj. All rights reserved.
//

#import "YYOpusSettingViewController.h"

#import "UIImage+YYImage.h"
#import "UIView+UpdateAutoLayoutConstraints.h"
#import "YYYellowPanelManage.h"
#import "AppDelegate.h"
#import "YYConnApi.h"

@interface YYOpusSettingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *opusStatusType1;
@property (weak, nonatomic) IBOutlet UIButton *opusStatusType2;
@property (weak, nonatomic) IBOutlet UIButton *opusStatusType3;
@property (weak, nonatomic) IBOutlet UIButton *opusStatusType4;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong,nonatomic) NSString *authTypeInfo;
@end

@implementation YYOpusSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initBtn:_opusStatusType1 icon:@"panel_pub_status_me" txt:NSLocalizedString(@"仅自己可见",nil)];
    [self initBtn:_opusStatusType2 icon:@"panel_pub_status_buyer" txt:NSLocalizedString(@"合作买手店可见",nil)];
    [self initBtn:_opusStatusType3 icon:@"panel_pub_status_all" txt:NSLocalizedString(@"公开",nil)];
    [self initBtn:_opusStatusType4 icon:@"panel_pub_status_defined" txt:NSLocalizedString(@"自定义合作买手店查看权限",nil)];
    //_opusStatusType4.alpha = 0.5;
    [_opusStatusType4 setTitleColor:[UIColor colorWithHex:@"d3d3d3"] forState:UIControlStateNormal];
    _opusStatusType4.userInteractionEnabled = NO;
    [self updateOpusStatusTypeView];
    NSInteger contentWidht = MIN(325, SCREEN_WIDTH-30);
    [_contentView setConstraintConstant:contentWidht forAttribute:NSLayoutAttributeWidth];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initBtn:(UIButton *)button icon:(NSString *)icon txt:(NSString*)btnStr{
    NSString *normal_image_name = icon;
    NSString *selected_image_name = [NSString stringWithFormat:@"%@1",icon];
    UIImage *btnImage = [UIImage imageNamed:normal_image_name];
    
    [button setImage:btnImage forState:UIControlStateNormal];
    //    [button setImage:[UIImage imageNamed:selected_image_name] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:selected_image_name] forState:UIControlStateSelected];
    
    [button setTitleColor:[UIColor colorWithHex:@"919191"] forState:UIControlStateNormal];
    //    [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:button.frame.size] forState:UIControlStateNormal];
    //    [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:@"efefef"] size:button.frame.size] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:@"efefef"] size:button.frame.size] forState:UIControlStateSelected];
    
    [button setTitle:btnStr forState:UIControlStateNormal];
    
    [button.titleLabel setFont:[UIFont systemFontOfSize:IsPhone6_gt?14.0f:12.0f]];
    
    NSInteger contentWidht = MIN(325, SCREEN_WIDTH-30);
    float btnWith = contentWidht-78;//CGRectGetWidth(button.frame);
    CGSize txtSize= [btnStr sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font} ];
    float imageWith = button.imageView.image.size.width;
    //float imageHeight = button.imageView.image.size.height;
    float labelWidth = txtSize.width;
    //float labelHeight = txtSize.height;
    CGFloat imageOffsetX = ((imageWith + labelWidth) / 2)-btnWith/2;
    CGFloat imageOffsetY = 0;
    button.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX+10, imageOffsetY, -imageOffsetX-10);
    CGFloat labelOffsetX =  (imageWith + labelWidth) / 2-btnWith/2;
    CGFloat labelOffsetY = 0;
//    {top, left, bottom, right};
    button.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX-10, -labelOffsetY, labelOffsetX+10);
//    button.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -imageWith-10, -labelOffsetY, imageWith+10);
    //button.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 20);
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)closeBtnHandler:(id)sender {
    if (_cancelButtonClicked) {
        _cancelButtonClicked();
    }
}
- (IBAction)settingHandler:(id)sender {
    if(_opusStatusType1.selected || _opusStatusType2.selected || _opusStatusType3.selected || _opusStatusType4.selected){
        if(_selectedValue){
            if(_opusStatusType1.selected){
                _selectedValue(@"1");
            }
            if(_opusStatusType2.selected){
                _selectedValue(@"0");
            }
            if(_opusStatusType3.selected){
                _selectedValue(@"2");
            }
            if(_opusStatusType4.selected){
                if(self.authTypeInfo != nil){
                    _selectedValue(self.authTypeInfo);
                }
            }
        }
    }else{
        [YYToast showToastWithTitle:NSLocalizedString(@"请选择发布方式！",nil) andDuration:kAlertToastDuration];
    }
}
- (IBAction)selectOpusStatusType:(id)sender {
    if(sender == _opusStatusType1){
        _opusStatusType1.selected = YES;
        _opusStatusType2.selected = NO;
        _opusStatusType3.selected = NO;
        _opusStatusType4.selected = NO;
    }
    if(sender == _opusStatusType2){
        _opusStatusType2.selected = YES;
        _opusStatusType1.selected = NO;
        _opusStatusType3.selected = NO;
        _opusStatusType4.selected = NO;
    }
    if(sender == _opusStatusType3){
        _opusStatusType3.selected = YES;
        _opusStatusType2.selected = NO;
        _opusStatusType1.selected = NO;
        _opusStatusType4.selected = NO;
    }
    if(sender == _opusStatusType4 && _opusStatusType4.alpha >= 1){
        WeakSelf(ws);
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UIViewController *parent =appDelegate.mainViewController.topViewController;
        if(_seriesId > 0){
            [[YYYellowPanelManage instance] showOpusSettingDefinedViewWidthParentView:parent info:@[@(_seriesId),@(-1)] andCallBack:^(NSArray *value) {
                ws.opusStatusType4.selected = YES;
                ws.opusStatusType2.selected = NO;
                ws.opusStatusType1.selected = NO;
                ws.opusStatusType3.selected = NO;
                ws.authTypeInfo =[value objectAtIndex:0];
            }];
        }
        return;
    }
}

-(void)updateOpusStatusTypeView{
    WeakSelf(ws);
    [YYConnApi getConnBuyers:1 pageIndex:1 pageSize:1 andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYConnBuyerListModel *listModel, NSError *error) {
        if(rspStatusAndMessage.status == kCode100){
            if(listModel && [listModel.result count] > 0){
                //ws.opusStatusType4.alpha = 1.0;
                ws.opusStatusType4.userInteractionEnabled = YES;
                [ws.opusStatusType4 setTitleColor:[UIColor colorWithHex:@"919191"] forState:UIControlStateNormal];
                
            }
        }
    }];
}
@end
