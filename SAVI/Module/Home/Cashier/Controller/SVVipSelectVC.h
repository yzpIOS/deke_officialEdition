//
//  SVVipSelectVC.h
//  SAVI
//
//  Created by Sorgle on 2017/5/28.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVVipSelectVC : UIViewController


/**
 block回调
 */
//名字、电话、等级、会员折扣、会员ID、会员储值、会员头像,可用积分,累计积分，会员密码
@property (nonatomic,copy) void(^vipBlock)(NSString *name,NSString *phone,NSString *level,NSString *discount,NSString *member_id,NSString *storedValue,NSString *headimg,NSString *sv_mr_cardno,NSString *sv_mw_availablepoint,NSString *sv_mw_sumpoint,NSString *sv_mr_birthday,NSString *sv_mr_pwd,NSString *grade,NSArray *ClassifiedBookArray,NSString *memberlevel_id,NSString *user_id);


@end
