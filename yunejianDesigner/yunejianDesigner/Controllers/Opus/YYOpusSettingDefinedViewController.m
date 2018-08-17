//
//  YYOpusSettingDefinedViewController.m
//  yunejianDesigner
//
//  Created by Apple on 16/11/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYOpusSettingDefinedViewController.h"
#import "YYOpusSettingDefinedTypeViewCell.h"
#import "YYOpusSettingDefinedBuyerViewCell.h"
#import "YYOpusApi.h"
#import "MBProgressHUD.h"
#import "YYConnApi.h"

@interface YYOpusSettingDefinedViewController ()<UITableViewDataSource,UITableViewDelegate,YYTableCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) NSInteger selectedType;
@property (strong, nonatomic) NSMutableArray *selectedBuyerIndexArr;
@property (strong,nonatomic) NSArray *buyerList;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@end

@implementation YYOpusSettingDefinedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.buyerList = [NSArray arrayWithObjects:@"",@"",@"",@"",@"", nil];
    self.selectedType = -1;
    if(_authType == 3){
        _selectedType = 0;
    }else if (_authType == 4){
        _selectedType = 1;
    }
    _selectedBuyerIndexArr = [[NSMutableArray alloc] init];
    _saveBtn.enabled = NO;
    _saveBtn.alpha = 0.5;
    [self getSeriesAuthTypeBuyerList:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 进入埋点
    [MobClick beginLogPageView:kYYPageOpusSettingDefined];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageOpusSettingDefined];
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

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if(_selectedType == 0){
            return [self.buyerList  count]+1;
        }else{
            return 0;
        }
    }
    if (section == 2) {
        if(_selectedType == 1){
            return  [self.buyerList  count]+1;
        }else{
            return 0;
        }
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 51;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"YYOpusSettingDefinedBuyerViewCell";
    YYOpusSettingDefinedBuyerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(indexPath.section == 0){
        cell.type = 0;
    }else{
        cell.type = 1;
    }
    cell.indexPath = indexPath;
    if(indexPath.row == 0){
        if([self.selectedBuyerIndexArr count] > 0 && [self.selectedBuyerIndexArr count] >= [self.buyerList  count]){
            cell.statusBtn.selected = YES;
        }else{
            cell.statusBtn.selected = NO;
        }
        [cell.statusBtn setTitle:NSLocalizedString(@"全选",nil) forState:UIControlStateNormal];

    }else{
        if([self.selectedBuyerIndexArr containsObject:@(indexPath.row)]){
            cell.statusBtn.selected = YES;
        }else{
            cell.statusBtn.selected = NO;
        }
        YYOpusSeriesAuthTypeBuyerModel *buyerModel = [_buyerList objectAtIndex:(indexPath.row-1)];
        if(buyerModel!=nil){
            [cell.statusBtn setTitle:buyerModel.buyerName forState:UIControlStateNormal];
        }else{
            [cell.statusBtn setTitle:@"" forState:UIControlStateNormal];

        }
    }
    [cell updateUI];
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 1)
        return 12;
    if(section == 0)
        return 60;
    return 61;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 1){
        static NSString *reuseIdentifier = @"YYOpusSettingDefinedSpaceViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        return cell;
    }
    static NSString *reuseIdentifier = @"YYOpusSettingDefinedTypeViewCell";
    YYOpusSettingDefinedTypeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(section == 0){
        cell.type = 0;
    }else{
        cell.type = 1;
    }
    cell.delegate = self;
    cell.selectedType = self.selectedType;
    cell.selectedCount = MIN([self.selectedBuyerIndexArr count] ,[self.buyerList  count]);
    [cell updateUI];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"+++++");
    if(indexPath.row == 0){
        if( [self.selectedBuyerIndexArr count] >= [self.buyerList  count]){
            [self.selectedBuyerIndexArr removeAllObjects];
        }else{
            [self.selectedBuyerIndexArr removeAllObjects];
            NSInteger len = [self.buyerList  count];
            for (NSInteger i=0; i<len; i++) {
                [self.selectedBuyerIndexArr addObject:@(i+1)];
            }
        }
    }else{
        if([self.selectedBuyerIndexArr containsObject:@(indexPath.row)]){
            [self.selectedBuyerIndexArr removeObject:@(indexPath.row)];
        }else{
            [self.selectedBuyerIndexArr addObject:@(indexPath.row)];
        }
    }
    if([_selectedBuyerIndexArr count] == 0){
        _saveBtn.enabled = NO;
        _saveBtn.alpha = 0.5;
    }else{
        _saveBtn.enabled = YES;
        _saveBtn.alpha = 1.0;
    }
    [self.tableView reloadData];
}


#pragma YYTableCellDelegate
-(void) btnClick:(NSInteger)row section:(NSInteger)section andParmas:(NSArray *)parmas{
    NSString *type = [parmas objectAtIndex:0];
    if([type isEqualToString:@"selectedtype"]){
        self.selectedBuyerIndexArr = [[NSMutableArray alloc] init];
        _saveBtn.enabled = NO;
        _saveBtn.alpha = 0.5;
        if(self.selectedType != section){
            self.selectedType = section;
            [self getSeriesAuthTypeBuyerList:NO];

        }else{
            self.selectedType = -1;
        }
        

        [self.tableView reloadData];
    }
}

#pragma private
- (IBAction)cancelBtnHandler:(id)sender {
    if([self.selectedBuyerIndexArr count] > 0){
        WeakSelf(ws);
        CMAlertView *alertView = [[CMAlertView alloc] initWithTitle:NSLocalizedString(@"退出此次设置？",nil) message:NSLocalizedString(@"退出后，您的操作将不被保存" ,nil) needwarn:NO delegate:nil cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:@[NSLocalizedString(@"退出",nil)]];
        alertView.specialParentView = self.view;
        [alertView setAlertViewBlock:^(NSInteger selectedIndex){
            if (selectedIndex == 1) {
                if(ws.cancelButtonClicked){
                    ws.cancelButtonClicked();
                }
            }
        }];

        [alertView show];
    }else{
        if(self.cancelButtonClicked){
            self.cancelButtonClicked();
        }
    }
}
- (IBAction)saveBtnHandler:(id)sender {
    NSMutableArray *buyerIds = [[NSMutableArray alloc] init];
    for (NSNumber *index in self.selectedBuyerIndexArr){
        if([index integerValue] > 0){
            YYOpusSeriesAuthTypeBuyerModel *buyerModel = [_buyerList objectAtIndex:([index integerValue]-1)];
            [buyerIds addObject:buyerModel.buyerId];
        }
    }
    if([buyerIds count] == 0){
        return;
    }
    WeakSelf(ws);
    NSString *buyerIdsStr = [buyerIds componentsJoinedByString:@","];
    [YYConnApi checkConnBuyers:buyerIdsStr andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, BOOL isConn, NSError *error) {
        if(isConn){
            if(ws.selectedValue){
                NSString *tmpAuthType = nil;
                if (ws.selectedType == 0) {
                    tmpAuthType = @"3";
                }else if(ws.selectedType == 1){
                    tmpAuthType = @"4";
                }
                
                NSString *value = [NSString stringWithFormat:@"%@|%@",tmpAuthType,buyerIdsStr];
                ws.selectedValue(value);
            }
        }else{
            
            [YYToast showToastWithView:ws.view title:NSLocalizedString(@"被选中买手店已解除合作",nil) andDuration:kAlertToastDuration];
            ws.selectedBuyerIndexArr  = [[NSMutableArray alloc] init];
            [ws getSeriesAuthTypeBuyerList:YES];
        }
    }];
}

#pragma loadremote
-(void)getSeriesAuthTypeBuyerList:(BOOL)isselect{
    if(_selectedType == -1){
        return;
    }
    NSString *tmpAuthType = nil;
    if (_selectedType == 0) {
        tmpAuthType = @"3";
    }else if(_selectedType == 1){
        tmpAuthType = @"4";
    }
    WeakSelf(ws);
    __block BOOL blockIsSelect = isselect;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [YYOpusApi getSeriesAuthTypeBuyerList:_seriesId authType:tmpAuthType andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYOpusSeriesAuthTypeBuyerListModel *buyerList, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];
        if(rspStatusAndMessage.status == kCode100){
            ws.buyerList = buyerList.result;
            if(blockIsSelect){
            NSInteger len = [ws.buyerList  count];
            for (NSInteger i=0; i<len; i++) {
                YYOpusSeriesAuthTypeBuyerModel *buyerModel = [ws.buyerList objectAtIndex:(i)];
                if(buyerModel.authType != nil)
                    [ws.selectedBuyerIndexArr addObject:@(i+1)];
            }
            if([ws.selectedBuyerIndexArr count] == 0){
                ws.saveBtn.enabled = NO;
                ws.saveBtn.alpha = 0.5;
            }else{
                ws.saveBtn.enabled = YES;
                ws.saveBtn.alpha = 1.0;
            }
            }
            [ws.tableView reloadData];
        }else{
            [YYToast showToastWithView:ws.view title:rspStatusAndMessage.message andDuration:kAlertToastDuration];
        }
    }];
}
@end
