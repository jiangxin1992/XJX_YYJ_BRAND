//
//  YYBuyerModifyCellDetailAddressViewCell.m
//  YunejianBuyer
//
//  Created by Apple on 16/12/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYBuyerModifyCellDetailAddressViewCell.h"
#import "YYBuyerHomeUpdateModel.h"

@implementation YYBuyerModifyCellDetailAddressViewCell
#pragma mark - update
-(void)updateUI{
    _maxLength = 300;
    
    YYBuyerHomeUpdateModel *model = [YYBuyerHomeUpdateModel createUploadCertModel:@[_value]];
    if(![NSString isNilOrEmpty:model.addressDetail])
    {
        _addressInputText.attributedText = [self getParagraphWithStr:model.addressDetail];
    }else
    {
        _addressInputText.attributedText = [self getParagraphWithStr:@""];
    }
    _addressInputText.keyboardType = UIKeyboardTypeDefault;
    _addressInputText.delegate = self;
    [self updateLimitTip];
    [_addressInputText becomeFirstResponder];
}

-(void)updateLimitTip{
    NSInteger limitValue = 0;
    if(_maxLength > _addressInputText.text.length){
        limitValue = _maxLength - _addressInputText.text.length;
    }
    
    //    NSString *numStr = [NSString stringWithFormat:@"%ld",(long)limitValue];
    //    NSString *limitLabelStr = [NSString stringWithFormat:NSLocalizedString(@"还可输入 %@ 字",nil),numStr];
    
    //    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString: limitLabelStr];
    //    [attributedStr addAttribute: NSFontAttributeName value: [UIFont boldSystemFontOfSize:15] range: NSMakeRange(5,numStr.length)];
    //    _limitLabel.attributedText=attributedStr;
    if(limitValue == _maxLength){
        //_introduceInputText.text = infoModel.tipStr;
        // infoModel.value = @"";
    }else{
        //_inputText.placeholder = @"";
    }
}
#pragma mark - textFiled
-(void)textFiledEditChanged:(NSNotification *)obj{
    NSString *toBeString = _addressInputText.text;
    NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [_addressInputText markedTextRange];
        //高亮部分
        UITextPosition *position = [_addressInputText positionFromPosition:selectedRange.start offset:0];
        //已输入的文字进行字数统计和限制
//        if (!position) {
//            if (toBeString.length > self.maxLength) {
//                _addressInputText.attributedText = [self getParagraphWithStr:[toBeString substringToIndex:self.maxLength]];
//            }else
//            {
//                _addressInputText.attributedText = [self getParagraphWithStr:_addressInputText.text];
//            }
//        }else
//        {
//            _addressInputText.attributedText = [self getParagraphWithStr:_addressInputText.text];
//        }
        if (!position) {
            if (toBeString.length > self.maxLength) {
                _addressInputText.attributedText = [self getParagraphWithStr:[toBeString substringToIndex:self.maxLength]];
            }
        }else
        {
            return;
        }
    }
    else{
//        if (toBeString.length > self.maxLength) {
//            _addressInputText.attributedText = [self getParagraphWithStr:[toBeString substringToIndex:self.maxLength]];
//        }else
//        {
//            _addressInputText.attributedText = [self getParagraphWithStr:_addressInputText.text];
//        }
        if (toBeString.length > self.maxLength) {
            _addressInputText.attributedText = [self getParagraphWithStr:[toBeString substringToIndex:self.maxLength]];
        }
    }
    
    [self updateLimitTip];
    //[self.delegate selectClick:_indexPath.row AndSection:_indexPath.section andParmas:@[_introduceInputText.text,@(0)]];
    NSString *value = [NSString stringWithFormat:@"addressDetail=%@",_addressInputText.text];
    [self.delegate btnClick:0 section:0 andParmas:@[@"modify",value]];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    YYBuyerHomeUpdateModel *model = [YYBuyerHomeUpdateModel createUploadCertModel:@[_value]];
    if([NSString isNilOrEmpty:model.addressDetail]){
        _addressInputText.attributedText = [self getParagraphWithStr:@""];
    }
}

#pragma mark - Other
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextViewTextDidChangeNotification"
                                              object:_addressInputText];
}
-(NSAttributedString *)getParagraphWithStr:(NSString *)str
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    return [[NSAttributedString alloc] initWithString:str attributes:attributes];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UITextViewTextDidChangeNotification"
                                                  object:_addressInputText];
}
@end
