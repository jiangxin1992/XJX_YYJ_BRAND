//
//  YYBuyerHomeModel.m
//  YunejianBuyer
//
//  Created by Apple on 16/12/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYBuyerHomeInfoModel.h"

@implementation YYBuyerHomeInfoModel

-(void )SetPickerRowAndComponent
{
    __block NSInteger idxRow = 19;
    __block NSInteger idxComponent = 0;
    NSArray *plistArr=[self getPlistArray];
    if(![NSString isNilOrEmpty:self.province])
    {
        __block BOOL haveRowValue = NO;
        [plistArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([[obj objectForKey:@"p_Name"] isEqualToString:self.province])
            {
                idxRow = idx;
                haveRowValue = YES;
                *stop=YES;
            }
        }];
        
        if(![NSString isNilOrEmpty:self.city])
        {
            if(haveRowValue)
            {
                if(plistArr.count>idxRow)
                {
                    NSArray *cityArr = [((NSDictionary *)[plistArr objectAtIndex:idxRow]) objectForKey:@"Citys"];
                    __block BOOL haveComponentValue = NO;
                    [cityArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if([[obj objectForKey:@"C_Name"] isEqualToString:self.city])
                        {
                            idxComponent = idx;
                            haveComponentValue = YES;
                            *stop=YES;
                        }
                    }];
                }
            }
        }
    }
    self.pickerRow = @(idxRow);
    self.pickerComponent = @(idxComponent);
    NSLog(@"111");
}

-(NSArray *)getPlistArray{
    
    NSString *path= [[NSBundle mainBundle] pathForResource:@"Provineces" ofType:@"plist"];
    NSMutableArray * array=[[NSMutableArray alloc] initWithContentsOfFile:path];
    [array addObject:@{@"p_ID":@"0",@"p_Name":@"海外港澳台",@"Citys":@[@{@"C_ID":@"0",@"C_Name":@"香港"},@{@"C_ID":@"0",@"C_Name":@"澳门"},@{@"C_ID":@"0",@"C_Name":@"台湾"},@{@"C_ID":@"0",@"C_Name":@"海外"}]}];
    
    return array;
}

-(NSString *)getStoreImgCover{
    NSString *albumImgPath = @"";
    if(self.storeImgs)
    {
        if(self.storeImgs.count)
        {
            albumImgPath = self.storeImgs[0];
        }
    }
    return albumImgPath;
}
@end
