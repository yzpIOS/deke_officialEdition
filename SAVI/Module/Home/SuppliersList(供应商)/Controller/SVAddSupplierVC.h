//
//  SVAddSupplierVC.h
//  SAVI
//
//  Created by Sorgle on 2017/12/25.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVBaseVC.h"

@interface SVAddSupplierVC : SVBaseVC

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

//备注
@property (nonatomic, copy) NSString *sv_subeizhu;

//ID
@property (nonatomic, copy) NSString *sv_suid;
//记录是不是添加供应商跳转过来的，yes就是:是、no就是:不是;默认为no
@property (nonatomic,assign) BOOL supplierBool;

//block
@property (nonatomic,copy) void (^supplierBlock)();

@property (nonatomic,copy) void (^modifySupplierBlock)();

@end
