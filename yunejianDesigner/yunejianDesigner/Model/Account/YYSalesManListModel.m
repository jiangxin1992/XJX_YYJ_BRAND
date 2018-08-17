//
//  YYSalesManListModel.m
//  Yunejian
//
//  Created by yyj on 15/7/15.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYSalesManListModel.h"


@implementation YYSalesManListModel

-(NSNumber *)getTypeWithID:(NSNumber *)CreateID WithName:(NSString *)CreateName{
    if(self.result){
        if(self.result.count){
            for (int i=0;i<self.result.count; i++) {
                YYSalesManModel *salesManModel = [self.result objectAtIndex:i];
                if([salesManModel.username isEqualToString:CreateName]&&([salesManModel.userId integerValue]==[CreateID integerValue])){
                    return salesManModel.userType;
                }
            }
        }
    }
    return nil;
}

-(void)sortModelWithAddArr:(NSArray *)addArr
{
    if(self.result){
        if(self.result.count){
            NSMutableArray *tempArr = [self.result mutableCopy];
            if(addArr)
            {
                [tempArr addObjectsFromArray:addArr];
            }
            //用户类型 0:设计师 1:买手店 2:销售代表 5:Showroom 6:Showroom子账号
            NSMutableArray *mutaleArr = [[NSMutableArray alloc] init];
            
            NSMutableArray *mutaleArr0 = [[NSMutableArray alloc] init];
            NSMutableArray *mutaleArr2 = [[NSMutableArray alloc] init];
            NSMutableArray *mutaleArr5 = [[NSMutableArray alloc] init];
            NSMutableArray *mutaleArr6 = [[NSMutableArray alloc] init];
            for (YYSalesManModel *saleManModel in tempArr) {
                if([saleManModel.userType integerValue] == 0){
                    [mutaleArr0 addObject:saleManModel];
                }else if([saleManModel.userType integerValue] == 2){
                    [mutaleArr2 addObject:saleManModel];
                }else if([saleManModel.userType integerValue] == 5){
                    [mutaleArr5 addObject:saleManModel];
                }else if([saleManModel.userType integerValue] == 6){
                    [mutaleArr6 addObject:saleManModel];
                }
            }
            [mutaleArr addObjectsFromArray:mutaleArr5];
            [mutaleArr addObjectsFromArray:mutaleArr6];
            [mutaleArr addObjectsFromArray:mutaleArr0];
            [mutaleArr addObjectsFromArray:mutaleArr2];
            self.result = [mutaleArr copy];
        }
    }
}

-(void)getTrueSalesMainList
{
    if(self.result){
        if(self.result.count){
            NSMutableArray *mutableArr = [[NSMutableArray alloc] init];
            for (YYSalesManModel *saleManModel in self.result) {
                if([saleManModel.userType integerValue] == 2){
                    [mutableArr addObject:saleManModel];
                }
            }
            self.result = [mutableArr copy];
        }
    }
}
@end
