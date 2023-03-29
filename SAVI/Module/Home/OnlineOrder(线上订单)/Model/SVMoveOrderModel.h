//
//  SVMoveOrderModel.h
//  SAVI
//
//  Created by 杨忠平 on 2020/3/18.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVMoveOrderModel : NSObject
/**
 付款方式
 */
@property (nonatomic,strong) NSString *order_payment;
/**
 付款状态
 */
@property (nonatomic,assign) NSInteger order_state;
/**
 收货人
 */
@property (nonatomic,strong) NSString *sv_receipt_name;
/**
 配送方式
 */
@property (nonatomic,strong) NSString *sv_shipping_methods;
/**
 收货电话
 */
@property (nonatomic,strong) NSString *sv_receipt_phone;
/**
 收货地址
 */
@property (nonatomic,strong) NSString *getShopAddress;

/**
 销售单号
 */
@property (nonatomic,strong) NSString *sv_order_number;

/**
下单时间
 */
@property (nonatomic,strong) NSString *sv_order_adddate;

/**
 应收金额
 */
@property (nonatomic,strong) NSString *order_receivable;

/**
 免运费
 */
@property (nonatomic,assign) double sv_prduct_freight;


@end

NS_ASSUME_NONNULL_END
