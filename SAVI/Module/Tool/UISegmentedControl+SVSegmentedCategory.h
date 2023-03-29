//
//  UISegmentedControl+SVSegmentedCategory.h
//  SAVI
//
//  Created by 杨忠平 on 2020/3/20.
//  Copyright © 2020 Sorgle. All rights reserved.
//

//#import <AppKit/AppKit.h>

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UISegmentedControl (SVSegmentedCategory)
/// UISegmentedControl 将iOS13风格转化成iOS12之前的风格样式
- (void)ensureiOS12Style;
@end

NS_ASSUME_NONNULL_END
