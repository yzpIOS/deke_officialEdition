//
//  UIColor+SVcolorManager.h
//  SAVI
//
//  Created by houming Wang on 2018/8/7.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (SVcolorManager)
// 颜色转换：iOS中（以#开头）十六进制的颜色转换为UIColor(RGB)
+ (UIColor *) colorWithHexString: (NSString *)color;
@end
