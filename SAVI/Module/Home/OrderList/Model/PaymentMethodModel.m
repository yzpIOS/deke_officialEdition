//
//  PaymentMethodModel.m
//  DekeAIpad
//
//  Created by houming Wang on 2018/12/14.
//  Copyright © 2018年 houming Wang. All rights reserved.
//

#import "PaymentMethodModel.h"

@implementation PaymentMethodModel
+ (NSDictionary *)mj_objectClassInArray {
    
    // 表明你products数组存放的将是FKGoodsModelInOrder类的模型
    return @{
             @"c_custorm_payment" : @"CustomPaymentModel",
             };
}
@end
