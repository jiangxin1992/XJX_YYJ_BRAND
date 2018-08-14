//
//  YYPaymentNoteOnlinePayDetailModel.h
//  yunejianDesigner
//
//  Created by Apple on 16/7/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol YYPaymentNoteOnlinePayDetailModel @end
@interface YYPaymentNoteOnlinePayDetailModel : JSONModel
@property (strong, nonatomic) NSString <Optional>*accountTime;
@property (strong, nonatomic) NSNumber <Optional>*payChannel;
@property (strong, nonatomic) NSString <Optional>*payTime;
@property (strong, nonatomic) NSString <Optional>*tradeNo;
@property (strong, nonatomic) NSString <Optional>*transStatus;
@end
