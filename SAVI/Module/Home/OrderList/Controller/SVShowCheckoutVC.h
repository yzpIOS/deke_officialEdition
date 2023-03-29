//
//  SVShowCheckoutVC.h
//  SAVI
//
//  Created by Sorgle on 2017/5/25.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVShowCheckoutVC : UIViewController
@property (nonatomic,strong) SVProductResultsData *productResultsData;
//带过来的是字典
@property (nonatomic,strong) NSDictionary *md;

@property (nonatomic,strong) NSDictionary *md_two;
//支付方式
@property (nonatomic,copy) NSString *pay;
// 本次积分
@property (nonatomic,strong) NSString * order_integral;

//金额
@property (nonatomic,copy) NSString *money;

//会员
@property (nonatomic,copy) NSString *vipName;
//会员卡号
@property (nonatomic,copy) NSString *sv_mr_cardno;
//会员储值
@property (nonatomic,copy) NSString *storedValue;
@property (nonatomic,strong) NSString *sv_remarks;
/**
 会员积分
 */
@property (nonatomic,strong) NSString *member_Cumulative;
//记录是那个界面跳转过来的，yes就是选择商品、no就是挂单
@property (nonatomic,assign) NSInteger interface;
// 1是聚合支付过来的
@property (nonatomic,assign) NSInteger selectNumber;

@property (nonatomic,assign) BOOL isAggregatePayment;
@property (nonatomic,strong) NSString *queryId;
@end
