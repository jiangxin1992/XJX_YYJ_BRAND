//
//  YYBuyerInfoCell.m
//  Yunejian
//
//  Created by lixuezhi on 15/8/17.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYBuyerInfoCell1.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图
#import "YYYellowPanelManage.h"
#import "MBProgressHUD.h"
#import "SCGIFImageView.h"

// 接口
#import "YYOrderApi.h"

// 分类
#import "UIImage+YYImage.h"
#import "UIView+UpdateAutoLayoutConstraints.h"

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYBuyerModel.h"
#import "YYOrderInfoModel.h"
#import "YYOrderBuyerAddress.h"

#import "UserDefaultsMacro.h"

@interface YYBuyerInfoCell1 ()
@property (weak, nonatomic) IBOutlet UIButton *headIcon;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *payMethodLab;
@property (weak, nonatomic) IBOutlet UILabel *giveMethodLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab1;

@property (weak, nonatomic) IBOutlet SCGIFImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *logoNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *connStatusBtn;
@property (weak, nonatomic) IBOutlet UIButton *connStatusHelpBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *connStatusHelpBtnRightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *connStatusHelpBtnWidthLayoutConstraint;

@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeLeftLenthLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payLeftLengthLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *giveLeftLengthLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressLeftLengthLayout;

@end

@implementation YYBuyerInfoCell1

#pragma mark - --------------生命周期--------------
- (void)awakeFromNib {
    [super awakeFromNib];
    [self SomePrepare];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - --------------SomePrepare--------------
- (void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
- (void)PrepareData{}
- (void)PrepareUI{
    if([LanguageManager isEnglishLanguage]){
        _typeLeftLenthLayout.constant = 100;
        _payLeftLengthLayout.constant = 100;
        _giveLeftLengthLayout.constant = 100;
        _addressLeftLengthLayout.constant = 100;
    }else{
        _typeLeftLenthLayout.constant = 60;
        _payLeftLengthLayout.constant = 60;
        _giveLeftLengthLayout.constant = 60;
        _addressLeftLengthLayout.constant = 60;
    }

    _connStatusBtn.layer.borderColor = [UIColor colorWithHex:@"919191"].CGColor;
    _connStatusBtn.layer.borderWidth = 1;
    _connStatusBtn.layer.cornerRadius = 2.5;
    _connStatusBtn.layer.masksToBounds = YES;

    _logoImageView.layer.borderWidth = 1;
    _logoImageView.layer.borderColor = [UIColor colorWithHex:@"d3d3d3"].CGColor;
    _logoImageView.layer.cornerRadius = 1;
    _logoImageView.layer.masksToBounds = YES;
}

#pragma mark - --------------UpdataUI----------------------
- (void)updataUI{

    _connStatusBtn.hidden = NO;

    _logoImageView.hidden = NO;
    _logoNameLabel.hidden = NO;
    _logoNameLabel.text = _currentYYOrderInfoModel.buyerName;

    sd_downloadWebImageWithRelativePath(NO, _currentYYOrderInfoModel.buyerLogo, _logoImageView, kLogoCover, 0);

    if([NSString isNilOrEmpty:_currentYYOrderInfoModel.type]){
        _typeLab.text = NSLocalizedString(@"订单类型未设置",nil);
        _typeLab.textColor = [UIColor colorWithHex:@"919191"];
    }else{
        if([_currentYYOrderInfoModel.type isEqualToString:@"BUYOUT"]){
            _typeLab.text = NSLocalizedString(@"买断",nil);
            _typeLab.textColor = _define_black_color;
        }else if([_currentYYOrderInfoModel.type isEqualToString:@"CONSIGNMENT"]){
            _typeLab.text = NSLocalizedString(@"寄售",nil);
            _typeLab.textColor = _define_black_color;
        }else{
            _typeLab.text = NSLocalizedString(@"订单类型未设置",nil);
            _typeLab.textColor = [UIColor colorWithHex:@"919191"];
        }
    }

    if(_currentYYOrderInfoModel.payApp == nil || [_currentYYOrderInfoModel.payApp  isEqualToString:@""]){
        self.payMethodLab.text = NSLocalizedString(@"结算方式未录入",nil);
        self.payMethodLab.textColor = [UIColor colorWithHex:@"919191"];
    }else{
        self.payMethodLab.text = _currentYYOrderInfoModel.payApp;
        self.payMethodLab.textColor = [UIColor colorWithHex:@"000000"];

    }
    if(_currentYYOrderInfoModel.deliveryChoose == nil || [_currentYYOrderInfoModel.deliveryChoose  isEqualToString:@""]){
        self.giveMethodLab.text = NSLocalizedString(@"发货方式未录入",nil);
        self.giveMethodLab.textColor = [UIColor colorWithHex:@"919191"];
    }else{
        self.giveMethodLab.text = _currentYYOrderInfoModel.deliveryChoose;
        self.giveMethodLab.textColor = [UIColor colorWithHex:@"000000"];

    }

    //设置地址
    YYOrderBuyerAddress *buyerAddress = _currentYYOrderInfoModel.buyerAddress;
    if (buyerAddress) {
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = 10;
        NSDictionary *attrDict = @{ NSParagraphStyleAttributeName: paraStyle,
                                    NSFontAttributeName: [UIFont systemFontOfSize: 13] };

        self.addressLab1.attributedText = [[NSAttributedString alloc] initWithString: getBuyerAddressStr_phone(buyerAddress) attributes: attrDict];
        self.addressLab1.textColor = [UIColor colorWithHex:@"000000"];

    }else{
        self.addressLab1.text = NSLocalizedString(@"收件地址未录入",nil);
        self.addressLab1.textColor = [UIColor colorWithHex:@"919191"];
    }
    //设置关联状态
    if(_currentOrderConnStatus >=-1){
        NSString *orderConnStutas = @"";
        NSMutableAttributedString *helpTipAttrStr = [[NSMutableAttributedString alloc] init];

        if(_currentOrderConnStatus == YYOrderConnStatusNotFound){
            orderConnStutas = getOrderConnStatusName_brand(_currentOrderConnStatus,NO);//@"【未入驻】";
            [helpTipAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:orderConnStutas attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:@"ef4e31"],NSFontAttributeName:[UIFont systemFontOfSize:13]}]];

        }else if(_currentOrderConnStatus == YYOrderConnStatusUnconfirmed){
            orderConnStutas = getOrderConnStatusName_brand(_currentOrderConnStatus,NO);//@"【关联中】";
            [helpTipAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:orderConnStutas attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:@"919191"],NSFontAttributeName:[UIFont systemFontOfSize:13]}]];

        }else if(_currentOrderConnStatus == YYOrderConnStatusLinked){

            orderConnStutas = getOrderConnStatusName_brand(_currentOrderConnStatus,NO);//@"【关联成功】";
            [helpTipAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:orderConnStutas attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:@"58c776"],NSFontAttributeName:[UIFont systemFontOfSize:13]}]];

        }else{
            orderConnStutas = getOrderConnStatusName_brand(_currentOrderConnStatus,NO);//@"【关联失败】";
            [helpTipAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:orderConnStutas attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:@"ef4e31"],NSFontAttributeName:[UIFont systemFontOfSize:13]}]];

        }
        NSInteger orderStatus = getOrderTransStatus(_currentYYOrderInfoModel.designerOrderStatus, _currentYYOrderInfoModel.buyerOrderStatus);
        if((_currentOrderConnStatus != YYOrderConnStatusLinked)&&(orderStatus == YYOrderCode_NEGOTIATION)){
            _connStatusBtn.hidden = NO;
            _connStatusHelpBtnRightLayoutConstraint.constant = 114;
        }else{
            _connStatusBtn.hidden = YES;
            _connStatusHelpBtnRightLayoutConstraint.constant = 17;
        }
        [_connStatusHelpBtn setAttributedTitle:helpTipAttrStr forState:UIControlStateNormal];
        CGSize seriesNameTextSize =[orderConnStutas sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
        CGSize imageSize = [UIImage imageNamed:@"help_icon"].size;
        float labelWidth = seriesNameTextSize.width;
        float imageWith = imageSize.width;
        [_connStatusHelpBtn setConstraintConstant:labelWidth+imageWith+1+10 forAttribute:NSLayoutAttributeWidth];
        _connStatusHelpBtn.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth, 0, -labelWidth);
        _connStatusHelpBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWith-5, 0, imageWith+5);
        _connStatusHelpBtn.hidden = NO;
    }else{
        _connStatusHelpBtn.hidden = YES;
    }
}

//#pragma mark - --------------请求数据----------------------
//-(void)RequestData{}

#pragma mark - --------------自定义响应----------------------
- (IBAction)reConnStatusHandler:(id)sender {
    if(self.currentYYOrderInfoModel.orderCode ==nil || self.currentYYOrderInfoModel.orderCode.length ==0){
        return;
    }

    //追单处理
    if([_currentYYOrderInfoModel.isAppend integerValue] == 1){
        if(self.originalOrderButtonClicked){
            self.originalOrderButtonClicked();
        }
        return;
    }

    //重新关联
    UIView *parentView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    __block UIView *blockParentView = parentView;
    UIViewController *viewController = (UIViewController *)_delegate;
    WeakSelf(ws);
    [[YYYellowPanelManage instance] showOrderBuyerAddressListPanel:@"Order" andIdentifier:@"YYOrderAddressListController"  needUnDefineBuyer:1 parentView:viewController andCallBack:^(NSArray *value) {

        YYBuyerModel *_buyerModel = nil;
        [MBProgressHUD showHUDAddedTo:blockParentView animated:YES];

        if([value count] >= 2){
            _buyerModel = [value objectAtIndex:1];
            ws.currentYYOrderInfoModel.buyerName = [NSString stringWithFormat:@"%@",_buyerModel.name];//;
            ws.currentYYOrderInfoModel.buyerEmail = [NSString stringWithFormat:@"%@",_buyerModel.contactEmail];//_buyerModel.contactEmail;
        }else{
            NSString* name = [value objectAtIndex:0];
            ws.currentYYOrderInfoModel.buyerName = name;
            ws.currentYYOrderInfoModel.buyerEmail = @"";
        }

        NSData *jsonData = [[ws.currentYYOrderInfoModel toDictionary] mj_JSONData];

        NSString *actionRefer = @"rebuild";
        NSInteger realBuyerId = [_buyerModel.buyerId integerValue];
        NSString *logoPath = nil;
        if(_buyerModel != nil){
            ws.currentYYOrderInfoModel.realBuyerId = [[NSNumber alloc ] initWithInt:[_buyerModel.buyerId intValue]];//;
            logoPath = (_buyerModel.logoPath?[_buyerModel.logoPath copy]:@"");
        }else{
            ws.currentYYOrderInfoModel.realBuyerId = [[NSNumber alloc ] initWithInt:0];
            logoPath = @"";
        }

        [YYOrderApi createOrModifyOrderByJsonData:jsonData actionRefer:actionRefer realBuyerId:realBuyerId andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSString *orderCode, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:blockParentView animated:YES];
            if (rspStatusAndMessage.status == YYReqStatusCode100) {
                [YYToast showToastWithView:blockParentView title:NSLocalizedString(@"操作成功",nil)  andDuration:kAlertToastDuration];
                if(ws.reConnStatusButtonClicked){
                    ws.reConnStatusButtonClicked(@[ws.currentYYOrderInfoModel.buyerName,ws.currentYYOrderInfoModel.buyerEmail, ws.currentYYOrderInfoModel.realBuyerId,logoPath]);
                }
            }else{
                [YYToast showToastWithView:blockParentView title:rspStatusAndMessage.message  andDuration:kAlertToastDuration];
            }
        }];

    }];
}
- (IBAction)connStatusHelpBtnHandler:(id)sender {
    NSString *imageStr = [LanguageManager isEnglishLanguage]?@"connstatushelp_img_en":@"connstatushelp_img";
    CMAlertView *alertView = [[CMAlertView alloc] initWithImage:[UIImage imageNamed:imageStr] imageFrame:CGRectMake(0, 0, 292, 219) cancelButtonTitle:nil bgClose:NO];
    [alertView setAlertViewBlock:^(NSInteger selectedIndex){

    }];
    [alertView show];
}


- (IBAction)showBuyerInfoView:(id)sender {
    if (self.delegate) {
        [self.delegate btnClick:0 section:0 andParmas:@[@"buyerInfo"]];
    }
}

#pragma mark - --------------自定义方法----------------------
+(NSInteger) getCellHeight:(NSString *)desc{
    NSInteger txtWidth = SCREEN_WIDTH - (([LanguageManager isEnglishLanguage]?100:60))-17;

    NSInteger textHeight = 0;
    if([desc isEqualToString:@""]){
        textHeight = 30;//13
    }else{
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = 10;
        NSDictionary *attrDict = @{ NSParagraphStyleAttributeName: paraStyle,
                                    NSFontAttributeName: [UIFont systemFontOfSize: 13]};
        textHeight = getTxtHeight(txtWidth, desc, attrDict);
    }
    return textHeight + 110 + 46 + 36;
}

#pragma mark - --------------other----------------------


@end
