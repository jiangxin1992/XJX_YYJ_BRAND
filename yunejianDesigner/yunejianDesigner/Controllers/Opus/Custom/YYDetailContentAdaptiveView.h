//
//  YYDetailContentAdaptiveView.h
//  YunejianBuyer
//
//  Created by yyj on 2017/7/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYDetailContentAdaptiveView : UIView

-(instancetype)initWithKey:(NSString *)key Value:(NSString *)value IsValueLineNum:(NSInteger )lineNum;

@property (nonatomic,strong) NSString *key;
@property (nonatomic,strong) NSString *value;
@property (nonatomic,assign) NSInteger lineNum;
-(void)updateUI;
@end
