//
//  SVSelectedGoodsModel.h
//  SAVI
//
//  Created by hashakey on 2017/5/30.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVSelectedGoodsModel : NSObject

//头像
@property(nonatomic, copy) NSString *sv_p_images2;
@property(nonatomic, copy) NSString *sv_p_images;
//商品名
@property(nonatomic, copy) NSString *sv_p_name;//
//单价
@property(nonatomic, copy) NSString *sv_p_unitprice;//
// 改价存储的值
@property (nonatomic,strong) NSString * priceChange;
//会员售价
@property (nonatomic,copy) NSString *sv_p_memberprice;
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
//库存
@property(nonatomic, copy) NSString *sv_p_storage;

//单位
@property(nonatomic, copy) NSString *sv_p_unit;
//规格
@property (nonatomic, copy) NSString *sv_p_specs;
// 商品款号
@property (nonatomic,strong) NSString *sv_p_barcode;
//ID
@property(nonatomic, copy) NSString *product_id;//

@property (nonatomic,strong) NSString * sv_p_artno;

//记录点击后的件数
@property(nonatomic, assign) float product_num;//
//@property (nonatomic,strong) NSString *product_num;
/**
 最低价
 */
@property (nonatomic,strong) NSString *sv_p_minunitprice;
/**
 最低折
 */
@property (nonatomic,strong) NSString *sv_p_mindiscount;
/**
 记录计重的商品重量
 */
@property (nonatomic,strong) NSString *sv_p_weight;

@property(nonatomic, strong) NSIndexPath *indexPath;


@property (nonatomic,assign) double sv_p_total_weight;


// 判断是否是多规格的产品  0不是，  1是
@property (nonatomic,assign) NSInteger sv_is_newspec;
/**
 1是包装，2是套餐，0是普通商品
 */
@property (nonatomic,strong) NSString *sv_product_type;

/**
 sv_product_type：0为普通商品（"sv_pricing_method" IS '计价方式（0为件 ，1为称）';），1为包装，2为套餐 ，优先验证sv_product_type类型，套餐为主，如：A商品是称重又是套装（包装） A商品显示套装（包装）。
 */

/**
 0是计件的，1是计重的
 */

@property (nonatomic,strong) NSString *sv_pricing_method;

//NSString *size,NSString *color,NSString *money,NSString *tf_count
@property (nonatomic,strong) NSString *size;
@property (nonatomic,strong) NSString *color;
//@property (nonatomic,strong) NSString *money;// 售价
//@property (nonatomic,strong) NSString *tf_count;
//@property (nonatomic,strong) NSString *titleName;// 名称
//@property (nonatomic,strong) NSString *memberPrice;// 会员售价

//@property (nonatomic,strong) NSString *sv_p_images2;// 图片
//@property (nonatomic,strong) NSString *product_id;
// 记录用户购买商品的个数 text的
@property (nonatomic,assign) NSInteger count;
/**
 进货价
 */
@property (nonatomic,strong) NSString *sv_purchaseprice;

@property (nonatomic,strong) NSString *ImageHidden;

/**
大分类ID
*/
@property (nonatomic,strong) NSString *productcategory_id;

/**
小分类ID
*/
@property (nonatomic,strong) NSString *productsubcategory_id;

/**
 服装的数量
 */
@property(nonatomic, assign) float clother_product_num;

/**
 记录改价的值 等于1就是改价的
 */
@property (nonatomic,strong) NSString *isPriceChange;




@end
