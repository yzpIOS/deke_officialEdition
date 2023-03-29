//
//  SVPayManagementModel.h
//  SAVI
//
//  Created by Sorgle on 2017/10/20.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVPayManagementModel : NSObject


//一级类名
@property (nonatomic, copy) NSString *e_expenditurename;
//二级类名
@property (nonatomic, copy) NSString *e_expenditureclassname;
/**
 小分类id
 */
@property (nonatomic,strong) NSString *e_expenditureclass;
/**
 大分类id
 */
@property (nonatomic,strong) NSString *parentid;
/**
 ID
 */
@property (nonatomic, copy) NSString *e_expenditureid;

/**
 价格
 */
@property (nonatomic, copy) NSString *e_expenditure_money;

/**
 时间
 */
@property (nonatomic, copy) NSString *e_expendituredate;

/**
 备注
 */
@property (nonatomic, copy) NSString *e_expenditure_node;

@end
