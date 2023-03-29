//
//  SVproductCustomModel.m
//  SAVI
//
//  Created by houming Wang on 2019/4/15.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import "SVproductCustomModel.h"

@implementation SVproductCustomModel
+ (NSDictionary *)mj_objectClassInArray {
    
    // 表明你products数组存放的将是FKGoodsModelInOrder类的模型
    return @{
             @"sv_cur_spec" : @"SVSpecModel",
             @"productCustomdDetailList" : @"SVduoguigeModel"
             };
   
}
@end
