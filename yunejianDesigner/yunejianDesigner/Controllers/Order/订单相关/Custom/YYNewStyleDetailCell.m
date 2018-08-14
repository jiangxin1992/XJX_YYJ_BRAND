//
//  YYNewStyleDetailCell.m
//  YunejianBuyer
//
//  Created by Apple on 16/3/4.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYNewStyleDetailCell.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图
#import "YYDiscountView.h"
#import "SCGIFImageView.h"
#import "YYCartStyleSizeInfoView.h"

// 接口

// 分类
#import "UIImage+YYImage.h"
#import "UIView+UpdateAutoLayoutConstraints.h"
#import "UIImage+Tint.h"

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYOrderSeriesModel.h"
#import "YYOrderStyleModel.h"
#import "YYOrderOneInfoModel.h"

@interface YYNewStyleDetailCell()

@property (nonatomic, weak) IBOutlet UILabel *topHeaderLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topHeaderHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *styleModifyTipLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *styleModifyTipLayoutLeftConstraint;
@property (weak, nonatomic) IBOutlet UILabel *styleCodeLabel;

@property (weak, nonatomic) IBOutlet UIButton *oprateBtn;
@property (weak, nonatomic) IBOutlet UIButton *oprateBtn1;
@property (weak, nonatomic) IBOutlet SCGIFImageView *styleImage;
@property (weak, nonatomic) IBOutlet UILabel *styleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stylePriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *styleTaxPriceTitle;
@property (weak, nonatomic) IBOutlet UILabel *styleTaxPriceLabel;

@property (weak, nonatomic) IBOutlet UIView *oneSizeInfoContainer;
@property (weak, nonatomic) IBOutlet YYDiscountView *priceDiscountView;

@property (weak, nonatomic) IBOutlet UILabel *sizeNameTitle;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceTitle;
@property (weak, nonatomic) IBOutlet UILabel *receivedTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sizeNameTitleRightWidthLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalPriceTitleRightWidthLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *receivedTitleRightWidthLayout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIButton *amountMinTipLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (weak, nonatomic) IBOutlet UIButton *addRemarkButton;

@property (nonatomic, strong) UIView *noCountTipView;

@property (nonatomic, assign) NSInteger tmpTopMagin;
@property (nonatomic, assign) NSInteger tmpSizeViewNum;
@property (nonatomic, strong) UITapGestureRecognizer *tap;

@end

@implementation YYNewStyleDetailCell

static NSInteger SizeViewCOnatinerTag = 10000;

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

    self.selectionStyle = UITableViewCellSelectionStyleNone;

    [_oprateBtn setBackgroundColor:[UIColor clearColor]];
    [_oprateBtn1 setBackgroundColor:[UIColor clearColor]];

    _styleImage.layer.cornerRadius = 5;
    _styleImage.layer.borderWidth = 2;
    _styleImage.layer.borderColor = [UIColor whiteColor].CGColor;
    _styleImage.layer.masksToBounds = YES;
}

#pragma mark - --------------UpdateUI----------------------
- (void)updateUI{

    _receivedTitle.hidden = !_isReceived;
    if(_isReceived){
        _sizeNameTitleRightWidthLayout.constant = -184;
        _totalPriceTitleRightWidthLayout.constant = -114;
    }else{
        _sizeNameTitleRightWidthLayout.constant = -170;
        _totalPriceTitleRightWidthLayout.constant = -62;
    }
    
    UIView *line = [self.contentView viewWithTag:10001];
    UIView *line1 = [self.contentView viewWithTag:10002];
    [line1 hideByWidth:YES];
    
    if (self.hiddenTopHeader || self.orderOneInfoModel.dateRange.start) {
        self.topHeaderHeightConstraint.constant = 0;
        self.topHeaderLabel.attributedText = nil;
    } else {
        self.topHeaderHeightConstraint.constant = 40;
        NSString *note = self.orderSeriesModel.note;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"发货方式：", nil) attributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
        [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"现货", nil)]];
        [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"  "]];
        [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"发货日期：", nil) attributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];
        [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString isNilOrEmpty:note] ? NSLocalizedString(@"马上发货", nil) : note]];
        self.topHeaderLabel.attributedText = attributedString;
    }
    
    //备注
    _addRemarkButton.hidden = YES;
    if (_showRemarkButton) {
        if(![NSString isNilOrEmpty:_orderStyleModel.remark]){
            _addRemarkButton.hidden = NO;
        }else{
            _addRemarkButton.hidden = YES;
        }
    }
    _totalPriceTitle.hidden = NO;
    if (self.delegate == nil || _isModifyNow == 0) {
        [_oprateBtn hideByWidth:YES];
        [_oprateBtn1 hideByWidth:YES];
        [line hideByWidth:YES];
    }else{
        if(_isModifyNow == 1){
            [_oprateBtn hideByWidth:NO];
            [_oprateBtn setConstraintConstant:60 forAttribute:NSLayoutAttributeWidth];

            [_oprateBtn1 hideByWidth:YES];
        }else if(_isModifyNow == 2){
            [_oprateBtn hideByWidth:YES];
            UIImage *icon = [[UIImage imageNamed:@"styledelete_icon"] imageWithTintColor:[UIColor colorWithHex:@"919191"]];
            [_oprateBtn1 setImage:icon forState:UIControlStateNormal];
            [_oprateBtn1 hideByWidth:NO];
            [_oprateBtn1 setConstraintConstant:60 forAttribute:NSLayoutAttributeWidth];
            _totalPriceTitle.hidden = YES;
        }else if(_isModifyNow == 3 || _isModifyNow == 5){
            UIImage *icon = [[UIImage imageNamed:@"styledelete_icon"] imageWithTintColor:[UIColor colorWithHex:@"919191"]];
            [_oprateBtn1 setImage:icon forState:UIControlStateNormal];

            [_oprateBtn hideByWidth:NO];
            [_oprateBtn1 hideByWidth:NO];
            if(!IsPhone6_gt){
                [_oprateBtn setConstraintConstant:30 forAttribute:NSLayoutAttributeWidth];
                [_oprateBtn1 setConstraintConstant:30 forAttribute:NSLayoutAttributeWidth];
            }else{
                [_oprateBtn setConstraintConstant:59 forAttribute:NSLayoutAttributeWidth];
                [_oprateBtn1 setConstraintConstant:59 forAttribute:NSLayoutAttributeWidth];
            }
            [line1 hideByWidth:NO];
        }else if(_isModifyNow == 4){
            [_oprateBtn hideByWidth:YES];
            UIImage *icon = [[UIImage imageNamed:@"styledelete_icon"] imageWithTintColor:[UIColor colorWithHex:@"ef4e31"]];
            [_oprateBtn1 setImage:icon forState:UIControlStateNormal];
            [_oprateBtn1 hideByWidth:NO];
            [_oprateBtn1 setConstraintConstant:60 forAttribute:NSLayoutAttributeWidth];
        }
        [line hideByWidth:NO];
    }

    NSString *imageRelativePath = _orderStyleModel.albumImg;
    sd_downloadWebImageWithRelativePath(NO, imageRelativePath, _styleImage, kStyleCover, 0);

    _styleNameLabel.text = _orderStyleModel.name;
    _styleCodeLabel.text = _orderStyleModel.styleCode;
    if(_isModifyNow == 0 && _tap == nil){
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBrandInfo:)];
        [_styleImage addGestureRecognizer:_tap];
        [_styleNameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBrandInfo:)]];
    }

    CGFloat minPrice = [self.orderStyleModel getMinOriginalPrice];
    CGFloat maxPrice = [self.orderStyleModel getMaxOriginalPrice];
    NSString *originalPriceStr = replaceMoneyFlag([NSString stringWithFormat:@"￥%0.2f",[_orderStyleModel.originalPrice floatValue]],[_orderStyleModel.curType integerValue]);
    NSString *finalPriceStr = minPrice == maxPrice ? replaceMoneyFlag([NSString stringWithFormat:@"￥%.2f", minPrice], [self.orderStyleModel.curType integerValue]) : replaceMoneyFlag([NSString stringWithFormat:@"￥%.2f-%.2f", minPrice, maxPrice], [_orderStyleModel.curType integerValue]);

    if((_isModifyNow == 0 || _isModifyNow == 3|| _isModifyNow == 5)&& ([_orderStyleModel.originalPrice floatValue] - [_orderStyleModel.finalPrice floatValue] > 0.01)){
        _priceDiscountView.showDiscountValue = YES;
        [_priceDiscountView updateUIWithOriginPrice:originalPriceStr
                                         fianlPrice:finalPriceStr
                                         originFont:[UIFont systemFontOfSize:14]
                                          finalFont:[UIFont boldSystemFontOfSize:14]];
        CGSize size = [originalPriceStr sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]}];
        [_priceDiscountView setConstraintConstant:size.width forAttribute:NSLayoutAttributeWidth];
        _stylePriceLabel.text = @"";
        _priceDiscountView.hidden = NO;
    }else{
        _stylePriceLabel.text = finalPriceStr;
        _priceDiscountView.hidden = YES;
    }
    int styleBuyedCount = 0;

    UIView *hideView1 = [self.contentView viewWithTag:20001];
    UIView *hideView2 = [self.contentView viewWithTag:20002];
    UIView *hideView3 = [self.contentView viewWithTag:20003];
    UIView *hideView4 = [self.contentView viewWithTag:20004];
    UIView *hideView5 = [self.contentView viewWithTag:20005];
    UIView *hideView6 = [self.contentView viewWithTag:20006];
    UIView *hideView7 = [self.contentView viewWithTag:20007];
    if(_isModifyNow == 4){//失效状态
        hideView7.hidden = hideView1.hidden = hideView2.hidden = hideView3.hidden= hideView4.hidden= hideView5.hidden= hideView6.hidden = YES;
        _totalPriceTitle.hidden = _oneSizeInfoContainer.hidden = _totalPriceLabel.hidden = YES;
        _styleModifyTipLabel.hidden = NO;
        CGSize _styleNameLabelSize = [_styleNameLabel.text sizeWithAttributes:@{NSFontAttributeName:_styleNameLabel.font}];
        _styleModifyTipLayoutLeftConstraint.constant = 15+6 + _styleNameLabelSize.width;
        _styleTaxPriceTitle.hidden = YES;
        _styleTaxPriceLabel.hidden = YES;
        return;
    }else{
        hideView7.hidden = hideView1.hidden = hideView2.hidden = hideView3.hidden= hideView4.hidden= hideView5.hidden= hideView6.hidden = NO;
        _totalPriceTitle.hidden = _oneSizeInfoContainer.hidden = _totalPriceLabel.hidden = NO;
        _styleModifyTipLabel.hidden = YES;
    }
    float taxRate = 0 ;
    if((_isModifyNow != 4 ) && needPayTaxView([_orderStyleModel.curType integerValue]) ){
        if(_selectTaxType){
            _styleTaxPriceTitle.hidden = NO;
            _styleTaxPriceLabel.hidden = NO;
            taxRate =[getPayTaxValue(_menuData, _selectTaxType, NO) doubleValue];
            _styleTaxPriceLabel.text = replaceMoneyFlag([NSString stringWithFormat:@"￥%0.2f", [((YYOrderOneColorModel *)self.orderStyleModel.colors.firstObject).originalPrice floatValue] * (1+taxRate)], [_orderStyleModel.curType integerValue]);
        }else{
            _styleTaxPriceTitle.hidden = YES;
            _styleTaxPriceLabel.hidden = YES;
        }
    }else{
        _styleTaxPriceTitle.hidden = YES;
        _styleTaxPriceLabel.hidden = YES;
    }

    self.tmpSizeViewNum = 0;
    self.tmpTopMagin = 20;
    if (_orderStyleModel.colors && [_orderStyleModel.colors count] > 0) {
        for (int i=0; i<[_orderStyleModel.colors count]; i++) {
            YYOrderOneColorModel *orderOneColorModel = [_orderStyleModel.colors objectAtIndex:i];
            orderOneColorModel.curType = orderOneColorModel.curType ? orderOneColorModel.curType : self.orderStyleModel.curType;
            int aColorCount = [self addAlineView:orderOneColorModel andLineIndex:i originalPrice:[_orderStyleModel.originalPrice floatValue] finalPrice:[_orderStyleModel.finalPrice floatValue]];
            styleBuyedCount += aColorCount;
        }
    }

    WeakSelf(ws);
    if(!_noCountTipView){
        //创建提示view
        int top_magin = 20;
        _noCountTipView = [UIView getCustomViewWithColor:_define_white_color];
        [_oneSizeInfoContainer addSubview:_noCountTipView];
        [_noCountTipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ws.tmpTopMagin);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(30);
        }];

        UILabel *tipLabel = [UILabel getLabelWithAlignment:1 WithTitle:NSLocalizedString(@"请重新编辑您要采购的商品", nil) WithFont:14.f WithTextColor:[UIColor colorWithHex:@"919191"] WithSpacing:0];
        [_noCountTipView addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(ws.noCountTipView);
        }];
        tipLabel.numberOfLines = 2;
        _tmpTopMagin += top_magin+30;
        _noCountTipView.hidden = YES;
    }
    if(!styleBuyedCount && _isModifyNow == 3){
        _noCountTipView.hidden = NO;
    }else{
        _noCountTipView.hidden = YES;
    }

    for (NSInteger i = _tmpSizeViewNum; i < [[_oneSizeInfoContainer subviews] count]; i++) {
        YYCartStyleSizeInfoView *sizeInfoView = [_oneSizeInfoContainer viewWithTag:(SizeViewCOnatinerTag+i)];
        sizeInfoView.hidden = YES;
    }
    if(_isAppendOrder && [_orderStyleModel.supportAdd integerValue] ==0){
        UIImage *icon = [[UIImage imageNamed:@"warn"] imageWithTintColor:[UIColor colorWithHex:@"ef4e31"]];
        [_amountMinTipLabel setImage:icon forState:UIControlStateNormal];
        [_amountMinTipLabel setTitle:NSLocalizedString(@"此款式不支持补货",nil) forState:UIControlStateNormal];
        _bottomLineLayoutConstraint.constant = 60;
    }else if(styleBuyedCount<[_orderStyleModel.orderAmountMin integerValue] ){
        UIImage *icon = [[UIImage imageNamed:@"warn"] imageWithTintColor:[UIColor colorWithHex:@"ef4e31"]];
        [_amountMinTipLabel setImage:icon forState:UIControlStateNormal];
        [_amountMinTipLabel setTitle:[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"未达每款起订量",nil),_orderStyleModel.orderAmountMin] forState:UIControlStateNormal];
        _bottomLineLayoutConstraint.constant = 60;
    }else{
        [_amountMinTipLabel setImage:nil forState:UIControlStateNormal];
        [_amountMinTipLabel setTitle:@"" forState:UIControlStateNormal];
        _bottomLineLayoutConstraint.constant = 45;
    }

    BOOL isAllSelectColor = YES;
    if (_orderStyleModel.colors && [_orderStyleModel.colors count] > 0) {
        for (YYOrderOneColorModel *orderOneColorModel in _orderStyleModel.colors) {
            if(![orderOneColorModel.isColorSelect boolValue]){
                isAllSelectColor = NO;
                break;
            }
        }
    }
    if(isAllSelectColor){
        _totalPriceLabel.text = [[NSString alloc] initWithFormat:NSLocalizedString(@"共计：%@件" ,nil),@"--"];
    }else{
        _totalPriceLabel.text = [[NSString alloc] initWithFormat:NSLocalizedString(@"共计：%d件  %@" ,nil), (styleBuyedCount < 0 ? 0 : styleBuyedCount), replaceMoneyFlag([NSString stringWithFormat:@"￥%0.2f", [self.orderStyleModel getTotalOriginalPrice]], [_orderStyleModel.curType integerValue])];
    }
}

#pragma mark - --------------请求数据----------------------
-(void)RequestData{}

#pragma mark - --------------自定义响应----------------------
- (IBAction)oprateBtnHandler:(id)sender {
    if (self.delegate) {
        [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:@[@"edit"]];
    }
}

- (IBAction)oprateBtnHandler1:(id)sender {
    if (self.delegate) {
        [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:@[@"delete"]];
    }
}
- (IBAction)showStyleRemark:(id)sender {
    if (self.delegate) {
        [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:@[@"styleRemark",_orderStyleModel.remark]];
    }
}

#pragma mark - --------------自定义方法----------------------
-(void)OnTapBrandInfo:(UITapGestureRecognizer *)sender{
    if (self.delegate) {
        [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:@[@"styleInfo"]];
    }
}
- (int)addAlineView:(YYOrderOneColorModel *)orderOneColorModel andLineIndex:(int)lineIndex originalPrice:(float)originalPrice finalPrice:(float)finalPrice{

    WeakSelf(ws);

    int item_width = SCREEN_WIDTH;
    int item_height = 30;
    int top_magin = 20;

    //尺码数量部份
    NSMutableArray *sizeSequence = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<[_orderStyleModel.sizeNameList count]; i++) {
        YYSizeModel *orderSizeDetailModel = [_orderStyleModel.sizeNameList objectAtIndex:i];
        for (YYOrderSizeModel *orderSizeModel in orderOneColorModel.sizes) {
            if ([orderSizeDetailModel.id intValue] == [orderSizeModel.sizeId intValue]) {
                [sizeSequence addObject:orderSizeModel];
                break;
            }
        }
    }

    int aColorAllSizeCount = 0;
    NSInteger tmpAmount = 0;
    if ([sizeSequence count] == [_orderStyleModel.sizeNameList count]) {
        //判断amount是不是都是0
        BOOL isColorSelect = [orderOneColorModel.isColorSelect boolValue];

        NSInteger sizeCount = 0;
        if(isColorSelect){
            if(_isModifyNow == 2 || _isModifyNow == 5){
                sizeCount = [sizeSequence count];
            }else{
                sizeCount = 1;
            }
        }else{
            //判断amount是不是都是0
            BOOL haveNum = NO;
            for (YYOrderSizeModel *sizeModel in orderOneColorModel.sizes) {
                if([sizeModel.amount integerValue]){
                    haveNum = YES;
                }
            }
            if(haveNum){
                sizeCount = [sizeSequence count];
            }else{
                sizeCount = 0;
            }
        }

        if(sizeCount){
            for (NSInteger i = (sizeCount-1); i >=0 ; i--) {
                YYOrderSizeModel *orderSizeModel = [sizeSequence objectAtIndex:i];
                tmpAmount = [orderSizeModel.amount intValue];
                if((tmpAmount > 0 || tmpAmount == -1) || isColorSelect){
                    YYSizeModel *orderSizeDetailModel = [_orderStyleModel.sizeNameList objectAtIndex:i];
                    YYCartStyleSizeInfoView *sizeInfoView = [_oneSizeInfoContainer viewWithTag:(SizeViewCOnatinerTag+_tmpSizeViewNum)];
                    if(sizeInfoView != nil){
                        [sizeInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.top.mas_equalTo(@(ws.tmpTopMagin));
                            make.left.mas_equalTo(@(0));
                            make.width.mas_equalTo(item_width);
                            make.height.mas_equalTo(@(item_height));
                        }];

                    }else{
                        sizeInfoView = [[YYCartStyleSizeInfoView alloc] init];
                        sizeInfoView.tag = (SizeViewCOnatinerTag+_tmpSizeViewNum);
                        [_oneSizeInfoContainer addSubview:sizeInfoView];
                        [sizeInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.mas_equalTo(@(ws.tmpTopMagin));
                            make.left.mas_equalTo(@(0));
                            make.width.mas_equalTo(item_width);
                            make.height.mas_equalTo(@(item_height));
                        }];
                    }
                    sizeInfoView.isReceived = _isReceived;
                    sizeInfoView.isColorSelect = @(isColorSelect);
                    sizeInfoView.hidden = NO;
                    tmpAmount = MAX(0,tmpAmount);
                    sizeInfoView.orderOneColorModel = orderOneColorModel;
                    sizeInfoView.orderSizeModel = orderSizeModel;
                    if (!self.orderStyleModel.dateRange || !self.orderStyleModel.dateRange.start) {
                        self.orderStyleModel.dateRange = self.orderOneInfoModel.dateRange;
                    }
                    sizeInfoView.orderStyleMedel = self.orderStyleModel;

                    sizeInfoView.sizeNameLabel.textColor = _define_black_color;
                    if(isColorSelect){
                        if(_isModifyNow == 2 || _isModifyNow == 5){
                            sizeInfoView.sizeNameLabel.text = [orderSizeDetailModel getSizeShortStr];
                        }else{
                            sizeInfoView.sizeNameLabel.text = @"--";
                            sizeInfoView.sizeNameLabel.textColor = [UIColor colorWithHex:@"ef4e31"];
                        }
                    }else{
                        sizeInfoView.sizeNameLabel.text = [orderSizeDetailModel getSizeShortStr];
                    }
                    sizeInfoView.isModifyNow = (_isModifyNow == 2 || _isModifyNow == 5);
                    sizeInfoView.indexPath = [NSIndexPath indexPathForRow:i inSection:lineIndex];
                    sizeInfoView.delegate = self;
                    [sizeInfoView setInputBoxHide:(_isModifyNow == 0||_isModifyNow == 1 ||_isModifyNow == 3)];
                    [sizeInfoView updateUI];

                    aColorAllSizeCount += tmpAmount;
                    _tmpTopMagin += top_magin+item_height;
                    _tmpSizeViewNum ++;
                }
            }
        }
    }

    return aColorAllSizeCount;
}

-(void)btnClick:(NSInteger)row section:(NSInteger)section andParmas:(NSArray *)parma{
    if (self.delegate) {
        NSIndexPath *sizeIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
        NSString *num = [parma objectAtIndex:0];
        [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:@[@"editStyleNum",sizeIndexPath,num]];
    }
}

+ (float)CellHeight:(NSInteger)num showHelpFlag:(BOOL)isShow showTopHeader:(BOOL)isShowHeader {
    int item_height = 30;
    int top_magin = 20;

    return (isShowHeader ? 285 : 245) - 42 + top_magin + (num?(top_magin+item_height)*num:(top_magin+item_height)) + (isShow ? 15 : 0);
}

#pragma mark - --------------other----------------------

@end
