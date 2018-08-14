//
//  YYShowroomBrandTool.m
//  yunejianDesigner
//
//  Created by yyj on 2017/3/7.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YYShowroomBrandTool.h"

@implementation YYShowroomBrandTool

+(NSInteger )getValueNumWithPinyinDict:(NSDictionary *)_dictPinyinAndChinese
{
    __block NSInteger valueNum =0;
    NSArray *keyArr = [_dictPinyinAndChinese allKeys];
    [keyArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *temp = [_dictPinyinAndChinese objectForKey:obj];
        if(temp.count)
        {
            valueNum++;
        }
    }];
    return valueNum;
}

+(NSArray *)getCharArr{
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    for (int i = 0; i < 26; i++) {
        NSString *str = [NSString stringWithFormat:@"%c", 'A' + i];
        [arr addObject:str];
    }
    [arr addObject:@"#"];
    return [arr copy];
}

+(UIView *)getViewForHeaderInSection:(NSInteger)section WithPinyinDict:(NSDictionary *)_dictPinyinAndChinese
{
    
    
    NSArray *_arrayChar = [YYShowroomBrandTool getCharArr];
    NSString *title = [_arrayChar objectAtIndex:section];
    if([_dictPinyinAndChinese objectForKey:title])
    {
        id vaule = [_dictPinyinAndChinese objectForKey:title];
        if([vaule isKindOfClass:[NSMutableArray class]])
        {
            NSMutableArray *keyArr = (NSMutableArray *)vaule;
            if(keyArr.count)
            {
                UIView *view = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"efefef"]];
                view.frame=CGRectMake(0, 0, SCREEN_WIDTH, 15);
                
                UILabel *titleLabel = [UILabel getLabelWithAlignment:0 WithTitle:[_arrayChar objectAtIndex:section] WithFont:14.0f WithTextColor:[UIColor colorWithHex:@"919191"] WithSpacing:0];
                [view addSubview:titleLabel];
                [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(15);
                    make.centerY.mas_equalTo(titleLabel.superview);
                    make.right.mas_equalTo(-15);
                }];
                
                return view;
            }
        }
    }
    
    UIView *view = [UIView getCustomViewWithColor:_define_white_color];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.01);
    return view;
}

+(CGFloat )heightForHeaderInSection:(NSInteger)section WithPinyinDict:(NSDictionary *)_dictPinyinAndChinese
{
    NSArray *_arrayChar = [YYShowroomBrandTool getCharArr];
    NSString *title = [_arrayChar objectAtIndex:section];
    if([_dictPinyinAndChinese objectForKey:title])
    {
        id vaule = [_dictPinyinAndChinese objectForKey:title];
        if([vaule isKindOfClass:[NSMutableArray class]])
        {
            NSMutableArray *keyArr = (NSMutableArray *)vaule;
            if(keyArr.count)
            {
                return 15;
            }
        }
    }
    return 0.01;
}
@end
