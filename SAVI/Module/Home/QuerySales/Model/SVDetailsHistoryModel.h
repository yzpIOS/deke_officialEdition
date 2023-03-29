//
//  SVDetailsHistoryModel.h
//  SAVI
//
//  Created by Sorgle on 2017/6/27.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVDetailsHistoryModel : NSObject

/**
 编码
 */
@property (nonatomic,strong) NSString *sv_p_artno;
/**
 条码
 */
@property (nonatomic,strong) NSString *sv_p_barcode;

/**
 产品名字
 */
@property (nonatomic, copy) NSString *product_name;

/**
 产品单价
 */
@property (nonatomic, copy) NSString *product_price;

/**
 产品数量
 */
@property (nonatomic, assign) NSNumber *product_num;

/**
 产品ID
 */
@property (nonatomic, assign) NSNumber *product_id;
//规格
@property (nonatomic, copy) NSString *sv_p_specs;
//单位
@property (nonatomic, copy) NSString *sv_p_unit;
// 销售金额
@property (nonatomic,strong) NSString *product_total;
// 折扣
@property (nonatomic,strong) NSString *product_discount;

@property (nonatomic,strong) NSString *product_total_bak;
/**
 成交价
 */
@property (nonatomic,strong) NSString *product_unitprice;
/**
 会员价
 */
@property (nonatomic,assign) double sv_p_memberprice;

/**
 会员折
 */
@property (nonatomic,strong) NSString * sv_member_discount;

/**
 图片
 */
@property (nonatomic,strong) NSString *sv_p_images2;

@property (nonatomic,strong) NSString *sv_mp_id;

@property (nonatomic,strong) NSString *sv_activity_depict;

@property (nonatomic,strong) NSString *product_num_bak;

@property (nonatomic,strong) NSString *sv_p_weight_bak;

/**
 明细验证
 */
@property (nonatomic,strong) NSString *order_stutia;
/**
 显示优惠的字段
 */
//@property (nonatomic,strong) NSString * sv_preferential_data;
@property (nonatomic,strong) NSArray * sv_preferential_data;
/**
 原价金额
 */
@property (nonatomic,strong) NSString * sv_order_total_money;

@property (nonatomic,strong) NSString * order_datetime;

@property (nonatomic,strong) NSString * sv_mr_name;
@end
