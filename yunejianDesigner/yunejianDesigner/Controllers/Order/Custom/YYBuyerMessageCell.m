//
//  YYBuyerMessageCell.m
//  Yunejian
//
//  Created by yyj on 15/8/21.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYBuyerMessageCell.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图
#import "SCGIFImageView.h"

// 接口

// 分类
#import "UIImage+YYImage.h"
#import "UIView+UpdateAutoLayoutConstraints.h"

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYOrderInfoModel.h"
#import "YYBuyerModel.h"

#import "UserDefaultsMacro.h"

@interface YYBuyerMessageCell ()<UITextFieldDelegate>{
    BOOL hasInitBuyerNameLabel;
}

@property (weak, nonatomic) IBOutlet UILabel *buyerNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyerNameButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buyerNameLayoutLeftConstraints;

@property (weak, nonatomic) IBOutlet UIButton *cardImageBtn;
@property (weak, nonatomic) IBOutlet SCGIFImageView *cardImageView;

@property (weak, nonatomic) IBOutlet UILabel *deliverMethodLabel;
@property (weak, nonatomic) IBOutlet UIButton *deliverMethodButton;
@property (weak, nonatomic) IBOutlet UILabel *payMethodLabel;
@property (weak, nonatomic) IBOutlet UIButton *payMethodButton;

@property (weak, nonatomic) IBOutlet UIButton *addAddressButton;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressLayoutLeftConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelWidthLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label2WidthLayout;

@end

@implementation YYBuyerMessageCell
#pragma mark - --------------生命周期--------------
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithBlock:(void(^)(NSString *type))block{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self SomePrepare];
    }
    return self;
}

#pragma mark - --------------SomePrepare--------------
- (void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
- (void)PrepareData{}
- (void)PrepareUI{
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;

    if([LanguageManager isEnglishLanguage]){
        _labelWidthLayout.constant = 120;
        _label2WidthLayout.constant = 120;
    }else{
        _labelWidthLayout.constant = 60;
        _label2WidthLayout.constant = 60;
    }

    _cardImageBtn.hidden = NO;
    _cardImageView.hidden = NO;
    [_cardImageBtn setTintColor:[UIColor blackColor]];

    [_deliverMethodButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
}

#pragma mark - --------------UpdateUI----------------------
- (void)updateUI{
    if (_currentYYOrderInfoModel) {
        if (_currentYYOrderInfoModel.deliveryChoose
            && [_currentYYOrderInfoModel.deliveryChoose length] > 0) {
            _deliverMethodLabel.text = _currentYYOrderInfoModel.deliveryChoose;
        }else{
            _deliverMethodLabel.text = @"";
        }

        if (_currentYYOrderInfoModel.payApp
            && [_currentYYOrderInfoModel.payApp length] > 0) {
            _payMethodLabel.text = _currentYYOrderInfoModel.payApp;
        }else{
            _payMethodLabel.text = @"";
        }

        if(self.orderCreateBuyerNameButtonClicked){
            _buyerNameButton.hidden = NO;
        }else{
            _buyerNameButton.hidden = YES;
        }
        if(_currentYYOrderInfoModel != nil && !hasInitBuyerNameLabel ){
            if (_currentYYOrderInfoModel.buyerName && [_currentYYOrderInfoModel.buyerName length] >0) {
                if(self.orderCreateBuyerNameButtonClicked){
                    NSString *undefineTip = NSLocalizedString(@"未入驻",nil);//
                    NSString *originStr = [NSString stringWithFormat:@"%@ %@",_currentYYOrderInfoModel.buyerName,undefineTip];

                    if(_buyerModel != nil && [_buyerModel.buyerId integerValue]>0){
                        originStr = [NSString stringWithFormat:@"%@ ",_buyerModel.name];
                        _buyerNameLabel.text = originStr;
                    }else{
                        originStr = [NSString stringWithFormat:@"%@ %@",_currentYYOrderInfoModel.buyerName,undefineTip];
                        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString: originStr];
                        [attributedStr addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithHex:@"ef4e31"] range: NSMakeRange(originStr.length-undefineTip.length, undefineTip.length)];
                        [attributedStr addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:12] range: NSMakeRange(originStr.length-undefineTip.length, undefineTip.length)];

                        _buyerNameLabel.attributedText = attributedStr;
                    }
                    _buyerNameLayoutLeftConstraints.constant = 37;
                    _buyerNameLabel.textColor = [UIColor blackColor];
                }else{
                    NSString *orderConnStutas = @"";
                    NSString * nameInfoStr = [NSString stringWithFormat:@"%@ ",_currentYYOrderInfoModel.buyerName];//_currentYYOrderInfoModel.buyerName;
                    NSMutableAttributedString *nameAttrStr = [[NSMutableAttributedString alloc] init];
                    NSInteger _currentOrderConnStatus= [_currentYYOrderInfoModel.orderConnStatus integerValue];
                    if(_currentOrderConnStatus == kOrderStatus){
                        [nameAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:nameInfoStr  attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]}]];
                        orderConnStutas = getOrderConnStatusName_brand(_currentOrderConnStatus,NO);//@"【未入驻】";
                        [nameAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:orderConnStutas attributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];

                    }else  if(_currentOrderConnStatus == kOrderStatus0){
                        [nameAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:nameInfoStr  attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]}]];
                        orderConnStutas = getOrderConnStatusName_brand(_currentOrderConnStatus,NO);//@"【未确认】";
                        [nameAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:orderConnStutas attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
                    }else if(_currentOrderConnStatus == kOrderStatus1){
                        [nameAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:nameInfoStr  attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]}]];
                        orderConnStutas = getOrderConnStatusName_brand(_currentOrderConnStatus,NO);//@"【关联中】";
                        [nameAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:orderConnStutas attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0 green:0 blue:0 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];

                    }else{
                        [nameAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:nameInfoStr  attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]}]];
                        orderConnStutas = getOrderConnStatusName_brand(_currentOrderConnStatus,NO);//@"【关联失败】";
                        [nameAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:orderConnStutas attributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
                    }
                    self.buyerNameLabel.attributedText = nameAttrStr;
                    _buyerNameLayoutLeftConstraints.constant = 17;
                    _buyerNameLabel.textColor = [UIColor colorWithHex:@"919191"];
                }
            }else{
                if(self.orderCreateBuyerNameButtonClicked){
                    _buyerNameLayoutLeftConstraints.constant = 17;
                    self.buyerNameLabel.text = @"";
                }else{
                    _buyerNameLayoutLeftConstraints.constant = 17;
                    self.buyerNameLabel.text = @"";
                }
            }

            _cardImageBtn.layer.borderWidth = 1;
            _cardImageBtn.layer.borderColor = [UIColor colorWithHex:@"efefef"].CGColor;
            _cardImageBtn.backgroundColor = [UIColor clearColor];
            _cardImageView.backgroundColor = [UIColor clearColor];
            _cardImageView.contentMode = UIViewContentModeScaleAspectFit;
            if (_currentYYOrderInfoModel.businessCard
                && [_currentYYOrderInfoModel.businessCard length] > 0) {
                [_cardImageBtn setImage:nil forState:UIControlStateNormal];
                NSString *imageRelativePath = _currentYYOrderInfoModel.businessCard;
                sd_downloadWebImageWithRelativePath(NO, imageRelativePath, _cardImageView, kBuyerCardImage, 0);

            }else{
                //这里判断一下，是否有离线创建订单时选择好的图片
                [_cardImageBtn setImage:[UIImage imageNamed:@"addcard"] forState:UIControlStateNormal];
                _cardImageView.image = nil;
            }

        }
        UIImageView *flagImgView = [self.contentView viewWithTag:10002];
        UILabel *addTipLabel = [self.contentView viewWithTag:10003];
        if (_buyerAddress) {
            NSString *showAddress = [self getAddressStr:_buyerAddress];
            NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
            paraStyle.lineSpacing = 8;
            NSDictionary *attrDict = @{ NSParagraphStyleAttributeName: paraStyle,
                                        NSFontAttributeName: [UIFont systemFontOfSize: 12] };

            _addressLabel.attributedText = [[NSAttributedString alloc] initWithString: showAddress attributes: attrDict];
            float txtheight = getTxtHeight(SCREEN_WIDTH-(self.orderCreateBuyerAddressButtonClicked?54:34), showAddress, attrDict);
            txtheight = MIN(38, txtheight);
            [_addressLabel setConstraintConstant:txtheight forAttribute:NSLayoutAttributeHeight];

            addTipLabel.text = @"";;
            flagImgView.hidden = NO;
            if (self.orderCreateBuyerAddressButtonClicked) {
                _addressLabel.textColor = [UIColor blackColor];
                _receiveLabel.font = [UIFont boldSystemFontOfSize:14];
                _phoneLabel.font = [UIFont boldSystemFontOfSize:14];
                _receiveLabel.text = _buyerAddress.receiverName;
                _phoneLabel.text = _buyerAddress.receiverPhone;
            }else{
                _addressLabel.textColor = [UIColor colorWithHex:@"919191"];
                _receiveLabel.font = [UIFont systemFontOfSize:14];
                _phoneLabel.font = [UIFont systemFontOfSize:14];
                _receiveLabel.text = [NSString stringWithFormat:@"%@  %@",_buyerAddress.receiverName,_buyerAddress.receiverPhone];//
                _phoneLabel.text = NSLocalizedString(@"来自买手店",nil);
            }

        }else{
            _addressLabel.text = @"";
            _receiveLabel.text = @"";
            _phoneLabel.text = @"";
            addTipLabel.text = NSLocalizedString(@"添加收货地址",nil);
            flagImgView.hidden = YES;
        }

        if (self.orderCreateBuyerAddressButtonClicked) {
            _addressLayoutLeftConstraints.constant = 37;
            _addAddressButton.hidden = NO;
        }else{
            _addressLayoutLeftConstraints.constant = 17;
            _addAddressButton.hidden = YES;
        }
    }
}

#pragma mark - --------------系统代理----------------------

#pragma mark - --------------自定义响应----------------------

- (IBAction)buyMessageButtonClicked:(id)sender{
    if (self.orderCreateBuyerMessageButtonClicked) {
        self.orderCreateBuyerMessageButtonClicked(sender);
    }
}

- (IBAction)buyAddressButtonClicked:(id)sender{

    if (self.orderCreateBuyerAddressButtonClicked) {
        self.orderCreateBuyerAddressButtonClicked();
    }
}

- (IBAction)deliverMethodButtonClicked:(id)sender{
    if (self.orderDeliverMethodButtonClicked) {
        self.orderDeliverMethodButtonClicked(sender);
    }
}
- (IBAction)buyerNameButtonClicked:(id)sender {
    if(self.orderCreateBuyerNameButtonClicked){
        self.orderCreateBuyerNameButtonClicked();
    }
}

- (IBAction)thirdButtonClicked:(id)sender{
    if (self.accountsMethodButtonClicked) {
        self.accountsMethodButtonClicked(sender);
    }
}
- (IBAction)oprateBtnHandler:(id)sender {
    if(self.delegate){
        [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:nil];
    }
}

#pragma mark - --------------自定义方法----------------------
-(NSString *)getAddressStr:(YYOrderBuyerAddress *)address{
    if(address == nil){
        return @" ";
    }
    NSString *nationStr = [LanguageManager isEnglishLanguage]?address.nationEn:address.nation;
    NSString *provinceStr = [LanguageManager isEnglishLanguage]?address.provinceEn:address.province;
    NSString *cityStr = [LanguageManager isEnglishLanguage]?address.cityEn:address.city;
    if([address.defaultShipping integerValue] > 0){
        return [NSString stringWithFormat:NSLocalizedString(@"[默认]%@ %@%@%@ %@",nil),nationStr,getProvince(provinceStr), [NSString isNilOrEmpty:cityStr]?@"":cityStr, [NSString isNilOrEmpty:address.street]?@"":address.street, address.detailAddress];
    }else{
        return [NSString stringWithFormat:NSLocalizedString(@"%@ %@%@%@ %@",nil),nationStr,getProvince(provinceStr), [NSString isNilOrEmpty:cityStr]?@"":cityStr, [NSString isNilOrEmpty:address.street]?@"":address.street, address.detailAddress];
    }
}

#pragma mark - --------------other----------------------
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
