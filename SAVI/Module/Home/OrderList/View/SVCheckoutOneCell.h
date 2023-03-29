//
//  SVCheckoutOneCell.h
//  SAVI
//
//  Created by houming Wang on 2018/6/7.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVCheckoutOneCell : UITableViewCell

//头像
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
//会员名
@property (weak, nonatomic) IBOutlet UILabel *vipName;
//储值
@property (weak, nonatomic) IBOutlet UILabel *storedValue;
//会员电话
@property (weak, nonatomic) IBOutlet UILabel *vipPhone;

@property (weak, nonatomic) IBOutlet UIButton *deleteVipB;

@property (weak, nonatomic) IBOutlet UIView *vipView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/**
 积分
 */
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;

@end
