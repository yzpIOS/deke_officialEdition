//
//  SVSupplierDetailsVC.h
//  SAVI
//
//  Created by Sorgle on 2017/12/26.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVBaseVC.h"

@interface SVSupplierDetailsVC : SVBaseVC

//供应商
@property (nonatomic, copy) NSString *sv_suname;

//联系人
@property (nonatomic, copy) NSString *sv_sulinkmnm;

//电话
@property (nonatomic, copy) NSString *sv_sumoble;

//QQ
@property (nonatomic, copy) NSString *sv_suqq;

//地址
@property (nonatomic, copy) NSString *sv_suadress;

//时间
@property (nonatomic, copy) NSString *sv_suaddtime;

//备注
@property (nonatomic, copy) NSString *sv_subeizhu;

//ID
@property (nonatomic, copy) NSString *sv_suid;

@property (nonatomic,copy) NSString *arrear;

//block
@property (nonatomic,copy) void (^supplierDetailsBlock)();

@end
