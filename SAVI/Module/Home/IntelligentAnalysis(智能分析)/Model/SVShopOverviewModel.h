//
//  SVShopOverviewModel.h
//  SAVI
//
//  Created by 杨忠平 on 2019/11/9.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVShopOverviewModel : NSObject
@property (nonatomic,strong) NSString *sv_us_name;
@property (nonatomic,strong) NSString *order_receivable;
@property (nonatomic,strong) NSString *order_pdgfee;
@property (nonatomic,strong) NSString *count;
@property (nonatomic,strong) NSString *user_id;
@property (nonatomic,strong) NSString *orderciunt;
@property (nonatomic,strong) NSString *order_unreceivable;


//@property (nonatomic,strong) NSString *maolili;
@property (nonatomic,strong) NSString *sv_mr_cardno;
@property (nonatomic,strong) NSString * sv_p_originalprice;
@property (nonatomic,assign) double maolili3;
@property (nonatomic,assign) double maolili;
@property (nonatomic,strong) NSString * product_id;


// 会员分析
@property (nonatomic,strong) NSString *rcount;
@property (nonatomic,strong) NSString *sv_mr_name;

/**
 判断是哪个控制器来的  1是店铺  2是会员分析  3是充值报表 。。。
 */
@property (nonatomic,assign) NSInteger selectVC;
//@property (nonatomic,assign) NSInteger number;
@property (nonatomic,strong) NSString * number;

@end

NS_ASSUME_NONNULL_END
