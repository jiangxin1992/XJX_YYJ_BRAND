//
//  YYTableViewCellInfoModel.h
//  Yunejian
//
//  Created by Apple on 15/9/24.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol YYRegisterTableCellDelegate
@optional
-(void)selectClick:(NSInteger)type AndSection:(NSInteger)section andParmas:(NSArray *)parmas;
-(NSInteger)getTableCellMinY:(NSInteger)row AndSection:(NSInteger)section;
-(NSInteger)getTableHeight;
-(void)showTopView:(BOOL)show;
-(id)getDelegateView;
-(void)upLoadPhotoImage:(NSInteger )type pointX:(NSInteger)px pointY:(NSInteger)py;
-(void)updateFrame:(NSInteger)offset andSection:(NSInteger )section;
@end

@interface YYTableViewCellInfoModel : NSObject
@property (nonatomic,copy) NSString *propertyKey;
@property (nonatomic,copy) NSString *title;
@property  NSInteger ismust;//是否必须0非必须  1必须 2必须验证（非传值）3特殊处理

@property (nonatomic,copy) NSString *tipStr;
@property (nonatomic,copy) NSString *warnStr;
@property (nonatomic,copy) NSString *inputTipStr;

@property (nonatomic,copy) NSString *value;

@property (nonatomic, assign) BOOL validated;
@property (nonatomic,copy) NSString *passwordvalue;//tmp
@property (nonatomic,assign) NSInteger brandRegisterType;//tmp

//UITextField
@property (nonatomic, assign) UIKeyboardType keyboardType;
@property (nonatomic, assign) BOOL secureTextEntry;

////格式错误
-(BOOL)checkWarn;
-(BOOL)checkPhoneWarnWithPhoneCode:(NSInteger )phoneCode;
-(NSString *)getParamStr;
@end
