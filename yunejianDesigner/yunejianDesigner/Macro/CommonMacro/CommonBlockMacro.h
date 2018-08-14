//
//  CommonBlockMacro.h
//  yunejianDesigner
//
//  Created by yyj on 2017/8/2.
//  Copyright © 2017年 Apple. All rights reserved.
//

#ifndef CommonBlockMacro_h
#define CommonBlockMacro_h

typedef void (^SelectedValue)(NSString *value);
typedef void (^ModifySuccess)();
typedef void (^UpdateInterface)();
typedef void (^CancelButtonClicked)();
typedef void (^SelectButtonClicked)(BOOL isSelectedNow);
typedef void (^YellowPabelCallBack)(NSArray *value);
@protocol YYTableCellDelegate
@required
-(void)btnClick:(NSInteger)row section:(NSInteger)section andParmas:(NSArray *)parmas;
@optional
-(void) test;
@end

#endif /* CommonBlockMacro_h */
