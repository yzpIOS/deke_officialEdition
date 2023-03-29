//
//  SVWarehouseDetailsVC.h
//  SAVI
//
//  Created by Sorgle on 2018/1/22.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVBaseVC.h"
//model
#import "SVWarehouseModel.h"

@interface SVWarehouseDetailsVC : SVBaseVC

@property (nonatomic,strong) SVWarehouseModel *model;

@property (nonatomic,copy) void(^warehouseDetailsBlock)();

@end
