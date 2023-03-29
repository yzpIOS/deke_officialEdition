//
//  SVOnlineOrderCell.h
//  SAVI
//
//  Created by 杨忠平 on 2020/3/17.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SVOnlineTobeDelivered;
@interface SVOnlineOrderCell : UITableViewCell
@property (nonatomic,strong) SVOnlineTobeDelivered *model;

@property (weak, nonatomic) IBOutlet UIButton *detailClick;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

NS_ASSUME_NONNULL_END
