//
//  SVModifySunCardVC.h
//  SAVI
//
//  Created by 杨忠平 on 2019/11/29.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SVCardRechargeInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface SVModifySunCardVC : UIViewController
@property (nonatomic,strong) SVCardRechargeInfoModel *model;
@property (nonatomic,strong) NSMutableArray *arr;
@end

NS_ASSUME_NONNULL_END
