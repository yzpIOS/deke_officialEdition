//
//  SVVipDetailsVC.h
//  SAVI
//
//  Created by Sorgle on 2017/5/31.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVVipDetailsVC : UIViewController

//会员ID
@property (nonatomic,copy) NSString *memberID;

//修改后，回调刷新
@property (nonatomic,copy) void (^VipDetailsBlock)();

@property (nonatomic,assign) NSInteger memberlevel_id;

/**
 车牌号码
 */
@property (nonatomic,strong) NSString * sv_mr_platenumber;
@end
