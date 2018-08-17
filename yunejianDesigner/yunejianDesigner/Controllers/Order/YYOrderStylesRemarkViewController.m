//
//  YYOrderStylesRemarkViewController.m
//  yunejianDesigner
//
//  Created by Apple on 16/8/16.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYOrderStylesRemarkViewController.h"
#import "YYNavigationBarViewController.h"
#import "YYOrderStyleRemarkCell.h"
#import "MLInputDodger.h"

@interface YYOrderStylesRemarkViewController ()<UITableViewDelegate,UITableViewDataSource,YYTableCellDelegate>
@property(nonatomic,strong) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@end

@implementation YYOrderStylesRemarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YYNavigationBarViewController *navigationBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNavigationBarViewController"];
    navigationBarViewController.previousTitle = @"";
    //self.navigationBarViewController = navigationBarViewController;
    navigationBarViewController.nowTitle = NSLocalizedString(@"款式备注",nil);
    [_containerView insertSubview:navigationBarViewController.view atIndex:0];
    //[_containerView addSubview:navigationBarViewController.view];
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
    //_tableView.contentInset = UIEdgeInsetsMake(17, 17, 17, 17);
    _saveBtn.layer.cornerRadius = 2.5;
    self.tableView.shiftHeightAsDodgeViewForMLInputDodger = 44.0f+5.0f;
    [self.tableView registerAsDodgeViewForMLInputDodger];
    [self initStylesRemark:YES];
}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveBtnHandler:(id)sender {
    [self initStylesRemark:NO];
    if(self.saveButtonClicked){
        self.saveButtonClicked();
    }
}


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
    
    NSString *CellIdentifier = @"YYOrderStyleRemarkCell";
    YYOrderStyleRemarkCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    
    YYOrderOneInfoModel *OneInfoModel = _orderInfoModel.groups[indexPath.section];
    YYOrderStyleModel *orderStyleModel= OneInfoModel.styles[indexPath.row];
    cell.orderStyleModel = orderStyleModel;
    cell.indexPath = indexPath;
    cell.delegate = self;
    [cell updateUI];
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 10;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

#pragma YYTableCellDelegate
-(void)btnClick:(NSInteger)row section:(NSInteger)section andParmas:(NSArray *)parmas{
    NSString *type = [parmas objectAtIndex:0];
    if([type isEqualToString:@"addremark"]){
        YYOrderOneInfoModel *OneInfoModel = _orderInfoModel.groups[section];
        YYOrderStyleModel *orderStyleModel= OneInfoModel.styles[row];
        NSString *tmpRemark = [parmas objectAtIndex:1];
        orderStyleModel.tmpRemark = tmpRemark;
        //[self.tableView reloadData];
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
-(void)scrollToIndexPath:(NSIndexPath *)path{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"keyboradAppear" object:nil userInfo:@{@"row":[NSNumber numberWithInteger:path.row],@"section":[NSNumber numberWithInteger:path.section]}];
}
@end
