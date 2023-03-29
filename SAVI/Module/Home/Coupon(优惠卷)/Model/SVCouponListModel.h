//
//  SVCouponListModel.h
//  SAVI
//
//  Created by houming Wang on 2018/7/17.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVCouponListModel : NSObject

@property (nonatomic,assign) int sv_coupon_state;

@property (nonatomic, copy) NSString *sv_coupon_id;

@property (nonatomic, copy) NSString *sv_coupon_name;

@property (nonatomic, copy) NSString *sv_coupon_money;//面值

@property (nonatomic, copy) NSString *sv_coupon_type;//类型

@property (nonatomic, copy) NSString *sv_coupon_use_conditions;//条件

@property (nonatomic, copy) NSString *sv_coupon_termofvalidity_type;//时间类型

@property (nonatomic, copy) NSString *sv_coupon_bendate;

@property (nonatomic, copy) NSString *sv_coupon_enddate;

@property (nonatomic, copy) NSString *sv_coupon_toal_num;//张数

@property (nonatomic, copy) NSString *sv_coupon_surplus_num;//余张数

@property (nonatomic,strong) NSString *sv_record_id;
@property (nonatomic,assign) NSInteger isSelectImg;
/**
 优惠券状态（0--待发放，1--发放, 2--已过期）
 */

/**
 0是相等，1是过期，-1是不过期
 */
@property (nonatomic,assign) int time;

/**
-1是没到期
*/
@property (nonatomic,assign) int time2;
@end
