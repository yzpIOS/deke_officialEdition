//
//  NSObject+wxh.m
//  KaiQiCaiFu
//
//  Created by Macx on 2017/4/25.
//  Copyright © 2017年 BAOKAI ASSET. All rights reserved.
//

#import "NSObject+wxh.h"

@implementation NSObject (wxh)
+ (void)saveObj:(NSObject *)obj withKey:(NSString *)key{
    if ([SVTool isBlankString:[NSString stringWithFormat:@"%@",obj]]) {
        return;
    }
    [[NSUserDefaults standardUserDefaults]setObject:obj forKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (NSObject *)readObjforKey:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults]objectForKey:key];
}

+ (void)removeObjforKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
@end
