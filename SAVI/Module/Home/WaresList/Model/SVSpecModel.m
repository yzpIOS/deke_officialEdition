//
//  SVSpecModel.m
//  SAVI
//
//  Created by houming Wang on 2018/11/30.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVSpecModel.h"

@implementation SVSpecModel
+ (NSDictionary *)mj_objectClassInArray {
    
    // 表明你products数组存放的将是FKGoodsModelInOrder类的模型
    return @{
             @"attrilist" : @"SVAtteilistModel",
             };
}
@end
