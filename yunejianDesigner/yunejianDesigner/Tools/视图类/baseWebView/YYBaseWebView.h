//
//  YYBaseWebView.h
//  yunejianDesigner
//
//  Created by Apple on 16/8/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface YYBaseWebView : UIWebView
@property (nonatomic, copy) NSString *urlString;
- (instancetype)initWithFrame:(CGRect)frame urlString:(NSString *)urlString;
@property(nonatomic,strong) SelectedValue jumpPageSuccess;
@end
