//
//  SVNewSettlementVC.h
//  SAVI
//
//  Created by houming Wang on 2021/5/10.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVBaseVC.h"
NS_ASSUME_NONNULL_BEGIN

@interface SVNewSettlementVC : SVBaseVC
///点击结算带过来的数组
@property (nonatomic, strong) NSMutableArray *resultArr;

//订单号
@property (nonatomic, copy) NSString *order_running_id;
//取消挂单ID
@property (nonatomic,copy) NSString *sv_without_list_id;

//商品选择的会员价
@property (nonatomic,copy) NSString *__nullable grade;
//会员名
@property (nonatomic,copy) NSString  *__nullable name;
//会员电话
@property (nonatomic,copy) NSString *__nullable phone;
//会员折扣
@property (nonatomic,copy) NSString *__nullable discount;
//会员卡号
@property (nonatomic,copy) NSString *__nullable sv_mr_cardno;
//会员ID
@property (nonatomic,copy) NSString *__nullable member_id;
//会员储值
@property (nonatomic,copy) NSString * __nullable stored;
//图片
@property (nonatomic, copy) NSString *__nullable headimg;

//记录是不是会员销售跳转过来的，yes就是:是、no就是:不是;
@property (nonatomic,assign) BOOL vipBool;
//记录是那个界面跳转过来的，1就是选择商品、2是快速销售、3就是挂单
@property (nonatomic,assign) NSInteger interface;
///**
// 总金额
// */
//@property (nonatomic,strong) NSString * totleMoney;

//blcok
@property (nonatomic,copy) void(^selectWaresBlock)();

// 点击删除会员的按钮
@property (nonatomic,copy) void(^deleteMemberBlock)();
/**
 会员密码
 */
@property (nonatomic,strong) NSString *__nullable sv_mr_pwd;
/**
 会员积分
 */
@property (nonatomic,strong) NSString *__nullable member_Cumulative;

@property (nonatomic,strong) NSString * sv_mw_availablepoint;
@property (nonatomic,strong) NSString * sv_mw_sumpoint;
@property (nonatomic,strong) NSString * sv_mr_birthday;
@property (nonatomic,strong) NSString * level;

// 点击选择会员按钮
@property (nonatomic,copy) void(^chooseMemberBlock)(NSString *name,NSString *phone,NSString *level,NSString *discount,NSString *member_id,NSString *storedValue,NSString *headimg,NSString *sv_mr_cardno,NSString *member_Cumulative,NSString *grade,NSArray *ClassifiedBookArray, NSString *memberlevel_id,NSString *sv_mw_sumpoint,NSString *sv_mr_birthday);

/**
 分类折数组
 */
@property (nonatomic,strong) NSArray *__nullable getUserLevelArray;
/**
分类折配置数组
 */
@property (nonatomic,strong) NSArray *__nullable sv_discount_configArray;

// 退出蒙版的block
// 点击删除会员的按钮
@property (nonatomic,copy) void(^tuichuMengbanBlock)();
@end

NS_ASSUME_NONNULL_END
