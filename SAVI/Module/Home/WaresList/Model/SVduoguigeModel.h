//
//  SVduoguigeModel.h
//  SAVI
//
//  Created by houming Wang on 2018/11/29.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVSpecModel.h"

@interface SVduoguigeModel : NSObject
//规格
@property (nonatomic, copy) NSString *sv_p_specs;

@property (nonatomic,strong) NSString *sv_pc_price;
@property (nonatomic,strong) NSString * id;

/**
 库存
 */
@property (nonatomic, copy) NSString *sv_p_storage;

// 售价
@property (nonatomic,strong) NSString *sv_per_price;
/**
 价格
 */
@property (nonatomic,strong) NSString *sv_p_unitprice;
@property(nonatomic, copy) NSString *sv_p_images;
@property (nonatomic,strong) NSString *sv_p_images2;// 图片
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

// 成本价
@property (nonatomic,strong) NSString *sv_p_originalprice;
@property (nonatomic,strong) NSString *productcategory_id;
@property (nonatomic,strong) NSString *productsubcategory_id;
@property (nonatomic,strong) NSString *sv_pc_name;
@property (nonatomic,strong) NSString *sv_remark;

@property (nonatomic,strong) NSString *sv_storestock_check_list_no;

@property (nonatomic,strong) NSString *sv_storestock_checkdetail_id;


/**
 商品
 */
@property (nonatomic, copy) NSString *sv_p_name;
/**
 条码
 */
@property (nonatomic,strong) NSString *sv_p_artno;

/**
 是否继续盘点
 */
@property (nonatomic,strong) NSString *sv_checkdetail_type;



// 颜色id
@property (nonatomic,assign) NSInteger spec_id;
///// 商品ID
@property (copy, nonatomic) NSString *product_id;
// 单位
@property (nonatomic,strong) NSString *sv_p_unit;
// 款号
@property (nonatomic,strong) NSString *sv_p_barcode;
//
@property(nonatomic, strong) NSMutableArray <SVSpecModel *>*sv_cur_spec;

/**
 1是包装，2是套餐，0是普通商品
 */
@property (nonatomic,strong) NSString *sv_product_type;

/**
 产品类型，1是服务商品  0是产品
 */
@property (nonatomic,strong) NSString *producttype_id;
/**
 ID
 */
//@property (nonatomic, copy) NSString *product_id;

@property (nonatomic,assign) double sv_p_total_weight;


/**
 计件是0,计重是1。
 */
@property (nonatomic, copy) NSString *sv_pricing_method;

//记录点击后的件数
@property(nonatomic, assign) NSInteger product_num;//

/**
 进货价
 */
@property (nonatomic,strong) NSString *sv_purchaseprice;

@property(nonatomic, strong) NSIndexPath *indexPath;

// 记录按钮是否被选中
@property (nonatomic, copy) NSString *isSelect;

// 是否是多规格商品
@property (nonatomic,assign) NSInteger sv_is_newspec;
/**
 是否是删除过的产品
 */
@property (nonatomic,assign) NSInteger sv_is_active;

@property (nonatomic,assign) NSInteger indexNum;

@property (nonatomic,assign) NSInteger list_number;

/**
 最低折
 */
@property (nonatomic,strong) NSString * sv_p_minunitprice;

/**
 最低价
 */
@property (nonatomic,strong) NSString * sv_p_mindiscount;

/**
 实盘数量
 */
@property (nonatomic,strong) NSString *FirmOfferNum;

/**
 记录是否是进货cell   1是进货的cell ，其他不是
 */
@property (nonatomic,strong) NSString *isStockPurchase;

/**
 进货数
 */
@property (nonatomic,strong) NSString *stockpurchaseNumber;

///**
// 进货价
// */
//@property (nonatomic,strong) NSString *stockpurchasePrice;

@property (nonatomic,strong) NSString *purchase;
@property (nonatomic,strong) NSString *give;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *termOfValidity;
@property (nonatomic,strong) NSString *time;

@end
