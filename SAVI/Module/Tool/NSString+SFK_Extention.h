//
//  NSString+SFK_Extention.h
//  SFKStudentCenterNew
//
//  Created by sfk-ios on 2017/4/17.
//  Copyright © 2017年 北京斯芬克教育咨询有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+SFK_Extension.h"

@interface NSString (SFK_Extention)

/** 对传入字符串MD5加密 */
+ (NSString *)md5:(NSString *)str;

/** 传入image返回base64二进制图像 */
+ (NSString *)imageBase64WithDataURL:(UIImage *)image;
+ (NSString *)imageBase64WithHightDataURL:(UIImage *)image;

/** 传入时间戳返回日期格式化字符串 */
+(NSString *)formatterDateFromTimeIntervalString:(NSString *)interval formatter:(NSString *)fmt;
+(NSString *)formatterDateFromTimeIntervalString:(NSString *)interval ;

///  现在时间对比传入时间,传入时间是否已经过去 @"yyyy-MM-dd HH:mm"
+ (BOOL)nowIsPassedDateString:(NSString *)dateString;
///  传入时间两个时间,传入时间1（one）是否比时间2（two）更接近现在 @"yyyy-MM-dd HH:mm:ss"
+ (BOOL)compareOneTimeString:(NSString *)one isPassedTowTimeString:(NSString *)two;
/// 传入格式日期（2017-05-23 15:30:00）返回 时间比较格式提示(昨天 15:30:00)
+ (NSString *)nowCompareDateString:(NSString *)dateString;
/// 传入格式日期（2017-05-23）返回 时间比较格式提示( x 天前 )
+ (NSString *)nowDateCompareDateString:(NSString *)dateString;

/// 传入一个日期(yyyy-MM-dd)，返回日期属于周几
+ (NSString *)weekDayWithDateString:(NSString *)dateString;

/// 系统真机测试打印用的时间格式
+ (NSString *)XM_stringDate;

/// 传入某个时间字符串，返回参数之后的格式字符串
+ (NSString *)dateStringAfterDateString:(NSString *)dateString ForYear:(NSInteger)year Month:(NSInteger)month Day:(NSInteger)day Hour:(NSInteger)hour Minute:(NSInteger)minute Second:(NSInteger)second dateFormet:(NSString *)dateFormet;

/// 获取由当前的NSString转换来的UIColor
- (UIColor*)color;

@end
