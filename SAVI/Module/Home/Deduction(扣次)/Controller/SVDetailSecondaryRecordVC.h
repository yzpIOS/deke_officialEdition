//
//  SVDetailSecondaryRecordVC.h
//  SAVI
//
//  Created by 杨忠平 on 2019/12/6.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SVCardRechargeInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface SVDetailSecondaryRecordVC : UIViewController
@property (nonatomic,strong) SVCardRechargeInfoModel *model;
@property (nonatomic,strong) NSString *member_id;
@end

NS_ASSUME_NONNULL_END
