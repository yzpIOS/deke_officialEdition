//
//  SVCouponListCell.h
//  SAVI
//
//  Created by houming Wang on 2018/7/9.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SVCouponListModel;

@interface SVCouponListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *selectIcon;
@property (nonatomic,strong) SVCouponListModel *model;

@end
