//
//  SVOrderDetailsVC.h
//  SAVI
//
//  Created by Sorgle on 17/5/17.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVOrderDetailsVC : UIViewController

//订单ID
@property (nonatomic,copy) NSString *orderID;

//ID
@property (nonatomic,copy) NSString *sv_without_list_id;
// 会员ID
@property (nonatomic,strong) NSString *member_id;

//block
@property (nonatomic,copy) void(^orderBlock)();

@property (nonatomic,strong) NSString *sv_member_discount;



@end
