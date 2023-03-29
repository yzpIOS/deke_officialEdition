//
//  SVCheckGoodsModel.h
//  SAVI
//
//  Created by Sorgle on 2017/10/30.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVCheckGoodsModel : NSObject

@property(nonatomic, copy) NSString *sv_p_images2;
//商品名
@property(nonatomic, copy) NSString *sv_p_name;
//单价
@property(nonatomic, copy) NSString *sv_p_unitprice;
//库存
@property(nonatomic, copy) NSString *sv_p_storage;
//单位
@property(nonatomic, copy) NSString *sv_p_unit;
//商品ID
@property(nonatomic, copy) NSString *product_id;
//
@property(nonatomic, copy) NSString *sv_p_specs;


//记录点击后的件数
@property(nonatomic, assign) NSInteger product_num;
//记录是否被点击,默认是0
@property(nonatomic, assign) NSInteger product_number;

@property(nonatomic, strong) NSIndexPath *indexPath;


@end
