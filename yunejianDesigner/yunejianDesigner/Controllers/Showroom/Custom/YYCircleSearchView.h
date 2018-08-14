//
//  YYCircleSearchView.h
//  YCO SPACE
//
//  Created by yyj on 16/8/15.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import <UIKit/UIKit.h>

@class YYShowroomBrandModel,YYShowroomBrandListModel;

@interface YYCircleSearchView : UIView

-(instancetype)initWithQueryStr:(NSString *)queryStr WithBlock:(void(^)(NSString *type,NSString *queryStr,YYShowroomBrandModel *ShowroomBrandModel))block;

@property (nonatomic ,strong) NSString *queryStr;

@property(nonatomic,copy) void (^block)(NSString *type,NSString *queryStr,YYShowroomBrandModel *ShowroomBrandModel);

@property (strong ,nonatomic) YYShowroomBrandListModel *ShowroomBrandListModel;

@end
