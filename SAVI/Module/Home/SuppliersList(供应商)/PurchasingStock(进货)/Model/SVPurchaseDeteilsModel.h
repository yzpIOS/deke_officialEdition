//
//  SVPurchaseDeteilsModel.h
//  SAVI
//
//  Created by Sorgle on 2018/3/2.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVPurchaseDeteilsModel : NSObject

//商品ID
@property (nonatomic, copy) NSString *product_id;
//商品名
@property (nonatomic, copy) NSString *sv_p_name;

@property (nonatomic, copy) NSString *sv_pc_combined;
//数量判断字段
@property (nonatomic, copy) NSString *sv_pricing_method;
//sv_pricing_method等于1的时候,取它
@property (nonatomic, copy) NSString *sv_p_weight;
//sv_pricing_method等于0的时候,取它
@property (nonatomic, copy) NSString *sv_pc_pnumber;
//单位
@property (nonatomic, copy) NSString *sv_p_unit;
//单价
@property (nonatomic,copy) NSString *sv_pc_price;

@property(nonatomic, strong) NSIndexPath *indexPath;
//记录点击后的件数
@property(nonatomic, assign) NSInteger product_num;//

@property(nonatomic, assign) int sv_record_id;

//商品款号
@property (nonatomic,copy) NSString *sv_p_barcode;
    
@property (nonatomic,copy) NSString *sv_p_specs;
@end
