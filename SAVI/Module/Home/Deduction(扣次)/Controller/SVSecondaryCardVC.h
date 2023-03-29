//
//  SVSecondaryCardVC.h
//  SAVI
//
//  Created by 杨忠平 on 2019/10/28.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SVCardRechargeInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface SVSecondaryCardVC : UIViewController
@property (nonatomic,assign) NSInteger selectCount;

@property (nonatomic, copy)void(^model_block)(SVCardRechargeInfoModel *model);

@property (nonatomic,strong) NSString *member_id;


@end

NS_ASSUME_NONNULL_END
