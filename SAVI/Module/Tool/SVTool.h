//
//  SVTool.h
//  SAVI
//
//  Created by hashakey on 2017/6/4.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVTool : NSObject

/**
 超哥给的方法,字条串的对比
 */
+ (BOOL)isEmptyString:(NSString *)input;

/**
 判断nsstring是否为空
 */
+ (BOOL) isBlankString:(NSString *)string;

/**
 判断Dictionary是否为空
 */
+ (BOOL) isBlankDictionary:(NSDictionary *)dictionary;

/**
 判断数组是否为空
 */
+ (BOOL)isEmpty:(NSArray *)array;

/**
 取得当前时间
 */
+ (NSString *)timeAcquireCurrentDate;

/**
 取得当前时间
 */
+ (NSString *)timeAcquireCurrentDateSfm;

/**
 根据年月日求星期几
 */
+ (NSString*)weekdayStringFromDate:(NSString *)inputDate;

/**
 获取某月的天数
 */
+ (NSInteger)NumberOfDaysInMonthDate:(NSString *)inputDate;

/**
 用正则来判断字符串是否是纯数字
 */
+ (BOOL)deptNumInputShouldNumber:(NSString *)str;

/**
 判断手机号码格式是否正确
 */
+ (BOOL)valiMobile:(NSString *)mobile;

/**
 邮箱地址的正则表达式
 */
+ (BOOL)isValidateEmail:(NSString *)email;

/**
 提示数据请求错误
 */
//+ (void)requestFailed;

/**
 给提示框重设背景色
 */
//+ (void)hintBoxBackgroundColor;

/**
 只显示文字的,加载在view的
 */
+ (void)TextButtonAction:(UIView *)acView withSing:(NSString *)sing;

/**
 只显示文字的,加载在keyWindow的
 */
+ (void)TextButtonActionWithSing:(NSString *)sing;

/**
 加载中…,加载在view的
 */
+ (void)IndeterminateButtonAction:(UIView *)acView withSing:(NSString *)sing;

/**
 加载中…,加载在keyWindow的
 */
+ (void)IndeterminateButtonActionWithSing:(NSString *)sing;

/**
 把格式化的JSON格式的字符串转换成字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSMutableString *)jsonString;

/**
 把格式化的JSON格式的字符串转换成字典
 */
+ (NSArray *)arrayWithJsonString:(NSString *)jsonString;
/**
 MJRefresh刷新动图
 */
+ (NSMutableArray *)MJRefreshAnimateArray;






@end
