//
//  UIImage+BBCompress.h
//  baobaotong
//
//  Created by Pig.Zhong on 2018/9/7.
//  Copyright © 2018年 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BBCompress)

#pragma mark - 压缩图片质量
- (NSData *)bb_compressQualityWithMaxLength:(NSInteger)maxLength;

#pragma mark - 压缩图片尺寸
- (NSData *)bb_compressBySizeWithMaxLength:(NSUInteger)maxLength;

#pragma mark - 两种图片压缩方法结合
-(NSData *)bb_compressWithMaxLength:(NSUInteger)maxLength size: (CGSize)size;

#pragma mark - 自动旋转图片
- (UIImage *)bb_fixOrientation;

#pragma mark - 按给定的方向旋转图片
- (UIImage*)bb_rotate:(UIImageOrientation)orient;

@end
