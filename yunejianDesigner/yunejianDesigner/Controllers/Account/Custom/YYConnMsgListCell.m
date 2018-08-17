//
//  YYConnMsgListCell.m
//  Yunejian
//
//  Created by Apple on 15/12/2.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "YYConnMsgListCell.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图
#import "SCGIFImageView.h"

// 接口

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYUser.h"
#import "YYOrderMessageInfoModel.h"

@interface YYConnMsgListCell()

@property (weak, nonatomic) IBOutlet SCGIFImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *readFlagView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelLayoutTopConstraint;

@end

@implementation YYConnMsgListCell

-(void)updateUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    YYUser *user = [YYUser currentUser];
    _tipLabel.adjustsFontSizeToFitWidth = YES;
    
    self.userImageView.layer.borderColor = [UIColor colorWithHex:kDefaultImageColor].CGColor;
    self.userImageView.layer.borderWidth = 2;
    self.userImageView.layer.cornerRadius = 25;
    self.userImageView.layer.masksToBounds = YES;

    _readFlagView.layer.borderColor = [UIColor whiteColor].CGColor;
    _readFlagView.layer.borderWidth = 2;
    _readFlagView.layer.cornerRadius = CGRectGetWidth(_readFlagView.frame)/2;
    _readFlagView.layer.masksToBounds = YES;
    
    if(_msgInfoModel && _msgInfoModel.msgContent){
        if(user.userType == kBuyerStorUserType){
            sd_downloadWebImageWithRelativePath(NO, _msgInfoModel.msgContent.designerBrandLogo, self.userImageView, kLogoCover, 0);
        }else {
            sd_downloadWebImageWithRelativePath(NO, _msgInfoModel.msgContent.buyerLogo, self.userImageView, kLogoCover, 0);
        }
    }else{
        sd_downloadWebImageWithRelativePath(NO, @"", self.userImageView, kLogoCover, 0);
    }

    if(_msgInfoModel.isRead == NO){
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.textColor = [UIColor blackColor];
        _readFlagView.hidden = NO;
     }else{
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor colorWithHex:kDefaultTitleColor_phone];
        _readFlagView.hidden = YES;
    }

    _emailLabel.text = @"";
    if(_msgInfoModel.isPlainMsg == NO){
        if([_msgInfoModel.dealStatus integerValue] == -1){
            _agreeBtn.hidden = NO;
            _tipLabel.hidden = YES;
        }else{
            _agreeBtn.hidden = YES;
            if([_msgInfoModel.msgType integerValue]== 0){//case 1: //合作分享消息
                _tipLabel.hidden = NO;
                if([_msgInfoModel.dealStatus integerValue]== 1){
                    _tipLabel.text = NSLocalizedString(@"已同意",nil);
                }else if([_msgInfoModel.dealStatus integerValue]== 2){
                    _tipLabel.text = NSLocalizedString(@"已拒绝",nil);
                }else if([_msgInfoModel.dealStatus integerValue]== 4){
                    _tipLabel.text = NSLocalizedString(@"对方已撤销邀请",nil);
                }
            }else{
                _tipLabel.hidden = YES;
            }
        }
    }else{
        _agreeBtn.hidden = YES;
        _tipLabel.hidden = YES;
        
    }
    
    NSString *msgTitleStr = nil;
    //用户类型 0:设计师 1:买手店 2:销售代表
    if(user.userType == 0 ||user.userType ==2 )
    {
        //0:设计师 1:买手店
        if(![NSString isNilOrEmpty:_msgInfoModel.msgContent.buyerName])
        {
            //同意 移除 拒绝
            msgTitleStr = [_msgInfoModel.msgTitle stringByReplacingOccurrencesOfString:_msgInfoModel.msgContent.buyerName withString:@""];
            msgTitleStr = [msgTitleStr stringByReplacingOccurrencesOfString:@"品牌" withString:@""];
        }else
        {
            msgTitleStr = _msgInfoModel.msgTitle;
        }
        
    }else
    {
        //2:销售代表
        if(![NSString isNilOrEmpty:_msgInfoModel.msgContent.designerBrandName])
        {
            msgTitleStr = [_msgInfoModel.msgTitle stringByReplacingOccurrencesOfString:_msgInfoModel.msgContent.designerBrandName withString:@""];
            msgTitleStr = [msgTitleStr stringByReplacingOccurrencesOfString:@"品牌" withString:@""];
        }else
        {
            msgTitleStr = _msgInfoModel.msgTitle;
        }
    }
    NSString *endMsgTitleStr = nil;
    NSString *temp1 = [msgTitleStr substringToIndex:1];
    NSString *temp2 = [msgTitleStr substringToIndex:2];
    NSString *temp3 = [msgTitleStr substringToIndex:3];
    NSString *temp11 = [msgTitleStr substringFromIndex:1];
    NSString *temp22 = [msgTitleStr substringFromIndex:2];
    NSString *temp33 = [msgTitleStr substringFromIndex:3];
    if([temp3 isEqualToString:@"   "]){
        endMsgTitleStr = temp33;
    }else if([temp2 isEqualToString:@"  "]){
        endMsgTitleStr = temp22;
    }else if([temp1 isEqualToString:@" "]){
        endMsgTitleStr = temp11;
    }else{
        endMsgTitleStr = msgTitleStr;
    }
    endMsgTitleStr = [endMsgTitleStr capitalizedString];
    _emailLabel.attributedText = [self getTextAttributedString:endMsgTitleStr replaceStrs:@[
                                                                                            [LanguageManager isEnglishLanguage]?@"Accepted":NSLocalizedString(@"同意",nil)
                                                                                            ,[LanguageManager isEnglishLanguage]?@"Rejected":NSLocalizedString(@"拒绝",nil)
                                                                                            ,[LanguageManager isEnglishLanguage]?@"Disconnected":NSLocalizedString(@"解除",nil)
                                                                                            ] replaceColors:@[@"58c776",@"ef4e31",@"ef4e31"]
                                  ];
    _titleLabel.text = _msgInfoModel.msgContent.buyerName;
}

-(NSMutableAttributedString *)getTextAttributedString:(NSString *)targetStr replaceStrs:(NSArray *)replaceStrs replaceColors:(NSArray *)replaceColors{
    targetStr = [targetStr stringByReplacingOccurrencesOfString:NSLocalizedString(@"品牌",nil) withString:@""];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString: targetStr];
    NSInteger index =0;
    for (NSString *replaceStr in replaceStrs) {
        NSRange range = [targetStr rangeOfString:replaceStr];
        if (range.location != NSNotFound) {
            [attributedStr addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithHex:[replaceColors objectAtIndex:index]] range:range];
        }
        index++;
    }
    return attributedStr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)agressBtnHandler:(id)sender {
    if(self.delegate){
        [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:@[@(1)]];
    }
}

@end
