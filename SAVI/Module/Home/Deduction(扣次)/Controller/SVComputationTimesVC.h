//
//  SVComputationTimesVC.h
//  SAVI
//
//  Created by 杨忠平 on 2019/12/6.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SVCardRechargeInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface SVComputationTimesVC : UIViewController
@property (nonatomic,strong) NSString *member_id;
@property (nonatomic,strong) SVCardRechargeInfoModel *model;

@end

NS_ASSUME_NONNULL_END
