//
//  SVGifView.h
//  SAVI
//
//  Created by 杨忠平 on 2022/11/14.
//  Copyright © 2022 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVGifView : UIView
+ (instancetype)adsView;

@property (nonatomic,copy) void (^stopAnimalBlock)();
@end

NS_ASSUME_NONNULL_END
