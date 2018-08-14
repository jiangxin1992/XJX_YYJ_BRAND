//
//  YYNoDataView.m
//  Yunejian
//
//  Created by Apple on 15/8/13.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYNoDataView.h"

@interface YYNoDataView ()

@end

@implementation YYNoDataView


-(id)init{
    if (self = [super init]) {
        UILabel *label = [[UILabel alloc] init];
        self.titleLabel = label;
        label.textColor = [UIColor colorWithHex:@"919191"];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = NSLocalizedString(@"没有数据",nil);
        [self addSubview:label];
        
        __weak UIView *weakSelf = self;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(40);
            make.center.mas_equalTo(weakSelf.center);
            //make.left.mas_equalTo(weakSelf.mas_left).with.offset(100);
            //make.top.mas_equalTo(weakSelf.mas_top).with.offset(200);
        }];
    }
    return self;
}

-(id)initWithIcon:(NSString *)iconName tipRow:(NSInteger)row topValue:(NSInteger)top{
    if (self = [super init]) {
        UILabel *label = [[UILabel alloc] init];
        self.titleLabel = label;
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = NSLocalizedString(@"没有数据",nil);
        [self addSubview:label];
        
        
        
        UIImage *iconImage = [UIImage imageNamed:iconName];
        float imageWidth = iconImage.size.width;
        float imageHeight = iconImage.size.height;
        UIImageView *iconView = [[UIImageView alloc] initWithImage:iconImage];
        [self addSubview:iconView];
        
        __weak UIView *weakSelf = self;
        __block NSInteger imageSpace = 32;
        if(top > 0){
            [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.mas_equalTo(imageWidth);
                make.height.mas_equalTo(imageHeight);
                make.centerX.mas_equalTo(0);
                make.top.mas_equalTo(weakSelf.mas_top).with.offset(top);
            }];
            __weak UIView *weakIconView = iconView;
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(400);
                make.height.mas_equalTo(18);
                make.centerX.mas_equalTo(0);
                make.top.mas_equalTo(weakIconView.mas_bottom).with.offset(imageSpace);
                
            }];
        }else{
            [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(imageWidth);
                make.height.mas_equalTo(imageHeight);
                make.center.mas_equalTo(CGPointMake(weakSelf.center.x, weakSelf.center.y -imageHeight/2 - imageSpace-7));
            }];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(400);
                make.height.mas_equalTo(18);
                make.center.mas_equalTo(CGPointMake(weakSelf.center.x, weakSelf.center.y));
            }];
        }
        if(row > 0){
            self.tipLabel = [[UILabel alloc] init];
            self.tipLabel.textColor = [UIColor colorWithHex:@"919191"];
            self.tipLabel.backgroundColor = [UIColor clearColor];
            self.tipLabel.textAlignment = NSTextAlignmentCenter;
            self.tipLabel.font = [UIFont systemFontOfSize:13];
            self.tipLabel.text = @"";
            self.tipLabel.numberOfLines = 0;
            [self addSubview:self.tipLabel];
            __block NSInteger labelHeight = row;
            if(top > 0){
                __weak UIView *weaklabel = label;
                
                [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(SCREEN_WIDTH-30);
                    make.height.mas_equalTo(labelHeight);
                    make.centerX.mas_equalTo(0);
                    make.top.mas_equalTo(weaklabel.mas_bottom).with.offset(14);
                }];
            }else{
                [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(SCREEN_WIDTH-30);
                    make.height.mas_equalTo(labelHeight);
                    make.center.mas_equalTo(CGPointMake(weakSelf.center.x, weakSelf.center.y+7+14+6));
                }];
            }
        }
    }
    return self;

}
-(id)initWithIcon:(NSString *)imageNamed offsetX:(NSInteger)offsetX{
    if (self = [super init]) {
        UILabel *label = [[UILabel alloc] init];
        self.titleLabel = label;
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        //        label.backgroundColor=[UIColor redColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13];
        label.text = @"没有作品";
        label.numberOfLines=0;
        [self addSubview:label];
        
        
        self.tipLabel = [[UILabel alloc] init];
        self.tipLabel.textColor = [UIColor colorWithHex:@"919191"];
        self.tipLabel.backgroundColor = [UIColor clearColor];
        self.tipLabel.textAlignment = NSTextAlignmentCenter;
        self.tipLabel.font = [UIFont systemFontOfSize:13];
        self.tipLabel.text = @"";
        [self addSubview:self.tipLabel];
        
        UIImage *iconImage = [UIImage imageNamed:imageNamed];
        float imageWidth = iconImage.size.width;
        float imageHeight = iconImage.size.height;
        UIImageView *iconView = [[UIImageView alloc] initWithImage:iconImage];
        [self addSubview:iconView];
        
        __weak UIView *weakSelf = self;
        __block NSInteger imageSpace = 40;
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(imageWidth);
            make.height.mas_equalTo(imageHeight);
            //make.center.mas_equalTo(weakSelf.center);
            make.center.mas_equalTo(CGPointMake(weakSelf.center.x-offsetX, weakSelf.center.y -imageHeight/2 - imageSpace/2));
            
            //make.left.mas_equalTo(weakSelf.mas_left).with.offset(100);
            //make.top.mas_equalTo(weakSelf.mas_top).with.offset(200);
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(225);
            make.height.mas_equalTo(60);
            make.center.mas_equalTo(CGPointMake(weakSelf.center.x-offsetX, weakSelf.center.y+imageSpace/2+7));
            //make.left.mas_equalTo(weakSelf.mas_left).with.offset(100);
            //make.top.mas_equalTo(weakSelf.mas_top).with.offset(200);
        }];
        
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(400);
            make.height.mas_equalTo(13);
            make.center.mas_equalTo(CGPointMake(weakSelf.center.x-offsetX, weakSelf.center.y+imageSpace/2+7+14+8));
            //make.left.mas_equalTo(weakSelf.mas_left).with.offset(100);
            //make.top.mas_equalTo(weakSelf.mas_top).with.offset(200);
        }];
    }
    return self;
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self) {
        return nil;
    }else{
       return view;
    }
}

@end
