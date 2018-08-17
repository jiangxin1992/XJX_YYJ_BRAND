//
//  YYDetailContentViewController.m
//  Yunejian
//
//  Created by yyj on 15/7/26.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYDetailContentViewController.h"

#import "YYOpusApi.h"

#import "UIImage+YYImage.h"

#import "AppDelegate.h"
#import "YYStyleDetailViewController.h"
#import "YYDetailContentTopViewCell.h"
#import "YYDetailContentParamsViewCellNew.h"
#import "MBProgressHUD.h"
#import "YYOrderInfoModel.h"
#import "YYOpusStyleModel.h"

@interface YYDetailContentViewController ()<YYTableCellDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *MyTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MyTableViewTopLayout;

@property(nonatomic) NSInteger tmpContentOffsety; //0

@property (weak, nonatomic) IBOutlet UIButton *addShoppingCarButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addShoppingCarButtonBottomLayout;

@property (nonatomic,strong) YYStyleInfoModel *styleInfoModel;

@property (nonatomic,strong) NSMutableArray *colorsArry;
@property(nonatomic) NSInteger currentColorIndexToShow; //0

@property (nonatomic,assign) NSComparisonResult orderDueCompareResult;

@property (nonatomic,assign) CGFloat desHeight;
@end

@implementation YYDetailContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self RequestData];
    [self updateUI];
}

#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}

-(void)PrepareData{}
-(void)PrepareUI{
    _MyTableViewTopLayout.constant = kIPhoneX?kStatusBarHeight:0;
    _addShoppingCarButtonBottomLayout.constant = kIPhoneX?34.f:0.f;
    _MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _MyTableView.separatorInset = UIEdgeInsetsMake(0, 40, 0,40 );
    
    self.currentColorIndexToShow = 0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.desHeight = 0;
}

#pragma mark - RequestData
-(void)RequestData{
    [self loadStyleInfo];
}
- (void)loadStyleInfo{
    WeakSelf(ws);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [YYOpusApi getStyleInfoByStyleId:[_currentOpusStyleModel.id longValue] orderCode:nil andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYStyleInfoModel *styleInfoModel, NSError *error) {
        if (rspStatusAndMessage.status == kCode100) {
            ws.styleInfoModel = styleInfoModel;
            [self updateUI];

            // ---------- 修改按钮状态 start ----------
            // 0 代表未分类， 需要加入购物车按钮置为灰色、不可点击、toast提示
            if ([_styleInfoModel.style.seriesId intValue] == 0) {
                self.addShoppingCarButton.backgroundColor = [UIColor colorWithHex:@"D3D3D3"];
                [self.addShoppingCarButton setEnabled:NO];
                [YYToast showToastWithTitle:NSLocalizedString(@"该款式未分类不能加入购物车", nil) andDuration:kAlertToastDuration];
            }else{
                self.addShoppingCarButton.backgroundColor = [UIColor blackColor];
                [self.addShoppingCarButton setEnabled:YES];
            }
            // ---------- end ----------

            ws.desHeight = [YYDetailContentParamsViewCellNew getHeightWithColorModel:self.styleInfoModel atColorIndex:self.currentColorIndexToShow];
            [ws.MyTableView reloadData];
            [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];
        }else{
            [YYToast showToastWithTitle:NSLocalizedString(@"没有数据",nil) andDuration:kAlertToastDuration];
            [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];
        }
    }];
}
#pragma mark - updateUI
- (void)updateUI{

    NSComparisonResult compareResult = NSOrderedDescending;
    if(_opusSeriesModel.orderDueTime !=nil){
        compareResult = compareNowDate(_opusSeriesModel.orderDueTime);
    }
    self.orderDueCompareResult = compareResult;
    
    if ( self.orderDueCompareResult == NSOrderedAscending) {
        self.addShoppingCarButton.backgroundColor = [UIColor colorWithHex:@"d3d3d3"];
        [YYToast showToastWithTitle:NSLocalizedString(@"此系列已过最晚下单日期，不能下单。",nil) andDuration:kAlertToastDuration];
        return;
    }

}
#pragma mark - SomeAction
- (IBAction)addShoppingCarAction:(id)sender {
    if(_opusSeriesModel == nil || [_opusSeriesModel.status integerValue] == kOpusDraft){
        if(_isToScan){
            [YYToast showToastWithView:self.view title:NSLocalizedString(@"该款式为草稿不能加入购物车",nil) andDuration:kAlertToastDuration];
        }else{
            [YYToast showToastWithView:self.view title:NSLocalizedString(@"请先发布作品！",nil) andDuration:kAlertToastDuration];
        }
        return;
    }
    
    if (self.orderDueCompareResult == NSOrderedAscending) {
        [YYToast showToastWithTitle:NSLocalizedString(@"此系列已过最晚下单日期，不能下单。",nil) andDuration:kAlertToastDuration];
        return;
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSInteger moneyType = -1;
    if (_styleInfoModel) {
        moneyType = [_styleInfoModel.style.curType integerValue];
    }
    NSInteger cartMoneyType = -1;
    if(appDelegate.cartModel == nil){
        cartMoneyType = -1;
    }else{
        cartMoneyType = getMoneyType([appDelegate.cartModel.designerId integerValue]);
    }
    
    if(cartMoneyType > -1 && moneyType != cartMoneyType){
        [YYToast showToastWithView:self.view title:NSLocalizedString(@"购物车中存在其他币种的款式，不能将此款式加入购物车。您可以清空购物车后，将此款式加入购物车。",nil) andDuration:kAlertToastDuration];
        return;
    }
    
    UIView *superView = self.styleDetailViewController.view;
    [appDelegate showShoppingView:NO styleInfoModel:_styleInfoModel seriesModel:_opusSeriesModel opusStyleModel:nil parentView:superView fromBrandSeriesView:NO WithBlock:nil];
}

-(void)btnClick:(NSInteger)row section:(NSInteger)section andParmas:(NSArray *)parmas{
    NSString *type = [parmas objectAtIndex:0];
    if([type isEqualToString:@"ColorIndexToShow"]){
        NSInteger index = [[parmas objectAtIndex:1] integerValue];
        _currentColorIndexToShow = index;
        [_MyTableView reloadData];
    }
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        //        NSInteger arrayCount = (_styleInfoModel?[_styleInfoModel.colorImages count]:0);
        //        return [YYDetailContentTopViewCell cellHeight:arrayCount];

        CGFloat tempHeight = 176 + SCREEN_WIDTH + 10;
        if(_styleInfoModel){
            if(_styleInfoModel.colorImages && _styleInfoModel.colorImages.count > 0){
                NSInteger lineNum = (_styleInfoModel.colorImages.count/5) + 1;
                tempHeight += (lineNum - 1)*(32 + 3 + 25);
            }
        }
        return tempHeight;

    }else if(indexPath.row == 1){
//        return infoViewHeight;
        return _desHeight;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        YYDetailContentTopViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYDetailContentTopViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.styleInfoModel = _styleInfoModel;
        cell.indexPath = indexPath;
        cell.delegate = self;
        cell.currentColorIndexToShow = _currentColorIndexToShow;
        cell.selectTaxType = _selectTaxType;
        [cell updateUI];
        return cell;
    }else if(indexPath.row == 1){
        YYDetailContentParamsViewCellNew *cell = [tableView dequeueReusableCellWithIdentifier:@"YYDetailContentParamsViewCellNew"];
        if(!cell){
            cell = [[YYDetailContentParamsViewCellNew alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YYDetailContentParamsViewCellNew"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell updateUI:self.styleInfoModel atColorIndex:self.currentColorIndexToShow];
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYOrderNullCell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YYOrderNullCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark - Other

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
