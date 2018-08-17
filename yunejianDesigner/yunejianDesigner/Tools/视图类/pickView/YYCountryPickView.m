//
//  YYCountryPickView.m
//  YunejianBuyer
//
//  Created by Apple on 16/3/17.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYCountryPickView.h"
#import "AppDelegate.h"
#import "YYCountryModel.h"
#import "YYCountryListModel.h"
#import "YYUserApi.h"
#define ZHToobarHeight 40
#define ZHViewOffset 0

@interface YYCountryPickView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,assign)YYCountryPickViewType plistType;//类型

@property (nonatomic,strong)YYCountryListModel *subCountryModel;//子城市数据

@property(nonatomic,strong)UIToolbar *toolbar;
@property(nonatomic,strong)UIPickerView *pickerView;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,assign)BOOL isHaveNavControler;
@property(nonatomic,assign)BOOL isHaveSubComponent;
@property(nonatomic,assign)NSInteger pickeviewHeight;
@property(nonatomic,copy)NSString *resultString;
@end

@implementation YYCountryPickView

-(NSArray *)plistArray{
    if (_plistArray==nil) {
        _plistArray=[[NSArray alloc] init];
    }
    return _plistArray;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = _define_white_color;
        [self setUpToolBar];
    }
    return self;
}

-(instancetype)initPickviewWithCountryArray:(NSArray *)array WithPlistType:(YYCountryPickViewType )plistType isHaveNavControler:(BOOL)isHaveNavControler{
    
    self=[super init];
    if (self) {
        self.backgroundColor = _define_white_color;
        self.plistArray = array;
        self.plistType = plistType;
        _isHaveSubComponent = NO;
        if(self.plistType == SubCountryPickView){
            [self setIsHaveSubComponent];
        }
        [self setUpPickView];
        [self setFrameWith:isHaveNavControler];
    }
    return self;
}
-(void)setIsHaveSubComponent{
    
    for (YYCountryModel  *countryModel in self.plistArray) {
        if([countryModel.parentImpId integerValue]){
            _isHaveSubComponent = YES;
            break;
        }
    }
    if(!_isHaveSubComponent){
        [self updateResultStringWithIndex:0 WithRow:0];//更新resultString
        [self selectPickerRow:0 inComponent:0 animated:NO];
    }
}
-(void)setUpPickView{
    
    UIPickerView *pickView=[[UIPickerView alloc] init];
    pickView.backgroundColor=[UIColor whiteColor];
    _pickerView=pickView;
    pickView.delegate=self;
    pickView.dataSource=self;
    pickView.showsSelectionIndicator=YES;
    pickView.frame=CGRectMake(0, ZHToobarHeight-ZHViewOffset, [UIScreen mainScreen].bounds.size.width, pickView.frame.size.height-ZHViewOffset*2);
    _pickeviewHeight=pickView.frame.size.height-ZHViewOffset*2;
    //[self addSubview:pickView];
    [self insertSubview:pickView atIndex:0];
    
    if(self.plistType == SubCountryPickView){
        if(_isHaveSubComponent){
            [self reloadDataWithIndex:0 WithRow:0 isFirstLoad:YES];
        }
    }else if(self.plistType == CountryPickView){
        [self updateResultStringWithIndex:0 WithRow:0];//更新resultString
        [self selectPickerRow:0 inComponent:0 animated:NO];
    }
}
-(void)setFrameWith:(BOOL)isHaveNavControler{
    CGFloat toolViewX = 0;
    CGFloat toolViewH = _pickeviewHeight + ZHToobarHeight + kBottomSafeAreaHeight;
    CGFloat toolViewY ;
    if (isHaveNavControler) {
        toolViewY= [UIScreen mainScreen].bounds.size.height-toolViewH-50;
    }else {
        toolViewY= [UIScreen mainScreen].bounds.size.height-toolViewH;
    }
    CGFloat toolViewW = [UIScreen mainScreen].bounds.size.width;
    self.frame = CGRectMake(toolViewX, toolViewY, toolViewW, toolViewH);
    NSLog(@"111");
}

-(void)selectPickerRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)anim{
    if(_pickerView){
        [_pickerView selectRow:row inComponent:component animated:anim];
    }
}

-(void)setUpToolBar{
    _toolbar=[self setToolbarStyle];
    [self setToolbarWithPickViewFrame];
    [self addSubview:_toolbar];
}
-(UIToolbar *)setToolbarStyle{
    UIToolbar *toolbar=[[UIToolbar alloc] init];
    toolbar.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *lefeRightSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    lefeRightSpace.width = 15;
    
    UIButton *customLeftBtn = [UIButton getCustomTitleBtnWithAlignment:1 WithFont:17 WithSpacing:0 WithNormalTitle:NSLocalizedString(@"取消",nil) WithNormalColor:nil WithSelectedTitle:nil WithSelectedColor:nil];
    [customLeftBtn addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    customLeftBtn.frame = CGRectMake(0, 0, 100, ZHToobarHeight);
    UIBarButtonItem *lefttem=[[UIBarButtonItem alloc] initWithCustomView:customLeftBtn];
    [lefttem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
    
    UIBarButtonItem *centerSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIButton *customRightBtn = [UIButton getCustomTitleBtnWithAlignment:2 WithFont:17 WithSpacing:0 WithNormalTitle:NSLocalizedString(@"确定",nil) WithNormalColor:nil WithSelectedTitle:nil WithSelectedColor:nil];
    [customRightBtn addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    customRightBtn.frame = CGRectMake(0, 0, 100, ZHToobarHeight);
    UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithCustomView:customRightBtn];
    [right setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    
    toolbar.items=@[lefeRightSpace,lefttem,centerSpace,right,lefeRightSpace];
    
    return toolbar;
}

-(void)setToolbarWithPickViewFrame{
    _toolbar.frame=CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, ZHToobarHeight);
}

#pragma mark piackView 数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    if(_isHaveSubComponent){
        return 2;
    }else{
        return 1;
    }
    
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger _count = 0;
    if(component == 0){
        _count = _plistArray.count;
    }else{
        if(_subCountryModel){
            _count = _subCountryModel.result.count;
        }else{
            _count = 0;
        }
    }
    return _count;
}

#pragma mark UIPickerViewdelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *rowTitle=nil;
    if (component == 0) {
        YYCountryModel *tmpCountryModel = _plistArray[row];
        rowTitle = [LanguageManager isEnglishLanguage]?tmpCountryModel.nameEn:tmpCountryModel.name;
    }else if (component == 1){
        if(_subCountryModel){
            if(_subCountryModel.result.count > row){
                YYCountryModel *subCountryModel=_subCountryModel.result[row];
                rowTitle = [LanguageManager isEnglishLanguage]?subCountryModel.nameEn:subCountryModel.name;
            }else{
                rowTitle = @"";
            }
        }else{
            rowTitle = @"";
        }
    }
    return rowTitle;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    NSInteger cIndex_section = [pickerView selectedRowInComponent:0];
    NSInteger cIndex_row = 0;
    if(_isHaveSubComponent){
        cIndex_row = [pickerView selectedRowInComponent:1];
    }
    YYCountryModel *countryModel=_plistArray[cIndex_section];
    
    if(_plistType == SubCountryPickView){
        if(_isHaveSubComponent){
            BOOL changeProvince = YES;
            if(_subCountryModel){
                if(_subCountryModel.result.count){
                    YYCountryModel *tempModel = _subCountryModel.result[0];
                    if([tempModel.parentImpId integerValue] == [countryModel.impId integerValue]){
                        changeProvince = NO;
                    }
                }
            }
            if(changeProvince){
                _subCountryModel = nil;
                [self reloadDataWithIndex:cIndex_section WithRow:cIndex_row isFirstLoad:NO];//加载
            }else{
                [self updateResultStringWithIndex:cIndex_section WithRow:cIndex_row];
            }
        }else{
            [self updateResultStringWithIndex:cIndex_section WithRow:cIndex_row];
        }
        
    }else if(_plistType == CountryPickView){
        [self updateResultStringWithIndex:cIndex_section WithRow:cIndex_row];
    }
    
}
#pragma mark - SomeAction
-(void)updateResultStringWithIndex:(NSInteger )index WithRow:(NSInteger )row{
    YYCountryModel *countryModel=_plistArray[index];
    NSString *countryStr = [[NSString alloc] initWithFormat:@"%@/%ld",[LanguageManager isEnglishLanguage]?countryModel.nameEn:countryModel.name,[countryModel.impId integerValue]];
    
    if(_plistType == SubCountryPickView){
        if(_isHaveSubComponent){
            if(_subCountryModel){
                if(_subCountryModel.result.count > row){
                    YYCountryModel *subCountryModel=_subCountryModel.result[row];
                    NSString *subCountryStr = [[NSString alloc] initWithFormat:@"%@/%ld",[LanguageManager isEnglishLanguage]?subCountryModel.nameEn:subCountryModel.name,[subCountryModel.impId integerValue]];
                    _resultString = [NSString stringWithFormat:@"%@,%@",countryStr,subCountryStr];
                }else{
                    _resultString = countryStr;
                }
            }else{
                _resultString = countryStr;
            }
        }else{
            _resultString = countryStr;
        }
    }else if(_plistType == CountryPickView){
        _resultString = countryStr;
    }
    NSLog(@"resultString=%@",_resultString);
    NSLog(@"111");
}
-(void)reloadDataWithIndex:(NSInteger )index WithRow:(NSInteger)row isFirstLoad:(BOOL )isfirst{
    if(_plistType == SubCountryPickView){
        YYCountryModel *countryModel=_plistArray[index];
        NSInteger _impId = [countryModel.impId integerValue];
        if(_plistType == SubCountryPickView){
            [YYUserApi getSubCountryInfoWithCountryID:_impId WithBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYCountryListModel *countryListModel,NSInteger impId, NSError *error) {
                if (rspStatusAndMessage.status == YYReqStatusCode100) {
                    if(_impId == impId){
                        _subCountryModel = countryListModel;
                        [_pickerView reloadAllComponents];
                        if(isfirst){
                            //存一下
                            [self updateResultStringWithIndex:0 WithRow:0];//更新resultString
                            [self selectPickerRow:0 inComponent:0 animated:NO];
                        }else{
                            [self updateResultStringWithIndex:index WithRow:row];//更新resultString
                        }
                    }
                }
            }];
        }
    }
}
-(void)remove{
    if(_cancelButtonClicked){
        _cancelButtonClicked();
    }
    [self.bgView removeFromSuperview];
    self.bgView = nil;
    [self removeFromSuperview];
}
-(void)removeNoBlock{
    [self.bgView removeFromSuperview];
    self.bgView = nil;
    [self removeFromSuperview];
}
-(void)show:(UIView *)specialParentView{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(self.bgView == nil){
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.bgView.backgroundColor = [UIColor grayColor];
        self.bgView.alpha = 0.6;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remove)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        [self.bgView addGestureRecognizer:tapGestureRecognizer];
    }
    CGFloat toolViewH = _pickeviewHeight+ZHToobarHeight;
    if(specialParentView == nil){
        specialParentView = appDelegate.mainViewController.view;
    }
    [specialParentView addSubview:self.bgView];
    [specialParentView addSubview:self];
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame)+toolViewH, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame)-toolViewH, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    }];
}
-(void)doneClick
{
    NSLog(@"resultString=%@",_resultString);
    if ([self.delegate respondsToSelector:@selector(toobarDonBtnHaveCountryClick:resultString:)]) {
        [self.delegate toobarDonBtnHaveCountryClick:self resultString:_resultString];
    }
    [self removeNoBlock];
}
/**
 *  设置PickView的颜色
 */
-(void)setPickViewColer:(UIColor *)color{
    _pickerView.backgroundColor=color;
}
/**
 *  设置toobar的文字颜色
 */
-(void)setTintColor:(UIColor *)color{
    
    _toolbar.tintColor=color;
}
/**
 *  设置toobar的背景颜色
 */
-(void)setToolbarTintColor:(UIColor *)color{
    
    _toolbar.barTintColor=color;
}
-(void)dealloc{
    
    //NSLog(@"销毁了");
}
@end
