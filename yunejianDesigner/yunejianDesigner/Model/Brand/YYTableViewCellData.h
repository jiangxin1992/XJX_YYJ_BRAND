//
//  YYTableViewCellData.h
//  Yunejian
//
//  Created by Apple on 15/9/24.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, RegisterTableCellType) {
    RegisterTableCellTypeHead = 1,
    RegisterTableCellTypeInput = 2,
    RegisterTableCellTypeSaleInfo = 3,
    RegisterTableCellTypeCanal = 4,
    RegisterTableCellTypeSubmit = 5,
    RegisterTableCellTypeArea = 6,
    RegisterTableCellTypeBrandRegisterType = 7,
    RegisterTableCellTypeBrandRegisterUpload = 8,
    RegisterTableCellTypeBuyerRegisterUpload = 9,
    RegisterTableCellTypeBuyerPriceRang = 10,
    RegisterTableCellTypeConnBrand = 11,
    RegisterTableCellTypeBuyerPhotos = 12,
    RegisterTableCellTypeIntroduce = 13,
    RegisterTableCellTypeTitle = 14,
    RegisterTableCellStep = 15,
    RegisterTableCellSpace = 16,
    RegisterTableCellTypeSubmitBtn = 17,
    RegisterTableCellTypeEmailVerify = 18,
    RegisterTableCellTypePayType = 19,
    TableViewCellTypeDefault = 20
};
@interface YYTableViewCellData : NSObject
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *reuseIdentifier;
@property (nonatomic, assign) BOOL useDynamicRowHeight;
@property (nonatomic, assign) CGFloat estimatedRowHeight;
@property (nonatomic, assign) CGFloat tableViewCellRowHeight;
@property (nonatomic,strong) id object;

@property (nonatomic, copy) CGFloat(^dynamicCellRowHeight)(void);
@property (nonatomic, copy) void(^selectedCellBlock)(NSIndexPath *indexPath);

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
