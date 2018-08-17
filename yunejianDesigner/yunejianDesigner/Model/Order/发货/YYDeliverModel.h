//
//  YYDeliverModel.h
//  yunejianDesigner
//
//  Created by yyj on 2018/6/21.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@class YYPackingListDetailModel;

@interface YYDeliverModel : JSONModel

@property (strong, nonatomic) NSNumber <Optional>*packageId;//装箱单id
@property (strong, nonatomic) NSString <Optional>*logisticsCode;//物流号
@property (strong, nonatomic) NSString <Optional>*logisticsName;//物流公司名称
@property (strong, nonatomic) NSString <Optional>*receiver;//收件人名称
@property (strong, nonatomic) NSString <Optional>*receiverPhone;//收件人电话
@property (strong, nonatomic) NSString <Optional>*receiverAddress;//收件人地址
@property (strong, nonatomic) NSNumber <Optional>*warehouseId;//仓库id ，对方开通仓库功能的情况下需要传
@property (strong, nonatomic) NSString <Optional>*warehouseName;//仓库名称 ,同上


/**
 初始化

 @param packingListDetailModel ...
 @return ...
 */
-(instancetype)initWithPackingListDetailModel:(YYPackingListDetailModel *)packingListDetailModel;

/**
 地址是否有效

 @param buyerStockEnabled 此单的买手店库存是否已经开通 bool
 @return ...
 */
-(BOOL)isValidAddressWithBuyerStockEnabled:(BOOL)buyerStockEnabled;

/**
 是否满足发货条件

 @param buyerStockEnabled 此单的买手店库存是否已经开通 bool
 @return ...
 */
-(BOOL)canDeliverWithBuyerStockEnabled:(BOOL)buyerStockEnabled;

@end
