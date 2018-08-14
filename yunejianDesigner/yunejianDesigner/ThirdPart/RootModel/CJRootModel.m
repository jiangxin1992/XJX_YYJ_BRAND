//
//  JRModel.m
//  parking
//
//  Created by chjsun on 2016/12/9.
//  Copyright © 2016年 chjsun. All rights reserved.
//

#import "CJRootModel.h"
#import <objc/runtime.h>

static NSMutableDictionary *storagePool;

@implementation CJRootModel

+ (id)shareModel{

    CJRootModel *model;
    NSString *modelClass = NSStringFromClass([self class]);
    if (storagePool != nil && [storagePool objectForKey:modelClass]) {//首先判断缓存池或缓存池是否存在
        model = storagePool[modelClass];

    }else{
        @synchronized(self){
            if (storagePool == nil) {//首先判断缓存池是否存在
                storagePool = [[NSMutableDictionary alloc] init];//不存在就先创建
            }
            if ([storagePool objectForKey:modelClass]) {
                return storagePool[modelClass];
            }else{
                model = [[super alloc] init];
                [storagePool setObject:model forKey:modelClass];
            }
        }

    }
    return model;
}

//重写alloc方法，保证在使用alloc、new 去创建对象时，不产生新的对象
//+ (id)allocWithZone:(NSZone *)zone{
//    NSString *modelClass = NSStringFromClass([self class]);
//    //
//    if (storagePool == nil) {
//        storagePool = [[NSMutableDictionary alloc] init];;
//    }
//    //
//    if ([storagePool objectForKey:modelClass]) {
//        return storagePool[modelClass];
//    }else{
//        model = [[super allocWithZone:zone] init];
//        [storagePool setObject:model forKey:modelClass];
//    }
//    return model;
//}

// //允许copy,
//- (id)copyWithZone:(NSZone *)zone{
//    return model;
//}
//
// //允许copy,
//- (id)mutableCopyWithZone:(NSZone *)zone{
//    return model;
//}

// 快速设置值
- (void)setValueForDict:(NSDictionary *)dict{
    [self setValuesForKeysWithDictionary:dict];
}

// 快速设置值
- (void)setValueForJson:(NSString *)json{
    if (json == nil) {
        return;
    }

    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    [self setValueForDict:dic];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return;
    }
}

// 快速清空模型
- (void)clearModelInfo{
    // 记录属性的个数
    unsigned int propertyCount = 0;
    objc_property_t *propertys = class_copyPropertyList([self class], &propertyCount);

    // 把属性放到数组中
    for (int i = 0; i < propertyCount; i ++) {
        // 取出每一个属性
        objc_property_t property = propertys[i];
        const char *propertyName = property_getName(property);
        // 将所有属性值设置为nil

        //  number类型就放@(0)
        if ([[self valueForKey:[[NSString alloc] initWithUTF8String:propertyName]] isKindOfClass:[NSNumber class]]) {
            [self setValue:@(0) forKey:[[NSString alloc] initWithUTF8String:propertyName]];
            continue;
        }

        [self setValue:nil forKey:[[NSString alloc] initWithUTF8String:propertyName]];
    }
}

// // 模型转字典
- (NSDictionary *)modelToDict{

    // 记录属性的个数
    unsigned int propertyCount = 0;
    objc_property_t *propertys = class_copyPropertyList([self class], &propertyCount);

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    // 把属性放到数组中
    for (int i = 0; i < propertyCount; i ++) {
        // 取出每一个属性
        objc_property_t property = propertys[i];
        const char *propertyName = property_getName(property);
        
        // 将所有属性值赋值给字典
        id value = [self valueForKey:[[NSString alloc] initWithUTF8String:propertyName]];
        if (value == nil) {
            value = @"";
        }
        [dict setObject:value forKey:[[NSString alloc] initWithUTF8String:propertyName]];
    }

    return dict;

}

// 模型转json
-(NSString *)modelToJson{

    NSError *error;

    // 先把对象转成字典
    NSDictionary *dict = [self modelToDict];

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];

    NSString *jsonString;

    if (!jsonData) {

        NSLog(@"%@",error);

    }else{

        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    }

    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];

    NSRange range = {0, jsonString.length};

    //去掉字符串中的空格

    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];

    NSRange range2 = {0, mutStr.length};

    //去掉字符串中的换行符

    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}

// 设置不存在 key 的值
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

    NSLog(@"%@ key 值 %@ 未定义，无法设置值 ！", [self class], key);
}

// 获取不存在的 key 的值
- (id)valueForUndefinedKey:(NSString *)key {

    NSLog(@"%@ key 值 %@ 不存在，无法获取值 ！", [self class], key);
    
    return nil;
}
@end
