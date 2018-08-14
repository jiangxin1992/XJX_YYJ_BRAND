//
//  YYOrderTransStatusModel.h
//  Yunejian
//
//  Created by Apple on 15/11/30.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"

@interface YYOrderTransStatusModel : JSONModel

@property (strong, nonatomic) NSNumber <Optional>*buyerTransStatus;//买手订单状态
@property (strong, nonatomic) NSNumber <Optional>*designerTransStatus;//品牌订单状态
@property (strong, nonatomic) NSNumber <Optional>*rejectReason;//拒绝理由，为空时表明没有拒绝过
@property (strong, nonatomic) NSNumber <Optional>*operationTime;//操作时间
@property (nonatomic) BOOL isOwnCloseReq;//是否是自己请求关闭

@end

