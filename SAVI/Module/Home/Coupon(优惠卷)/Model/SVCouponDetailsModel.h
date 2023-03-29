//
//  SVCouponDetailsModel.h
//  SAVI
//
//  Created by houming Wang on 2018/7/19.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVCouponDetailsModel : NSObject

@property (nonatomic,assign) int isdate;

@property (nonatomic, copy) NSString *sv_creation_date;//没核销日期

@property (nonatomic, copy) NSString *sv_modification_date;//已核销日期

@property (nonatomic, copy) NSString *sv_coupon_code;

@end
