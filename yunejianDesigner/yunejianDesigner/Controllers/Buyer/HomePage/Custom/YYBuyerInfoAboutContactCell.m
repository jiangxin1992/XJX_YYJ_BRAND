//
//  YYBuyerInfoAboutCell.m
//  YunejianBuyer
//
//  Created by yyj on 2017/1/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YYBuyerInfoAboutContactCell.h"

#import "YYBuyerHomeInfoModel.h"
#import "YYTypeButton.h"

#import "YYBuyerInfoContactCell.h"
#import "YYBuyerInfoAboutCell.h"

#import "YYNoDataView.h"

@interface YYBuyerInfoAboutContactCell ()

@property (nonatomic,strong) YYBuyerInfoContactCell *infoContactCell;
@property (nonatomic,strong) YYBuyerInfoAboutCell *infoAboutCell;

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *titleLineView;
@property (nonatomic,strong) UIView *middleLineView;

@property (nonatomic, strong) UIView *noIntroductionDataView;

@end

@implementation YYBuyerInfoAboutContactCell

#pragma mark - INIT
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithBlock:(void(^)(NSString *type, CGFloat height,YYTypeButton *typeButton))block
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _cellblock=block;
        [self SomePrepare];
    }
    return self;
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
-(void)PrepareData{}
-(void)PrepareUI{
    self.backgroundColor = [UIColor clearColor];
}
#pragma mark - Setter
-(void)setHomePageModel:(YYBuyerHomeInfoModel *)homePageModel
{
    _homePageModel=homePageModel;
    
    if(!_titleLabel){
        _titleLabel = [UILabel getLabelWithAlignment:1 WithTitle:NSLocalizedString(@"关于买手店",nil) WithFont:15.0f WithTextColor:nil WithSpacing:0];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(50);
        }];
        _titleLabel.backgroundColor = _define_white_color;
    }
    
    if(!_titleLineView){
        _titleLineView = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"EFEFEF"]];
        [self.contentView addSubview:_titleLineView];
        [_titleLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(_titleLabel.mas_bottom).with.offset(0);
            make.height.mas_equalTo(1);
        }];
    }
    if(!_infoAboutCell){
        _infoAboutCell = [[YYBuyerInfoAboutCell alloc] initWithBlock:^(NSString *type, CGFloat height) {
            if(_cellblock){
                _cellblock(type,height,nil);
            }
        }];
        [self.contentView addSubview:_infoAboutCell.contentView];
        [_infoAboutCell.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(_titleLineView.mas_bottom).with.offset(0);
            make.height.mas_equalTo(250);
        }];
        _infoAboutCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    _infoAboutCell.isHomePage = _isHomePage;
    _infoAboutCell.homePageModel = _homePageModel;
    [_infoAboutCell.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_aboutHeight);
    }];
    
    if(!_middleLineView){
        _middleLineView = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"EFEFEF"]];
        [self.contentView addSubview:_middleLineView];
        [_middleLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(13.0f);
            make.right.mas_equalTo(-13.0f);
            make.top.mas_equalTo(_infoAboutCell.contentView.mas_bottom).with.offset(0);
            make.height.mas_equalTo(1);
        }];
    }
    if(!_aboutHeight || !_contactHeight){
        [_middleLineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
    
    if(!_infoContactCell){
        _infoContactCell = [[YYBuyerInfoContactCell alloc] initWithBlock:^(NSString *type ,YYTypeButton *typeButton) {
            if(_cellblock){
                _cellblock(type,0,typeButton);
            }
        }];
        [self.contentView addSubview:_infoContactCell.contentView];
        [_infoContactCell.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(_middleLineView.mas_bottom).with.offset(0);
            make.height.mas_equalTo(250);
        }];
        _infoContactCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    _infoContactCell.isHomePage = _isHomePage;
    _infoContactCell.homePageModel = _homePageModel;
    [_infoContactCell.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_contactHeight);
    }];
    
    [self CreateNoDataView];
}
-(void)CreateNoDataView
{
    if(!_noIntroductionDataView){
        if(_isHomePage)
        {
            _noIntroductionDataView = (YYNoDataView *)addNoDataView_phone(self.contentView,[NSString stringWithFormat:@"%@|icon:notxt_icon",NSLocalizedString(@"还未添买手店品牌信息，点击右上角编辑",nil)],kDefaultBorderColor,@"noinfo_icon");
        }else
        {
            _noIntroductionDataView = (YYNoDataView *)addNoDataView_phone(self.contentView,[NSString stringWithFormat:@"%@|icon:notxt_icon",NSLocalizedString(@"店家还未添买手店品牌信息",nil)],kDefaultBorderColor,@"noinfo_icon");
        }
        [self.contentView addSubview:_noIntroductionDataView];
        [_noIntroductionDataView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
            make.top.mas_equalTo(150);
        }];
        _noIntroductionDataView.hidden=YES;
    }
    
    if(!_aboutHeight && !_contactHeight){
        _noIntroductionDataView.hidden = NO;
    }else{
        _noIntroductionDataView.hidden = YES;
    }

}
#pragma mark - Other
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
