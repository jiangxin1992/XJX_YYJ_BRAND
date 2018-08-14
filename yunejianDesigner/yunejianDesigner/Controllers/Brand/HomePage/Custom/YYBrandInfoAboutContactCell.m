//
//  YYBuyerInfoAboutCell.m
//  YunejianBuyer
//
//  Created by yyj on 2017/1/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YYBrandInfoAboutContactCell.h"

#import "YYBrandHomeInfoModel.h"
#import "YYTypeButton.h"
#import "YYNoDataView.h"

#import "YYBrandInfoContactCell.h"
#import "YYBrandInfoAboutCell.h"

@interface YYBrandInfoAboutContactCell ()

@property (nonatomic,strong) YYBrandInfoAboutCell *infoAboutCell;
@property (nonatomic,strong) YYBrandInfoContactCell *infoContactCell;

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *titleLineView;
@property (nonatomic,strong) UIView *middleLineView;

@property (nonatomic, strong) UIView *noIntroductionDataView;

@end

@implementation YYBrandInfoAboutContactCell

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
-(void)setHomePageModel:(YYBrandHomeInfoModel *)homePageModel
{
    _homePageModel=homePageModel;
    
    if(!_infoAboutCell){
        _infoAboutCell = [[YYBrandInfoAboutCell alloc] initWithBlock:^(NSString *type, CGFloat height) {
            if(_cellblock){
                _cellblock(type,height,nil);
            }
        }];
        [self.contentView addSubview:_infoAboutCell.contentView];
        [_infoAboutCell.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
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
        _infoContactCell = [[YYBrandInfoContactCell alloc] initWithBlock:^(NSString *type ,YYTypeButton *typeButton) {
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
            _noIntroductionDataView = (YYNoDataView *)addNoDataView_phone(self.contentView,[NSString stringWithFormat:@"%@|icon:notxt_icon",NSLocalizedString(@"还没有添加品牌信息，点击右上角编辑",nil)],kDefaultBorderColor,@"noinfo_icon");
        }else
        {
            _noIntroductionDataView = (YYNoDataView *)addNoDataView_phone(self.contentView,[NSString stringWithFormat:@"%@|icon:notxt_icon",NSLocalizedString(@"还没有添加品牌信息",nil)],kDefaultBorderColor,@"noinfo_icon");
        }
        [self.contentView addSubview:_noIntroductionDataView];
        [_noIntroductionDataView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
            make.top.mas_equalTo(100);
            
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
