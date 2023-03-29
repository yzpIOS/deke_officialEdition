//
//  SVNewVipOneCell.h
//  SAVI
//
//  Created by Sorgle on 17/4/13.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVNewVipOneCell : UITableViewCell

/**
 头像
 */
@property (weak, nonatomic) IBOutlet UIButton *iconButton;
//卡号
@property (weak, nonatomic) IBOutlet UITextField *cardNumber;
//姓名
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UIButton *scanButton;

@end
