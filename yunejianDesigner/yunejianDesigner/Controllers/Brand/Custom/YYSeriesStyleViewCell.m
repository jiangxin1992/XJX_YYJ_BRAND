//
//  YYSeriesStyleViewself.m
//  Yunejian
//
//  Created by Apple on 15/12/3.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "YYSeriesStyleViewCell.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图
#import "SCGIFImageView.h"
#import "YYSmallShoppingCarButton.h"

// 接口

// 分类
#import "UIView+UpdateAutoLayoutConstraints.h"

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYOrderOneInfoModel.h"
#import "YYOrderInfoModel.h"
#import "YYOpusStyleModel.h"

#import "AppDelegate.h"

@interface YYSeriesStyleViewCell()

@property (weak, nonatomic) IBOutlet SCGIFImageView *styleImg;
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *styleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *retailPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *taxPriceLabel;

@property (weak, nonatomic) IBOutlet UIButton *selectButton;


@end

@implementation YYSeriesStyleViewCell
#pragma mark - --------------生命周期--------------

#pragma mark - --------------SomePrepare--------------
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
-(void)PrepareData{}
-(void)PrepareUI{
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.rasterizationScale = [UIScreen mainScreen].scale;

    _styleImg.contentMode = UIViewContentModeScaleAspectFit;
    _styleImg.layer.cornerRadius = 5;
    _styleImg.layer.masksToBounds = YES;
    _styleImg.backgroundColor = [UIColor colorWithHex:kDefaultImageColor];
}

#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{

    [self SomePrepare];

    if(!_isModifyOrder){
        if(_isSelect){
            _selectButton.hidden = NO;
            if(_opusStyleIsSelect){
                _selectButton.selected = YES;
                _selectButton.backgroundColor = [_define_black_color colorWithAlphaComponent:0.3];
            }else{
                _selectButton.selected = NO;
                _selectButton.backgroundColor = [UIColor clearColor];
            }
        }else{
            _selectButton.hidden = YES;
        }
    }else{
        _selectButton.hidden = YES;
    }

    UIButton *smallShoppingCarButton = (YYSmallShoppingCarButton *)[self viewWithTag:80005];
    smallShoppingCarButton.hidden = YES;

    _addButton.hidden = NO;
    if (!_isModifyOrder) {
        _addButton.hidden = YES;
    }else{
        smallShoppingCarButton.hidden = YES;
    }

    NSString *imageRelativePath = @"";
    NSString *name = @"";
    NSString *styleCode = @"";
    NSString *tradePrice = @"";
    NSString *retailPrice = @"";
    NSArray *colorArray = nil;

    if(_opusStyleModel){
        imageRelativePath = _opusStyleModel.albumImg;
        name = _opusStyleModel.name;
        styleCode = [_opusStyleModel.id stringValue];
        tradePrice = replaceMoneyFlag([NSString stringWithFormat:@"%@ ￥%0.2f",NSLocalizedString(@"批发价",nil),[_opusStyleModel.tradePrice floatValue]],[_opusStyleModel.curType integerValue]);
        retailPrice = replaceMoneyFlag([NSString stringWithFormat:@"%@ ￥%0.2f",NSLocalizedString(@"零售价",nil),[_opusStyleModel.retailPrice floatValue]],[_opusStyleModel.curType integerValue]);

        _taxPriceLabel.adjustsFontSizeToFitWidth = YES;
        if(_isModifyOrder == NO && needPayTaxView([_opusStyleModel.curType integerValue]) && _selectTaxType){
            [_taxPriceLabel hideByHeight:NO];
            float taxRate = [getPayTaxType(_selectTaxType,NO) doubleValue];
            _taxPriceLabel.text = replaceMoneyFlag([NSString stringWithFormat:@"%@ ￥%0.2f",NSLocalizedString(@"税后价",nil),[_opusStyleModel.tradePrice floatValue]*(1+taxRate)],[_opusStyleModel.curType integerValue]);
        }else{
            [_taxPriceLabel hideByHeight:YES];
        }
        if (_opusStyleModel.color
            && [_opusStyleModel.color count] > 0) {
            colorArray = _opusStyleModel.color;
        }
    }

    sd_downloadWebImageWithRelativePath(YES, imageRelativePath, _styleImg, kStyleCover, UIViewContentModeScaleAspectFit);

    _nameLabel.text = name;
    [_nameLabel setAdjustsFontSizeToFitWidth:YES];
    _styleLabel.text = _opusStyleModel.styleCode;
    _tradePriceLabel.text = tradePrice;
    _retailPriceLabel.text = retailPrice;


    for (UIView *view in _colorView.subviews) {
        [view removeFromSuperview];
    }

    if (colorArray
        && [colorArray count] > 0) {
        [self addColorViewToCover:_colorView colors:colorArray];
    }
}

#pragma mark - --------------自定义响应----------------------

- (IBAction)selectAction:(id)sender {
    if (self.delegate) {
        [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:@[@"selectStyle",_opusStyleModel]];
    }
}

#pragma mark - --------------自定义方法----------------------
- (void)addColorViewToCover:(UIView *)coverImageView colors:(NSArray *)colorArray{

    UIView *lastView = nil;
    UIView *tempContainer = [[UIView alloc] init];
    __weak UIView *weakCoverImageView = coverImageView;

    [coverImageView addSubview:tempContainer];
    [tempContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(15);
        make.left.equalTo(weakCoverImageView.mas_left);
        make.bottom.equalTo(weakCoverImageView.mas_bottom);
    }];

    __weak UIView *weakContainer = tempContainer;
    for (NSObject *obj in colorArray) {
        NSString *colorValue = @"";
        if ([obj isKindOfClass:[YYColorModel class]]) {
            YYColorModel *colorModel = (YYColorModel *)obj;
            colorValue = colorModel.value;
        }

        if (colorValue) {
            if ([colorValue hasPrefix:@"#"]
                && [colorValue length] == 7) {
                //16进制的色值
                UIColor *color = [UIColor colorWithHex:[colorValue substringFromIndex:1]];
                UILabel *label = [[UILabel alloc] init];
                label.backgroundColor = color;
                label.layer.borderWidth = 1;
                label.layer.borderColor = kBorderColor.CGColor;
                [tempContainer addSubview:label];


                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.and.bottom.equalTo(weakContainer);
                    make.width.mas_equalTo(15);

                    if ( lastView )
                    {
                        make.left.mas_equalTo(lastView.mas_right).with.offset(5);
                    }
                    else
                    {
                        make.left.mas_equalTo(weakContainer.mas_left);
                    }

                }];
                lastView = label;


            }else{
                //是图片的地址

                SCGIFImageView *imageView = [[SCGIFImageView alloc] init];
                [tempContainer addSubview:imageView];

                imageView.layer.borderWidth = 1;
                imageView.layer.borderColor = kBorderColor.CGColor;

                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.and.bottom.equalTo(weakContainer);
                    make.width.mas_equalTo(15);

                    if ( lastView )
                    {
                        make.left.mas_equalTo(lastView.mas_right).with.offset(5);
                    }
                    else
                    {
                        make.left.mas_equalTo(weakContainer.mas_left);
                    }

                }];
                lastView = imageView;


                NSString *imageRelativePath = colorValue;

                imageView.contentMode = UIViewContentModeScaleAspectFit;
                sd_downloadWebImageWithRelativePath(NO, imageRelativePath, imageView, kStyleColorImageCover, 0);

            }
        }
    }

    if (lastView) {
        [tempContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lastView.mas_right);
        }];
    }
}

+(float)CellHeight:(NSInteger)cellWidth showtax:(BOOL)showtax{
    //299  170
    if(showtax){
        return 355 + cellWidth - 10 - 196;
    }
    return 333 + cellWidth - 10 - 196;
}

#pragma mark - --------------other----------------------

@end
