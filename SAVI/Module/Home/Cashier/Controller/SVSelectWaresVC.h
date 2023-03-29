//
//  SVSelectWaresVC.h
//  SAVI
//
//  Created by Sorgle on 17/5/19.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVSelectWaresVC : UIViewController

//记录是那个界面跳转过来的，1就是选择商品、2是快速销售
@property (nonatomic,assign) NSInteger interface;

//会员名
@property (nonatomic,copy) NSString *name;
//会员电话
@property (nonatomic,copy) NSString *phone;
//会员折扣
@property (nonatomic,copy) NSString *discount;
//会员ID
@property (nonatomic,copy) NSString *member_id;
//会员卡号
@property (nonatomic,copy) NSString *sv_mr_cardno;
//会员储值
@property (nonatomic,copy) NSString *storedValue;
//图片
@property (nonatomic, copy) NSString *headimg;
/**
 会员积分
 */
@property (nonatomic,strong) NSString *member_Cumulative;

/**
 会员密码
 */
@property (nonatomic,strong) NSString *sv_mr_pwd;

@property (nonatomic,strong) NSMutableArray *goodsArr;


//订单ID
@property (nonatomic,copy) NSString *orderID;

//ID
@property (nonatomic,copy) NSString *sv_without_list_id;

//订单号
@property (nonatomic, copy) NSString *order_running_id;

@property (nonatomic, copy)void(^numBlock)();
// 保存从改价出来的数据
@property (nonatomic,strong) NSMutableArray *priceChangeArray;

@property (nonatomic,strong) NSString *grade;// 选择商品会员价
/**
分类折配置数组
 */
@property (nonatomic,strong) NSArray *sv_discount_configArray;


/**
 带出去给会员详情页面
 */

@property (nonatomic,copy) void (^memberDetail)();

@end
