//
//  NSString+Utility.h
//  TianLi_Proprietor
//
//  Created by Allen on 5/20/16.
//  Copyright © 2016 TianLi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IS_iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)
#define IS_iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)

@interface NSString (Utility)

- (BOOL)validateStringEqualToValid;
- (BOOL)stringContainsString:(NSString *)other;

//转换为JSON
+ (NSString *)jsonStringWithObject:(id)object;

//域名解析是否有限制
+ (BOOL)resolveHost:(NSString *)hostname;

@end
