//
//  NSDate+SFK_Extension.h
//  SFKStudentCenterNew
//
//  Created by sfk-ios on 2017/5/23.
//  Copyright © 2017年 北京斯芬克教育咨询有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (SFK_Extension)

/**
 *  判断某个时间是否为今年
 */
- (BOOL)isThisYear;
/**
 *  判断某个时间是否为当前月
 */
- (BOOL)isThisMonth;
/**
 *  判断某个时间是否为昨天
 */
- (BOOL)isYesterday;
/**
 *  判断某个时间是否为今天
 */
- (BOOL)isToday;

/// 传入日期字符串返回中国格式日期 （yyyy年MM月dd日）
- (NSDate *)dateFromDateString:(NSString *)dateString dateFormat:(NSString *)dateFormat; 
@end
