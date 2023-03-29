//
//  SVOnlineTobeDelivered.h
//  SAVI
//
//  Created by 杨忠平 on 2020/3/18.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVOnlineTobeDelivered : NSObject
//@property (nonatomic,strong) NSString *sv_contact_name;
//@property (nonatomic,strong) NSString *sv_contact_phone;
/**
 时间
 */
@property (nonatomic,strong) NSString *wt_datetime;
/**
 配送方式0--到店自提 ，1--商家配送
 */
@property (nonatomic,strong) NSString *sv_shipping_methods;
/**
 2 == 交易完成   其他的就是
 */
//@property (nonatomic,strong) NSString *sv_delivery_status;

/**
 地址
 */
@property (nonatomic,strong) NSString *sv_receipt_address;

@property (nonatomic,strong) NSString *order_product_json_str;


/**
 收货人
 */
@property (nonatomic,strong) NSString *sv_receipt_name;

/**
 收货电话
 */
@property (nonatomic,strong) NSString *sv_receipt_phone;





@property (nonatomic,strong) NSString *wt_nober;


@property (nonatomic,strong) NSString *sv_move_order_id;

@end

NS_ASSUME_NONNULL_END
