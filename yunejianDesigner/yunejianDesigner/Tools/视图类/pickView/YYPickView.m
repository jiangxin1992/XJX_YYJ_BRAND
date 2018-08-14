//
//  YYPickView.m
//  YunejianBuyer
//
//  Created by Apple on 16/3/17.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYPickView.h"
#import "AppDelegate.h"
#define ZHToobarHeight 50
#define ZHViewOffset 0

@interface YYPickView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,copy)NSString *plistName;
@property(nonatomic,strong)NSArray *plistArray;
@property(nonatomic,assign)BOOL isLevelArray;
@property(nonatomic,assign)BOOL isLevelString;
@property(nonatomic,assign)BOOL isLevelDic;
@property(nonatomic,strong)NSDictionary *levelTwoDic;

@property(nonatomic,strong)UIToolbar *toolbar;
@property(nonatomic,strong)UIPickerView *pickerView;
@property(nonatomic,strong)UIDatePicker *datePicker;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,assign)NSDate *defaulDate;
@property(nonatomic,assign)BOOL isHaveNavControler;
@property(nonatomic,assign)NSInteger pickeviewHeight;
@property(nonatomic,copy)NSString *resultString;
@property(nonatomic,strong)NSMutableArray *componentArray;
@property(nonatomic,strong)NSMutableArray *dicKeyArray;
@property(nonatomic,copy)NSMutableArray *state;
@property(nonatomic,copy)NSMutableArray *city;
@end

@implementation YYPickView

-(NSArray *)plistArray{
    if (_plistArray==nil) {
        _plistArray=[[NSArray alloc] init];
    }
    return _plistArray;
}

-(NSArray *)componentArray{
    
    if (_componentArray==nil) {
        _componentArray=[[NSMutableArray alloc] init];
    }
    return _componentArray;
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


-(instancetype)initPickviewWithPlistName:(NSString *)plistName isHaveNavControler:(BOOL)isHaveNavControler{
    
    self=[super init];
    if (self) {
        self.backgroundColor = _define_white_color;
        _plistName=plistName;
        self.plistArray=[self getPlistArrayByplistName:plistName];
        [self setUpPickView];
        [self setFrameWith:isHaveNavControler];
        
    }
    return self;
}
-(instancetype)initPickviewWithArray:(NSArray *)array isHaveNavControler:(BOOL)isHaveNavControler{
    self=[super init];
    if (self) {
        self.backgroundColor = _define_white_color;
        self.plistArray=array;
        [self setArrayClass:array];
        [self setUpPickView];
        [self setFrameWith:isHaveNavControler];
    }
    return self;
}

-(instancetype)initDatePickWithDate:(NSDate *)defaulDate datePickerMode:(UIDatePickerMode)datePickerMode isHaveNavControler:(BOOL)isHaveNavControler{
    
    self=[super init];
    if (self) {
        self.backgroundColor = _define_white_color;
        _defaulDate=defaulDate;
        [self setUpDatePickerWithdatePickerMode:(UIDatePickerMode)datePickerMode];
        [self setFrameWith:isHaveNavControler];
    }
    return self;
}


-(NSArray *)getPlistArrayByplistName:(NSString *)plistName{
    
    NSString *path= [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSMutableArray * array=[[NSMutableArray alloc] initWithContentsOfFile:path];
    [array addObject:@{@"p_ID":@"0",@"p_Name":@"海外港澳台",@"Citys":@[@{@"C_ID":@"0",@"C_Name":@"香港"},@{@"C_ID":@"0",@"C_Name":@"澳门"},@{@"C_ID":@"0",@"C_Name":@"台湾"},@{@"C_ID":@"0",@"C_Name":@"海外"}]}];

    [self setArrayClass:array];
    return array;
}

-(void)setArrayClass:(NSArray *)array{
    _dicKeyArray=[[NSMutableArray alloc] init];
    for (id levelTwo in array) {
        
        if ([levelTwo isKindOfClass:[NSArray class]]) {
            _isLevelArray=YES;
            _isLevelString=NO;
            _isLevelDic=NO;
        }else if ([levelTwo isKindOfClass:[NSString class]]){
            _isLevelString=YES;
            _isLevelArray=NO;
            _isLevelDic=NO;
            
        }else if ([levelTwo isKindOfClass:[NSDictionary class]])
        {
            _isLevelDic=YES;
            _isLevelString=NO;
            _isLevelArray=NO;
            _levelTwoDic=levelTwo;
            [_dicKeyArray addObject:[_levelTwoDic allKeys] ];
        }
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
}
-(void)setUpPickView{
    
    UIPickerView *pickView=[[UIPickerView alloc] init];
    pickView.backgroundColor=[UIColor whiteColor];
    _pickerView=pickView;
    pickView.delegate=self;
    pickView.dataSource=self;
    pickView.frame=CGRectMake(0, ZHToobarHeight-ZHViewOffset, [UIScreen mainScreen].bounds.size.width, pickView.frame.size.height-ZHViewOffset*2);
    _pickeviewHeight=pickView.frame.size.height-ZHViewOffset*2;
    //[self addSubview:pickView];
    [self insertSubview:pickView atIndex:0];
}
-(void)selectPickerRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)anim{
    if(_pickerView){
        [_pickerView selectRow:row inComponent:component animated:anim];
        if (_isLevelString) {
            _resultString=_plistArray[row];
            _resultString=[NSString stringWithFormat:@"%@|%ld",_resultString,(long)row];

        }else if (_isLevelArray){
            _resultString=@"";
            if (![self.componentArray containsObject:@(component)]) {
                [self.componentArray addObject:@(component)];
            }
            for (int i=0; i<_plistArray.count;i++) {
                if ([self.componentArray containsObject:@(i)]) {
                    NSInteger cIndex = [_pickerView selectedRowInComponent:i];
                    _resultString=[NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][cIndex]];
                }else{
                    _resultString=[NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][0]];
                }
            }
        }else if (_isLevelDic){
            if([_plistName isEqualToString:@"Provineces"]){
                if (component == 0) {
                    _state = [_plistArray[row] objectForKey:@"p_Name"];
                    [_pickerView reloadComponent:1];
                }else if (component == 1){
                    _state = [_plistArray[0] objectForKey:@"p_Name"];
                    NSInteger cIndex = [_pickerView selectedRowInComponent:0];
                    NSDictionary *dicValueDic=_plistArray[cIndex];
                    _city = [[[dicValueDic objectForKey:@"Citys"] objectAtIndex:row] objectForKey:@"C_Name"];
                }
            }else{
            if (component==0) {
                _state =_dicKeyArray[row][0];
            }else{
                NSInteger cIndex = [_pickerView selectedRowInComponent:0];
                NSDictionary *dicValueDic=_plistArray[cIndex];
                NSArray *dicValueArray=[dicValueDic allValues][0];
                if (dicValueArray.count>row) {
                    _city =dicValueArray[row];
                }
            }
            }
        }
        
    }
}

-(void)setUpDatePickerWithdatePickerMode:(UIDatePickerMode)datePickerMode{
    UIDatePicker *datePicker=[[UIDatePicker alloc] init];
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    datePicker.datePickerMode = datePickerMode;
    datePicker.backgroundColor=[UIColor whiteColor];
    NSDate* minDate = [[NSDate alloc] initWithTimeIntervalSince1970:1000];
    
    NSDate* maxDate =_defaulDate;
    
    datePicker.minimumDate = minDate;
    datePicker.maximumDate = maxDate;
    if (_defaulDate) {
        [datePicker setDate:_defaulDate];
    }
    _datePicker=datePicker;
    _pickeviewHeight=_datePicker.frame.size.height-ZHViewOffset*2;
    datePicker.frame=CGRectMake(0, ZHToobarHeight, datePicker.frame.size.width,_pickeviewHeight);
    //_pickeviewHeight=datePicker.frame.size.height;
    //[self addSubview:datePicker];
    [self insertSubview:datePicker atIndex:0];
    
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
    
    NSInteger component = 0;
    if (_isLevelArray) {
        component=_plistArray.count;
    } else if (_isLevelString){
        component=1;
    }else if(_isLevelDic){
        if([_plistName isEqualToString:@"Provineces"]){
            component = 2;
        }else{
            component=[_levelTwoDic allKeys].count*2;
        }
    }
    return component;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *rowArray=[[NSArray alloc] init];
    if (_isLevelArray) {
        rowArray=_plistArray[component];
    }else if (_isLevelString){
        rowArray=_plistArray;
    }else if (_isLevelDic){
        NSInteger pIndex = [pickerView selectedRowInComponent:0];
        NSDictionary *dic=_plistArray[pIndex];
        if([_plistName isEqualToString:@"Provineces"]){
            if(component == 0){
                rowArray = _plistArray;
            }else{
                rowArray = [dic objectForKey:@"Citys"];
            }
        }else{
        for (id dicValue in [dic allValues]) {
            if ([dicValue isKindOfClass:[NSArray class]]) {
                if (component%2==1) {
                    rowArray=dicValue;
                }else{
                    rowArray=_plistArray;
                }
            }
        }
        }
    }
    return rowArray.count;
}

#pragma mark UIPickerViewdelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *rowTitle=nil;
    if (_isLevelArray) {
        rowTitle=_plistArray[component][row];
    }else if (_isLevelString){
        rowTitle=_plistArray[row];
    }else if (_isLevelDic){
        NSInteger pIndex = [pickerView selectedRowInComponent:0];
        NSDictionary *dic=_plistArray[pIndex];
        if([_plistName isEqualToString:@"Provineces"]){
            if (component == 0) {
                rowTitle = [_plistArray[row] objectForKey:@"p_Name"];
            }else if (component == 1){
                if([(NSArray *)[dic objectForKey:@"Citys"] count] > row)
                rowTitle = [[[dic objectForKey:@"Citys"] objectAtIndex:row] objectForKey:@"C_Name"];
            }
        }else{
        if(component%2==0)
        {
            rowTitle=_dicKeyArray[row][component];
        }
        for (id aa in [dic allValues]) {
            if ([aa isKindOfClass:[NSArray class]]&&component%2==1){
                NSArray *bb=aa;
                if (bb.count>row) {
                    rowTitle=aa[row];
                }
                
            }
        }
        }
    }
    return rowTitle;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
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
    
    if (_isLevelDic&&component%2==0) {
        
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }
    if (_isLevelString) {
        if(_uidataType == UIDataTypeModifyLimit)
        {
            _resultString=_plistArray[row];
        }else
        {
            _resultString=_plistArray[row];
            _resultString=[NSString stringWithFormat:@"%@|%ld",_resultString,(long)row];
        }
        NSLog(@"111");
    }else if (_isLevelArray){
        _resultString=@"";
        if (![self.componentArray containsObject:@(component)]) {
            [self.componentArray addObject:@(component)];
        }
        for (int i=0; i<_plistArray.count;i++) {
            if ([self.componentArray containsObject:@(i)]) {
                NSInteger cIndex = [pickerView selectedRowInComponent:i];
                _resultString=[NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][cIndex]];
            }else{
                _resultString=[NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][0]];
            }
        }
    }else if (_isLevelDic){
        NSInteger cIndex = [pickerView selectedRowInComponent:0];
        NSDictionary *dicValueDic=_plistArray[cIndex];
        if([_plistName isEqualToString:@"Provineces"]){
            if (component == 0) {
                _state = [_plistArray[row] objectForKey:@"p_Name"];
                _city = nil;
            }else if (component == 1){
                if([(NSArray *)[dicValueDic objectForKey:@"Citys"] count] > row){
                    _city = [[[dicValueDic objectForKey:@"Citys"] objectAtIndex:row] objectForKey:@"C_Name"];
                }else{
                    _city = nil;
                }
            }
            if(_state && _city){
                _resultString=[NSString stringWithFormat:@"%@,%@",_state,_city];
            }else{
                _resultString = nil;
            }
        }else{
        if (component==0) {
            _state =_dicKeyArray[row][0];
        }else{
            NSArray *dicValueArray=[dicValueDic allValues][0];
            if (dicValueArray.count>row) {
                _city =dicValueArray[row];
            }
        }
        }
    }
}

-(void)remove{
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
    if (_pickerView) {
        
        if (_resultString) {
            
        }else{
            if (_isLevelString) {
                if(_uidataType == UIDataTypeModifyLimit)
                {
                    _resultString=[NSString stringWithFormat:@"%@",_plistArray[0]];
                }else
                {
                    _resultString=[NSString stringWithFormat:@"%@",_plistArray[0]];
                    _resultString=[NSString stringWithFormat:@"%@|%ld",_resultString,(long)0];
                }
            }else if (_isLevelArray){
                _resultString=@"";
                for (int i=0; i<_plistArray.count;i++) {
                    _resultString=[NSString stringWithFormat:@"%@ %@",_resultString,_plistArray[i][0]];
                }
            }else if (_isLevelDic){
                if([_plistName isEqualToString:@"Provineces"]){
                    NSDictionary *dicValueDic=_plistArray[0];
                    if (_state == nil) {
                        _state = [dicValueDic objectForKey:@"p_Name"];
                        _city = [[[dicValueDic objectForKey:@"Citys"] objectAtIndex:0] objectForKey:@"C_Name"];

                    }
                    if (_city == nil){
                        NSInteger cIndex = [_pickerView selectedRowInComponent:0];
                        dicValueDic=_plistArray[cIndex];
                        _city = [[[dicValueDic objectForKey:@"Citys"] objectAtIndex:0] objectForKey:@"C_Name"];
                    }
                }else{
                if (_state==nil) {
                    _state =_dicKeyArray[0][0];
                    NSDictionary *dicValueDic=_plistArray[0];
                    _city=[dicValueDic allValues][0][0];
                }
                if (_city==nil){
                    NSInteger cIndex = [_pickerView selectedRowInComponent:0];
                    NSDictionary *dicValueDic=_plistArray[cIndex];
                    _city=[dicValueDic allValues][0][0];
                    
                }}
                _resultString=[NSString stringWithFormat:@"%@,%@",_state,_city];
            }
        }
    }else if (_datePicker) {
        
        _resultString=[NSString stringWithFormat:@"%@",_datePicker.date];
    }
    if ([self.delegate respondsToSelector:@selector(toobarDonBtnHaveClick:resultString:)]) {
        [self.delegate toobarDonBtnHaveClick:self resultString:_resultString];
    }
    [self remove];
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
