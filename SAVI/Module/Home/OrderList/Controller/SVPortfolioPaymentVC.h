//
//  SVPortfolioPaymentVC.h
//  SAVI
//
//  Created by houming Wang on 2021/3/22.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVPortfolioPaymentVC : UIViewController
//会员ID
@property (nonatomic,copy) NSString *member_id;

@property (nonatomic,strong) NSMutableArray *titleArray;
@property (nonatomic,strong) NSMutableArray *imageArray;

@property (nonatomic,strong) NSString * money;
//会员储值
@property (nonatomic,copy) NSString *stored;

@property (nonatomic,copy) void (^selectMoneyArrayBlock)(NSMutableArray *array);
@end

NS_ASSUME_NONNULL_END
