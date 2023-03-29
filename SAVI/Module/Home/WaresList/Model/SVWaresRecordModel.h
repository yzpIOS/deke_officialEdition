//
//  SVWaresRecordModel.h
//  SAVI
//
//  Created by Sorgle on 2017/10/13.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVWaresRecordModel : NSObject

// 时间
// */
@property (nonatomic, copy) NSString *order_datetime;

/**
 客户名
 */
@property (nonatomic, copy) NSString *sv_mr_name;

/**
 头像
 */
@property (nonatomic, copy) NSString *sv_mr_headimg;

/**
 数量
 */
@property (nonatomic, copy) NSString *product_num;

@property (nonatomic,copy) NSString *sv_p_specs;

/**
 单价
 */
@property (nonatomic, copy) NSString *product_unitprice;

@end
