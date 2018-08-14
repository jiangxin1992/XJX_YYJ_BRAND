//
//  YYDesignerInfoSeriesView.h
//  YunejianBuyer
//
//  Created by yyj on 2017/2/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYBrandInfoSeriesCell : UITableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithBlock:(void(^)(NSString *type, NSInteger idx))block;

+(CGFloat )getHeightWithHomeSeriesArray:(NSMutableArray *)seriesArray;

@property (nonatomic,copy) void (^cellblock)(NSString *type, NSInteger idx);

@property (nonatomic,strong) NSMutableArray *seriesArray;

@property (nonatomic,assign) BOOL isHomePage;//用于无数据时文案差别

@property (nonatomic, strong) UIView *lastView;
@end
