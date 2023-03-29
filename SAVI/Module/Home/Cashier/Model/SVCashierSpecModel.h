//
//  SVSpecModel.h
//  SAVI
//
//  Created by houming Wang on 2018/12/11.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVCashierSpecModel : NSObject


/**
 图片
 */
@property (nonatomic, copy) NSString *sv_p_images2;

/**
 商品名
 */
@property (nonatomic, copy) NSString *sv_p_name;

/**
 价格
 */
@property (nonatomic, copy) NSString *sv_p_unitprice;

//会员售价
@property (nonatomic,copy) NSString *sv_p_memberprice;
//会员ID
@property (nonatomic,copy) NSString *member_id;
//会员折
@property (nonatomic,copy) NSString *discount;

/**
 商品ID
 */
@property(nonatomic, copy) NSString *product_id;

/**
 数量
 */
@property (nonatomic, assign) NSInteger product_num;

//规格
@property (nonatomic, copy) NSString *sv_p_specs;

// 单位
@property (nonatomic,strong) NSString *sv_p_unit;
// 款号
@property (nonatomic,strong) NSString *sv_p_barcode;

/**
 库存
 */
@property (nonatomic, copy) NSString *sv_p_storage;
// 判断是否是多规格的产品  0不是，  1是
@property (nonatomic,assign) NSNumber *sv_is_newspec;

// 记录用户购买商品的个数 text的
@property (nonatomic,assign) NSInteger count;
@end
