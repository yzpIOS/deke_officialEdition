//
//  SVproductCustomModel.h
//  SAVI
//
//  Created by houming Wang on 2019/4/15.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVSpecModel.h"
#import "SVduoguigeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SVproductCustomModel : NSObject
@property (nonatomic,strong) NSMutableArray <SVduoguigeModel *>*productCustomdDetailList;
//规格
@property (nonatomic, copy) NSString *sv_p_specs;
/**
 库存
 */
@property (nonatomic, copy) NSString *sv_p_storage;
/**
 价格
 */
@property (nonatomic,strong) NSString *sv_p_unitprice;

@property (nonatomic,strong) NSString *sv_p_images2;// 图片
// 会员售价
@property (nonatomic,strong) NSString *sv_p_memberprice;
/**
 商品
 */
@property (nonatomic, copy) NSString *sv_p_name;
/**
 条码
 */
@property (nonatomic,strong) NSString *sv_p_artno;

// 颜色id
@property (nonatomic,assign) NSInteger spec_id;
///// 商品ID
//@property (copy, nonatomic) NSString *product_id;
// 单位
@property (nonatomic,strong) NSString *sv_p_unit;
// 款号
@property (nonatomic,strong) NSString *sv_p_barcode;
//
@property(nonatomic, strong) NSMutableArray <SVSpecModel *>*sv_cur_spec;

/**
 ID
 */
@property (nonatomic, copy) NSString *product_id;

/**
 计件是0,计重是1。
 */
@property (nonatomic, copy) NSString *sv_pricing_method;

//记录点击后的件数
@property(nonatomic, assign) NSInteger product_num;//

@property (nonatomic,strong) NSString *sv_purchaseprice;

@property(nonatomic, strong) NSIndexPath *indexPath;

// 记录按钮是否被选中
@property (nonatomic, copy) NSString *isSelect;

// 是否是多规格商品
@property (nonatomic,assign) NSInteger sv_is_newspec;
@end

NS_ASSUME_NONNULL_END
