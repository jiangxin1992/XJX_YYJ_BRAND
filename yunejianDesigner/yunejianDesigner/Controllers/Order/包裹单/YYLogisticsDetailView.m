//
//  YYLogisticsDetailView.m
//  yunejianDesigner
//
//  Created by yyj on 2018/7/2.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "YYLogisticsDetailView.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图
#import "YYLogisticsDetailCell.h"

// 接口

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYPackingListDetailModel.h"

@interface YYLogisticsDetailView()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *logisticsInfoLabel;

@end

@implementation YYLogisticsDetailView

#pragma mark - --------------生命周期--------------
-(instancetype)init{
    self = [super init];
    if(self){
        [self SomePrepare];
        [self UIConfig];
    }
    return self;
}

#pragma mark - --------------SomePrepare--------------
- (void)SomePrepare {
    [self PrepareData];
    [self PrepareUI];
}
- (void)PrepareData {

}
- (void)PrepareUI {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
}

#pragma mark - --------------UIConfig----------------------
- (void)UIConfig {

    [self createBackView];
    [self createContentView];

}
-(void)createBackView{
    WeakSelf(ws);

    UIButton *backButton = [UIButton getCustomBtn];
    [self addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(ws);
    }];
    [backButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];

    //这里的尺寸要和视觉确认下
    _contentView = [UIView getCustomViewWithColor:_define_white_color];
    [backButton addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.centerY.mas_equalTo(backButton);
        make.height.mas_equalTo(370);
    }];
    setBorderCustom(_contentView, 4, _define_black_color);
}
-(void)createContentView{

    WeakSelf(ws);

    _logisticsInfoLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:13.f WithTextColor:nil WithSpacing:0];
    [_contentView addSubview:_logisticsInfoLabel];
    [_logisticsInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(16.5);
    }];
    _logisticsInfoLabel.font = getSemiboldFont(13.f);

    UIView *cutoffLine = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"EFEFEF"]];
    [_contentView addSubview:cutoffLine];
    [cutoffLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.5);
        make.right.mas_equalTo(-12.5);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(ws.logisticsInfoLabel.mas_bottom).with.offset(10);
    }];

    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_contentView addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cutoffLine.mas_bottom).with.offset(20.f);
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.bottom.mas_equalTo(-24.f);
    }];

}
#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{

    _logisticsInfoLabel.text = [[NSString alloc] initWithFormat:NSLocalizedString(@"%@%@%@", nil),_packingListDetailModel.logisticsName,NSLocalizedString(@"：",nil),_packingListDetailModel.logisticsCode];

    [_tableView setContentOffset:CGPointMake(0,0) animated:NO];

    WeakSelf(ws);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [ws.tableView reloadData];
        });
    });
}
#pragma mark - --------------系统代理----------------------
#pragma mark - TableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!_packingListDetailModel){
        //数据还未加载出来
        return 0;
    }
    return _packingListDetailModel.express.data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!_packingListDetailModel){
        static NSString *cellid = @"cellid";
        UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellid];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }

    static NSString *cellid = @"YYLogisticsDetailCell";
    YYLogisticsDetailCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellid];
    if(!cell){
        cell = [[YYLogisticsDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    YYExpressItemModel *expressItemModel = _packingListDetailModel.express.data[indexPath.row];
    cell.expressItemModel = expressItemModel;
    if(!indexPath.row){
        cell.newestExpress = YES;
    }else{
        cell.newestExpress = NO;
    }
    [cell updateUI];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 10;
}

#pragma mark - --------------自定义代理/block----------------------


#pragma mark - --------------自定义响应----------------------
-(void)goBack:(id)sender {
    if(_cancelButtonClicked){
        _cancelButtonClicked();
    }
}

#pragma mark - --------------自定义方法----------------------


#pragma mark - --------------other----------------------

@end
