//
//  YYChooseLogisticsViewController.m
//  yunejianDesigner
//
//  Created by yyj on 2018/6/20.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "YYChooseLogisticsViewController.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图
#import "YYNavView.h"
#import "MBProgressHUD.h"
#import "YYChooseLogisticsCell.h"

// 接口
#import "YYOrderApi.h"

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYExpressCompanyModel.h"

#import "ChineseToPinyin.h"

@interface YYChooseLogisticsViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) YYNavView *navView;

@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UITextField *searchField;

@property (nonatomic, assign) BOOL isSearchView;//该状态直接表示当前的search状态

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *noDataView;

@property (nonatomic, strong) NSMutableArray *expressCompanyArray;
@property (nonatomic, strong) NSMutableDictionary *dictPinyinAndChinese;
@property (nonatomic, strong) NSMutableArray *arrayChar;
@property (nonatomic, strong) NSMutableDictionary *dictPinyinAndChinese1;
@property (nonatomic, strong) NSMutableArray *arrayChar1;

@end

@implementation YYChooseLogisticsViewController

#pragma mark - --------------生命周期--------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self RequestData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 进入埋点
    [MobClick beginLogPageView:kYYPageChooseLogistics];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageChooseLogistics];
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
    _isSearchView = NO;
    _expressCompanyArray = [[NSMutableArray alloc] init];
    _arrayChar = [[NSMutableArray alloc] init];
    _arrayChar1 = [[NSMutableArray alloc] init];
    _dictPinyinAndChinese = [[NSMutableDictionary alloc] init];
    _dictPinyinAndChinese1 = [[NSMutableDictionary alloc] init];
}
- (void)PrepareUI {

    self.view.backgroundColor = _define_white_color;

    _navView = [[YYNavView alloc] initWithTitle:nil WithSuperView:self.view haveStatusView:YES];

    UIButton *backBtn = [UIButton getCustomImgBtnWithImageStr:@"goBack_normal" WithSelectedImageStr:nil];
    [_navView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.width.mas_equalTo(40);
        make.bottom.mas_equalTo(-1);
    }];
}
#pragma mark - --------------UIConfig----------------------
- (void)UIConfig {
    [self createSearchView];
    [self createTableView];
    [self createNoDataView];
}
-(void)createSearchView{

    UIButton *searchButton = [UIButton getCustomTitleBtnWithAlignment:1 WithFont:14.f WithSpacing:0 WithNormalTitle:NSLocalizedString(@"搜索物流公司", nil) WithNormalColor:[UIColor colorWithHex:@"919191"] WithSelectedTitle:nil WithSelectedColor:nil];
    [_navView addSubview:searchButton];
    [searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40.5);
        make.right.mas_equalTo(-16.5);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(-9);
    }];
    [searchButton addTarget:self action:@selector(showSearchView) forControlEvents:UIControlEventTouchUpInside];
    searchButton.backgroundColor = [UIColor colorWithHex:@"EFEFEF"];
    [searchButton setImage:[UIImage imageNamed:@"search_Img"] forState:UIControlStateNormal];
    searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 14, 0, 0);
    searchButton.imageEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    searchButton.layer.masksToBounds = YES;
    searchButton.layer.cornerRadius = 3.f;

    _searchView = [UIView getCustomViewWithColor:_define_white_color];
    [_navView addSubview:_searchView];
    [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];

    UIButton *searchCancelButton = [UIButton getCustomTitleBtnWithAlignment:2 WithFont:18.f WithSpacing:0 WithNormalTitle:NSLocalizedString(@"取消",nil) WithNormalColor:[UIColor colorWithHex:@"919191"] WithSelectedTitle:nil WithSelectedColor:nil];
    [_searchView addSubview:searchCancelButton];
    [searchCancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-13);
        make.width.mas_equalTo(60);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [searchCancelButton addTarget:self action:@selector(hideSearchView) forControlEvents:UIControlEventTouchUpInside];

    UIView *searchBackView = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"EFEFEF"]];
    [_searchView addSubview:searchBackView];
    [searchBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13.f);
        make.right.mas_equalTo(searchCancelButton.mas_left).with.offset(0);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(-8);
    }];
    searchBackView.layer.masksToBounds = YES;
    searchBackView.layer.cornerRadius = 3.f;

    UIButton *icon = [UIButton getCustomImgBtnWithImageStr:@"search_Img" WithSelectedImageStr:nil];
    [searchBackView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(22);
        make.centerY.mas_equalTo(searchBackView);
    }];

    _searchField = [UITextField getTextFieldWithPlaceHolder:NSLocalizedString(@"搜索物流公司", nil) WithAlignment:0 WithFont:14.f WithTextColor:nil WithLeftWidth:0 WithRightWidth:0 WithSecureTextEntry:NO HaveBorder:NO WithBorderColor:nil];
    [searchBackView addSubview:_searchField];
    [_searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(icon.mas_right).with.offset(0);
        make.top.bottom.right.mas_equalTo(0);
    }];
    _searchField.delegate = self;
    _searchField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _searchField.returnKeyType = UIReturnKeyDone;

    _searchView.hidden = YES;
}
-(void)createTableView{
    WeakSelf(ws);
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexColor = [UIColor colorWithHex:@"AFAFAF"];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ws.navView.mas_bottom).with.offset(0);
        make.left.right.bottom.mas_equalTo(0);
    }];
}
-(void)createNoDataView{
    if(!_noDataView){
        self.noDataView = addNoDataView_phone(self.view, [NSString stringWithFormat:@"%@|icon:noSearchResultData_icon",NSLocalizedString(@"抱歉，没有搜索到相关物流公司",nil)],nil,nil);
        _noDataView.hidden = YES;
    }
}
-(UIView *)getHeaderViewWithTitle:(NSString *)titleStr{

    UIView *headerView = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"EFEFEF"]];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 15.f);

    UILabel *titleLabel = [UILabel getLabelWithAlignment:0 WithTitle:titleStr WithFont:14.f WithTextColor:nil WithSpacing:0];
    [headerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.right.mas_equalTo(-17);
        make.top.bottom.mas_equalTo(0);
    }];

    return headerView;
}
#pragma mark - --------------请求数据----------------------
- (void)RequestData {
    WeakSelf(ws);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [YYOrderApi getExpressCompanyWithBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSArray *expressCompanyArray, NSError *error) {
        [hud hideAnimated:YES];
        if(rspStatusAndMessage.status == YYReqStatusCode100){

            [ws analysisData:expressCompanyArray];
            [ws.tableView reloadData];

        }else{
            [YYToast showToastWithView:self.view title:rspStatusAndMessage.message andDuration:kAlertToastDuration];
        }
    }];
}
#pragma mark - --------------系统代理----------------------
#pragma mark - UITableViewDelegate-索引相关
//右边索引 字节数(如果不实现 就不显示右侧索引)
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(!_isSearchView)
    {
        return _arrayChar;
    }
    //搜索的时候不给他索引
    return @[];
}
//索引列点击事件
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if(!_isSearchView)
    {
        NSInteger count = 0;
        for(NSString *character in _arrayChar)
        {
            if([character isEqualToString:title])
            {
                return count;
            }
            count++;
        }
    }
    return 0;
}
#pragma mark - UITableViewDelegate-SectionHeader相关
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(!_isSearchView)
    {
        if(_arrayChar.count){
            return 15.f;
        }
    }
    //因为在searchDC上的_searchBar就是创建searchDC时，由第一个参数指定的_searchBar
    if(![NSString isNilOrEmpty:_searchField.text])
    {
        if(_arrayChar1.count){
            return 15.f;
        }
    }
    return 0;
}

//section （标签）标题显示
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(!_isSearchView)
    {
        if(_arrayChar.count){
            return [self getHeaderViewWithTitle:_arrayChar[section]];
        }
    }
    //因为在searchDC上的_searchBar就是创建searchDC时，由第一个参数指定的_searchBar
    if(![NSString isNilOrEmpty:_searchField.text])
    {
        if(_arrayChar1.count){
            return [self getHeaderViewWithTitle:_arrayChar1[section]];
        }
    }

    return nil;
}
#pragma mark - UITableViewDelegate-Normal
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(!_isSearchView)
    {
        if(_arrayChar.count){
            return _arrayChar.count;
        }
    }
    //因为在searchDC上的_searchBar就是创建searchDC时，由第一个参数指定的_searchBar
    if(![NSString isNilOrEmpty:_searchField.text])
    {
        if(_arrayChar1.count){
            return _arrayChar1.count;
        }
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!_isSearchView)
    {
        if(_arrayChar.count)
        {
            NSString *strKey = _arrayChar[section];
            NSInteger count = [_dictPinyinAndChinese[strKey] count];
            return count;
        }
    }

    if(![NSString isNilOrEmpty:_searchField.text])
    {
        if(_arrayChar1.count)
        {
            NSString *strKey = _arrayChar1[section];
            NSInteger count = [_dictPinyinAndChinese1[strKey] count];
            return count;
        }
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYExpressCompanyModel *expressCompanyModel = nil;
    BOOL isHideBottomLine = YES;
    if(!_isSearchView)
    {
        if(_arrayChar.count){
            NSString *titleStr = _arrayChar[indexPath.section];
            NSArray *groupArr = _dictPinyinAndChinese[titleStr];
            expressCompanyModel = groupArr[indexPath.row];

            if((_arrayChar.count == indexPath.section+1) && (groupArr.count == indexPath.row+1)){
                isHideBottomLine = NO;
            }else{
                if(groupArr.count > indexPath.row+1){
                    isHideBottomLine = NO;
                }
            }
        }
    }
    //因为在searchDC上的_searchBar就是创建searchDC时，由第一个参数指定的_searchBar
    if(![NSString isNilOrEmpty:_searchField.text])
    {
        if(_arrayChar1.count){
            NSString *titleStr = _arrayChar1[indexPath.section];
            NSArray *groupArr = _dictPinyinAndChinese1[titleStr];
            expressCompanyModel = groupArr[indexPath.row];

            if((_arrayChar1.count == indexPath.section+1) && (groupArr.count == indexPath.row+1)){
                isHideBottomLine = NO;
            }else{
                if(groupArr.count > indexPath.row+1){
                    isHideBottomLine = NO;
                }
            }
        }
    }

    if(expressCompanyModel){
        static NSString *cellid = @"YYChooseLogisticsCell";
        YYChooseLogisticsCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellid];
        if(!cell){
            cell = [[YYChooseLogisticsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.isHideBottomLine = isHideBottomLine;
        cell.expressCompanyModel = expressCompanyModel;
        [cell updateUI];
        return cell;
    }else{
        static NSString *cellid = @"cellid";
        UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellid];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YYExpressCompanyModel *expressCompanyModel = nil;
    if(!_isSearchView){
        expressCompanyModel = (_dictPinyinAndChinese[_arrayChar[indexPath.section]])[indexPath.row];
    }else{
        expressCompanyModel = (_dictPinyinAndChinese1[_arrayChar1[indexPath.section]])[indexPath.row];
    }
    if(_chooseLogisticsSelectBlock){
        _chooseLogisticsSelectBlock(expressCompanyModel);
    }
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:_searchField];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:_searchField];
}
- (void)textFieldDidChange:(NSNotification *)note{
    NSLog(@"_searchField = %@",_searchField.text);
    NSLog(@"111");
    //咱们需要通过当前搜索内容，去筛选出dictPinyinAndChinese1、arrayChar1的数据
    [self updateSearchData];
    [_tableView reloadData];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_searchField resignFirstResponder];
    return YES;
}
#pragma mark - --------------自定义代理/block----------------------

#pragma mark - --------------自定义响应----------------------
-(void)goBack:(id)sender {
    if(_cancelButtonClicked){
        _cancelButtonClicked();
    }
}

-(void)showSearchView{
    if (_searchView.hidden == YES) {
        WeakSelf(ws);
        _searchView.hidden = NO;
        _searchField.text = nil;
        _searchView.alpha = 0.0;
        [_searchView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-44);
        }];
        [UIView animateWithDuration:0.3 animations:^{
            ws.searchView.alpha = 1.0;
            [ws.searchView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
            }];
        } completion:^(BOOL finished) {
            ws.isSearchView = YES;
            [ws.searchField becomeFirstResponder];
            [ws.tableView reloadData];
        }];
    }
}
-(void)hideSearchView{
    if (_searchView.hidden == NO) {
        WeakSelf(ws);
        _searchView.alpha = 1.0;
        [_searchView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
        }];
        [UIView animateWithDuration:0.3 animations:^{
            [ws.searchView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(-44);
            }];
            ws.searchView.alpha = 0.0;
            [ws.searchView layoutIfNeeded];
        } completion:^(BOOL finished) {
            [ws.dictPinyinAndChinese1 removeAllObjects];
            [ws.arrayChar1 removeAllObjects];
            [ws.searchField resignFirstResponder];
            ws.searchField.text = nil;
            ws.searchView.hidden = YES;
            ws.isSearchView = NO;
            ws.noDataView.hidden = YES;
            [ws.tableView reloadData];
        }];
    }
}
#pragma mark - --------------自定义方法----------------------
-(void)updateSearchData{

    [_dictPinyinAndChinese1 removeAllObjects];
    [_arrayChar1 removeAllObjects];

    if(![NSString isNilOrEmpty:_searchField.text]){
        //有搜索内容
        NSMutableArray *tmpArray = [[NSMutableArray alloc] init];

        for (YYExpressCompanyModel *model in _expressCompanyArray) {
            NSString *modelName = [[ChineseToPinyin pinyinFromChiniseString:model.name] uppercaseString];
            if ([modelName containsString:[[ChineseToPinyin pinyinFromChiniseString:_searchField.text] uppercaseString]]) {
                [tmpArray addObject:model];
            }
        }

        NSArray *result_arr = [tmpArray sortedArrayUsingComparator:^NSComparisonResult(YYExpressCompanyModel *obj1, YYExpressCompanyModel * obj2) {
            return [[ChineseToPinyin pinyinFromChiniseString:obj1.name] compare:[ChineseToPinyin pinyinFromChiniseString:obj2.name] options:NSNumericSearch];
        }];

        //name = “关羽”
        for (YYExpressCompanyModel *model in result_arr) {
            //‘GUANYU’
            NSString *pinyin = [ChineseToPinyin pinyinFromChiniseString:model.name];

            //“G”
            NSString *charFirst = [pinyin substringToIndex:1];
            //从字典中招关于G的键值对
            NSMutableArray *charArray = [_dictPinyinAndChinese1 objectForKey:charFirst];
            //没有找到
            if (charArray == nil) {
                NSMutableArray *subArray = [[NSMutableArray alloc] init];
                //“关羽”
                [subArray addObject:model];
                // dict   key = "G"  value = subArray -> "关羽"
                [_dictPinyinAndChinese1 setValue:subArray forKey:charFirst];
            }else
            {
                [charArray addObject:model];
            }
        }

        //索引整出来
        for (int i = 0; i < 26; i++) {
            NSString *str = [NSString stringWithFormat:@"%c", 'A' + i];
            for (NSString *key in [_dictPinyinAndChinese1 allKeys]) {
                if ([str isEqualToString:key]) {
                    [_arrayChar1 addObject:str];
                }
            }
        }
        if(_arrayChar1.count){
            _noDataView.hidden = YES;
        }else{
            _noDataView.hidden = NO;
        }
    }else{
        _noDataView.hidden = YES;
    }
}
-(void)analysisData:(NSArray *)dataArr{

    NSArray *result_arr = [dataArr sortedArrayUsingComparator:^NSComparisonResult(YYExpressCompanyModel *obj1, YYExpressCompanyModel * obj2) {
        return [[ChineseToPinyin pinyinFromChiniseString:obj1.name] compare:[ChineseToPinyin pinyinFromChiniseString:obj2.name] options:NSNumericSearch];
    }];

    [_expressCompanyArray addObjectsFromArray:result_arr];


    [_dictPinyinAndChinese removeAllObjects];
    //name = “关羽”
    for (YYExpressCompanyModel *model in _expressCompanyArray) {
        //‘GUANYU’
        NSString *pinyin = [ChineseToPinyin pinyinFromChiniseString:model.name];

        //“G”
        NSString *charFirst = [pinyin substringToIndex:1];
        //从字典中招关于G的键值对
        NSMutableArray *charArray = [_dictPinyinAndChinese objectForKey:charFirst];
        //没有找到
        if (charArray == nil) {
            NSMutableArray *subArray = [[NSMutableArray alloc] init];
            //“关羽”
            [subArray addObject:model];
            // dict   key = "G"  value = subArray -> "关羽"
            [_dictPinyinAndChinese setValue:subArray forKey:charFirst];
        }else
        {
            [charArray addObject:model];
        }
    }

    //索引整出来
    [_arrayChar removeAllObjects];
    for (int i = 0; i < 26; i++) {
        NSString *str = [NSString stringWithFormat:@"%c", 'A' + i];
        for (NSString *key in [_dictPinyinAndChinese allKeys]) {
            if ([str isEqualToString:key]) {
                [_arrayChar addObject:str];
            }
        }
    }
}

#pragma mark - --------------other----------------------

@end
