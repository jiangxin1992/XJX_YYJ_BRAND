//
//  YYConnDesignerModel.h
//  Yunejian
//
//  Created by Apple on 15/12/4.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"
@protocol YYConnDesignerModel @end

@interface YYConnDesignerModel : JSONModel
@property (strong, nonatomic) NSString <Optional>*brandName;//": "DDD的style",
@property (strong, nonatomic) NSNumber <Optional>*connectStatus;//": -1 没有关系0 我已发送邀请，对方未处理1 已为好友2 对方已发出邀请，我未处理

@property (strong, nonatomic) NSString <Optional>*brandDescription;//": "我是一个有追求的设计师",
@property (strong, nonatomic) NSArray< Optional,ConvertOnDemand>*retailerNameList;//": ["买手店1","买手店2","买手店3"],
@property (strong, nonatomic) NSString <Optional>*logo;//": "http://source.yunejian.com/ufile/20150904/2391e1b9d4774332abbd9a31801c42b5",
@property (strong, nonatomic) NSArray< Optional,ConvertOnDemand>*indexPicList;
@property (strong, nonatomic) NSString <Optional>*email;//": "designer@yej.com"
@property (strong, nonatomic) NSNumber <Optional>*id;

@property (strong, nonatomic) NSString <Optional>*designerName;
@end
