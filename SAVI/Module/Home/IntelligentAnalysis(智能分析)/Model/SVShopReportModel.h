//
//  SVShopReportModel.h
//  SAVI
//
//  Created by 杨忠平 on 2019/12/31.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVShopReportModel : NSObject
@property (nonatomic,strong) NSString *sv_mr_name;
@property (nonatomic,strong) NSString *sv_mrr_money;
@property (nonatomic,strong) NSString *sv_mrr_present;
@property (nonatomic,strong) NSString *sv_mrr_date;
@property (nonatomic,strong) NSString *recharge_id;
@property (nonatomic,strong) NSString *sv_mrr_state;
@property (nonatomic,strong) NSString *sv_mrr_type;
@property (nonatomic,strong) NSString *sv_mrr_desc;
@property (nonatomic,strong) NSString *sv_mrr_payment;

@end

NS_ASSUME_NONNULL_END
