//
//  SVWarehouseModel.h
//  SAVI
//
//  Created by Sorgle on 2018/3/9.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVWarehouseModel : NSObject

//仓库名
@property (nonatomic, copy) NSString *sv_warehouse_name;
//商品ID
@property (nonatomic, copy) NSString *sv_warehouse_id;
//编号
@property (nonatomic, copy) NSString *sv_warehouse_code;
//联系人
@property (nonatomic,copy) NSString *sv_warehouse_managers;
//电话
@property (nonatomic, copy) NSString *sv_warehouse_phone;
//创建时间
@property (nonatomic, copy) NSString *sv_creation_date;
//是否启用
@property (nonatomic, copy) NSString *sv_is_enable;
//地址
@property (nonatomic, copy) NSString *sv_warehouse_address;
//备注
@property (nonatomic,copy) NSString *sv_remark;

@end
