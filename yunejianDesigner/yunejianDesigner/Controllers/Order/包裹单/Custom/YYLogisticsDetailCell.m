//
//  YYLogisticsDetailCell.m
//  yunejianDesigner
//
//  Created by yyj on 2018/7/2.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "YYLogisticsDetailCell.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图

// 接口

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYExpressItemModel.h"

@interface YYLogisticsDetailCell()

@property (nonatomic, strong) UIView *signView;
@property (nonatomic, strong) UILabel *logisticsInfoLabel;
@property (nonatomic, strong) UILabel *logisticsCreateTimeLabel;

@end

@implementation YYLogisticsDetailCell

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
- (void)PrepareData{}
- (void)PrepareUI{
    self.contentView.backgroundColor = _define_white_color;
}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{

    WeakSelf(ws);

    _signView = [UIView getCustomViewWithColor:[UIColor colorWithWhite:0 alpha:0.3]];
    [self.contentView addSubview:_signView];
    [_signView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(5.5);
        make.width.height.mas_equalTo(5);
    }];
    _signView.layer.masksToBounds = YES;
    _signView.layer.cornerRadius = 2.5f;

    _logisticsInfoLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:12.f WithTextColor:[UIColor colorWithHex:@"919191"] WithSpacing:0];
    [self.contentView addSubview:_logisticsInfoLabel];
    [_logisticsInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.signView.mas_right).with.offset(7);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-20);
    }];
    _logisticsInfoLabel.numberOfLines = 0;

    _logisticsCreateTimeLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:13.f WithTextColor:[UIColor colorWithHex:@"919191"] WithSpacing:0];
    [self.contentView addSubview:_logisticsCreateTimeLabel];
    [_logisticsCreateTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(32);
        make.top.mas_equalTo(ws.logisticsInfoLabel.mas_bottom).with.offset(5);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-15);
    }];

}

#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{
    if(_newestExpress){
        _signView.backgroundColor = _define_black_color;
        _logisticsInfoLabel.textColor = _define_black_color;
        _logisticsInfoLabel.font = getFont(13.f);
    }else{
        _signView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _logisticsInfoLabel.textColor = [UIColor colorWithHex:@"919191"];
        _logisticsInfoLabel.font = getFont(12.f);
    }
    _logisticsInfoLabel.text = _expressItemModel.context;
    _logisticsCreateTimeLabel.text = [self getLogisticsCreateTime];
}

#pragma mark - --------------系统代理----------------------

#pragma mark - --------------自定义响应----------------------


#pragma mark - --------------自定义方法----------------------
-(NSString *)getLogisticsCreateTime{
    NSString *timeStr = _expressItemModel.time;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    // ----------设置你想要的格式,hh与 HH的区别:分别表示12小时制,24小时制
    //设置时区,这个对于时间的处理有时很重要
    //例如你在国内发布信息,用户在国外的另一个时区,你想让用户看到正确的发布时间就得注意时区设置,时间的换算.
    //例如你发布的时间为2010-01-26 17:40:50,那么在英国爱尔兰那边用户看到的时间应该是多少呢?
    //他们与我们有7个小时的时差,所以他们那还没到这个时间呢...那就是把未来的事做了
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate* date = [formatter dateFromString:timeStr]; //------------将字符串按formatter转成nsdate
    NSString *nowtimeStr = [formatter stringFromDate:date];//----------将nsdate按formatter格式转成nsstring
    return nowtimeStr;
}

#pragma mark - --------------other----------------------


@end
