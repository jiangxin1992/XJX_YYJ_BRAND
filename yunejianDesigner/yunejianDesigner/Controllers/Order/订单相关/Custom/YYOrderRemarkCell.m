//
//  YYOrderRemarkCell.m
//  Yunejian
//
//  Created by yyj on 15/8/20.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYOrderRemarkCell.h"

#import "YYUser.h"
#import "YYStylesAndTotalPriceModel.h"

@interface YYOrderRemarkCell ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *styleRemarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *billCreatePersonNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *occasionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *valueLabelTrailing;


@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (assign,nonatomic) Boolean hasAddNotification;
@end

@implementation YYOrderRemarkCell

static NSInteger maxLength = 150;
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UITextViewTextDidChangeNotification"
                                                  object:self.textView];
}

- (void)updateUI{
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.textView.delegate = self;
    if(!_hasAddNotification){
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextViewTextDidChangeNotification"
                                              object:self.textView];
        _hasAddNotification =YES;
    }

    
    
    if (_currentYYOrderInfoModel) {
        
        if (!_currentYYOrderInfoModel.billCreatePersonId) {
            //[_firstButton setTitle:user.name forState:UIControlStateNormal];
            //_currentYYOrderInfoModel.billCreatePersonName = user.name;
            
           // NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
           // [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            
            //NSNumber *tempBillCreatePersonId = [numberFormatter numberFromString:user.userId];
            //_currentYYOrderInfoModel.billCreatePersonId = tempBillCreatePersonId;
            
        }else{
            NSString *name = @"";
            if (_currentYYOrderInfoModel.billCreatePersonName) {
                name = _currentYYOrderInfoModel.billCreatePersonName;
            }
            _billCreatePersonNameLabel.text = name;
        }
//
        if (_currentYYOrderInfoModel.occasion
            && [_currentYYOrderInfoModel.occasion length] > 0) {
            _occasionLabel.text = _currentYYOrderInfoModel.occasion;
        }else{
            _occasionLabel.text = @"";
        }
//

        
        if (_currentYYOrderInfoModel.orderDescription
            && [_currentYYOrderInfoModel.orderDescription length] > 0) {
            _textView.text = _currentYYOrderInfoModel.orderDescription;
            _tipsLabel.hidden = YES;
        }else{
            _tipsLabel.hidden = NO;
        }
        NSInteger hasRemarkNum = 0;
        for (YYOrderOneInfoModel *oneInfoModel in _currentYYOrderInfoModel.groups) {
            for (YYOrderStyleModel *styleModel  in oneInfoModel.styles) {
                if(![NSString isNilOrEmpty:styleModel.remark]){
                    hasRemarkNum++;
                }
            }
        }
        
        _styleRemarkLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%ld款已备注",nil),(long)hasRemarkNum];
    }
}



- (IBAction)firstButtonClicked:(id)sender{
    if (self.buyerButtonClicked) {
        self.buyerButtonClicked(sender);
    }
}

- (IBAction)secondButtonClicked:(id)sender{
    if (self.orderSituationButtonClicked) {
        self.orderSituationButtonClicked(sender);
    }
}

- (IBAction)styleRemarkButtonClicked:(id)sender {
    if(self.remarkButtonClicked){
        self.remarkButtonClicked();
    }
}


//- (IBAction)discountButtonClicked:(id)sender{
//    if (self.discountButtonClicked) {
//        self.discountButtonClicked();
//    }
//}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (self.textViewIsEditCallback) {
        self.textViewIsEditCallback(YES);
    }
    _tipsLabel.hidden = YES;
}


- (void)textViewDidEndEditing:(UITextView *)textView{
    if (self.textViewIsEditCallback) {
        self.textViewIsEditCallback(NO);
    }
    
    if (textView.text
        && [textView.text length] > 0) {
        _currentYYOrderInfoModel.orderDescription = textView.text;
    }else{
        _tipsLabel.hidden = NO;
    }
}

-(void)textFiledEditChanged:(NSNotification *)obj{
    NSString *toBeString = _textView.text;
    NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [_textView markedTextRange];
        //高亮部分
        UITextPosition *position = [_textView positionFromPosition:selectedRange.start offset:0];
        //已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > maxLength) {
                _textView.text = [toBeString substringToIndex:maxLength];
            }
            
        }
    }
    else{
        if (toBeString.length > maxLength) {
            _textView.text = [toBeString substringToIndex:maxLength];
        }
    }
}
- (void)setOneState:(BOOL )oneState{
    _salesBtn.hidden=oneState;
    if(oneState){
        _billCreatePersonNameLabel.textColor = [UIColor colorWithHex:@"919191"];
        _valueLabelTrailing.constant = 13;
    }else{
        _billCreatePersonNameLabel.textColor = _define_black_color;
        _valueLabelTrailing.constant = 37;
    }
}

@end
