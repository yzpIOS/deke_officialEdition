//
//  SVVipCheckoutView.h
//  SAVI
//
//  Created by hashakey on 2017/7/1.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVVipCheckoutView : UIView


//头像
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
//会员名
@property (weak, nonatomic) IBOutlet UILabel *vipName;
//储值
@property (weak, nonatomic) IBOutlet UILabel *storedValue;
//会员电话
@property (weak, nonatomic) IBOutlet UILabel *vipPhone;

//产品详情响应View
@property (weak, nonatomic) IBOutlet UIView *waresView;
//件数
@property (weak, nonatomic) IBOutlet UILabel *number;
//合计
@property (weak, nonatomic) IBOutlet UILabel *oneMoney;


//会员折扣
@property (weak, nonatomic) IBOutlet UILabel *vipFold;


//本单应收
@property (weak, nonatomic) IBOutlet UILabel *twoMoney;
//整单打折
@property (weak, nonatomic) IBOutlet UITextField *playFold;
//本单实收
@property (weak, nonatomic) IBOutlet UITextField *moneyText;

////支付方式
//@property (weak, nonatomic) IBOutlet UILabel *payWay;
////支付view
//@property (weak, nonatomic) IBOutlet UIView *pay;





@end
