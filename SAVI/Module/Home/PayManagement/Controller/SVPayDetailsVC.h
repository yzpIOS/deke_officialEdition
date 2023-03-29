//
//  SVPayDetailsVC.h
//  SAVI
//
//  Created by Sorgle on 2017/10/18.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVPayManagementModel.h"
@class SVPayManagementVC;
@interface SVPayDetailsVC : UIViewController
//block
@property (nonatomic,copy) void(^payDetailBlock)(NSString *date);

@property (nonatomic,weak) SVPayManagementVC *payManagementVC;
//一级类名
@property (nonatomic, copy) NSString *e_expenditurename;
//二级类名
@property (nonatomic, copy) NSString *e_expenditureclassname;

@property (nonatomic,strong) SVPayManagementModel *model;
/**
 记录点击模型对应的索引
 */
@property (nonatomic,assign) NSInteger rowIndex;
/**
 对应的组
 */
//@property (nonatomic,assign) NSInteger sessionIndex;

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
