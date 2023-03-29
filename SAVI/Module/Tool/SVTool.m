//
//  SVTool.m
//  SAVI
//
//  Created by hashakey on 2017/6/4.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVTool.h"

@implementation SVTool

//超哥给的方法
+(BOOL)isEmptyString:(NSString *)input{
    
    BOOL res = [input isKindOfClass:[NSNull class]] || (input.length == 0)||input == nil;
    
    return res;
}

//判断nsstring是否为空
+ (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

//判断字典对象的元素是否为空
+ (BOOL) isBlankDictionary:(NSDictionary *)dictionary {
    NSString *value = [dictionary objectForKey:@"First"];
    if ((NSNull *)value == [NSNull null]) {
        return YES;
    }
    return NO;
}

//判断数组是否请求完了
+ (BOOL)isEmpty:(NSArray *)array{
    if (array==nil) {
        return YES;
    }
    if ([array isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (array.count==0){
        return YES;
    }
    return NO;
}

/**
 取得当前时间
 */
+ (NSString *)timeAcquireCurrentDate{
    //取得当前时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *DateTime = [formatter stringFromDate:date];
    return DateTime;
}

/**
 取得当前时间
 */
+ (NSString *)timeAcquireCurrentDateSfm{
    //取得当前时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *DateTime = [formatter stringFromDate:date];
    return DateTime;
}


/**
 根据年月日求星期几
 */
+ (NSString *)weekdayStringFromDate:(NSString *)inputDate {
    //字符串转Date
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[dateFormatter dateFromString:inputDate];
    
    //求星期几
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
    
    return [weekdays objectAtIndex:theComponents.weekday];
}

/**
 获取某月的天数
 */
+ (NSInteger)NumberOfDaysInMonthDate:(NSString *)inputDate {
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSDate *date=[dateFormatter dateFromString:inputDate];
    
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]; // 指定日历的算法
    //NSDate * currentDate = [NSDate date]; // 这个日期可以你自己给定
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit: NSMonthCalendarUnit forDate:date];
    
    return range.length;
}

//用正则来判断字符串是否是纯数字
+ (BOOL)deptNumInputShouldNumber:(NSString *)str {
    if (str.length == 0) {
        return NO;
    }
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}

/**
 判断手机号码格式是否正确
 */
+ (BOOL)valiMobile:(NSString *)mobile
{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(17[5-6])|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(166)|(173)|(177)|(198)|(199)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            
            return YES;
            
        }else{
            
            return NO;
        }
    }
}

/**
 邮箱地址的正则表达式
 */
+ (BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成数组
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSArray *)arrayWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return array;
}

//动图
+ (NSMutableArray *)MJRefreshAnimateArray {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < 12; i++) {
        NSString *imgeName = [NSString stringWithFormat:@"MJRefresh_%ld",(long)i];
        UIImage *imge = [UIImage imageNamed:imgeName];
        [arr addObject:imge];
    }
    return arr;
}

// 只显示文字，加载在view上
+ (void)TextButtonAction:(UIView *)acView withSing:(NSString *)sing {
    [MBProgressHUD hideHUDForView:acView animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:acView animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = sing;
    hud.label.textColor = [UIColor whiteColor];//字体颜色
    hud.bezelView.color = [UIColor blackColor];//背景颜色
    hud.cornerRadius = 10;//设置背景框的圆角值，默认是10
    //hud.activityIndicatorColor = [UIColor whiteColor];//设置菊花（活动指示器）颜色
    
    //指定距离中心点的X轴和Y轴的位置，不指定则在屏幕中间显示
    hud.yOffset = -100.0f;
    
    //用延迟来移除提示框
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //[SVProgressHUD dismiss];
        [MBProgressHUD hideHUDForView:acView animated:YES];
    });
}

// 只显示文字,加载在keyWindow上
+ (void)TextButtonActionWithSing:(NSString *)sing {
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
 //   hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = sing;
    hud.label.textColor = [UIColor whiteColor];//字体颜色
    hud.bezelView.color = [UIColor blackColor];//背景颜色
    hud.cornerRadius = 10;//设置背景框的圆角值，默认是10
    //hud.activityIndicatorColor = [UIColor whiteColor];//设置菊花（活动指示器）颜色
    
    //指定距离中心点的X轴和Y轴的位置，不指定则在屏幕中间显示
    hud.yOffset = -100.0f;
    
    //用延迟来移除提示框
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //[SVProgressHUD dismiss];
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    });
}

//加载中，加载在view上
+ (void)IndeterminateButtonAction:(UIView *)acView withSing:(NSString *)sing {
    [MBProgressHUD hideHUDForView:acView animated:YES];
    //提示请求中
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:acView animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = sing;
    hud.label.textColor = RGBA(0, 0, 0, 0.5);//字体颜色
    hud.bezelView.color = [UIColor clearColor];//背景颜色
    hud.cornerRadius = 10;//设置背景框的圆角值，默认是10
    hud.activityIndicatorColor = RGBA(0, 0, 0, 0.5);//设置菊花（活动指示器）颜色
    //指定距离中心点的X轴和Y轴的位置，不指定则在屏幕中间显示
    hud.yOffset = -50.0f;
    //11，背景框的最小大小
    //hud.minSize = CGSizeMake(10, 10);
}

//加载中，加载在keyWindow上
+ (void)IndeterminateButtonActionWithSing:(NSString *)sing {
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    //提示请求中
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = sing;
    hud.label.textColor = RGBA(0, 0, 0, 0.5);//字体颜色
    hud.bezelView.color = [UIColor clearColor];//背景颜色
    hud.cornerRadius = 10;//设置背景框的圆角值，默认是10
    hud.activityIndicatorColor = RGBA(0, 0, 0, 0.5);//设置菊花（活动指示器）颜色
    //指定距离中心点的X轴和Y轴的位置，不指定则在屏幕中间显示
    hud.yOffset = -50.0f;
    //11，背景框的最小大小
    //hud.minSize = CGSizeMake(10, 10);
}

/**
 提示数据请求错误
 */
//+ (void)requestFailed{
//    [SVProgressHUD showErrorWithStatus:@"网络开小差了"];
//    [SVProgressHUD setBackgroundColor:BackgroundColor]; //背景颜色
//    [SVProgressHUD setForegroundColor:GlobalFontColor]; //字体颜色
//    //用延迟来移除提示框
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [SVProgressHUD dismiss];
//    });
//}




/**
 
 
 给提示框重设背景色
 */
//+ (void)hintBoxBackgroundColor{
//
//    [SVProgressHUD setBackgroundColor:BackgroundColor]; //背景颜色
//    [SVProgressHUD setForegroundColor:GlobalFontColor]; //字体颜色
//    //用延迟来移除提示框
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [SVProgressHUD dismiss];
//    });
//
//}

@end
