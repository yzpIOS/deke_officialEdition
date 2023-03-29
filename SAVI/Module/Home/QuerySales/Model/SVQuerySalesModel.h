//
//  SVQuerySalesModel.h
//  SAVI
//
//  Created by Sorgle on 2018/4/12.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVQuerySalesModel : NSObject

//商品
@property (nonatomic, strong) NSArray *prlist;

//支付方式
@property (nonatomic, copy) NSString *sv_order_source;
////支付方式
//@property (nonatomic, copy) NSString *order_payment;
////支付方式
//@property (nonatomic, copy) NSString *order_payment2;

//时间
@property (nonatomic, copy) NSString *order_datetime;

//会员
@property (nonatomic, copy) NSString *sv_mr_name;

//数量
@property (nonatomic, copy) NSString *numcount;

//总价
@property (nonatomic, copy) NSString *order_money;

/**
 总额
 */
@property (nonatomic,strong) NSString *order_receivable_bak;

/**
 支付方式一金额
 */
@property (nonatomic,strong) NSString *order_money_bak;

/**
 支付方式二金额
 */
@property (nonatomic,strong) NSString *order_money2_bak;

/**
 支付方式一名称
 */
@property (nonatomic,strong) NSString *order_payment;

/**
 支付方式二名称
 */
@property (nonatomic,strong) NSString *order_payment2;

/**
 销售或者退货
 */
@property (nonatomic,strong) NSString *return_type;

@property (nonatomic,strong) NSString *numcount_bak;

@end
