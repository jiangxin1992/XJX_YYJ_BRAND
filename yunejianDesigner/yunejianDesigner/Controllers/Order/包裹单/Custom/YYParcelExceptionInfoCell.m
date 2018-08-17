//
//  YYParcelExceptionInfoCell.m
//  yunejianDesigner
//
//  Created by yyj on 2018/7/9.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "YYParcelExceptionInfoCell.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图
#import "SCGIFButtonView.h"

// 接口

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYParcelExceptionModel.h"

@interface YYParcelExceptionInfoCell()

@property (nonatomic, strong) UILabel *noteLabel;
@property (nonatomic, strong) NSMutableArray *exceptionImgsArray;

@property (nonatomic, strong) UIView *exceptionImgsView;

@end

@implementation YYParcelExceptionInfoCell

#pragma mark - --------------生命周期--------------
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self SomePrepare];
        [self UIConfig];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
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
- (void)PrepareData{
    _exceptionImgsArray = [[NSMutableArray alloc] init];
}
- (void)PrepareUI{
    self.contentView.backgroundColor = [UIColor colorWithHex:@"f8f8f8"];
}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{

    WeakSelf(ws);

    UIView *upLine = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"EFEFEF"]];
    [self.contentView addSubview:upLine];
    [upLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];

    UIView *downLine = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"EFEFEF"]];
    [self.contentView addSubview:downLine];
    [downLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];

    _noteLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:13.f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:_noteLabel];
    [_noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.right.mas_equalTo(-17);
        make.top.mas_equalTo(upLine.mas_bottom).with.offset(15);
    }];
    _noteLabel.numberOfLines = 0;

    _exceptionImgsView = [UIView getCustomViewWithColor:nil];
    [self.contentView addSubview:_exceptionImgsView];
    [_exceptionImgsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(ws.noteLabel.mas_bottom).with.offset(0);
        make.bottom.mas_equalTo(-15);
    }];

}

#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{

    if(_parcelExceptionModel){

        WeakSelf(ws);

        NSString *noteLabelTitle = [[NSString alloc] initWithFormat:@"%@%@",NSLocalizedString(@"异常说明：",nil),_parcelExceptionModel.note];
        NSRange totalAmountRange = [noteLabelTitle rangeOfString:NSLocalizedString(@"异常说明：",nil)];
        NSMutableAttributedString *totalAmountAttributedStr = [[NSMutableAttributedString alloc] initWithString:noteLabelTitle];
        [totalAmountAttributedStr addAttribute:NSFontAttributeName value:getSemiboldFont(13.f) range:totalAmountRange];
        _noteLabel.attributedText = totalAmountAttributedStr;

        for (UIView *obj in _exceptionImgsArray) {
            [obj removeFromSuperview];
        }
        [_exceptionImgsArray removeAllObjects];

        CGFloat itemWidth = (SCREEN_WIDTH - 37 - 12*4)/5.f;
        UIView *lastView = nil;
//        _parcelExceptionModel.imgs = @[
//                                       @"https://scdn.ycosystem.com/ufile/20170926/77bac2f66dba4760a231dd27167e1c06"
//                                       ,@"https://scdn.ycosystem.com/ufile/20180524/d3401c990d8a431ea5789e858f1dd39a"
//                                       ,@"https://scdn.ycosystem.com/ufile/2018326/97e13bdfaa2742979e31ad2619b293ca"
//                                       ,@"https://scdn.ycosystem.com/ufile/20180408/9a68ce7f7c864d5bbc14e3271f3c456a"
//                                       ,@"https://scdn.ycosystem.com/ufile/20180408/43e251d34ff143d7a24f2c9ba71dfca3"
//                                       ,@"https://scdn.ycosystem.com/ufile/2018326/25f282ba642f4640921c422f27db26ea"
//                                       ,@"https://scdn.ycosystem.com/ufile/2018326/84f96627e0b845a3be236f707eba6d88"
//                                       ,@"https://scdn.ycosystem.com/ufile/2018326/5f48f30225aa46018c69bca865f5507a"
//                                       ];
        for (int i = 0; i < _parcelExceptionModel.imgs.count; i++) {

            NSString *imgStr = _parcelExceptionModel.imgs[i];

            SCGIFButtonView *imgButton = [[SCGIFButtonView alloc] init];
            [_exceptionImgsView addSubview:imgButton];
            [imgButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(itemWidth);
                if(i%5 == 0){
                    make.left.mas_equalTo(18.5f);
                }else{
                    make.left.mas_equalTo(lastView.mas_right).with.offset(12.f);
                }
                if(i == 0){
                    make.top.mas_equalTo(10.f);
                }else{
                    if(i%5 == 0){
                        make.top.mas_equalTo(lastView.mas_bottom).with.offset(12.f);
                    }else{
                        make.top.mas_equalTo(lastView);
                    }
                }
                if(i == ws.parcelExceptionModel.imgs.count - 1){
                    make.bottom.mas_equalTo(0);
                }
            }];
            imgButton.backgroundColor = [UIColor colorWithHex:@"f8f8f8"];
            [imgButton setAdjustsImageWhenHighlighted:NO];
            imgButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
            imgButton.clipsToBounds = YES;
            [imgButton addTarget:self action:@selector(imgAction:) forControlEvents:UIControlEventTouchUpInside];
            imgButton.tag = 100+i;

            sd_downloadWebImageWithRelativePath(NO, imgStr, imgButton, kLogoCover, UIViewContentModeScaleAspectFit);

            lastView = imgButton;
        }
    }

}

#pragma mark - --------------系统代理----------------------

#pragma mark - --------------自定义响应----------------------
-(void)imgAction:(UIButton *)sender{
    if(_parcelExceptionInfoCellBlock){
        NSInteger selectIndex = sender.tag - 100;
        _parcelExceptionInfoCellBlock(@"showpics",_indexPath,selectIndex);
    }
}

#pragma mark - --------------自定义方法----------------------


#pragma mark - --------------other----------------------


@end
