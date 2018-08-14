//
//  YYShowroomBrandListModel.m
//  yunejianDesigner
//
//  Created by yyj on 2017/3/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YYShowroomBrandListModel.h"

@implementation YYShowroomBrandListModel

-(void)getTestModel{
    if(self)
    {
        if(self.brandList)
        {
            if(self.brandList.count)
            {
                YYShowroomBrandModel *model = self.brandList[0];
                NSMutableArray *tempArr = [[NSMutableArray alloc] init];
                NSArray *tempnilArr = @[@"😄",@"@",@"1"];
                for (int i = 0; i < 50; i++) {
                    YYShowroomBrandModel *tempmodel = [model copy];
                    NSString *charStr = arc4random()%2?[[NSString alloc] initWithFormat:@"%c",'A' + arc4random()%26]:[tempnilArr objectAtIndex:arc4random()%3];
                    tempmodel.brandName = [[NSString alloc] initWithFormat:@"%@%@",charStr,model.brandName];
                    [tempArr addObject:tempmodel];
                }
                self.brandList = [tempArr copy];
                //        self.brandList = @[];
            }
        }
    }
}
@end
