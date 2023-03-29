//
//  SVHairCouponCell.h
//  SAVI
//
//  Created by houming Wang on 2018/7/12.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVCouponListModel.h"

@interface SVHairCouponCell : UITableViewCell

@property (nonatomic,strong) SVCouponListModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *selectIcon;
@property (weak, nonatomic) IBOutlet UILabel *sv_coupon_surplus_num;

@end
