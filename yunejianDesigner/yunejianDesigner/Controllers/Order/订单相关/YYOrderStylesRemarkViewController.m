//
//  YYOrderStylesRemarkViewController.m
//  yunejianDesigner
//
//  Created by Apple on 16/8/16.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYOrderStylesRemarkViewController.h"

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "YYNavigationBarViewController.h"

// 自定义视图
#import "YYOrderStyleRemarkCell.h"
#import "MLInputDodger.h"

// 接口

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYOrderInfoModel.h"

@interface YYOrderStylesRemarkViewController ()<UITableViewDelegate,UITableViewDataSource,YYTableCellDelegate>

@property (nonatomic,strong) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end

@implementation YYOrderStylesRemarkViewController
#pragma mark - --------------生命周期--------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 进入埋点
    [MobClick beginLogPageView:kYYPageOrderStylesRemark];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageOrderStylesRemark];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - --------------SomePrepare--------------
- (void)SomePrepare {
    [self PrepareData];
    [self PrepareUI];
}
- (void)PrepareData {
    [self initStylesRemark:YES];
}
- (void)PrepareUI {

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YYNavigationBarViewController *navigationBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNavigationBarViewController"];
    navigationBarViewController.previousTitle = @"";
    navigationBarViewController.nowTitle = NSLocalizedString(@"款式备注",nil);
    [_containerView insertSubview:navigationBarViewController.view atIndex:0];
    __weak UIView *_weakContainerView = _containerView;
    [navigationBarViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_weakContainerView.mas_top);
        make.left.equalTo(_weakContainerView.mas_left);
        make.bottom.equalTo(_weakContainerView.mas_bottom);
        make.right.equalTo(_weakContainerView.mas_right);
    }];

    WeakSelf(ws);
    __block YYNavigationBarViewController *blockVc = navigationBarViewController;

    [navigationBarViewController setNavigationButtonClicked:^(NavigationButtonType buttonType){
        if (buttonType == NavigationButtonTypeGoBack) {
            if(ws.cancelButtonClicked){
                ws.cancelButtonClicked();
            }
            blockVc = nil;
        }
    }];

    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _saveBtn.layer.cornerRadius = 2.5;
    self.tableView.shiftHeightAsDodgeViewForMLInputDodger = 44.0f+5.0f;
    [self.tableView registerAsDodgeViewForMLInputDodger];

}

#pragma mark - --------------系统代理----------------------
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_orderInfoModel){
        return [_orderInfoModel.groups count];
    }else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_orderInfoModel){
        YYOrderOneInfoModel *OneInfoModel= [_orderInfoModel.groups objectAtIndex:section];
        return [OneInfoModel.styles count];
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYOrderOneInfoModel *OneInfoModel = _orderInfoModel.groups[indexPath.section];
    YYOrderStyleModel *orderStyleModel= OneInfoModel.styles[indexPath.row];
    return [YYOrderStyleRemarkCell cellHeight:orderStyleModel.tmpRemark];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYOrderStyleRemarkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYOrderStyleRemarkCell" forIndexPath:indexPath];
    YYOrderOneInfoModel *OneInfoModel = _orderInfoModel.groups[indexPath.section];
    YYOrderStyleModel *orderStyleModel = OneInfoModel.styles[indexPath.row];
    cell.orderStyleModel = orderStyleModel;
    cell.indexPath = indexPath;
    cell.delegate = self;
    [cell updateUI];
    return cell;
}

#pragma mark - --------------自定义代理/block----------------------
#pragma YYTableCellDelegate
-(void)btnClick:(NSInteger)row section:(NSInteger)section andParmas:(NSArray *)parmas{
    NSString *type = [parmas objectAtIndex:0];
    if([type isEqualToString:@"addremark"]){
        YYOrderOneInfoModel *OneInfoModel = _orderInfoModel.groups[section];
        YYOrderStyleModel *orderStyleModel= OneInfoModel.styles[row];
        NSString *tmpRemark = [parmas objectAtIndex:1];
        orderStyleModel.tmpRemark = tmpRemark;
    }else if([type isEqualToString:@"refresh"]){
        [self.tableView reloadData];
    }else if([type isEqualToString:@"editremark"]){
        YYOrderOneInfoModel *OneInfoModel = _orderInfoModel.groups[section];
        YYOrderStyleModel *orderStyleModel= OneInfoModel.styles[row];
        orderStyleModel.tmpRemark = @"";
        [self.tableView reloadData];
        [self performSelector:@selector(scrollToIndexPath:) withObject:[NSIndexPath indexPathForRow:row inSection:section] afterDelay:0.1];
    }
}

#pragma mark - --------------自定义响应----------------------
- (IBAction)saveBtnHandler:(id)sender {
    [self initStylesRemark:NO];
    if(self.saveButtonClicked){
        self.saveButtonClicked();
    }
}

-(void)scrollToIndexPath:(NSIndexPath *)path{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"keyboradAppear" object:nil userInfo:@{@"row":[NSNumber numberWithInteger:path.row],@"section":[NSNumber numberWithInteger:path.section]}];
}

#pragma mark - --------------自定义方法----------------------
-(void)initStylesRemark:(BOOL)isSetOrSave{
    for (YYOrderOneInfoModel *oneInfoModel in _orderInfoModel.groups) {
        for (YYOrderStyleModel *orderStyleModel in oneInfoModel.styles) {
            if(isSetOrSave){
                orderStyleModel.tmpRemark =  orderStyleModel.remark;
            }else{
                if(![NSString isNilOrEmpty:orderStyleModel.tmpRemark]){
                    orderStyleModel.remark = orderStyleModel.tmpRemark;
                }
            }
        }
    }
}

#pragma mark - --------------other----------------------

@end
