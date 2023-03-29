//
//  SVVipListModel.h
//  SAVI
//
//  Created by hashakey on 2017/5/30.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVVipListModel : NSObject

/**
 图片
 */
@property (nonatomic, copy) NSString *sv_mr_headimg;

/**
 名字
 */
@property (nonatomic, copy) NSString *sv_mr_name;

/**
 手机
 */
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
 会员等级
 */
@property (nonatomic,strong) NSString * sv_ml_name;

/**
 会员ID
 */
@property (nonatomic, copy) NSString *member_id;

// 记录按钮是否被选中
@property (nonatomic, copy) NSString *isSelect;
/**
 挂失状态
 */
@property (nonatomic,assign) NSInteger sv_mr_status;

/**
 权限
 */
@property (nonatomic,assign)NSInteger JurisdictionNum;

/**
 欠款
 */
@property (nonatomic,assign) double sv_mw_credit;

/**
 会员等级id
 */
@property (nonatomic,assign) NSInteger memberlevel_id;

/**
 到期时间
 */
@property (nonatomic,strong) NSString *sv_mr_deadline;

/**
 车牌号码
 */
@property (nonatomic,strong) NSString * sv_mr_platenumber;

@end
