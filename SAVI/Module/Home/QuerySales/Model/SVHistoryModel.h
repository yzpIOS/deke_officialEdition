//
//  SVHistoryModel.h
//  SAVI
//
//  Created by Sorgle on 2017/6/20.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVHistoryModel : NSObject


/**
 订单号
 */
//@property (nonatomic, copy) NSString *order_id;

/**
 产品ID
 */
//@property (nonatomic, copy) NSString *product_id;

//@property (nonatomic,copy) NSString *sv_p_images2;

/**
 产品名字
 */
@property (nonatomic, copy) NSString *product_name;

/**
 产品数量
 */
@property (nonatomic, copy) NSString *product_num;

/**
 成交价
 */
//@property (nonatomic, copy) NSString *order_receivable;

/**
 支付方式
 */
//@property (nonatomic, copy) NSString *order_payment;

/**
 件数
 */
@property (nonatomic, strong) NSMutableArray *prlist;

@end


