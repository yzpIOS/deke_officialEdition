//
//  UISegmentedControl+SVSegmentedCategory.m
//  SAVI
//
//  Created by 杨忠平 on 2020/3/20.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "UISegmentedControl+SVSegmentedCategory.h"

//#import <AppKit/AppKit.h>


@implementation UISegmentedControl (SVSegmentedCategory)

- (void)ensureiOS12Style {
    // UISegmentedControl has changed in iOS 13 and setting the tint
    // color now has no effect.
    if (@available(iOS 13, *)) {
         UIColor *tintColor = [UIColor whiteColor];
             UIImage *tintColorImage = [self imageWithColor:tintColor];
             // Must set the background image for normal to something (even clear) else the rest won't work
             [self setBackgroundImage:[self imageWithColor:self.backgroundColor ? self.backgroundColor : [UIColor clearColor]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
             [self setBackgroundImage:tintColorImage forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
             [self setBackgroundImage:[self imageWithColor:[tintColor colorWithAlphaComponent:0.2]] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
             [self setBackgroundImage:tintColorImage forState:UIControlStateSelected|UIControlStateSelected barMetrics:UIBarMetricsDefault];
             [self setTitleTextAttributes:@{NSForegroundColorAttributeName: tintColor, NSFontAttributeName: [UIFont systemFontOfSize:13]} forState:UIControlStateNormal];
             [self setDividerImage:tintColorImage forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
             self.layer.masksToBounds = YES;
             self.layer.borderWidth = 1;
             self.layer.borderColor = [tintColor CGColor];
       
        
    }
}

- (UIImage *)imageWithColor: (UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
