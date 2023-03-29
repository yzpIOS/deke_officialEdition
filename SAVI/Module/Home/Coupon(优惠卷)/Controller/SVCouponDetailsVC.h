//
//  SVCouponDetailsVC.h
//  SAVI
//
//  Created by houming Wang on 2018/7/11.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVBaseVC.h"

@interface SVCouponDetailsVC : SVBaseVC

@property (nonatomic,copy) NSString *couponId;

@property (nonatomic,copy) void (^couponDetailsBlock)();

@end
