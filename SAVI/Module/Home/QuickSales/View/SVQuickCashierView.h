//
//  SVQuickCashierView.h
//  SAVI
//
//  Created by Sorgle on 17/5/19.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVQuickCashierView : UIView
//显示输入的字体
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
//显示总额
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
//已优惠
@property (weak, nonatomic) IBOutlet UILabel *preferential;
//应收金额
@property (weak, nonatomic) IBOutlet UILabel *amount;

//等级
@property (weak, nonatomic) IBOutlet UILabel *level;

//抹零
@property (weak, nonatomic) IBOutlet UIButton *wipeZero;

@property (weak, nonatomic) IBOutlet UISwitch *switch_open;

//删除折扣
@property (weak, nonatomic) IBOutlet UIButton *deleteDiscount;

@end
