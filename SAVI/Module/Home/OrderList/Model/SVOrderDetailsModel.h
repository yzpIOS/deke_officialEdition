//
//  SVOrderDetailsModel.h
//  SAVI
//
//  Created by Sorgle on 2017/7/5.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVOrderDetailsModel : NSObject

/**
 新的商品名
 */
@property (nonatomic,strong) NSString *product_name;
/**
 图片
 */
@property (nonatomic, copy) NSString *sv_p_images2;

//@property (nonatomic,strong) NSString *sv_pricing_method;
@property (nonatomic, copy) NSString *sv_p_images;

/**
 商品名
 */
@property (nonatomic, copy) NSString *sv_p_name;
/**
 进货价
 */
@property (nonatomic,strong) NSString *sv_purchaseprice;
/**
 价格
 */
@property (nonatomic, copy) NSString *sv_p_unitprice;

@property (nonatomic,strong) NSString *product_unitprice;

/**
 条码
 */
@property (nonatomic,strong) NSString *sv_p_artno;

/**
 规格
 */
@property (nonatomic,strong) NSString *sv_p_specs;

//会员售价
@property (nonatomic,copy) NSString *sv_p_memberprice;
//会员ID
@property (nonatomic,copy) NSString *member_id;
//会员折
@property (nonatomic,copy) NSString *discount;

@property (nonatomic,strong) NSString *sv_pricing_method;
/**
 商品ID
 */
@property(nonatomic, copy) NSString *product_id;

@property (nonatomic,strong) NSString *sv_p_weight;
/**
 数量
 */
//@property (nonatomic, assign) NSNumber *product_num;
@property (nonatomic, strong) NSString *product_num;

////规格
//@property (nonatomic, copy) NSString *sv_p_specs;

// 单位
@property (nonatomic,strong) NSString *sv_p_unit;
// 款号
@property (nonatomic,strong) NSString *sv_p_barcode;

/**
 库存
 */
@property (nonatomic, copy) NSString *sv_p_storage;
// 判断是否是多规格的产品  0不是，  1是
@property (nonatomic,assign) NSInteger sv_is_newspec;
///// 数量
//@property (nonatomic,assign) NSInteger duoguige_product_num;
@property (nonatomic,strong) NSString *sv_product_type;

/**
 记录改价的值 等于1就是改价的
 */
@property (nonatomic,strong) NSString *isPriceChange;
@property (nonatomic,strong) NSString *priceChange;
// 专门给列表显示用的  就是为了平摊金额
@property (nonatomic,strong) NSString *price;

//会员售价
@property (nonatomic,copy) NSString *sv_p_memberprice1;
//会员售价
@property (nonatomic,copy) NSString *sv_p_memberprice2;
//会员售价
@property (nonatomic,copy) NSString *sv_p_memberprice3;
//会员售价
@property (nonatomic,copy) NSString *sv_p_memberprice4;
//会员售价
@property (nonatomic,copy) NSString *sv_p_memberprice5;
/**
 最低价
 */
@property (nonatomic,strong) NSString * sv_p_minunitprice;

/**
 最低折
 */
@property (nonatomic,strong) NSString * sv_p_mindiscount;

/**
大分类ID
*/
@property (nonatomic,strong) NSString *productcategory_id;

/**
小分类ID
*/
@property (nonatomic,strong) NSString *productsubcategory_id;

@end
