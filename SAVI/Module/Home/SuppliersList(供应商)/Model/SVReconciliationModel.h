//
//  SVReconciliationModel.h
//  SAVI
//
//  Created by houming Wang on 2021/4/29.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVReconciliationModel : NSObject
@property (nonatomic,assign) NSInteger sv_is_arrears;
@property (nonatomic,assign) double sv_pc_total;
@property (nonatomic,strong) NSString * sv_pc_noid;
@property (nonatomic,strong) NSString * sv_typeName;

@property (nonatomic,assign) NSInteger user_id;
@property (nonatomic,assign) NSInteger sv_pc_id;
//@property (nonatomic,strong) NSString * sv_pc_noid;
@property (nonatomic,assign) NSInteger sv_type;
@property (nonatomic,assign) double sv_pr_totalnum;// 供货数量
@property (nonatomic,strong) NSString * sv_suname;
/**
 应付欠款
 */
@property (nonatomic,assign) double payable_arrears;
/**
 备注
 */
@property (nonatomic,strong) NSString * sv_pc_note;

/**
 实付金额
 */
@property (nonatomic,assign) double sv_pc_realpay;
@property (nonatomic,strong) NSString * sv_targetwarehouse_name;
@property (nonatomic,strong) NSString * sv_pc_cdate;
/**
 其他费用
 */
@property (nonatomic,assign) double sv_pc_costs;

@property (nonatomic,assign) NSInteger sv_suid;

@end

NS_ASSUME_NONNULL_END
