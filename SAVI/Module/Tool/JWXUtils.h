//
//  JWXUtils.h
//  JUtils
//
//  Created by 456 on 15-1-12.
//  Copyright (c) 2015年 456. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger, NumberType) {
    NumberTypeNone = 0,
    NumberTypeInt,
    NumberTypeBool,
    NumberTypeFloat,
    NumberTypeDouble,
    NumberTypeElse
};

@interface JWXUtils : NSObject
//  md5加密方法
+(NSString*)EncodingWithMD5:(NSString *)params;
//  SHA1加密方法
+(NSString*)EncodingWithSHA1:(NSString *)params;
// encodeURL转码方法
+(NSString*)StringFormatEncodeURL:(NSString *)urlstr;
// 给字典的key值排序，返回字符串  key=values&
+(NSString *)genSortAndSubString:(NSDictionary *)params;
//  生成时间戮
+(NSString *)genTimeStamp;
//  生成随机码并且加密 md5
+(NSString *)genRandomMD5;
//  生成商户对用户唯一标识
+(NSString *)genTraceId:(NSString *)timestamp;
//  显示框
+(void)showAlertWithTitle:(NSString *)title msg:(NSString*)msg;
//  显示框
+(void)showAlertView:(NSString *)strMessage;
//数组 值排列 返回字符串
+(NSString *)asSortAndSubString:(NSArray *)params;

//检查手机号
+ (BOOL)isValidOfPhoneNumber:(NSString*)aPhoneNumber;
//检查邮箱
+ (BOOL)isValidateEmail:(NSString *)email;
//检查用户名
+ (BOOL)isValidateUsername:(NSString *)email;
//检查密码
+ (BOOL)isValidatePassword:(NSString *)email;


//检查字符类型
+ (NSInteger)fromTypeToString:(id)data;









/*
 *********
 按比例裁剪Image
 设定最大的width
 设定最大的height
 *********
 */
+ (CGSize)cutImageWithImage:(UIImage *)image maxWidth:(float)maxWidth maxHeight:(float)maxHeight;


//图片过大剪裁图片
+ (UIImageView *)cutImageViewWithImageView:(UIImageView *)imageView cutWidth:(int)cutWidth cutHeight:(int)cutHeight;



/*
 把UIView 转换成图片
 */
+ (UIImage *)getImageFromView:(UIView *)view;




//对NSString进行encode
+ (NSString*)urlValueEncode:(NSString*)str;


//Dictionary To JSON string
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

//根据字符串的的长度来计算UITextView、UITextField、UILabel的高度
+ (CGSize)sizeForString:(NSString *)value font:(UIFont *)font andWidth:(float)width;

//根据字符串的的长度来计算UITextView、UITextField、UILabel的宽度
+ (CGSize)sizeForString:(NSString *)value font:(UIFont *)font andHeight:(float)height;


//自定义图片长宽
+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;




//从String中获取URL
+ (NSArray *)urlArrayFromString:(NSString *)string;


//计算label高度
+ (CGFloat)heightOfString:(NSString *)string textFrame:(CGRect)textFrame textFont:(UIFont *)textFont paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle;



/*
 加密实现MD5和SHA1
 */
+ (NSString *)md5:(NSString *)str;
+ (NSString *)sha1:(NSString *)str;


/*
 随机生成UUID
 */
+ (NSString *)uuidString;


/*
 等比例缩放图片
 */
+ (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;


/*
 加载图片
 */
+ (void)loadImageWithUrlStr:(NSString *)urlStr block:(void (^)(UIImage *image))block;


/*
 头像变圆
 */
+ (void)cutCircleImageViewWithImageView:(UIImageView *)imageView;

/*
 NSArray分组
 */
+ (NSArray *)arrayClassWithArray:(NSArray *)array;


/*
 UIImage旋转
 */
+ (UIImage *)imageRotateWithImage:(UIImage *)originImage;


/*保存照片到相册*/
+ (void)saveImageToPhotos:(UIImage*)savedImage;
@end
