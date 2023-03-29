//
//  SVVipChargeVC.h
//  SAVI
//
//  Created by Sorgle on 2017/6/6.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVVipChargeVC : UIViewController

//会员ID
@property (nonatomic,copy) NSString *memberID;

//储值余额
@property (nonatomic,copy) NSString *balance;
// 会员姓名
@property (nonatomic,strong) NSString *nameText;
// 会员卡号
@property (nonatomic,strong) NSString *careNum;
// 充值类型
@property (nonatomic,strong) NSString *RechargeType;

@property (nonatomic,copy) void (^vipChargeBlock)();

@property (nonatomic,assign) NSInteger memberlevel_id;

@end
