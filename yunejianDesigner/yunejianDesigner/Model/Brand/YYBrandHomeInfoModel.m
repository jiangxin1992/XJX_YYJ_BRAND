//
//  YYBuyerHomeModel.m
//  YunejianBuyer
//
//  Created by Apple on 16/12/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYBrandHomeInfoModel.h"

@implementation YYBrandHomeInfoModel

-(NSString *)getStoreImgCover{
    NSString *albumImgPath = @"";
    if(self.indexPics)
    {
        if(self.indexPics.count)
        {
            albumImgPath = self.indexPics[0];
        }
    }
    return albumImgPath;
}

@end
