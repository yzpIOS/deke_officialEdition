//
//  SVRepayMoneyVC.h
//  SAVI
//
//  Created by Sorgle on 2018/1/24.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVBaseVC.h"

@interface SVRepayMoneyVC : SVBaseVC

//供应商
@property (nonatomic, copy) NSString *sv_suname;
//ID
@property (nonatomic, copy) NSString *sv_suid;
//欠款
@property (nonatomic,copy) NSString *arrears;

@property (nonatomic,copy) void (^repayMoneyBlock)();

@end
