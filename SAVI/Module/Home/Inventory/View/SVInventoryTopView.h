//
//  SVInventoryTopView.h
//  SAVI
//
//  Created by houming Wang on 2019/6/4.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVInventoryTopView : UIView
@property (weak, nonatomic) IBOutlet UIButton *costDeficifBtn;
@property (weak, nonatomic) IBOutlet UIButton *moneyDeficifBtn;
@property (weak, nonatomic) IBOutlet UILabel *pandiandanhaoL;
@property (weak, nonatomic) IBOutlet UILabel *caogaoL;
@property (weak, nonatomic) IBOutlet UILabel *totleshopL;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;

@property (weak, nonatomic) IBOutlet UILabel *number_num;
@property (weak, nonatomic) IBOutlet UILabel *number_text;
@property (weak, nonatomic) IBOutlet UILabel *number_pingheng;

@property (weak, nonatomic) IBOutlet UILabel *cost_num;
@property (weak, nonatomic) IBOutlet UILabel *cost_text;
@property (weak, nonatomic) IBOutlet UILabel *cost_pingheng;

@property (weak, nonatomic) IBOutlet UILabel *money_num;
@property (weak, nonatomic) IBOutlet UILabel *money_text;
@property (weak, nonatomic) IBOutlet UILabel *money_pingheng;
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;

@end

NS_ASSUME_NONNULL_END
