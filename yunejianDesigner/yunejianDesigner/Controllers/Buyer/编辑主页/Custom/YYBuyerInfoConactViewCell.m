//
//  YYBuyerInfoConactViewCell.m
//  YunejianBuyer
//
//  Created by Apple on 16/12/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYBuyerInfoConactViewCell.h"
@interface YYBuyerInfoConactViewCell()
@property (weak, nonatomic) IBOutlet UIButton *emailLabel;
@property (weak, nonatomic) IBOutlet UIButton *mobileLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *weixinLabel;
@property (weak, nonatomic) IBOutlet UIButton *qqLabel;

@property (weak, nonatomic) IBOutlet UIButton *xinlangLabel;
@property (weak, nonatomic) IBOutlet UIButton *weixinPublicLabel;
@property (weak, nonatomic) IBOutlet UIButton *instagramLabel;
@property (weak, nonatomic) IBOutlet UIButton *facebookLabel;
@end


@implementation YYBuyerInfoConactViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self.emailLabel setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.mobileLabel setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.phoneLabel setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.weixinLabel setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.qqLabel setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];

    [self.xinlangLabel setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.weixinPublicLabel setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.instagramLabel setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.facebookLabel setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateUI{
    
    WeakSelf(ws);
    [_homeInfoModel.userContactInfos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj){
            if([obj[@"contactType"] integerValue] == 0){
                [ws.emailLabel setTitle:obj[@"contactValue"] forState:UIControlStateNormal];
            }else if ([obj[@"contactType"] integerValue] == 1){
                [ws.mobileLabel setTitle:obj[@"contactValue"] forState:UIControlStateNormal];
            }else if ([obj[@"contactType"] integerValue] == 2){
                [ws.phoneLabel setTitle:obj[@"contactValue"] forState:UIControlStateNormal];
            }else if ([obj[@"contactType"] integerValue] == 3){
                [ws.weixinLabel setTitle:obj[@"contactValue"] forState:UIControlStateNormal];
            }else if ([obj[@"contactType"] integerValue] == 4){
                [ws.qqLabel setTitle:obj[@"contactValue"] forState:UIControlStateNormal];
            }
        }
    }];
    [_homeInfoModel.userSocialInfos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(obj){
                if([obj[@"socialType"] integerValue] == 0){
                    [ws.xinlangLabel setTitle:obj[@"socialName"] forState:UIControlStateNormal];
                }else if([obj[@"socialType"] integerValue] == 1){
                    [ws.weixinPublicLabel setTitle:obj[@"socialName"] forState:UIControlStateNormal];
                }else if([obj[@"socialType"] integerValue] == 2){
                    [ws.facebookLabel setTitle:obj[@"socialName"] forState:UIControlStateNormal];
                }else if([obj[@"socialType"] integerValue] == 3){
                    [ws.instagramLabel setTitle:obj[@"socialName"] forState:UIControlStateNormal];
                }
            }
        
    }];
}

@end
