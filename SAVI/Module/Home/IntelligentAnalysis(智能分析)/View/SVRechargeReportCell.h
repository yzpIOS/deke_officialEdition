//
//  SVRechargeReportCell.h
//  SAVI
//
//  Created by 杨忠平 on 2019/12/31.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SVShopReportModel;
NS_ASSUME_NONNULL_BEGIN

@interface SVRechargeReportCell : UITableViewCell
@property (nonatomic,strong) SVShopReportModel *model;

@property (nonatomic, copy)void(^RevokeBlock)();

@end

NS_ASSUME_NONNULL_END
