//
//  NSDictionary+SVMutabledictionary.m
//  SAVI
//
//  Created by 杨忠平 on 2020/5/26.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "NSDictionary+SVMutabledictionary.h"

//#import <AppKit/AppKit.h>


@implementation NSDictionary (SVMutabledictionary)

-(NSMutableDictionary *)mutableDicDeepCopy{
 
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithCapacity:[self count]];
 
    NSArray *keys=[self allKeys];
    for(id key in keys)
    {
    //循环读取复制每一个元素
        id value=[self objectForKey:key];
        id copyValue;
        
        // 如果是字典，递归调用
        if ([value isKindOfClass:[NSDictionary class]]) {
            
            copyValue=[value mutableDicDeepCopy];
            
            //如果是数组，数组数组深拷贝
        }else if([value isKindOfClass:[NSArray class]])
            
        {
           // copyValue=[value mutableArrayDeeoCopy];
        }else{
            
            copyValue = value;
        }
        
        [dict setObject:copyValue forKey:key];
        
    }
    return dict;
 
}

@end
