//
//  NSObject+wxh.h
//  KaiQiCaiFu
//
//  Created by Macx on 2017/4/25.
//  Copyright © 2017年 BAOKAI ASSET. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (wxh)

+ (void)saveObj:(NSObject *)obj withKey:(NSString *)key;

+ (NSObject *)readObjforKey:(NSString *)key;

+ (void)removeObjforKey:(NSString *)key;

@end
