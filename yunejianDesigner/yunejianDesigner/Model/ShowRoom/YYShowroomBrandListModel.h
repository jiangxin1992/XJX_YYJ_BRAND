//
//  YYShowroomBrandListModel.h
//  yunejianDesigner
//
//  Created by yyj on 2017/3/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "JSONModel.h"

#import "YYShowroomBrandModel.h"

@interface YYShowroomBrandListModel : JSONModel

@property (strong, nonatomic) NSArray<YYShowroomBrandModel,Optional, ConvertOnDemand>* brandList;//show下的合作品牌
@property (strong, nonatomic) NSString <Optional>*pic;//Showroom 海报
@property (strong, nonatomic) NSString <Optional>*name;//Showroom 名字
@property (strong, nonatomic) NSString <Optional>*logo;//Showroom logo

-(void)getTestModel;

@end
