//
//  YYBuyerModifyCellDescViewCell.m
//  YunejianBuyer
//
//  Created by Apple on 16/12/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYBuyerModifyCellDescViewCell.h"
#import "YYBuyerHomeUpdateModel.h"
@implementation YYBuyerModifyCellDescViewCell

#pragma mark - update
-(void)updateLimitTip{
    NSInteger limitValue = 0;
    if(_maxLength > _descInputText.text.length){
        limitValue = _maxLength - _descInputText.text.length;
    }
    
    NSString *numStr = [NSString stringWithFormat:@"%ld",(long)limitValue];
    NSString *limitLabelStr = [NSString stringWithFormat:NSLocalizedString(@"还可输入 %@ 字",nil),numStr];
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString: limitLabelStr];
    if([LanguageManager isEnglishLanguage]){
        [attributedStr addAttribute: NSFontAttributeName value: [UIFont boldSystemFontOfSize:15] range: NSMakeRange(0,numStr.length)];
    }else{
        [attributedStr addAttribute: NSFontAttributeName value: [UIFont boldSystemFontOfSize:15] range: NSMakeRange(5,numStr.length)];
    }
    _limitLabel.attributedText=attributedStr;
    if(limitValue == _maxLength){
    }else{
    }
}
-(void)updateUI{
    _maxLength = 500;
    YYBuyerHomeUpdateModel *model = [YYBuyerHomeUpdateModel createUploadCertModel:@[_value]];
    if(![NSString isNilOrEmpty:model.introduction])
    {
        _descInputText.attributedText = [self getParagraphWithStr:model.introduction];
    }else
    {
        _descInputText.attributedText = [self getParagraphWithStr:@""];
    }
    _descInputText.keyboardType = UIKeyboardTypeDefault;
    _descInputText.delegate = self;
    [self updateLimitTip];
    
    [_descInputText becomeFirstResponder];
}
#pragma mark - textFiled
-(void)textFiledEditChanged:(NSNotification *)obj{
    NSString *toBeString = _descInputText.text;
    NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [_descInputText markedTextRange];
        //高亮部分
        UITextPosition *position = [_descInputText positionFromPosition:selectedRange.start offset:0];
        //已输入的文字进行字数统计和限制
//        if (!position) {
//            if (toBeString.length > self.maxLength) {
//                _descInputText.attributedText = [self getParagraphWithStr:[toBeString substringToIndex:self.maxLength]];
//            }else
//            {
//                _descInputText.attributedText = [self getParagraphWithStr:_descInputText.text];
//            }
//        }else
//        {
//            _descInputText.attributedText = [self getParagraphWithStr:_descInputText.text];
//        }
        if (!position) {
            if (toBeString.length > self.maxLength) {
                _descInputText.attributedText = [self getParagraphWithStr:[toBeString substringToIndex:self.maxLength]];
            }
        }else
        {
            return;
        }
        
    }else{
//        if (toBeString.length > self.maxLength) {
//            _descInputText.attributedText = [self getParagraphWithStr:[toBeString substringToIndex:self.maxLength]];
//        }else
//        {
//            _descInputText.attributedText = [self getParagraphWithStr:_descInputText.text];
//        }
        if (toBeString.length > self.maxLength) {
            _descInputText.attributedText = [self getParagraphWithStr:[toBeString substringToIndex:self.maxLength]];
        }
    }
    
    [self updateLimitTip];
    //[self.delegate selectClick:_indexPath.row AndSection:_indexPath.section andParmas:@[_introduceInputText.text,@(0)]];
    NSString *value = [NSString stringWithFormat:@"introduction=%@",_descInputText.text];
    [self.delegate btnClick:0 section:0 andParmas:@[@"modify",value]];
}



- (void)textViewDidBeginEditing:(UITextView *)textView{
    YYBuyerHomeUpdateModel *model = [YYBuyerHomeUpdateModel createUploadCertModel:@[_value]];
    if([NSString isNilOrEmpty:model.introduction]){
        _descInputText.attributedText = [self getParagraphWithStr:@""];
    }
}


#pragma mark - Other

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextViewTextDidChangeNotification"
                                              object:_descInputText];
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
                                                  object:_descInputText];
}

@end
