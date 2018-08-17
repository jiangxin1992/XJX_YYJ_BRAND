//
//  YYShoppingCell.m
//  Yunejian
//
//  Created by Apple on 15/8/3.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYShoppingCell.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图
#import "SCGIFImageView.h"
#import "YYShoppingStyleSizeInputView.h"

// 接口

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYColorModel.h"
#import "YYOrderSizeModel.h"
#import "YYStyleInfoModel.h"
#import "YYMessageUnreadModel.h"
#import "AppDelegate.h"

@interface YYShoppingCell ()<YYTableCellDelegate>

@property (weak, nonatomic) IBOutlet SCGIFImageView *clothColorImage;
@property (weak, nonatomic) IBOutlet UILabel *sizeColorNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *tradePriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectColorButton;

@property (nonatomic,strong) NSMutableArray *sizeInputArray;

@property (nonatomic, strong) YYColorModel *colorModel;

@end

@implementation YYShoppingCell
#pragma mark - --------------生命周期--------------
- (void)awakeFromNib {
    [super awakeFromNib];
    [self SomePrepare];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
#pragma mark - --------------SomePrepare--------------
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
-(void)PrepareData{}
-(void)PrepareUI{
    self.clothColorImage.backgroundColor = [UIColor whiteColor];
    self.clothColorImage.layer.borderWidth = 1;
    self.clothColorImage.layer.borderColor = [UIColor colorWithHex:@"d3d3d3"].CGColor;
}

//#pragma mark - --------------UIConfig----------------------
//-(void)UIConfig{}
#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{

    NSInteger cellRow = _indexPath.row/2 ;
    _colorModel = [_styleInfoModel.colorImages objectAtIndex:cellRow];
    
    if(!self.sizeInputArray){
        self.sizeInputArray = [[NSMutableArray alloc] init];
    }else{
        for (UIView *obj in self.sizeInputArray) {
            [obj removeFromSuperview];
        }
        [self.sizeInputArray removeAllObjects];
    }

    //设置颜色或者图片
    YYColorModel  *colorModel = _colorModel;
    _sizeColorNameLabel.text = colorModel.name;
    self.tradePriceLabel.text = replaceMoneyFlag([NSString stringWithFormat:@"￥%.2f", [colorModel.tradePrice floatValue]],[_styleInfoModel.style.curType integerValue]);
    if ([colorModel.value hasPrefix:@"#"] && [colorModel.value  length] == 7) {
        //16进制的色值
        UIColor *color = [UIColor colorWithHex:[colorModel.value substringFromIndex:1]];
        [self.clothColorImage setImage:nil];
        self.clothColorImage.backgroundColor = color;
    }else{
        //图片
        NSString *imageRelativePath = colorModel.value;
        sd_downloadWebImageWithRelativePath(NO, imageRelativePath, self.clothColorImage, kStyleColorImageCover, 0);
    }

    _selectColorButton.hidden = !_isOnlyColor;
    if(_isOnlyColor){

        _selectColorButton.selected = [_colorModel.isSelect boolValue];

    }else{

        NSInteger maxSizeCount = kMaxSizeCount;
        if ([_styleInfoModel.size count] < kMaxSizeCount) {
            maxSizeCount = [_styleInfoModel.size count];
        }
        YYSizeModel *sizeModel = nil;
        NSInteger sizeStock = LONG_MAX;
        YYOrderSizeModel *amountsizeModel = nil;
        UIView *lastView = nil;
        for (int i = 0; i<maxSizeCount; i++) {
            sizeModel = [_styleInfoModel.size objectAtIndex:i];
            if ([self useStockControl] && self.colorModel.sizeStocks.count == self.styleInfoModel.size.count) {
                sizeStock = [[self.colorModel.sizeStocks objectAtIndex:i] integerValue];
            }
            YYShoppingStyleSizeInputView *sizeInput = [[YYShoppingStyleSizeInputView alloc] init];
            [self.contentView addSubview:sizeInput];
            [sizeInput mas_makeConstraints:^(MASConstraintMaker *make) {
                if(lastView){
                    make.top.mas_equalTo(lastView.mas_bottom).with.offset(20);
                }else{
                    make.top.mas_equalTo(20);
                }
                make.right.mas_equalTo(-17);
                make.height.mas_equalTo(30);
                make.width.mas_equalTo(183);
            }];
            sizeInput.hidden = NO;
            sizeInput.sizeNameLabel.text = [sizeModel getSizeShortStr];
            sizeInput.minCount = 0;
            sizeInput.maxCount = sizeStock;
            if(_amountsizeArr && [_amountsizeArr count] > i){
                amountsizeModel = [_amountsizeArr objectAtIndex:i];
                sizeInput.value = (amountsizeModel && [amountsizeModel.amount integerValue] > 0) ? [amountsizeModel.amount integerValue] : 0;
            }else{
                sizeInput.value = 0;
            }
            sizeInput.index = i;
            sizeInput.delegate = self;
            [sizeInput setTextFieldDidEndEditingBlock:^(YYShoppingStyleSizeInputView *inputView) {
                if (inputView.value > sizeStock) {
                    [YYToast showToastWithTitle:[NSString stringWithFormat:NSLocalizedString(@"目前该尺码最大库存数为%ld，请重新输入", nil), sizeStock] andDuration:kAlertToastDuration];
                    inputView.value = sizeStock;
                }
            }];
            lastView = sizeInput;
            [_sizeInputArray addObject:sizeInput];
        }
    }
}
#pragma mark - --------------自定义响应----------------------
-(void)btnClick:(NSInteger)row section:(NSInteger)section andParmas:(NSArray *)parmas{
    if(self.delegate){
        [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:@[@"styleNumChange",@(row),[parmas objectAtIndex:0]]];
    }
}
- (IBAction)selectColorAction:(id)sender {
    if(self.delegate){
        if([_colorModel.isSelect boolValue]){
            _colorModel.isSelect = @(NO);
        }else{
            _colorModel.isSelect = @(YES);
        }
        [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:@[@"selectColor",_colorModel.isSelect]];
    }
}

#pragma mark - --------------自定义方法----------------------
- (BOOL)useStockControl {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([appDelegate.messageUnreadModel.stockStatus isEqualToString:StockStatusNormal] && (!self.styleInfoModel.dateRange || !self.styleInfoModel.dateRange.start)) {
        return YES;
    }
    return NO;
}

#pragma mark - --------------other----------------------


@end
