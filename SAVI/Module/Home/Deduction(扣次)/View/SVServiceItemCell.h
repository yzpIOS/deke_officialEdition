//
//  SVServiceItemCell.h
//  SAVI
//
//  Created by 杨忠平 on 2019/12/6.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SVCardRechargeInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface SVServiceItemCell : UITableViewCell
@property (nonatomic,strong) SVCardRechargeInfoModel *model;
@property (nonatomic, copy)void(^DelayBlock)(SVCardRechargeInfoModel *model);
@end

NS_ASSUME_NONNULL_END
