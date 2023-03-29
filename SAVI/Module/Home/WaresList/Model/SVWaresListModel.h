//
//  SVWaresListModel.h
//  SAVI
//
//  Created by Sorgle on 2017/5/31.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVWaresListModel : NSObject

///**
// 图片
// */
@property (nonatomic, copy) NSString *sv_p_images2;

/**
 商品
 */
@property (nonatomic, copy) NSString *sv_p_name;

/**
 价格
 */
@property (nonatomic, copy) NSString *sv_p_unitprice;

/**
 库存
 */
@property (nonatomic, copy) NSString *sv_p_storage;

/**
 条码
 */
@property (nonatomic,strong) NSString *sv_p_artno;

/**
 ID
 */
@property (nonatomic, copy) NSString *product_id;

//规格
@property (nonatomic, copy) NSString *sv_p_specs;

// 单位
@property (nonatomic,strong) NSString *sv_p_unit;

// 会员售价
@property (nonatomic,strong) NSString *sv_p_memberprice;


// 商品款号
@property (nonatomic,strong) NSString *sv_p_barcode;

/**
 计件是0,计重是1。
 */
@property (nonatomic, copy) NSString *sv_pricing_method;

//记录点击后的件数
@property(nonatomic, assign) NSInteger product_num;//

@property(nonatomic, strong) NSIndexPath *indexPath;

// 记录按钮是否被选中
@property (nonatomic, copy) NSString *isSelect;

// 是否是多规格商品
@property (nonatomic,assign) NSInteger sv_is_newspec;

@end
