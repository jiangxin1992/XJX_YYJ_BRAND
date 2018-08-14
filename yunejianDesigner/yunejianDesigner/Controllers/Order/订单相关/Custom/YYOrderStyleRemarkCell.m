//
//  YYOrderStyleRemarkCell.m
//  yunejianDesigner
//
//  Created by Apple on 16/8/16.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYOrderStyleRemarkCell.h"

@implementation YYOrderStyleRemarkCell

static NSInteger maxLength;

- (void)awakeFromNib {
    [super awakeFromNib];
    _contentBgView.layer.borderWidth=1;
    _contentBgView.layer.borderColor = [UIColor colorWithHex:@"efefef"].CGColor;
    _contentBgView.layer.cornerRadius = 3;
    _addRemarkInput.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:_addRemarkInput];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboradAppear:)
                                                name:@"keyboradAppear"
                                              object:nil];
}
-(void)keyboradAppear:(NSNotification *)not{
    NSDictionary *userinfo = not.userInfo;
    if(userinfo){
        if([[userinfo objectForKey:@"row"] integerValue]==_indexPath.row&&[[userinfo objectForKey:@"section"] integerValue]==_indexPath.section){
            [_addRemarkInput becomeFirstResponder];
        }
    }
}
#pragma mark - updateUI
-(void)updateUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    maxLength = 150;
    NSString *imageRelativePath = _orderStyleModel.albumImg;
    sd_downloadWebImageWithRelativePath(NO, imageRelativePath, _styleImageView, kStyleCover, 0);
    _styleNameLabel.text = _orderStyleModel.name;
    NSString *remark = _orderStyleModel.tmpRemark;
    _remarkFlagView.hidden = YES;
    _remarkContentLabel.hidden = YES;
    _addRemarkInput.hidden = YES;
    if([NSString isNilOrEmpty:remark]){
        _addRemarkInput.hidden = NO;
        if(![NSString isNilOrEmpty:_remarkTip]){
            _addRemarkInput.text = _remarkTip;
        }else{
            _addRemarkInput.text = nil;
        }
        _remarkTip = @"";
    }else{
      _remarkFlagView.hidden = NO;
      _remarkContentLabel.hidden = NO;
      _remarkContentLabel.text = remark;
    }
    
    _remarkFlagView.layer.cornerRadius = 2;
    _remarkFlagView.layer.masksToBounds = YES;

}
#pragma mark - SomeAction
+(float)cellHeight:(NSString*)remark{
    if([NSString isNilOrEmpty:remark]){
        return 104;
    }else{
        float cellWidth = SCREEN_WIDTH - 34 - 35;
        float txtHeight = getTxtHeight(cellWidth,remark,@{NSFontAttributeName:[UIFont systemFontOfSize:13]});
        return 66+30 +txtHeight+1;
    }
}
- (IBAction)editRemarkHandler:(id)sender {
    if(self.delegate){
        _remarkTip = _remarkContentLabel.text;
        [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:@[@"editremark"]];
    }
}
#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        NSString *str =textField.text;
        if(self.delegate){
            [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:@[@"addremark",str]];
            [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:@[@"refresh"]];
        }
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}

-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        //已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > maxLength) {
                textField.text = [toBeString substringToIndex:maxLength];
            }
            
        }
    }
    else{
        if (toBeString.length > maxLength) {
            textField.text = [toBeString substringToIndex:maxLength];
        }
    }
    
    NSString *str =textField.text;
    if(self.delegate){
        [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:@[@"addremark",str]];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField == _addRemarkInput){
        WeakSelf(ws);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *str = textField.text;
            if(self.delegate){
                [self.delegate btnClick:ws.indexPath.row section:ws.indexPath.section andParmas:@[@"addremark",str]];
                [self.delegate btnClick:ws.indexPath.row section:ws.indexPath.section andParmas:@[@"refresh"]];
            }
        });
    }
}

#pragma mark - other
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UITextFieldTextDidChangeNotification"
                                                  object:_addRemarkInput];
    
}

@end
