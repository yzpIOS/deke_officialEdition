//
//  SVStoreCategaryModel.h
//  SAVI
//
//  Created by 杨忠平 on 2020/1/2.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVStoreCategaryModel : NSObject
@property (nonatomic,strong) NSString *total_amount;
@property (nonatomic,strong) NSString *category_num;
@property (nonatomic,strong) NSString *sv_pc_name;
@property (nonatomic,strong) NSString *category_total;
@property (nonatomic,strong) NSString *percent;


/**
 判断是哪个控制器来的  1是店铺  2是会员分析  3是充值报表 。。。
 */
@property (nonatomic,assign) NSInteger selectVC;
@end

NS_ASSUME_NONNULL_END
