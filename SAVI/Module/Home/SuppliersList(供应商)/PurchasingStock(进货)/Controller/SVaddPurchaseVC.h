//
//  SVaddPurchaseVC.h
//  SAVI
//
//  Created by Sorgle on 2018/1/23.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVBaseVC.h"

@interface SVaddPurchaseVC : SVBaseVC
// 1是进货的，其他的是退货的
@property (nonatomic,assign) NSInteger selectNumber;

@property (nonatomic,copy) void(^addPurchaseBlock)();

@property (nonatomic,strong) NSArray *prlistArray;
// 再传一个大字典
@property (nonatomic,strong) NSMutableDictionary *dic;


@end
