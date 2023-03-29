//
//  SVRefundDetailsVC.h
//  SAVI
//
//  Created by Sorgle on 2018/1/25.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVBaseVC.h"

@interface SVRefundDetailsVC : SVBaseVC

//带过来的是字典
@property (nonatomic,strong) NSMutableDictionary *dic;

@property (nonatomic,copy) void (^addRefundGoodsBlock)();

@end
