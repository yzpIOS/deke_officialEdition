//
//  SVGuidePagesVC.h
//  SAVI
//
//  Created by Sorgle on 2017/11/29.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CALayer+Transition.h"

@protocol selectDelegate <NSObject>

- (void)clickEnter;

@end

@interface SVGuidePagesVC : UIViewController

// 初始化引导页
- (void)guidePageControllerWithImages:(NSArray *)images;
+ (BOOL)isShow;
@property (nonatomic, assign) id<selectDelegate> delegate;

@end
