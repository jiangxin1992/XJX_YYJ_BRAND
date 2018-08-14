//
//  YYBuyerInfoAboutCell.h
//  YunejianBuyer
//
//  Created by yyj on 2017/1/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYBrandHomeInfoModel;

@interface YYBrandInfoAboutCell : UITableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithBlock:(void(^)(NSString *type, CGFloat height))block;

-(id)initWithBlock:(void(^)(NSString *type, CGFloat height))block;

+(CGFloat )getHeightWithHomeInfoModel:(YYBrandHomeInfoModel *)homePageModel;

@property (nonatomic,strong)YYBrandHomeInfoModel *homePageModel;

@property (nonatomic,assign) BOOL isHomePage;//用于无数据时文案差别

@property (nonatomic,copy) void (^cellblock)(NSString *type, CGFloat height);

@property (nonatomic, strong) UIView *retailerNameBackView;

@end
