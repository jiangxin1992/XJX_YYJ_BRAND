//
//  YYShowroomInfoByDesignerModel.m
//  yunejianDesigner
//
//  Created by yyj on 2017/3/14.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YYShowroomInfoByDesignerModel.h"

@implementation YYShowroomInfoByDesignerModel

-(NSString *)getSalesStr
{
    if(self)
    {
        if(self.sales)
        {
            if(self.sales.count)
            {
                NSMutableArray *tempArr = [[NSMutableArray alloc] init];
                for (YYShowRoomSubModel *model in self.sales) {
                    if(![NSString isNilOrEmpty:model.manager])
                    {
                        [tempArr addObject:model.manager];
                    }
                }
                return [tempArr componentsJoinedByString:@"，"];
            }
        }
    }
    return @"";
}

@end
