//
//  YYBuyerInfoContactCell.h
//  YunejianBuyer
//
//  Created by yyj on 2017/1/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYBrandHomeInfoModel;
@class YYTypeButton;

@interface YYBrandInfoContactCell : UITableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithBlock:(void(^)(NSString *type ,YYTypeButton *typeButton))block;

-(id)initWithBlock:(void(^)(NSString *type ,YYTypeButton *typeButton))block;

+(CGFloat )getHeightWithHomeInfoModel:(YYBrandHomeInfoModel *)homePageModel IsHomePage:(BOOL )isHomePage;

@property (nonatomic,strong)YYBrandHomeInfoModel *homePageModel;

@property (nonatomic,assign) BOOL isHomePage;//用于无数据时文案差别

@property (nonatomic,copy) void (^cellblock)(NSString *type ,YYTypeButton *typeButton);

@property (nonatomic, strong) UIView *infoAboutBackView;

@property (nonatomic, strong) UIView *lastView;

@end
