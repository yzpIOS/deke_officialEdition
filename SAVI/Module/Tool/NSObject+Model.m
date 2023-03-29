//
//  NSObject+Model.m
//  SAVI
//
//  Created by luhoun on 16/7/5.
//  Copyright © 2016年 Hanymore. All rights reserved.
//

#import "NSObject+Model.h"
#import <objc/runtime.h>

@implementation NSObject (Model)

+(NSArray*)propertiesList{
    //获取属性的列表
    unsigned int count;
    objc_property_t *property_t_array = class_copyPropertyList([self class], &count);
    NSMutableArray *mutable=[NSMutableArray arrayWithCapacity:count];
    for (int i = 0 ; i < count ; i ++) {
        objc_property_t pro_t = property_t_array[i];//获取对象的某个属性
        const char *pro_name = property_getName(pro_t);//得到属性名字的字符串
        NSString *key = [NSString stringWithUTF8String:pro_name];
        [mutable addObject:key];
    }
    free(property_t_array);
    return [mutable copy];
}

+ (id)getObjectInternal:(id)obj{
    if([obj isKindOfClass:[NSString class]]|| [obj isKindOfClass:[NSNumber class]]|| [obj isKindOfClass:[NSNull class]]){
        return obj;
    }
    
    if([obj isKindOfClass:[NSArray class]]){
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++){
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    
    if([obj isKindOfClass:[NSDictionary class]]){
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys){
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self dictionaryWithObject:obj];
}

+ (NSData*)toJSON:(id)obj options:(NSJSONWritingOptions)options error:(NSError**)error{
    return [NSJSONSerialization dataWithJSONObject:[self dictionaryWithObject:obj] options:options error:error];
}

+(NSDictionary*)dictionaryWithObject:(id)obj{
    unsigned int propsCount;
    objc_property_t *props=class_copyPropertyList([obj class], &propsCount);
   NSMutableDictionary *md=[NSMutableDictionary dictionaryWithCapacity:propsCount];
    
    for (int i=0; i<propsCount; i++) {
        objc_property_t prop=props[i];
        NSString *propName=[NSString stringWithUTF8String:property_getName(prop)];
        id value=[obj valueForKey:propName];
        
        if (value==nil) {
            value=[NSNull null];
        }else{
            value=[self getObjectInternal:value];
        }
        [md setObject:value forKey:propName];
    }
    return md;
}

+ (instancetype)modelWithDict:(NSDictionary *)dict {
    id obj = [[self alloc] init];
    NSArray *properties = [self propertiesList];
    // 遍历属性数组
    for (NSString *key in properties) {
        // 判断字典中是否包含这个key
        if (dict[key] != nil) {
            // 使用 KVC 设置数值
            [obj setValue:dict[key] forKey:key];
        }
    }
    return obj;
}

+(NSMutableArray*)arrayWithObject:(NSArray*)arrs{
    NSMutableArray *mutable=[NSMutableArray array];
    for (NSDictionary *dic in arrs) {
        [mutable addObject:[self modelWithDict:dic]];
    }
    return mutable;
}


@end
