//
//  SVVipSelectModdl.h
//  SAVI
//
//  Created by Sorgle on 2017/6/3.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVVipSelectModdl : NSObject

@property (nonatomic,strong) NSString * level;

@property (nonatomic,strong) NSString * sv_mw_sumpoint;
/**
 图片
 */
@property (nonatomic, copy) NSString *sv_mr_headimg;

/**
 名字
 */
@property (nonatomic, copy) NSString *sv_mr_name;

///**
// 手机
// */
@property (nonatomic, copy) NSString *sv_mr_mobile;

/**
 储值
 */
@property (nonatomic, copy) NSString *sv_mw_availableamount;

/**
 积分
 */
@property (nonatomic, copy) NSString *sv_mw_availablepoint;

/**
 累计消费积分
 */
@property (nonatomic,strong) NSString *sv_mw_sumamount;


/**
 等级
 */
@property (nonatomic, copy) NSString *sv_ml_name;

/**
 折扣
 */
@property (nonatomic, copy) NSString *sv_ml_commondiscount;

/**
 会员ID
 */
@property (nonatomic, copy) NSString *member_id;

/**
 会员ID
 */
@property (nonatomic, copy) NSString *sv_mr_cardno;

/**
 挂失状态
 */
@property (nonatomic,assign) NSInteger sv_mr_status;

/**
 权限控制
 */
@property (nonatomic,assign) NSInteger JurisdictionNum;

/**
 生日
 */
@property (nonatomic,strong) NSString *sv_mr_birthday;

/**
 会员密码
 */
@property (nonatomic,strong) NSString *sv_mr_pwd;
// 会员等级
@property (nonatomic,strong) NSString *sv_grade_price;
/**
店铺ID
*/
@property (nonatomic,strong) NSString *user_id;

/**
 分类折
 */
@property (nonatomic,strong) NSString *sv_discount_config;

/**
 会员等级ID
 */
@property (nonatomic,strong) NSString *memberlevel_id;

/**
 到期时间
 */
@property (nonatomic,strong) NSString *sv_mr_deadline;

///**
// 消费金额
// */
//@property (nonatomic,assign) double sv_mw_sumamount;

@end
