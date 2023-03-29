//
//  SVHistoryDateilsModel.h
//  SAVI
//
//  Created by Sorgle on 2018/2/10.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVHistoryDateilsModel : NSObject

///**
// 产品名字
// */
//@property (nonatomic, copy) NSString *product_name;
//
///**
// 产品单价
// */
//@property (nonatomic, copy) NSString *product_price;
//
///**
// 产品数量
// */
//@property (nonatomic, assign) NSNumber *product_num;
//
///**
// 产品IDorder_stutia
// */
//@property (nonatomic, assign) NSNumber *product_id;
//
///**
// 判断退货
// */
//@property (nonatomic, assign) NSNumber *order_stutia;
//
///**
// 规格
// */
//@property (nonatomic,strong) NSString *sv_p_specs;
//
//@property (nonatomic,strong) NSString *sv_p_images2;

/**
 判断退货
 */
@property (nonatomic, assign) NSNumber *order_stutia;
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
/**
 成交价
 */
@property (nonatomic,strong) NSString *product_unitprice;
/**
 会员价
 */
@property (nonatomic,assign) double sv_p_memberprice;

/**
 图片
 */
@property (nonatomic,strong) NSString *sv_p_images2;

@end
