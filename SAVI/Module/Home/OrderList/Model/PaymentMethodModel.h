//
//  PaymentMethodModel.h
//  DekeAIpad
//
//  Created by houming Wang on 2018/12/14.
//  Copyright © 2018年 houming Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomPaymentModel.h"
@interface PaymentMethodModel : NSObject
@property (nonatomic,strong) NSString *p_cashpay;
@property (nonatomic,strong) NSString *p_cardpay;
@property (nonatomic,strong) NSString *p_scanpay;
@property (nonatomic,strong) NSString *p_alipay;
@property (nonatomic,strong) NSString *p_weChatpay;
@property (nonatomic,strong) NSString *p_bank;
@property (nonatomic,strong) NSString *p_coupon;
@property (nonatomic,strong) NSString *p_meituan;
@property (nonatomic,strong) NSString *p_koubei;
@property (nonatomic,strong) NSString *p_meituan55;
@property (nonatomic,strong) NSString *p_shezhang;
// 自定义支付数组
@property (nonatomic,strong) NSMutableArray <CustomPaymentModel *>*c_custorm_payment;
@end
