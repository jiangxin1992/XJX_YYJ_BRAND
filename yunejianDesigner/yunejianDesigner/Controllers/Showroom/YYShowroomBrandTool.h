//
//  YYShowRoomBrandTool.h
//  yunejianDesigner
//
//  Created by yyj on 2017/3/7.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YYShowroomBrandTool : NSObject

+(NSInteger )getValueNumWithPinyinDict:(NSDictionary *)dictPinyinAndChinese;

+(NSArray *)getCharArr;

+(UIView *)getViewForHeaderInSection:(NSInteger)section WithPinyinDict:(NSDictionary *)dictPinyinAndChinese;

+(CGFloat )heightForHeaderInSection:(NSInteger)section WithPinyinDict:(NSDictionary *)dictPinyinAndChinese;

@end
