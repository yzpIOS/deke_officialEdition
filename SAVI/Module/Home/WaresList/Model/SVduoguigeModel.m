//
//  SVduoguigeModel.m
//  SAVI
//
//  Created by houming Wang on 2018/11/29.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVduoguigeModel.h"

@implementation SVduoguigeModel
+ (NSDictionary *)mj_objectClassInArray {
    
    // 表明你products数组存放的将是FKGoodsModelInOrder类的模型
    return @{
             @"sv_cur_spec" : @"SVSpecModel",
             };
}

//- (void)setValue:(id)value forUndefinedKey:(NSString *)key  {
//    if([key isEqualToString:@"id"])
//        self.product_id = value;
//}
@end
