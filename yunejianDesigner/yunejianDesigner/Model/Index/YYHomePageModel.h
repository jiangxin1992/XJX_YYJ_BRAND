//
//  YYHomePageModel.h
//  Yunejian
//
//  Created by Apple on 15/12/17.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"
#import "YYBrandIntroductionModel.h"
@interface YYHomePageModel : JSONModel
@property (strong, nonatomic) NSString <Optional>*logo;
@property (strong, nonatomic) YYBrandIntroductionModel *brandIntroduction;
@property (strong, nonatomic) NSString <Optional>*designerName;
@property (strong, nonatomic) NSNumber <Optional>*connectStatus;
@end
