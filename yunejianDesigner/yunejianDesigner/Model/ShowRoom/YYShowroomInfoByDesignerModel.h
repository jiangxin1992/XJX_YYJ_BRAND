//
//  YYShowroomInfoByDesignerModel.h
//  yunejianDesigner
//
//  Created by yyj on 2017/3/14.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "YYShowRoomSubModel.h"

@interface YYShowroomInfoByDesignerModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *status;//AGREE 已同意(代理中) INIT 待同意
@property (strong, nonatomic) NSNumber<Optional> *showroomId;
@property (strong, nonatomic) NSNumber<Optional> *brandId;//对应的设计师ID
@property (strong, nonatomic) NSString<Optional> *showroomName;//showroom名
@property (strong, nonatomic) NSString<Optional> *pic;//showroom海报（主页头那边）
@property (strong, nonatomic) NSArray<YYShowRoomSubModel, Optional, ConvertOnDemand>* sales;//Showroom信息

-(NSString *)getSalesStr;
@end
