//
//  YYSubShowroomPowerViewContorller.h
//  Yunejian
//
//  Created by yyj on 17/9/13.
//  Copyright (c) 2017年 yyj. All rights reserved.
//

#import "YYSubShowroomPowerViewContorller.h"
#import "YYNavigationBarViewController.h"


#import "YYUserApi.h"
#import "YYShowroomApi.h"
#import "YYRspStatusAndMessage.h"
#import "YYUser.h"

@interface YYSubShowroomPowerViewContorller ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;

/** 选择的项目 */
@property (nonatomic, strong) NSMutableArray *selectRow;
/** 文案集合 */
@property (nonatomic, strong) NSArray *rowTitle;

/** tableview */
@property (nonatomic, strong) UITableView *tableView;

@property(nonatomic,strong)YYNavigationBarViewController *navigationBarViewController;

@end

@implementation YYSubShowroomPowerViewContorller


#pragma mark - --------------生命周期--------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
}


#pragma mark - --------------SomePrepare--------------

-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
    
}

-(void)PrepareData{

    if (self.defaultPowerArray) {
        self.selectRow = [NSMutableArray arrayWithArray:self.defaultPowerArray];
    }else{
        self.selectRow = [NSMutableArray array];
    }

    self.rowTitle = @[NSLocalizedString(@"品牌操作权限",nil),
                      NSLocalizedString(@"品牌报表查看权限",nil),
                      NSLocalizedString(@"Showroom 报表查看权限",nil),
                      NSLocalizedString(@"所有订单查看权限",nil),
                      NSLocalizedString(@"订货会审核查看权限",nil)];
}

#pragma mark - --------------UI----------------------

// 创建子控件
-(void)PrepareUI{
    self.view.backgroundColor = _define_white_color;
    UIView *titleView = [[UIView alloc] init];
    [self.view addSubview:titleView];

    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(kStatusBarAndNavigationBarHeight);
    }];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YYNavigationBarViewController *navigationBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNavigationBarViewController"];
    navigationBarViewController.previousTitle = @"";
    self.navigationBarViewController = navigationBarViewController;

    navigationBarViewController.nowTitle = NSLocalizedString(@"新建Showroom子账号",nil);

    [titleView addSubview:navigationBarViewController.view];

    [navigationBarViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom).with.offset(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop).with.offset(0);
    }];

    WeakSelf(ws);
    [navigationBarViewController setNavigationButtonClicked:^(NavigationButtonType buttonType){
        if (buttonType == NavigationButtonTypeGoBack) {
            [ws cancelClicked:nil];
        }
    }];

       // 选中列表
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    tableView.backgroundColor = _define_white_color;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorColor = [UIColor colorWithHex:@"EFEFEF"];
    tableView.scrollEnabled = NO;

    [self.view addSubview:tableView];

    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
        make.top.mas_equalTo(titleView.mas_bottom);
        make.height.mas_equalTo(275);
    }];

    // 保存按钮
    UIButton *saveButton = [[UIButton alloc] init];
    saveButton.backgroundColor = _define_black_color;
    saveButton.layer.cornerRadius = 3;
    saveButton.layer.masksToBounds = YES;
    [saveButton setTitle:NSLocalizedString(@"保存", nil) forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];

    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tableView.mas_bottom).mas_offset(40);
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
        make.height.mas_equalTo(40);
    }];

}


#pragma mark - --------------系统代理----------------------
#pragma mark - uitableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _rowTitle.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = [UIColor colorWithHex:@"EFEFEF"];
    return header;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYSubShowroomPowerViewContorller"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"YYSubShowroomPowerViewContorller"];
        cell.preservesSuperviewLayoutMargins = NO;
        cell.separatorInset = UIEdgeInsetsZero;
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithHex:@"F8F8F8"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }

    BOOL isSelect = [self.selectRow containsObject:[NSString stringWithFormat:@"%li", (indexPath.row + 1)]];

    if (isSelect) {
        cell.imageView.image = [UIImage imageNamed:@"opus_selected_green_icon"];
    }else{
        cell.imageView.image = [UIImage imageNamed:@"opus_unselected_icon"];
    }

    cell.textLabel.text = NSLocalizedString(self.rowTitle[indexPath.row], nil);

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    // 记录已经存在的位置。 初始化为一个很大的数字 999
    NSInteger selectRowIndex = 999;
    for (int i = 0; i < self.selectRow.count; i++) {
        if (indexPath.row + 1 == [self.selectRow[i] intValue]) {
            selectRowIndex = i;
            break;
        }
    }

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (selectRowIndex == 999) {
        // 修改图案成选中
        cell.imageView.image = [UIImage imageNamed:@"opus_selected_green_icon"];
        // 添加到array中
        [self.selectRow addObject:[NSString stringWithFormat:@"%li", indexPath.row+1]];
    }else{
        // 修改成未选中
        cell.imageView.image = [UIImage imageNamed:@"opus_unselected_icon"];
        // 从array中删除
        [self.selectRow removeObjectAtIndex:selectRowIndex];
    }

}

#pragma mark - --------------自定义代理/block----------------------


#pragma mark - --------------自定义响应----------------------
- (void)cancelClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    if (_cancelButtonClicked) {
        _cancelButtonClicked();
    }
}

- (void)saveClicked:(UIButton *)sender{

    [YYShowroomApi subShowroomPowerUserId:self.userId authList:self.selectRow andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {

        if (rspStatusAndMessage.status == YYReqStatusCode100) {
            [YYToast showToastWithTitle:NSLocalizedString(@"操作成功！",nil) andDuration:kAlertToastDuration];
            // 退出
            if (!self.defaultPowerArray) {
                //连续返回两级
                NSUInteger index = [[self.navigationController viewControllers] indexOfObject:self];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 2]animated:YES];

                //回到第一级
                [self.navigationController popToRootViewControllerAnimated:YES];  

            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }

            if (_modifySuccess) {
                _modifySuccess();
            }

        }else{
            [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
        }
    }];
}

#pragma mark - --------------自定义方法----------------------


#pragma mark - --------------other----------------------

- (void)dealloc{

}

@end
