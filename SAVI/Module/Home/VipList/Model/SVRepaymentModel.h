//
//  SVRepaymentModel.h
//  SAVI
//
//  Created by houming Wang on 2018/6/26.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVRepaymentModel : NSObject


@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *order_running_id;
@property (nonatomic, copy) NSString *order_payment;
@property (nonatomic, copy) NSString *order_datetime;
@property (nonatomic, copy) NSString *sv_credit_money;

// 记录是否被选中
@property (nonatomic, copy) NSString *isSelect;


@property (nonatomic, copy) NSString *sv_order_id;
@property (nonatomic, copy) NSString *sv_payment_method_name;
@property (nonatomic, copy) NSString *sv_date;
@property (nonatomic, copy) NSString *sv_money;

@end
