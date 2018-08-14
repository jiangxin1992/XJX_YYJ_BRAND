//
//  YYTableViewCellData.m
//  Yunejian
//
//  Created by Apple on 15/9/24.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYTableViewCellData.h"

@implementation YYTableViewCellData

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.estimatedRowHeight > 0) {
        return self.estimatedRowHeight;
    } else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.useDynamicRowHeight) {
        if (self.dynamicCellRowHeight) {
            return self.dynamicCellRowHeight();
        } else {
            return UITableViewAutomaticDimension;
        }
    } else {
        return self.tableViewCellRowHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedCellBlock) {
        self.selectedCellBlock(indexPath);
    }
}

@end
