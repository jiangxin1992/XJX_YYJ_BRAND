//
//  YYGuideHandler.m
//  YunejianBuyer
//
//  Created by Apple on 16/11/28.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYGuideHandler.h"

#import "YYGuideView.h"
#import "UserDefaultsMacro.h"

@implementation YYGuideHandler
static NSArray *guideInfoData = nil;
static dispatch_once_t onceToken;
static YYGuideView *guideView;
static UIView *dotView;
static UIImageView *newFlagView;

+(void)showGuideView:(NSInteger)type parentView:(UIView *)parentView targetView:(UIView *)targetview{
    dispatch_once(&onceToken, ^{
        //版本 类型 文本(offsetx) 方向(offsety) insert
        guideInfoData = @[@[],
                          @[@"2.6",@"dot",@"10",@"0"],
                          @[@"2.6",@"newflag",@"15",@"0"],
                          @[@"2.6",@"arrowtxt",@"发送站内信",@"0",@"-5"],
                          @[@"2.6",@"arrowtxt",@"戳这里规定黑白名单",@"1",@"5"],
                          @[@"2.6",@"dot",@"18",@"-30"]
                        ];
        guideView = [YYGuideView new];
    });
    NSArray *guideInfo = [guideInfoData objectAtIndex:type];
    NSString *guideVersionStr = [guideInfo objectAtIndex:0];
    NSString *versionStr = kYYCurrentVersion;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    __block  NSString *blockkey = [NSString stringWithFormat:@"%@_%ld",kNoLongerRemindNewFuntion,(long)type];
    if([userDefaults objectForKey:blockkey] != nil || ![versionStr isEqualToString:guideVersionStr]){
        return;
    }
    
    
    NSString *guidetype = [guideInfo objectAtIndex:1];
    if([guidetype isEqualToString:@"dot"]){
        NSInteger offsetx = [[guideInfo objectAtIndex:2] integerValue];
        NSInteger offsety = [[guideInfo objectAtIndex:3] integerValue];
        [YYGuideHandler addDotView:targetview offsetx:offsetx offsety:offsety];
    }else if([guidetype isEqualToString:@"newflag"]){
        NSInteger offsetx = [[guideInfo objectAtIndex:2] integerValue];
        NSInteger offsety = [[guideInfo objectAtIndex:3] integerValue];
        [YYGuideHandler addNewFlagView:targetview offsetx:offsetx offsety:offsety];
    }else if ([guidetype isEqualToString:@"arrowtxt"]){
        NSString *tipStr = [guideInfo objectAtIndex:2];
        NSInteger direction = [[guideInfo objectAtIndex:3] integerValue];
        NSInteger gap = [[guideInfo objectAtIndex:4] integerValue];
        [guideView showInView:parentView targetView:targetview tipStr:tipStr direction:direction gap:gap];
        [userDefaults setObject:@"true" forKey:blockkey];
        [userDefaults synchronize];
    }
}

+(void)markGuide:(NSInteger)type{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    __block  NSString *blockkey = [NSString stringWithFormat:@"%@_%ld",kNoLongerRemindNewFuntion,(long)type];
    [userDefaults setObject:@"true" forKey:blockkey];
    [userDefaults synchronize];
    
    NSArray *guideInfo = [guideInfoData objectAtIndex:type];
    NSString *guidetype = [guideInfo objectAtIndex:1];
    if([guidetype isEqualToString:@"dot"]){
        [dotView removeFromSuperview];
    }else if([guidetype isEqualToString:@"newflag"]){
        [newFlagView removeFromSuperview];
    }
}
+(void)addDotView:(UIView*)targetView offsetx:(NSInteger)offsetx offsety:(NSInteger)offsety{
    float dotSize = 7;
    if(dotView == nil){
        dotView = [[UIView alloc] init];
        dotView.layer.cornerRadius = dotSize/2;
        dotView.backgroundColor = [UIColor colorWithHex:@"ef4e31"];
        dotView.layer.masksToBounds = YES;
    }
    [targetView addSubview:dotView];
    __block UIView *blockTargetView = targetView;
    [dotView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(blockTargetView.mas_top).with.offset(-dotSize/2+offsetx);
        make.width.equalTo(@(dotSize));
        make.height.equalTo(@(dotSize));
        make.right.equalTo(blockTargetView.mas_right).with.offset((dotSize)/2+offsety);
    }];
}

+(void)addNewFlagView:(UIView*)targetView offsetx:(NSInteger)offsetx offsety:(NSInteger)offsety{
    NSInteger dotSizeW = 22;
    NSInteger dotSizeH = 18;
    if(newFlagView == nil){
        newFlagView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new_fun_flag"]];
        //22 18
    }
    [targetView addSubview:newFlagView];
    __block UIView *blockTargetView = targetView;
    [newFlagView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(blockTargetView.mas_top).with.offset(-dotSizeH/2+offsetx);
        make.width.equalTo(@(dotSizeW));
        make.height.equalTo(@(18));
        make.right.equalTo(blockTargetView.mas_right).with.offset((dotSizeW)/2+offsety);
    }];
}
@end
