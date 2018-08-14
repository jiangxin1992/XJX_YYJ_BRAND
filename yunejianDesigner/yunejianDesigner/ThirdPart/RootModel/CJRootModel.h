//
//  CJRootModel.h
//
//  Created by chjsun on 2016/12/9.
//  Copyright © 2016年 chjsun. All rights reserved.
//  基础模型，该模型不是用于数据加载时使用，而是用于需要全局通用的数据的存储，
//  例如用户信息，用户状态，用户当前经纬度，屏幕中心点坐标等等在其他界面可能用到的数据，在此model的
//  子类中保存，
//  思想：单例
//  用法：继承此model，将属性声明在.h文件中即可。.m可以不写任何代码。也可以写
//

#import <Foundation/Foundation.h>

@interface CJRootModel : NSObject
/**
 *  通过此方法可以创建全局共享唯一模型返回model
 *  若想创建不是全局共享的model，请用init
 *  全局共享的思路就是保存到内存中不被释放。
 */
+ (id)shareModel;

/**
 *  通过kvc快速给属性赋值， dict转对象
 */
- (void)setValueForDict:(NSDictionary *)dict;
/**
 *  通过kvc快速给属性赋值， json转对象
 */
- (void)setValueForJson:(NSString *)json;

/**
 *  将所有属性值置为nil
 */
- (void)clearModelInfo;

/**
 *  格式化对象，对象转模型
 */
- (NSDictionary *)modelToDict;

/**
 * 格式化对象，对象转json
 */
-(NSString *)modelToJson;


@end
