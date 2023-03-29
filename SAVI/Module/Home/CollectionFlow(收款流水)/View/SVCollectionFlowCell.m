//
//  SVCollectionFlowCell.m
//  SAVI
//
//  Created by 杨忠平 on 2020/5/19.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVCollectionFlowCell.h"

@interface SVCollectionFlowCell()
@property (weak, nonatomic) IBOutlet UIImageView *icon_image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *money;

@end

@implementation SVCollectionFlowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDict:(NSDictionary *)dict
{

    _dict = dict;
    [SVUserManager loadUserInfo];
    NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
    if (ConvergePay.doubleValue == 1 && !kStringIsEmpty(ConvergePay)) {
        self.name.text = [NSString stringWithFormat:@"%@",dict[@"paymentTypeString"]];
        NSString *orderTime = [NSString stringWithFormat:@"%@",dict[@"orderTime"]];
         NSString *str2 = [orderTime substringWithRange:NSMakeRange(0,10)];//str2 = "is"
            NSString *str3 = [orderTime substringWithRange:NSMakeRange(11,8)];//str2 = "is"
        self.timeLabel.text = [NSString stringWithFormat:@"%@ %@",str2,str3];
        if ([dict[@"isRefund"]intValue] == 1) { // 是已还
            self.money.text = [NSString stringWithFormat:@"-%.2f",[dict[@"money"]doubleValue]];
        }else{
            self.money.text = [NSString stringWithFormat:@"+%.2f",[dict[@"money"]doubleValue]];
        }
       
        NSString *payment = [NSString stringWithFormat:@"%@",dict[@"paymentTypeString"]];
        if ([payment containsString:@"支付宝"]) {
            self.icon_image.image = [UIImage imageNamed:@"sales_treasure"];
        }else if ([payment containsString:@"微信"]){
            self.icon_image.image = [UIImage imageNamed:@"sales_wechat"];
        }else if ([payment containsString:@"龙支付"]){
            self.icon_image.image = [UIImage imageNamed:@"jianhang"];
        }else if ([payment containsString:@"扫码"]){
            self.icon_image.image = [UIImage imageNamed:@"saoma"];
        }
    }else{
            self.name.text = [NSString stringWithFormat:@"%@",dict[@"payment"]];
            NSString *orderTime = [NSString stringWithFormat:@"%@",dict[@"orderTime"]];
             NSString *str2 = [orderTime substringWithRange:NSMakeRange(0,10)];//str2 = "is"
                NSString *str3 = [orderTime substringWithRange:NSMakeRange(11,8)];//str2 = "is"
            self.timeLabel.text = [NSString stringWithFormat:@"%@ %@",str2,str3];
            self.money.text = [NSString stringWithFormat:@"￥%@",dict[@"orderMoney"]];
            NSString *payment = [NSString stringWithFormat:@"%@",dict[@"payment"]];
            if ([payment containsString:@"支付宝"]) {
                self.icon_image.image = [UIImage imageNamed:@"sales_treasure"];
            }else if ([payment containsString:@"微信"]){
                self.icon_image.image = [UIImage imageNamed:@"sales_wechat"];
            }else if ([payment containsString:@"龙支付"]){
                self.icon_image.image = [UIImage imageNamed:@"jianhang"];
            }else if ([payment containsString:@"扫码"]){
                self.icon_image.image = [UIImage imageNamed:@"saoma"];
            }
    }
    
}

@end
