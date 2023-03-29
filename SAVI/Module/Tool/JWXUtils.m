//
//  JWXUtils.m
//  JUtils
//
//  Created by 456 on 15-1-12.
//  Copyright (c) 2015年 456. All rights reserved.
//

#import "JWXUtils.h"
#import <CommonCrypto/CommonDigest.h>
#import <Security/Security.h>
#import "NSString+Utility.h"

@implementation JWXUtils
//SHA1加密方法
+(NSString*)EncodingWithSHA1:(NSString *)params{
    const char *cstr=params.UTF8String;
    NSData *data=[NSData dataWithBytes:cstr length:strlen(cstr)];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, data.length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:
                               CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}

//MD5加密方法
+(NSString *)EncodingWithMD5:(NSString *)params{
    const char *cStr = [params UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result);
    NSMutableString *hash = [NSMutableString string];
    for(int i=0;i<CC_MD5_DIGEST_LENGTH;i++)
    {
        [hash appendFormat:@"%02X",result[i]];
    }
    return hash;
}

//encodeURL转码方法
+(NSString*)StringFormatEncodeURL:(NSString *)urlstr{
    NSString *encodeValue=nil;
    encodeValue=(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlstr, nil, (CFStringRef)@"!*'&=();:@+$,/?%#[]", kCFStringEncodingUTF8));
    return encodeValue;
}
//给字典的key值排序，返回字符串
+(NSString *)genSortAndSubString:(NSDictionary *)params{
    NSArray *key=[params allKeys];
    NSArray *sortedKeys=[key sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2){
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSMutableString *aparams=[NSMutableString string];
    for(NSString *key1 in sortedKeys){
        [aparams appendString:key1];
        [aparams appendString:@"="];
        [aparams appendString:[params objectForKey:key1]];
        [aparams appendString:@"&"];
    }
    NSString *signString=[[aparams copy] substringWithRange:NSMakeRange(0, aparams.length-1)];
    return signString;
}
//给数组排序，返回字符串
/*
 
 */

+(NSString *)asSortAndSubString:(NSArray *)params{
    NSArray *values=[params sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2){
        return [obj1 compare:obj2 options:NSLiteralSearch];
    }];
    NSMutableString *aparams=[NSMutableString string];
    for(NSString *key1 in values){
        [aparams appendString:key1];
    }
    NSString *signString=[[aparams copy] substringWithRange:NSMakeRange(0, aparams.length)];
    return signString;
}
//生成时间戮
+(NSString *)genTimeStamp{
    return [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
}
//生成随机码并且加密
+(NSString *)genRandomMD5{
    return [self EncodingWithMD5:[NSString stringWithFormat:@"%d",arc4random()%10000]];
}
//生成商户对用户唯一标识
+(NSString *)genTraceId:(NSString *)timestamp{
    return [NSString stringWithFormat:@"crestxu_%@",timestamp];
}
//显示框
//+(void)showAlertWithTitle:(NSString *)title msg:(NSString*)msg{
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"HUDDismissNotification" object:nil userInfo:nil];
//}
////显示框
//+(void)showAlertView:(NSString *)strMessage{
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"消息提示" message:strMessage delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
//    [alert show];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"HUDDismissNotification" object:nil userInfo:nil];
//}


+ (BOOL)isValidOfPhoneNumber:(NSString*)aPhoneNumber
{
    if (aPhoneNumber.length <= 0)
    {
        return NO;
    }
    
    NSString *phoneRegex = @"\\b(1)[3456789][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\\b";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:aPhoneNumber];
}

+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)isValidateUsername:(NSString *)userName
{
    //字母开头的4-20
    //    NSString * regex = @"^[A-Za-z0-9]{4,20}$";
    //    NSString *regex = @"^[A-Za-z][a-zA-Z0-9\u4e00-\u9fa5]{4,20}";
    
    
    NSString *regex = @"^(?!_)(?!.*?_$)[a-zA-Z0-9 _.]{4,20}+$";
    
    for (int i=0; i<userName.length; ++i)
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [userName substringWithRange:range];
        const char    *cString = [subString UTF8String];
        if (strlen(cString) == 3)
        {
            NSLog(@"汉字:%s", cString);
            regex = @"^(?!_)(?!.*?_$)[\u4E00-\u9FA5\uF900-\uFA2D\a-zA-Z0-9 _.]{2,10}+$";
            
            break;
        }
    }
    
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return ![pred evaluateWithObject: userName];
    
}


+(BOOL)isValidatePassword:(NSString *)password
{
    //    NSString *regex = @"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]+";
    NSString *regex = @"\\w{6,16}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return ![pred evaluateWithObject: password];
    
    
}




+ (CGSize)cutImageWithImage:(UIImage *)image maxWidth:(float)maxWidth maxHeight:(float)maxHeight
{
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    
    float imageCutWith = 0;
    float imageCutHeight= 0;
    
    if (imageWidth > maxWidth && imageHeight <= maxHeight)
    {
        imageCutWith = maxWidth;
        imageCutHeight = imageHeight*maxWidth/imageWidth;
    }
    else if (imageWidth <= maxWidth && imageHeight > maxHeight)
    {
        imageCutWith = imageWidth*maxHeight/imageHeight;
        imageCutHeight = maxHeight;
    }
    else if (imageWidth > maxWidth && imageHeight > maxHeight)
    {
        if (maxWidth/maxHeight < imageWidth/imageHeight)
        {
            imageCutWith = maxWidth;
            imageCutHeight = imageHeight*maxWidth/imageWidth;
        }
        else if (maxWidth/maxHeight > imageWidth/imageHeight)
        {
            imageCutWith = imageWidth*maxHeight/imageHeight;
            imageCutHeight = maxHeight;
        }
        else
        {
            imageCutWith = maxWidth;
            imageCutHeight = maxHeight;
        }
    }
    else
    {
        imageCutWith = imageWidth;
        imageCutHeight = imageHeight;
    }
    
    return CGSizeMake(imageCutWith, imageCutHeight);
}

//图片过大剪裁图片
+ (UIImageView *)cutImageViewWithImageView:(UIImageView *)imageView cutWidth:(int)cutWidth cutHeight:(int)cutHeight{
    
        CGFloat scale = (cutHeight / cutWidth) / (imageView.frame.size.height / imageView.frame.size.width);
        if (scale < 0.99 || isnan(scale)) { // 宽图把左右两边裁掉
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.layer.contentsRect = CGRectMake(0, 0, 1, 1);
        } else { // 高图只保留顶部
            imageView.contentMode = UIViewContentModeScaleToFill;
            imageView.layer.contentsRect = CGRectMake(0, 0, 1, (float)cutWidth / cutHeight);
        }

    return imageView;
}


+ (NSInteger)fromTypeToString:(id)data
{
    NSNumber *myNumber = (NSNumber *)data;
    
    NSString *string = [NSString stringWithFormat:@"%.2f", myNumber.floatValue];
    NSScanner *scan = [NSScanner scannerWithString:string];
    int valInt;
    if ([scan scanInt:&valInt] && [scan isAtEnd])
    {
        return NumberTypeInt;
    }
    
    float valFloat;
    if ([scan scanFloat:&valFloat] && [scan isAtEnd])
    {
        return NumberTypeFloat;
    }
    
    return NumberTypeElse;
    
    
}




//把UIView 转换成图片
+ (UIImage *)getImageFromView:(UIView *)view
{
    CGSize s = view.bounds.size;
    
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}



//对NSString进行encode
+ (NSString*)urlValueEncode:(NSString*)str
{
    NSString *result = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)str,
                                                                                 NULL,
                                                                                 CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                 kCFStringEncodingUTF8));
    
    
    return result;
}


//Dictionary To JSON string
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}


//根据字符串的的长度来计算UITextView、UITextField、UILabel的高度
+ (CGSize)sizeForString:(NSString *)value font:(UIFont *)font andWidth:(float)width;
{
    CGSize stringSize = [[NSString stringWithFormat:@"%@\n ",value] boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil] context:nil].size;
    
    return stringSize;
}


//根据字符串的的长度来计算UITextView、UITextField、UILabel的宽度
+ (CGSize)sizeForString:(NSString *)value font:(UIFont *)font andHeight:(float)height {
    CGSize stringSize = [[NSString stringWithFormat:@"%@ ",value] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil] context:nil].size;
    
    return stringSize;
}


//格式化筹码数
+ (NSString *)chipsShowFormat:(float)chips isAbbreviation:(BOOL)isAbbreviation
{
    float formatChips = 0;
    
    if (isAbbreviation)
    {
        if (chips >= 1000000000)
        {
            formatChips = chips/1000000000;
        }
        else if (chips >= 1000000)
        {
            formatChips = chips/1000000;
        }
        else if (chips >= 1000)
        {
            formatChips = chips/1000;
        }
        else
        {
            formatChips = chips;
        }
        
    }
    else
    {
        formatChips = chips;
    }
    
    NSString *formatChipsStr = [NSString stringWithFormat:@"%.2f", formatChips];
    
    NSString *lastStr = [formatChipsStr substringWithRange:NSMakeRange(formatChipsStr.length-1, 1)];
    NSString *lastBOStr = [formatChipsStr substringWithRange:NSMakeRange(formatChipsStr.length-2, 1)];
    
    
    if ([lastStr isEqualToString:@"0"])
    {
        formatChipsStr = [formatChipsStr substringToIndex:formatChipsStr.length-1];
        
        if ([lastBOStr isEqualToString:@"0"])
        {
            formatChipsStr = [formatChipsStr substringToIndex:formatChipsStr.length-2];
            
        }
    }
    
    if (isAbbreviation)
    {
        if (chips >= 1000000000)
        {
            formatChipsStr = [NSString stringWithFormat:@"%@B", formatChipsStr];
        }
        else if (chips >= 1000000)
        {
            formatChipsStr = [NSString stringWithFormat:@"%@M", formatChipsStr];
        }
        else if (chips >= 1000)
        {
            formatChipsStr = [NSString stringWithFormat:@"%@K", formatChipsStr];
        }
    }
    
    
    
    
    return formatChipsStr;
    
}


//自定义图片长宽
+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize

{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
    
}



//从String中获取URL
+ (NSArray *)urlArrayFromString:(NSString *)string
{
    NSMutableArray *urlArray = [[NSMutableArray alloc] init];
    NSRange httpUrl = [string rangeOfString:@"http://" options:NSCaseInsensitiveSearch range:NSMakeRange(0, string.length)];
    NSRange httpsUrl = [string rangeOfString:@"https://" options:NSCaseInsensitiveSearch range:NSMakeRange(0, string.length)];
    NSRange wwwUrl = [string rangeOfString:@"www." options:NSCaseInsensitiveSearch range:NSMakeRange(0, string.length)];
    
    
    if (httpUrl.location != NSNotFound)
    {
        NSMutableString *httpUrlStr = [[NSMutableString alloc] init];
        NSMutableArray *urlDataArray = [[NSMutableArray alloc] init];
        
        for (; httpUrl.location != NSNotFound; )
        {
            [httpUrlStr appendString:@"http://"];
            
            for (int i = 0; i < string.length - (httpUrl.location + httpUrl.length); i++)
            {
                NSString *charStr = [string substringWithRange:NSMakeRange(httpUrl.location+httpUrl.length+i, 1)];
                
                const char *cString = [charStr UTF8String];
                if (strlen(cString) != 3 && [charStr validateStringEqualToValid])
                {
                    //非汉字且非空格
                    [httpUrlStr appendString:charStr];
                }
                else
                {
                    break;
                }
                
                
            }
            
            NSRange httpContainUrl = [httpUrlStr rangeOfString:@"http://" options:NSBackwardsSearch range:NSMakeRange(0, httpUrlStr.length)];
            
            if (httpContainUrl.location != 0)
            {
                httpUrlStr = [NSMutableString stringWithString:[httpUrlStr substringToIndex:httpContainUrl.location]];
            }
            
            
            
            NSArray *urlData = [NSArray arrayWithObjects:httpUrlStr, [NSValue valueWithRange:NSMakeRange(httpUrl.location, httpUrlStr.length)], nil];
            
            [urlDataArray addObject:urlData];
            
            httpUrlStr = [[NSMutableString alloc] init];
            
            
            httpUrl = [string rangeOfString:@"http://" options:NSBackwardsSearch range:NSMakeRange(httpUrl.length, string.length - (httpUrl.location + httpUrl.length))];
        }
        
        
        for (NSArray *urlData in urlDataArray)
        {
            if (![urlData[0] isEqualToString:@"http://"])
            {
                [urlArray addObject:urlData[0]];
            }
        }
        
        
    }
    else if (httpsUrl.location != NSNotFound)
    {
        NSMutableString *httpsUrlStr = [[NSMutableString alloc] init];
        NSMutableArray *urlDataArray = [[NSMutableArray alloc] init];
        
        for (; httpsUrl.location != NSNotFound; )
        {
            [httpsUrlStr appendString:@"https://"];
            
            for (int i = 0; i < string.length - (httpsUrl.location + httpsUrl.length); i++)
            {
                NSString *charStr = [string substringWithRange:NSMakeRange(httpsUrl.location+httpsUrl.length+i, 1)];
                
                const char *cString = [charStr UTF8String];
                if (strlen(cString) != 3 && [charStr validateStringEqualToValid])
                {
                    //非汉字且非空格
                    [httpsUrlStr appendString:charStr];
                }
                else
                {
                    break;
                }
                
                
            }
            
            NSRange httpsContainUrl = [httpsUrlStr rangeOfString:@"https://" options:NSBackwardsSearch range:NSMakeRange(0, httpsUrlStr.length)];
            
            if (httpsContainUrl.location != 0)
            {
                httpsUrlStr = [NSMutableString stringWithString:[httpsUrlStr substringToIndex:httpsContainUrl.location]];
            }
            
            
            
            NSArray *urlData = [NSArray arrayWithObjects:httpsUrlStr, [NSValue valueWithRange:NSMakeRange(httpsUrl.location, httpsUrlStr.length)], nil];
            
            [urlDataArray addObject:urlData];
            
            httpsUrlStr = [[NSMutableString alloc] init];
            
            
            httpsUrl = [string rangeOfString:@"https://" options:NSBackwardsSearch range:NSMakeRange(httpsUrl.length, string.length - (httpsUrl.location + httpsUrl.length))];
        }
        
        
        for (NSArray *urlData in urlDataArray)
        {
            if (![urlData[0] isEqualToString:@"https://"])
            {
                [urlArray addObject:urlData[0]];
            }
        }
        
    }
    else
    {
        NSMutableString *wwwUrlStr = [[NSMutableString alloc] init];
        NSMutableArray *urlDataArray = [[NSMutableArray alloc] init];
        
        for (; wwwUrl.location != NSNotFound; )
        {
            [wwwUrlStr appendString:@"www."];
            
            for (int i = 0; i < string.length - (wwwUrl.location + wwwUrl.length); i++)
            {
                NSString *charStr = [string substringWithRange:NSMakeRange(wwwUrl.location+wwwUrl.length+i, 1)];
                
                const char *cString = [charStr UTF8String];
                if (strlen(cString) != 3 && [charStr validateStringEqualToValid])
                {
                    //非汉字且非空格
                    [wwwUrlStr appendString:charStr];
                }
                else
                {
                    break;
                }
                
                
            }
            
            NSRange wwwContainUrl = [wwwUrlStr rangeOfString:@"www." options:NSBackwardsSearch range:NSMakeRange(0, wwwUrlStr.length)];
            
            if (wwwContainUrl.location != 0)
            {
                wwwUrlStr = [NSMutableString stringWithString:[wwwUrlStr substringToIndex:wwwContainUrl.location]];
            }
            
            
            
            NSArray *urlData = [NSArray arrayWithObjects:wwwUrlStr, [NSValue valueWithRange:NSMakeRange(wwwUrl.location, wwwUrlStr.length)], nil];
            
            [urlDataArray addObject:urlData];
            
            wwwUrlStr = [[NSMutableString alloc] init];
            
            
            wwwUrl = [string rangeOfString:@"www." options:NSBackwardsSearch range:NSMakeRange(wwwUrl.length, string.length - (wwwUrl.location + wwwUrl.length))];
        }
        
        
        for (NSArray *urlData in urlDataArray)
        {
            if (![urlData[0] isEqualToString:@"www."])
            {
                [urlArray addObject:urlData[0]];
            }
        }
        
    }
    
    
    
    return urlArray;
    
}





//计算label高度
+ (CGFloat)heightOfString:(NSString *)string textFrame:(CGRect)textFrame textFont:(UIFont *)textFont paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle
{
    CGRect txtFrame = textFrame;
    NSString *text = [NSString stringWithFormat:@"%@\n",string];
    CGFloat contentHeight = 0;
    if (IS_iOS8)
    {
        contentHeight = [text boundingRectWithSize:CGSizeMake(txtFrame.size.width, CGFLOAT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                        attributes:[NSDictionary dictionaryWithObjectsAndKeys:textFont, NSFontAttributeName, nil] context:nil].size.height;
        return contentHeight;
    }
    else
    {
        contentHeight = [text boundingRectWithSize:CGSizeMake(txtFrame.size.width-16, CGFLOAT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                        attributes:[NSDictionary dictionaryWithObjectsAndKeys:textFont, NSFontAttributeName, nil] context:nil].size.height;
        return contentHeight+16;
    }
    
}




/*
 加密实现MD5和SHA1
 */

//md5 encode
+ (NSString *)md5:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];
    
    return output;
    
}

//sha1 encode
+ (NSString *)sha1:(NSString *)str{
    const char *cstr = [str cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:str.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}


+ (NSString *)uuidString{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    return [uuid lowercaseString];
}



//等比例缩放图片
+ (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
            
        }
        else{
            
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}


////加载图片
//+ (void)loadImageWithUrlStr:(NSString *)urlStr block:(void (^)(UIImage *image))block{
//
//    if ([[SDWebImageManager sharedManager] cachedImageExistsForURL:[NSURL URLWithString:urlStr]]) {
//
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            //异步读取image
//            UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlStr];
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                if (block) {
//                    block(image);
//                }
//
//            });
//
//        });
//
//    } else {
//
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//            [SDWebImageManager.sharedManager downloadImageWithURL:[NSURL URLWithString:urlStr] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//                    if (image) {
//                        [[SDWebImageManager sharedManager] saveImageToCache:image forURL:imageURL];
//
//
//                        dispatch_async(dispatch_get_main_queue(), ^{
//
//                            if (block) {
//                                block(image);
//                            }
//
//                        });
//                    } else {
//
//                        dispatch_async(dispatch_get_main_queue(), ^{
//
//                            if (block) {
//                                block(nil);
//                            }
//
//                        });
//
//                    }
//
//                });
//
//
//
//            }];
//
//
//        });
//
//    }
//
//}

//加载图片
+ (void)loadImageWithUrlStr:(NSString *)urlStr block:(void (^)(UIImage *image))block{

    
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:urlStr] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            if (image) {
                
                dispatch_async(dispatch_get_main_queue(), ^{

                    if (block) {
                        block(image);
                    }

                });
            } else {

                dispatch_async(dispatch_get_main_queue(), ^{

                    if (block) {
                        block(nil);
                    }

                });

            }

        });
        
    }];
}


/*
 头像变圆
 */
+ (void)cutCircleImageViewWithImageView:(UIImageView *)imageView {
    
    imageView.layer.cornerRadius = imageView.bounds.size.height / 2.0;
    imageView.layer.masksToBounds = YES;
    //模式
    imageView.contentMode=UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
}

/*
 NSArray分组
 */
+ (NSArray *)arrayClassWithArray:(NSArray *)array {
    
    NSMutableArray *sortArr = [NSMutableArray new];
    
    if (array.count > 1000) {
        NSInteger sortCount = array.count/5000 + 2;
        
        NSInteger differCount = 500;
        
        if (array.count >= 10000) {
            differCount = 800;
        }
        
        NSInteger pageSize = (array.count- sortCount*differCount)/sortCount;
        
        NSInteger startIndex = 0;
        
        for (int i = 0; i < sortCount; i ++) {
            
            if (i == sortCount-1) {
                NSArray *subArray = [array subarrayWithRange:NSMakeRange(startIndex, array.count - startIndex)];
                startIndex = pageSize+i*differCount;
                [sortArr addObject:subArray];
                
            } else {
                
                NSArray *subArray = [array subarrayWithRange:NSMakeRange(startIndex, pageSize+i*differCount)];
                startIndex += pageSize+i*differCount;
                [sortArr addObject:subArray];
                
            }
        }
        
    } else {
        sortArr = [NSMutableArray arrayWithArray:@[array]];
    }
    
    return sortArr;
}


/*
 UIImage旋转
 */
+ (UIImage *)imageRotateWithImage:(UIImage *)originImage {
    return [UIImage imageWithCGImage:originImage.CGImage scale:1 orientation:UIImageOrientationLeft];
}


/*保存照片到相册*/
+ (void)saveImageToPhotos:(UIImage*)savedImage {
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    //因为需要知道该操作的完成情况，即保存成功与否，所以此处需要一个回调方法image:didFinishSavingWithError:contextInfo:
}

//回调方法
+ (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    if (error == nil){
        NSLog(@"Image was saved successfully.");
    } else {
        NSLog(@"An error happened while saving the image.");
        NSLog(@"Error = %@", error);
    }
    
}



@end
