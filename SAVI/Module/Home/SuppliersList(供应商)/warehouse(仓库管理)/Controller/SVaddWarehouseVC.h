//
//  SVaddWarehouseVC.h
//  SAVI
//
//  Created by Sorgle on 2018/1/22.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVBaseVC.h"
//model
#import "SVWarehouseModel.h"

@interface SVaddWarehouseVC : SVBaseVC

//ID        记录是什么界面跳转过来的：0就是:添加仓库、非0就是:修改仓库;
@property (nonatomic,copy) NSString *sv_warehouse_id;

@property (nonatomic,strong) SVWarehouseModel *model;

@property (nonatomic,copy) void(^addWarehouseBlock)();


@end
