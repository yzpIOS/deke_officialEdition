//
//  SVPurchaseDeteilsVC.h
//  SAVI
//
//  Created by Sorgle on 2017/12/28.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVBaseVC.h"

@interface SVPurchaseDeteilsVC : SVBaseVC

@property(nonatomic, strong) NSDictionary *dic;

@property (nonatomic,copy) void(^purchaseDeteilsBlock)();

@end
