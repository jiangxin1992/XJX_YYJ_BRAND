//
//  YYShoppingStyleSizeInputView.m
//  YunejianBuyer
//
//  Created by Apple on 16/2/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYShoppingStyleSizeInputView.h"

@interface YYShoppingStyleSizeInputView()

@property (nonatomic,strong) UITextField *numInput;
@property (nonatomic,strong) UIButton *reduceBtn;
@property (nonatomic,strong) UIButton *addBtn;

@property (nonatomic, assign) BOOL needDelegate;

@end

@implementation YYShoppingStyleSizeInputView{
    
    UIView *_bgView;
}


#pragma mark - INIT
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self UIConfig];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self UIConfig];
    }
    return self;
}

- (void)setValue:(NSInteger)value {
    self.numInput.text = [NSString stringWithFormat:@"%ld", value];
    if (self.minCount == self.maxCount) {
        self.numInput.text = [NSString stringWithFormat:@"%ld", self.minCount];
        self.reduceBtn.enabled = NO;
        self.addBtn.enabled = NO;
        _bgView.backgroundColor = [UIColor colorWithHex:@"f8f8f8"];
        _bgView.layer.borderWidth = 0;
        self.numInput.textColor = [UIColor colorWithHex:@"d3d3d3"];
        self.numInput.enabled = NO;
    } else {
        if (value <= self.minCount) {
            self.numInput.text = [NSString stringWithFormat:@"%ld", self.minCount];
            self.reduceBtn.enabled = NO;
            self.addBtn.enabled = YES;
        } else if (value >= self.maxCount) {
            self.numInput.text = [NSString stringWithFormat:@"%ld", self.maxCount];
            self.addBtn.enabled = NO;
            self.reduceBtn.enabled = YES;
        } else {
            self.addBtn.enabled = YES;
            self.reduceBtn.enabled = YES;
        }
        _bgView.backgroundColor = _define_white_color;
        _bgView.layer.borderWidth = 1;
        self.numInput.textColor = _define_black_color;
        self.numInput.enabled = YES;
    }
    [self textFieldDidChange:nil];
}

- (NSInteger)value {
    return [self.numInput.text integerValue];
}

#pragma mark - UIConfig
-(void)UIConfig{
    self.minCount = 0;
    self.maxCount = LONG_MAX;
    [self CreateContentSubViews];
}
-(void)CreateContentSubViews{
    __weak UIView *weakContainer = self;
    
    if(_sizeNameLabel == nil){
        _sizeNameLabel = [[UILabel alloc] init];
        _sizeNameLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_sizeNameLabel];
        [_sizeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakContainer.mas_top);
            make.left.mas_equalTo(weakContainer.mas_left);
            make.bottom.mas_equalTo(weakContainer.mas_bottom);
            make.width.mas_equalTo(@(65));
            
        }];
    }
    
    if(_bgView == nil){
        _bgView = [[UIView alloc] init];
        _bgView.layer.cornerRadius = 2.5;
        _bgView.layer.borderWidth = 1;
        _bgView.layer.borderColor = [UIColor colorWithHex:@"d3d3d3"].CGColor;
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakContainer.mas_top);
            make.left.mas_equalTo(@(65));
            make.bottom.mas_equalTo(weakContainer.mas_bottom);
            make.right.mas_equalTo(weakContainer.mas_right);
        }];
    }
    __weak UIView *weakBgView = _bgView;
    
    if(_reduceBtn == nil){
        _reduceBtn = [[UIButton alloc] init];
        [_reduceBtn setImage:[UIImage imageNamed:@"reducenum_icon"] forState:UIControlStateNormal];
        [_reduceBtn setImage:[UIImage imageNamed:@"reducenum_invalid_icon"] forState:UIControlStateDisabled];
        
        [_reduceBtn addTarget:self action:@selector(reduceBtnHandler) forControlEvents:UIControlEventTouchUpInside];
        [weakBgView addSubview:_reduceBtn];
        [_reduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(@(0));
            make.width.mas_equalTo(@(38));
            make.height.mas_equalTo(@(44));
            make.centerY.mas_equalTo(@(0));
        }];
    }
    
    if(_addBtn == nil){
        _addBtn = [[UIButton alloc] init];
        [_addBtn setImage:[UIImage imageNamed:@"addnum_icon"] forState:UIControlStateNormal];
        [_addBtn setImage:[UIImage imageNamed:@"addnum_invalid_icon"] forState:UIControlStateDisabled];
        [_addBtn addTarget:self action:@selector(addBtnHandler) forControlEvents:UIControlEventTouchUpInside];
        
        [weakBgView addSubview:_addBtn];
        [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(@(0));
            make.width.mas_equalTo(@(38));
            make.height.mas_equalTo(@(44));
            make.centerY.mas_equalTo(@(0));
        }];
    }
    
    if(_numInput == nil){
        _numInput = [[UITextField alloc] init];
        _numInput.font = [UIFont systemFontOfSize:13.0f];
        _numInput.delegate = self;
        _numInput.keyboardType = UIKeyboardTypeNumberPad;
        _numInput.textAlignment = NSTextAlignmentCenter;
        [weakBgView addSubview:_numInput];
        [_numInput mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakBgView.mas_top);
            make.left.mas_equalTo(@(38));
            make.bottom.mas_equalTo(weakBgView.mas_bottom);
            make.right.mas_equalTo(@(-38));
        }];
    }
}
#pragma mark - SomeAction
- (void)reduceBtnHandler{
    NSInteger value = [_numInput.text integerValue];
    value -- ;
    self.needDelegate = YES;
    self.value = value;
}

- (void)addBtnHandler{
    NSInteger value = [_numInput.text integerValue];
    value ++ ;
    self.needDelegate = YES;
    self.value = value;
}

#pragma mark - updateUI
-(void)updateUI{
    
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string {
    NSCharacterSet* cs = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [filtered isEqualToString:@""];
    if(basicTest) {
        return YES;
    }
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([NSString isNilOrEmpty:self.numInput.text]) {
        self.value = self.minCount;
    } else {
        if (self.textFieldDidEndEditingBlock) {
            self.textFieldDidEndEditingBlock(self);
        }
        self.needDelegate = YES;
        self.value = self.value;
    }
}

- (void)textFieldDidChange:(NSNotification *)note {
    if(self.delegate && self.needDelegate){
        [self.delegate btnClick:_index section:0 andParmas:@[_numInput.text]];
        self.needDelegate = NO;
    }
}



@end
