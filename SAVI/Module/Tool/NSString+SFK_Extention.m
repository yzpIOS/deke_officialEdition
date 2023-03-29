//
//  NSString+SFK_Extention.m
//  SFKStudentCenterNew
//
//  Created by sfk-ios on 2017/4/17.
//  Copyright © 2017年 北京斯芬克教育咨询有限公司. All rights reserved.
//

#import "NSString+SFK_Extention.h"
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (SFK_Extention)
/// MD5加密
+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    //    CC_MD5(cStr, strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

/** 传入image返回base64二进制图像（小图） */
+ (NSString *)imageBase64WithDataURL:(UIImage *)image
{
    NSData *imageData =nil;
    NSString *mimeType =nil;
    
    //图片要压缩的比例，此处100根据需求，自行设置
    CGFloat x = 100 / image.size.height;
    if (x >1)
    {
        x = 1.0;
    }
    imageData = UIImageJPEGRepresentation(image, x);
    mimeType = @"image/jpg";
    return [NSString stringWithFormat:@"%@%@",
            [imageData base64EncodedStringWithOptions:0], mimeType];
}

/** 传入image返回base64二进制图像(高清) */
+ (NSString *)imageBase64WithHightDataURL:(UIImage *)image
{
    NSData *imageData =nil;
    NSString *mimeType =nil;
    
    //图片要压缩的比例，此处800根据需求，自行设置
    CGFloat x = 800 / image.size.height;
    if (x >1)
    {
        x = 1.0;
    }
    imageData = UIImageJPEGRepresentation(image, x);
    mimeType = @"image/jpg";
    return [NSString stringWithFormat:@"%@%@",
            [imageData base64EncodedStringWithOptions:0], mimeType];
}

/** 传入时间戳返回日期格式化字符串 */
+(NSString *)formatterDateFromTimeIntervalString:(NSString *)interval formatter:(NSString *)fmt
{
    if (interval.length<7) {
        return @"";
    }
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:fmt.length?fmt:@"yyyy-MM-dd HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[interval doubleValue]];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

/** 传入时间戳返回日期格式化字符串 */
+(NSString *)formatterDateFromTimeIntervalString:(NSString *)interval
{
    return [NSString formatterDateFromTimeIntervalString:interval formatter:nil];
}


/// 系统真机测试打印用的时间格式
+ (NSString *)XM_stringDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    return dateString;
}

/// 传入格式日期（2017-05-23 15:30:00）返回 时间比较格式提示(昨天 15:30)
+ (NSString *)nowCompareDateString:(NSString *)dateString
{
    if (!dateString.length) {
        return @"";
    }
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    // 设置日期格式（声明字符串里面每个数字和单词的含义）
    // E:星期几
    // M:月份
    // d:几号(这个月的第几天)
    // H:24小时制的小时
    // m:分钟
    // s:秒
    // y:年
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 微博的创建日期
    NSDate *createDate = [fmt dateFromString:dateString];
    // 当前时间
    NSDate *now = [NSDate date];
    
    // 日历对象（方便比较两个日期之间的差距）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // NSCalendarUnit枚举代表想获得哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 计算两个日期之间的差值
    NSDateComponents *cmps = [calendar components:unit fromDate:createDate toDate:now options:0];
    
    if ([createDate isThisYear]) { // 今年
        if ([createDate isYesterday]) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:createDate];
        } else if ([createDate isToday]) { // 今天
            if (cmps.hour >= 1) {
                return [NSString stringWithFormat:@"%d小时前", (int)cmps.hour];
            } else if (cmps.minute >= 1) {
                return [NSString stringWithFormat:@"%d分钟前", (int)cmps.minute];
            } else {
                return @"刚刚";
            }
        } else { // 今年的其他日子
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:createDate];
        }
    } else { // 非今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:createDate];
    }
}

/// 传入格式日期（2017-05-23）返回 时间比较格式提示( x 天前 )
+ (NSString *)nowDateCompareDateString:(NSString *)dateString
{
    NSString *lastTime = dateString;
    
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"yyyy-MM-dd";
    NSString *nowDateStr = [dateFomatter stringFromDate:nowDate];
    // 截止时间data格式
    NSDate *lastDate = [dateFomatter dateFromString:lastTime];
    // 当前时间data格式
    nowDate = [dateFomatter dateFromString:nowDateStr];
    if (!lastDate) {
        lastDate = nowDate;
    }
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
//    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
//    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay ;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:lastDate toDate:nowDate options:0];
    // 小时差额 = dateCom.hour, 分钟差额 = dateCom.minute
//    SFKLog(@"小时差额==%ld  分钟差额==%ld  秒差==%ld",(long)dateCom.hour,(long)dateCom.minute,dateCom.second);
    
    if (dateCom.month >=1) {
        return dateString;
    }
    
    if (dateCom.day >= 10 ) {
        return dateString;
    }else {
        
        dateString = [NSString stringWithFormat:@"%ld 天前",(long)dateCom.day];
        
        if (dateCom.day == 0) {
            dateString = @"今天";
        }
    }
    
    return dateString;
}

///  现在时间对比传入时间,传入时间是否已经过去 @"yyyy-MM-dd HH:mm"
+ (BOOL)nowIsPassedDateString:(NSString *)dateString
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    // 设置日期格式（声明字符串里面每个数字和单词的含义）
    fmt.dateFormat = @"yyyy-MM-dd HH:mm";
    // 创建日期
    NSDate *createDate = [fmt dateFromString:dateString];
    // 当前时间
    NSDate *now = [NSDate date];
    
    // 日历对象（方便比较两个日期之间的差距）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // NSCalendarUnit枚举代表想获得哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 计算两个日期之间的差值
    NSDateComponents *cmps = [calendar components:unit fromDate:createDate toDate:now options:0];
    
    if (cmps.year<=0 && cmps.month <= 0 && cmps.date <= 0 && cmps.hour <=0 && cmps.minute <=0) {
//        XMLog(@"时间未过去");
        return NO;
    }else {
//        XMLog(@"时间是过去时");
        return YES;
    }
    
    return NO;
}

///  传入时间两个时间,传入时间1（one）是否比时间2（two）更接近现在 @"yyyy-MM-dd HH:mm:ss"
+ (BOOL)compareOneTimeString:(NSString *)one isPassedTowTimeString:(NSString *)two
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    // 设置日期格式（声明字符串里面每个数字和单词的含义）
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 创建日期
    NSDate *towTime = [fmt dateFromString:two];
    // 当前时间
    NSDate *oneTime = [fmt dateFromString:one];
    
    // 日历对象（方便比较两个日期之间的差距）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // NSCalendarUnit枚举代表想获得哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 计算两个日期之间的差值
    NSDateComponents *cmps = [calendar components:unit fromDate:towTime toDate:oneTime options:0];
    
    if (cmps.year<=0 && cmps.month <= 0 && cmps.date <= 0 && cmps.hour <=0 && cmps.minute <=0 && cmps.second <=0) {
              //  XMLog(@"时间未过去，one==%@,two==%@",one,two);
        return NO;
    }else {
               // XMLog(@"时间是过去时one==%@,two==%@",one,two);
        return YES;
    }
    
    return NO;
}


/// 传入某个时间字符串，返回参数之后的格式字符串
+ (NSString *)dateStringAfterDateString:(NSString *)dateString ForYear:(NSInteger)year Month:(NSInteger)month Day:(NSInteger)day Hour:(NSInteger)hour Minute:(NSInteger)minute Second:(NSInteger)second dateFormet:(NSString *)dateFormet
{
    // 当前日期
    NSDate *localDate = [NSDate date];  // 为伦敦时间
    // 在当前日期时间加上 时间：格里高利历
    localDate = [localDate dateFromDateString:dateString dateFormat:dateFormet];
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponent = [[NSDateComponents alloc]init];
    
    [offsetComponent setYear:year ];  // 设置开始查询时间为当前时间的前x年
    [offsetComponent setMonth:month];
    [offsetComponent setDay:day];
    [offsetComponent setHour:(hour+8)]; // 中国时区为正八区，未处理为本地，所以+8
    [offsetComponent setMinute:minute];
    [offsetComponent setSecond:second];
    
    // 当前时间前若干时间
    NSDate *minDate = [gregorian dateByAddingComponents:offsetComponent toDate:localDate options:0];
    
    NSString *dateStr = [NSString stringWithFormat:@"%@",minDate];
    
    NSRange range;
    range.location = 0 ;
    range.length = 11;
    //    range.length = [source rangeOfString:@"<" options:NSBackwardsSearch];
    dateStr = [NSString stringWithFormat:@"%@", [dateStr substringWithRange:range]];
    return dateStr;
}

/// 传入一个日期，返回日期属于周几
+ (NSString *)weekDayWithDateString:(NSString *)dateString
{
    NSString *weekDay = @"周天";
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay | NSCalendarUnitWeekday ;
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd";
    if (dateString.length>10) {
        dateString = [dateString substringToIndex:10];
    }
    NSDate *date = [fmt dateFromString:dateString];
    comps = [calendar components:unitFlags fromDate:date];
    
    NSInteger index = [comps weekday];
    // 1 星期天 ，7周六
    switch (index) {
        case 1:
            return @"周日";
            break;
        case 2:
            return @"周一";
            break;
        case 3:
            return @"周二";
            break;
        case 4:
            return @"周三";
            break;
        case 5:
            return @"周四";
            break;
        case 6:
            return @"周五";
            break;
        case 7:
            return @"周六";
            break;
            
        default:
            break;
    }
    
    return weekDay;
}

/// 获取由当前的NSString转换来的UIColor
- (UIColor *)color {
    // 判断长度先
    if (self.length < 6) return nil;
    // 去掉空格等其他字符
    NSString *cString = [[self stringByTrimmingCharactersInSet:
                          [NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    if ([cString length] < 6 || [cString length] > 8) return nil;
    
    static int COLOR_LENGTH = 4;
    // Alpha Red Green Blue
    unsigned int colorARGB[COLOR_LENGTH];
    for (int i = 0; i < 4; i++) {
        // 先初始化为所有都是255
        colorARGB[COLOR_LENGTH-i-1] = 255;
        
        // 根据子字符串进行数字转换
        NSString *subString = [cString substringFromIndex: cString.length < 2 ? 0 : cString.length - 2];
        cString = [cString substringToIndex:cString.length < 2 ? cString.length : cString.length - 2];
        if (subString.length) {
            [[NSScanner scannerWithString:subString] scanHexInt:&colorARGB[COLOR_LENGTH-i-1]];
        }
    }
    
    return [UIColor colorWithRed:((float) colorARGB[1] / 255.0f)
                           green:((float) colorARGB[2] / 255.0f)
                            blue:((float) colorARGB[3] / 255.0f)
                           alpha:((float) colorARGB[0] / 255.0f)];
}

@end
