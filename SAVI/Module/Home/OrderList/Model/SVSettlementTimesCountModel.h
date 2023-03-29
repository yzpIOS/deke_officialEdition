//
//  SVTimesCountModel.h
//  SAVI
//
//  Created by houming Wang on 2019/2/21.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVSettlementTimesCountModel : NSObject
/**
 计次卡的名称
 */
@property (nonatomic,strong) NSString *sv_p_name;
/**
 商品id
 */
@property (nonatomic,assign) NSInteger product_id;
/**
 计次卡的次数
 */
@property (nonatomic,assign) NSInteger sv_mcc_leftcount;

/**
 计次卡的款号
 */
@property (nonatomic,assign) NSInteger sv_p_barcode;

/**
 记录购物车商品多于次卡的次数
 */
@property (nonatomic,assign) NSInteger moreThanNum;

@property (nonatomic,strong) NSString *selectIndex;

/**
 流水号
 */
@property (nonatomic,strong) NSString *sv_serialnumber;

/**
充次记录ID
 */
@property (nonatomic,strong) NSString *userecord_id;

/**
   数量
 */
@property (nonatomic,strong) NSString *product_num;

/**
 到期时间
 */
@property (nonatomic,strong) NSString *validity_date;



@end
