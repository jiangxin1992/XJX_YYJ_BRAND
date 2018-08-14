//
//  YYRegisterTableSubmitCell.m
//  yunejianDesigner
//
//  Created by Victor on 2017/12/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YYRegisterTableSubmitCell.h"

@interface YYRegisterTableSubmitCell()

@property (nonatomic, strong) UIButton *ruleButon;
@property (nonatomic, strong) UITextView *ruleTextView;

@end

@implementation YYRegisterTableSubmitCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        __weak typeof (self)weakSelf = self;
        
        self.ruleButon = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.ruleButon setImage:[UIImage imageNamed:@"selectCircle"] forState:UIControlStateNormal];
        [self.ruleButon setImage:[UIImage imageNamed:@"selectedCircle"] forState:UIControlStateSelected];
        [self.ruleButon addTarget:self action:@selector(agreeRuleHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.ruleButon];
        [self.ruleButon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(24);
            make.height.mas_equalTo(24);
            make.top.mas_equalTo(8);
            make.left.mas_equalTo(15);
        }];
        
        self.ruleTextView = [[UITextView alloc] init];
        self.ruleTextView.editable = NO;
        self.ruleTextView.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.ruleTextView];
        [self.ruleTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(60);
            make.top.mas_equalTo(2);
            make.left.equalTo(weakSelf.ruleButon.mas_right).with.offset(0);
            make.right.mas_equalTo(-17);
        }];
    }
    return self;
}

-(void)updateCellInfo:(YYTableViewCellInfoModel *)info{
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    YYTableViewCellInfoModel *infoModel1 = info;
    self.ruleButon.selected = [infoModel1.value isEqualToString:@"checked"];
    if([infoModel1.title isEqualToString:@"hideRuleBtn"]){
        self.ruleButon.hidden = YES;
        self.ruleTextView.hidden = YES;
    }else{
        self.ruleButon.hidden = NO;
        self.ruleTextView.hidden = NO;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"已同意服务协议和隐私协议",nil)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:[[attributedString string] rangeOfString:[attributedString string]]];
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"type://serviceAgreement"
                             range:[[attributedString string] rangeOfString:NSLocalizedString(@"服务协议",nil)]];
    
    [attributedString addAttribute:NSUnderlineStyleAttributeName
                             value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                             range:[[attributedString string] rangeOfString:NSLocalizedString(@"服务协议",nil)]];
    
    
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"type://secrecyAgreement"
                             range:[[attributedString string] rangeOfString:NSLocalizedString(@"隐私协议",nil)]];
    
    [attributedString addAttribute:NSUnderlineStyleAttributeName
                             value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                             range:[[attributedString string] rangeOfString:NSLocalizedString(@"隐私协议",nil)]];
    
    NSDictionary *linkAttributes = @{NSForegroundColorAttributeName: _define_black_color,
                                     NSUnderlineColorAttributeName: _define_black_color,
                                     NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)};
    
    // assume that textView is a UITextView previously created (either by code or Interface Builder)
    self.ruleTextView.linkTextAttributes = linkAttributes; // customizes the appearance of links
    self.ruleTextView.attributedText = attributedString;
    self.ruleTextView.delegate = self;
    self.ruleTextView.scrollEnabled = NO;
}

#pragma mark - --------------系统代理----------------------
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([[URL scheme] isEqualToString:@"type"]) {
        NSString *type = [URL host];
        // do something with this username
        // ...
        [self ruleTxtBtnHandler:type];
        return NO;
    }
    return YES; // let the system open this URL
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    return;
    CGPoint point = scrollView.contentOffset;
    CGFloat contentHeight = scrollView.contentSize.height;
    CGFloat frameHeight   = scrollView.frame.size.height;
    
    if(point.y < 0){
        [scrollView setContentOffset:CGPointMake(point.x, 0) animated:NO];
    }else if(contentHeight > frameHeight){
        
        if(contentHeight - point.y < frameHeight){
            [scrollView setContentOffset:CGPointMake(point.x, contentHeight - frameHeight) animated:NO];
        }
        
    }else if(contentHeight <= frameHeight){
        [scrollView setContentOffset:CGPointMake(point.x, 0) animated:NO];
    }
    
}

#pragma mark - --------------自定义响应----------------------
- (void)ruleTxtBtnHandler:(NSString *)type {
    if([type isEqualToString:@"serviceAgreement"])
    {
        if(_block){
            _block(@"serviceAgreement");
        }
    }else if([type isEqualToString:@"secrecyAgreement"])
    {
        if(_block){
            _block(@"secrecyAgreement");
        }
    }
}

- (void)agreeRuleHandler:(id)sender {
    if(self.delegate == nil){
        return;
    }
    NSString *btnStatus = nil;
    if(self.ruleButon.selected == NO){
        btnStatus = @"checked";
    }else{
        btnStatus = @"";
    }
    [self.delegate selectClick:_indexPath.row AndSection:_indexPath.section andParmas:@[btnStatus,@(0),@(1)]];
}

@end
