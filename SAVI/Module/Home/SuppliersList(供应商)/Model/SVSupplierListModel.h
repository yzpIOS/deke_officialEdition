//
//  SVSupplierListModel.h
//  SAVI
//
//  Created by Sorgle on 2018/1/3.
//  Copyright © 2018年 Sorgle. All rights reserved.
// CommonResultListModel

#import <Foundation/Foundation.h>

@interface SVSupplierListModel : NSObject


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

//时间
@property (nonatomic, copy) NSString *sv_suaddtime;

//ID
@property (nonatomic, copy) NSString *sv_suid;

//欠款
@property (nonatomic, copy) NSString *arrears;

@property (nonatomic, copy) NSString *arrears_state;
/**
 状态 启用 true 启用，false不启用
 */
@property (nonatomic,assign) NSInteger sv_enable;
/**
 供应商编号
 */
@property (nonatomic,strong) NSString * sv_supplier_code;
/**
 初始欠款
 */
//@property (nonatomic,strong) NSString * sv_initial_arrears;
@property (nonatomic,assign) double sv_initial_arrears;
/**
 折扣
 */
@property (nonatomic,assign) double sv_discount;

@end
