//
//  YYNewsTableViewCell.m
//  YunejianBuyer
//
//  Created by Apple on 16/9/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYNewsTableViewCell.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图
#import "SCGIFImageView.h"

// 接口

// 分类
#import "UIView+UpdateAutoLayoutConstraints.h"

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYNewsInfoModel.h"

@interface YYNewsTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet SCGIFImageView *coverImageView;

@end

@implementation YYNewsTableViewCell
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
    _coverImageView.contentModeType = 1;
    _coverImageView.layer.masksToBounds = YES;
}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{
}

#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{
    if(_infoModel && _infoModel.coverImg != nil){
        sd_downloadWebImageWithRelativePath(YES, _infoModel.coverImg, _coverImageView, kNewsCover, UIViewContentModeScaleAspectFit);
    }else{
        sd_downloadWebImageWithRelativePath(YES, @"", _coverImageView, kNewsCover, UIViewContentModeScaleAspectFit);
    }
    _timerLabel.text = [NSString stringWithFormat:@"%@",getShowDateByFormatAndTimeInterval(@"yyyy/MM/dd HH:mm",[_infoModel.modifyTime stringValue])];

    _titleLabel.text = _infoModel.title;
    float titleLabelWidth = SCREEN_WIDTH - 17 - 152;
    CGSize titleSize = [_infoModel.title sizeWithAttributes:@{NSFontAttributeName:_titleLabel.font}];
    if(titleSize.width < titleLabelWidth){
        if(titleSize.height>50)
        {
            [_titleLabel setConstraintConstant:50 forAttribute:NSLayoutAttributeHeight];
        }else
        {
            [_titleLabel setConstraintConstant:titleSize.height forAttribute:NSLayoutAttributeHeight];
        }
        _titleLabel.text = _infoModel.title;
    }else{
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = 4;
        NSDictionary *attrDict01 = @{NSParagraphStyleAttributeName: paraStyle,NSFontAttributeName:_titleLabel.font};
        float titleLabelHeight = getTxtHeight(titleLabelWidth,_infoModel.title,attrDict01);
        if(titleLabelHeight>50)
        {
            [_titleLabel setConstraintConstant:50 forAttribute:NSLayoutAttributeHeight];
        }else
        {
            [_titleLabel setConstraintConstant:titleLabelHeight forAttribute:NSLayoutAttributeHeight];
        }
        _titleLabel.attributedText =  [[NSAttributedString alloc] initWithString: _infoModel.title attributes: attrDict01];
    }
}

#pragma mark - --------------系统代理----------------------

#pragma mark - --------------自定义响应----------------------


#pragma mark - --------------自定义方法----------------------


#pragma mark - --------------other----------------------

@end
