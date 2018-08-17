//
//  YYOrderTaxInfoCell.m
//  YunejianBuyer
//
//  Created by Apple on 16/7/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYOrderTaxInfoCell.h"

#import "YYDateRangeItemCell.h"
#import "YYYellowPanelManage.h"
#import "UIView+UpdateAutoLayoutConstraints.h"
#import "YYTaxChooseViewController.h"

@interface YYOrderTaxInfoCell()

@end
@implementation YYOrderTaxInfoCell

#pragma mark - updateUI
-(void)updateUI{

    if(_spaceViewType == 0){
        [_topSpaceView hideByHeight:NO];
        [_bottomSpaceView hideByHeight:YES];
    }else{
        [_topSpaceView hideByHeight:YES];
        [_bottomSpaceView hideByHeight:NO];
    }
    _totalStyleLabel.text = [NSString stringWithFormat:@"%i %@ %i %@",_stylesAndTotalPriceModel.totalStyles,NSLocalizedString(@"款",nil),_stylesAndTotalPriceModel.totalCount,NSLocalizedString(@"件",nil)];
    _originalPriceLabel.text =  replaceMoneyFlag([NSString stringWithFormat:@"￥%0.2f",_stylesAndTotalPriceModel.originalTotalPrice],_moneyType);
    
    double taxRate = 0;
    if(needPayTaxView(_moneyType)){
        _priceTitle.text = NSLocalizedString(@"税前总价",nil);
        if(_viewType != 3){
            if(_viewType == 4){//追单
                _taxTypeUI.layer.borderColor = [UIColor clearColor].CGColor;
                _taxTypeUI.layer.borderWidth = 1;
                _taxTypeUI.layer.cornerRadius = 2;
                _taxTypeUIDownImg.hidden = YES;
            }else{
                _taxTypeUI.layer.borderColor = [UIColor colorWithHex:@"efefef"].CGColor;
                _taxTypeUI.layer.borderWidth = 1;
                _taxTypeUI.layer.cornerRadius = 2;
                _taxTypeUIDownImg.hidden = NO;
            }
            _discountNumUI.layer.borderColor = [UIColor colorWithHex:@"efefef"].CGColor;
            _discountNumUI.layer.borderWidth = 1;
            _discountNumUI.layer.cornerRadius = 2;
            _discountNumUI.hidden = NO;
        }else{
            _taxTypeUI.layer.borderColor = [UIColor clearColor].CGColor;
            _taxTypeUI.layer.borderWidth = 1;
            _taxTypeUI.layer.cornerRadius = 2;
            _taxTypeUIDownImg.hidden = YES;
            _discountNumUI.hidden = YES;
        }
        _taxTypeLabel.text = getPayTaxValue(_menuData, _selectTaxType, YES);
        taxRate = [getPayTaxValue(_menuData,_selectTaxType,NO) doubleValue];
        _taxPriceLabel.text = replaceMoneyFlag([NSString stringWithFormat:@"+￥%0.2f",_stylesAndTotalPriceModel.originalTotalPrice*taxRate],_moneyType);
        if(taxRate > 0){
            _taxPriceLabel.textColor = [UIColor blackColor];
        }else{
            _taxPriceLabel.textColor = [UIColor colorWithHex:@"919191"];
        }
        _taxView.hidden = NO;
        _discountViewLayoutTopConstraint.constant = 67;
    }else{
        if(_viewType != 3){
            _discountNumUI.layer.borderColor = [UIColor colorWithHex:@"efefef"].CGColor;
            _discountNumUI.layer.borderWidth = 1;
            _discountNumUI.layer.cornerRadius = 2;
            _discountNumUI.hidden = NO;
        }else{
            _discountNumUI.hidden = YES;

        }
        _priceTitle.text = NSLocalizedString(@"总价",nil);
        _taxView.hidden = YES;
        _discountViewLayoutTopConstraint.constant = 23;
    }
    double discountRate = 0;
    double finalPrice = 0;
    if(false && _viewType == 1){
        _discountView.hidden = YES;
        finalPrice = _stylesAndTotalPriceModel.finalTotalPrice;

    }else{
        
        _discountView.hidden = NO;
        
        if(_currentYYOrderInfoModel != nil && [_currentYYOrderInfoModel.discount integerValue]>0 && [_currentYYOrderInfoModel.discount integerValue] < 100){
            
            if([LanguageManager isEnglishLanguage]){
                //英文
                discountRate = [_currentYYOrderInfoModel.discount doubleValue]/100;
                _discountNumLabel.text = [NSString stringWithFormat:@"%ld%% %@",[_currentYYOrderInfoModel.discount integerValue],NSLocalizedString(@"折_OFF",nil)];//3.5折
            }else{
                //中文
                discountRate = 1-[_currentYYOrderInfoModel.discount doubleValue]/100;
                double discountNum =[_currentYYOrderInfoModel.discount doubleValue]/10;
                _discountNumLabel.text = [NSString stringWithFormat:@"%0.1f %@",discountNum,NSLocalizedString(@"折_OFF",nil)];//3.5折
            }
            double discountPrice = _stylesAndTotalPriceModel.originalTotalPrice*(1+taxRate)*(discountRate);
            _discountPriceLabel.text = replaceMoneyFlag([NSString stringWithFormat:@"-￥%0.2f",discountPrice],_moneyType);
            _discountPriceLabel.textColor = [UIColor colorWithHex:@"ef4e31"];
        }else{
            _discountNumLabel.text = NSLocalizedString(@"无折扣",nil);
            _discountPriceLabel.text = replaceMoneyFlag([NSString stringWithFormat:@"-￥%0.2f",0.00],_moneyType);
            _discountPriceLabel.textColor = [UIColor colorWithHex:@"919191"];

        }
        finalPrice = _stylesAndTotalPriceModel.finalTotalPrice;
    }
    _finalPriceLabel.text = replaceMoneyFlag([NSString stringWithFormat:@"￥%0.2f",finalPrice],_moneyType);
}

#pragma mark - SomeAction

+(float)CellHeight:(BOOL)taxView :(BOOL)discountView{
    float height = 245;
    if(!taxView ){
        height = height - 27-13;
    }
    return height;
}

- (IBAction)selectTaxTypeHandler:(id)sender {
    if(_viewType == 3 || _viewType == 4){
        return;
    }
    
//跳转税率选择界面
    if(_taxChooseBlock){
        _taxChooseBlock();
    }
}
- (IBAction)discountBtnHandler:(id)sender {
    if(_viewType == 3){
        return;
    }
    if(_delegate){
        [_delegate btnClick:_indexPath.row section:_indexPath.section andParmas:@[@"discount"]];
    }
}
- (IBAction)helpBtnHandler:(id)sender {
    NSInteger helpPanelType = 3;//[[parmas objectAtIndex:2] integerValue];
    UIView *parentview = ((UIViewController *)_delegate).view;
    
    [[YYYellowPanelManage instance] showhelpPanelWidthParentView:parentview helpPanelType:helpPanelType andCallBack:^(NSArray *value) {
        
    }];
}

#pragma mark - Other
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
