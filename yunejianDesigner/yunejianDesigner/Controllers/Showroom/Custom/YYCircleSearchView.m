//
//  YYCircleSearchView.m
//  YCO SPACE
//
//  Created by yyj on 16/8/15.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "YYCircleSearchView.h"

#import "YYShowroomMainNoDataView.h"
#import "YYShowroomBrandListCell.h"

#import "YYShowroomBrandListModel.h"
#import "YYShowroomBrandModel.h"
#import "YYShowroomBrandTool.h"
#import "regular.h"

@interface YYCircleSearchView()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
//是否是索引状态
//@property (assign ,nonatomic) BOOL isIndex;
//用于存放索引
@property (strong ,nonatomic) NSArray *arrayChar;
//用于存放分类好的数据
@property (strong ,nonatomic) NSMutableDictionary *dictPinyinAndChinese;

@property (strong ,nonatomic) UISearchBar *searchBar;
@property (strong ,nonatomic) UIView *searchView;
@property (strong ,nonatomic) YYShowroomMainNoDataView *noDataView;
@property (strong ,nonatomic) UITableView *tableView;

@end

@implementation YYCircleSearchView

-(instancetype)initWithQueryStr:(NSString *)queryStr WithBlock:(void(^)(NSString *type,NSString *queryStr,YYShowroomBrandModel *ShowroomBrandModel))block;
{
    self=[super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if(self)
    {
        _block=block;
        _queryStr=queryStr;
        [self SomePrepare];
        [self UIConfig];
    }
    return self;
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}

-(void)PrepareData
{
    _dictPinyinAndChinese = [[NSMutableDictionary alloc] init];
    _arrayChar = [YYShowroomBrandTool getCharArr];
//    _isIndex = NO;
}
-(void)PrepareUI
{
    self.backgroundColor = _define_white_color;
}

-(void)initPinyinAndChinese
{
    [_dictPinyinAndChinese removeAllObjects];
    
    for (int i = 0; i < 26; i++) {
        NSMutableArray *arr=[[NSMutableArray alloc] init];
        NSString *str = [NSString stringWithFormat:@"%c", 'A' + i];
        [_dictPinyinAndChinese setObject:arr forKey:str];
    }
    [_dictPinyinAndChinese setObject:[[NSMutableArray alloc] init] forKey:@"#"];
}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateSearchBar];
    [self CreateTableView];
}
-(void)CreateSearchBar
{
    _searchView=[UIView getCustomViewWithColor:nil];
    [self addSubview:_searchView];
    [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(27 + (kIPhoneX?24.f:0.f));
        make.height.mas_equalTo(38);
    }];
    
    UIView *backView = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"EFEFEF"]];
    [_searchView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.centerY.mas_equalTo(_searchView);
        make.right.mas_equalTo(-63);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-8);
    }];
    backView.layer.masksToBounds=YES;
    backView.layer.cornerRadius=3;
    
    UIButton *cancelBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:15.0f WithSpacing:2 WithNormalTitle:NSLocalizedString(@"取消",nil) WithNormalColor:[UIColor colorWithHex:@"919191"] WithSelectedTitle:nil WithSelectedColor:nil];
    [_searchView addSubview:cancelBtn];
    [cancelBtn setEnlargeEdgeWithTop:0 right:0 bottom:0 left:15];
    [cancelBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(0);
        make.left.mas_equalTo(backView.mas_right).with.offset(0);
        make.bottom.mas_equalTo(-8);
    }];
    
    _searchBar = [[UISearchBar alloc] init];
    [backView addSubview:_searchBar];
    _searchBar.delegate=self;
    _searchBar.placeholder=NSLocalizedString(@"搜索品牌名称",nil);
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame=CGRectMake(0, 0, SCREEN_HEIGHT-80, 30);
    imageView.backgroundColor = [UIColor colorWithHex:@"EFEFEF"];
    [_searchBar insertSubview:imageView atIndex:1];
    _searchBar.searchBarStyle=UISearchBarStyleDefault;
    _searchBar.text=_queryStr;
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(0);
    }];
    [_searchBar becomeFirstResponder];
    
    UITextField * searchField = [_searchBar valueForKey:@"_searchField"];
    searchField.backgroundColor=[UIColor clearColor];
    [searchField setValue:getFont(14.0f) forKeyPath:@"_placeholderLabel.font"];
    [searchField setValue:[UIColor colorWithHex:@"AFAFAF"] forKeyPath:@"_placeholderLabel.textColor"];

    searchField.textColor=_define_black_color;
    searchField.leftViewMode=UITextFieldViewModeNever;
    
    
    UIView *leftview=[UIView getCustomViewWithColor:nil];
    [backView addSubview:leftview];
    [leftview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(22);
    }];
    UIImageView *img=[UIImageView getImgWithImageStr:@"searchtxt_icon"];
    [leftview addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.centerY.mas_equalTo(leftview);
        make.width.height.mas_equalTo(14);
    }];
    
    UIView *bottomView=[UIView getCustomViewWithColor:[UIColor colorWithHex:@"d3d3d3"]];
    [_searchView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}
-(void)CreateTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    [self addSubview:_tableView];
    //    消除分割线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithHex:@"F8F8F8"];
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexColor = [UIColor colorWithHex:@"D3D3D3"];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(_searchView.mas_bottom).with.offset(0);
    }];
}



#pragma mark - someAction
-(void)searchAction
{
    [self initPinyinAndChinese];
    if(![NSString isNilOrEmpty:_searchBar.text.uppercaseString]&&_ShowroomBrandListModel)
    {
        
        NSMutableArray *tempBrandList = [[NSMutableArray alloc] init];
        [_ShowroomBrandListModel.brandList enumerateObjectsUsingBlock:^(YYShowroomBrandModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([model.brandName.uppercaseString containsString:_searchBar.text.uppercaseString]) {
                [tempBrandList addObject:model];
            }
        }];
        
        for (YYShowroomBrandModel *model in tempBrandList) {
            
            NSString *pinyin = [model.brandName transformToPinyin];
            
            NSString *charFirst = [pinyin substringToIndex:1];
            //从字典中招关于G的键值对
            NSMutableArray *charArray  = [_dictPinyinAndChinese objectForKey:charFirst];
            //没有找到
            if (charArray) {
                [charArray addObject:model];
                
            }else
            {
                NSMutableArray *subArray = [_dictPinyinAndChinese objectForKey:@"#"];
                //“关羽”
                [subArray addObject:model];
            }
        }
    }
//    NSInteger valueNum = [YYShowroomBrandTool getValueNumWithPinyinDict:_dictPinyinAndChinese];
//    if(valueNum>1 && _ShowroomBrandListModel.brandList.count>=5)
//    {
//        _isIndex = YES;
//    }else
//    {
//        _isIndex = NO;
//    }
    [self reload];
    
}

-(void)reload
{
    [_tableView reloadData];
    
    if([NSString isNilOrEmpty:_searchBar.text.uppercaseString])
    {
        _noDataView.hidden=YES;
    }else
    {
        NSInteger _valueNum = [YYShowroomBrandTool getValueNumWithPinyinDict:_dictPinyinAndChinese];
        if(_valueNum)
        {
            _noDataView.hidden=YES;
        }else
        {
            _noDataView.hidden=NO;
        }
    }
}
-(void)rightAction
{
    if(_block){
        _block(@"back",@"",nil);
    }
//    _queryStr=@"";
//    searchField.text=_queryStr;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [regular dismissKeyborad];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [regular dismissKeyborad];
}
#pragma mark - TableViewDelegate
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    if(_isIndex)
//    {
//        return _arrayChar;
//    }
//    return nil;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(![NSString isNilOrEmpty:_searchBar.text.uppercaseString]){
        NSInteger _valueNum = [YYShowroomBrandTool getValueNumWithPinyinDict:_dictPinyinAndChinese];
        if(_valueNum)
        {
            return 80;
        }
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(![NSString isNilOrEmpty:_searchBar.text.uppercaseString]){
        NSString *strKey = [_arrayChar objectAtIndex:section];
        NSInteger _count=[(NSArray *)[_dictPinyinAndChinese objectForKey:strKey] count];
        return _count;
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(![NSString isNilOrEmpty:_searchBar.text.uppercaseString])
    {
        return _arrayChar.count;
    }else
    {
        return 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_ShowroomBrandListModel)
    {
        if(_ShowroomBrandListModel.brandList.count)
        {
            static NSString *cellid=@"YYShowroomBrandListCell";
            YYShowroomBrandListCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
            if(!cell)
            {
                cell = [[YYShowroomBrandListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.brandModel = [[_dictPinyinAndChinese objectForKey:[_arrayChar objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
            
//            if(_isIndex)
//            {
//                NSMutableArray *tempArr = [_dictPinyinAndChinese objectForKey:[_arrayChar objectAtIndex:indexPath.section]];
//                if(indexPath.row<tempArr.count-1){
//                    [cell bottomIsHide:NO];
//                }else{
//                    [cell bottomIsHide:YES];
//                }
//                
//            }else
//            {
                [cell bottomIsHide:NO];
//            }
            return cell;
        }
    }
    static NSString *cellid=@"UITableViewCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if(!cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYShowroomBrandModel *showbrandModel = [[_dictPinyinAndChinese objectForKey:[_arrayChar objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    if(_block){
        _block(@"search",@"",showbrandModel);
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    if(_isIndex)
//    {
//        return [YYShowroomBrandTool getViewForHeaderInSection:section WithPinyinDict:_dictPinyinAndChinese];
//    }
    UIView *view = [UIView getCustomViewWithColor:_define_white_color];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.01);
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if(_isIndex)
//    {
//        return [YYShowroomBrandTool heightForHeaderInSection:section WithPinyinDict:_dictPinyinAndChinese];
//    }
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self searchAction];
    NSLog(@"ShouldBeginEditing");
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self searchAction];
    [self CreateOrMoveNoDataView];
}
-(void)CreateOrMoveNoDataView
{
    if(!_noDataView)
    {
        _noDataView = [[YYShowroomMainNoDataView alloc] initNoDataSearchWithSuperView:_tableView];
    }
    NSLog(@"_searchBar.text=%@",_searchBar.text);
    NSLog(@"valuecount=%ld",[YYShowroomBrandTool getValueNumWithPinyinDict:_dictPinyinAndChinese]);
    if([NSString isNilOrEmpty:_searchBar.text])
    {
        _noDataView.hidden = YES;
    }else
    {
        if([YYShowroomBrandTool getValueNumWithPinyinDict:_dictPinyinAndChinese])
        {
            _noDataView.hidden = YES;
        }else{
            _noDataView.hidden = NO;
        }
    }
}
@end
