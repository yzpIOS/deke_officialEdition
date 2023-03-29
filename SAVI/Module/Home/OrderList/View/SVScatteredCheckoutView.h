//
//  SVScatteredCheckoutView.h
//  SAVI
//
//  Created by Sorgle on 2017/7/5.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVScatteredCheckoutView : UIView

//产品详情响应View
@property (weak, nonatomic) IBOutlet UIView *waresView;
//件数
@property (weak, nonatomic) IBOutlet UILabel *number;
//合计
@property (weak, nonatomic) IBOutlet UILabel *oneMoney;


//本单应收
@property (weak, nonatomic) IBOutlet UILabel *twoMoney;
//整单打折
@property (weak, nonatomic) IBOutlet UITextField *playFold;
//本单实收
@property (weak, nonatomic) IBOutlet UITextField *moneyText;


@end
