//
//  SVPandianDetailModel.h
//  SAVI
//
//  Created by houming Wang on 2019/6/11.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVPandianDetailModel : NSObject
@property (nonatomic,strong) NSString *sv_storestock_checkdetail_pbcode;// 款号
@property (nonatomic,strong) NSString *sv_storestock_checkdetail_pname; //名称

@property (nonatomic,strong) NSString *sv_storestock_check_list_no;

/**
 售价
 */
@property (nonatomic,strong) NSString *sv_storestock_checkdetail_checkprice;

@property (nonatomic,strong) NSString *sv_storestock_checkdetail_checkafternum;
/**
 实盘
 */
@property (nonatomic,strong) NSString *sv_storestock_checkdetail_checknum;
/**
 盈多少
 */
@property (nonatomic,strong) NSString *sv_storestock_checkdetail_diffnum;
/**
 库存
 */
@property (nonatomic,strong) NSString *sv_storestock_checkdetail_checkbeforenum;
/**
 成本价
 */
@property (nonatomic,strong) NSString *sv_storestock_checkdetail_checkoprice;

/**
 规格
 */
@property (nonatomic,strong) NSString *sv_storestock_checkdetail_specs;
/**
 id
 */
@property (nonatomic,strong) NSString *sv_storestock_checkdetail_pid;
/**
 单位
 */
@property (nonatomic,strong) NSString *sv_storestock_checkdetail_unit;

@property (nonatomic,strong) NSString *sv_checkdetail_pricing_method;

@property (nonatomic,strong) NSString *sv_storestock_checkdetail_id;
@property (nonatomic,strong) NSString *sv_checkdetail_type;
@property (nonatomic,strong) NSString *sv_storestock_checkdetail_categoryid;
@property (nonatomic,strong) NSString *sv_storestock_checkdetail_categoryname;

@property (nonatomic,strong) NSString *sv_remark;

@property (nonatomic,assign) NSInteger number;

@end

NS_ASSUME_NONNULL_END
