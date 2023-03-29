//
//  SVNewStockCheckVC.h
//  SAVI
//
//  Created by houming Wang on 2019/5/29.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVNewStockCheckVC : WMPageController

@property (nonatomic,strong) NSMutableArray *modelArr;
@property (nonatomic,assign) NSInteger selectNumber;
@property (nonatomic, copy)void(^modelArrayBlock)(NSString *sv_storestock_check_r_no,NSString *values);
@property (nonatomic,strong) NSString *sv_storestock_check_no;
@property (nonatomic,strong) NSString *sv_storestock_check_r_no;
@property (nonatomic,assign) NSInteger addShopTotleNum;


@end

NS_ASSUME_NONNULL_END
