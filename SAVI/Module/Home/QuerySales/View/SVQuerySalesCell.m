//
//  SVQuerySalesCell.m
//  SAVI
//
//  Created by Sorgle on 2018/4/3.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVQuerySalesCell.h"
#import "SVCarnoMoModel.h"
@interface SVQuerySalesCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *product_name;
//时间加会员
@property (weak, nonatomic) IBOutlet UILabel *order_datetime;
@property (weak, nonatomic) IBOutlet UILabel *numcount;
@property (weak, nonatomic) IBOutlet UILabel *order_money;
@property (weak, nonatomic) IBOutlet UILabel *zhekou;
@property (weak, nonatomic) IBOutlet UILabel *tuiLabel;

@end

@implementation SVQuerySalesCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.tuiLabel.layer.cornerRadius = 3;
    self.tuiLabel.layer.masksToBounds = YES;
}

- (void)setModel:(SVQuerySalesModel *)model {
    _model = model;
    
   
    
    if (![SVTool isEmpty:model.prlist]) {
        NSDictionary *dic = model.prlist[0];
       self.product_name.text = [NSString stringWithFormat:@"%@",dic[@"product_name"]];
         SVCarnoMoModel *carnoModel = [SVCarnoMoModel mj_objectWithKeyValues:dic];
       NSLog(@"carnoModel.product_discount = %f",carnoModel.product_discount);
        
        if ( carnoModel.product_discount == 1 || carnoModel.product_discount == 0)  {
            self.zhekou.text = @"无折扣";
        }else{
            self.zhekou.text = [NSString stringWithFormat:@"折扣%.4f",carnoModel.product_discount];
            
        }
        
    }else{
        
    }
   NSString *timeString = model.order_datetime;
    NSString *time1 = [timeString substringToIndex:10];
    NSString *time2 = [timeString substringWithRange:NSMakeRange(11, 8)];
    
    NSString *time = [NSString stringWithFormat:@"%@ %@",time1,time2];
    if ([SVTool isBlankString:model.sv_mr_name]) {
        self.order_datetime.text = [NSString stringWithFormat:@"%@ | %@",time,@"散客"];
        self.order_datetime.textColor = RGBA(198, 170, 88, 1);
        self.order_datetime.backgroundColor = RGBA(255, 250, 216, 1);
    } else {
        self.order_datetime.text = [NSString stringWithFormat:@"%@ | %@",time,model.sv_mr_name];
        self.order_datetime.textColor = RGBA(64, 130, 202, 1);
        self.order_datetime.backgroundColor = RGBA(230, 243, 255, 1);
    }
    
    self.numcount.text = [NSString stringWithFormat:@"%@",model.numcount_bak];
    
    if ([model.return_type isEqualToString:@"1"]) {// 退货单
        self.tuiLabel.hidden = NO;
        self.order_money.textColor = [UIColor colorWithHexString:@"FF2600"];
        self.order_money.text = [NSString stringWithFormat:@"%.2f",[model.order_money_bak floatValue]+ [model.order_money2_bak floatValue]];
    }else if ([model.return_type isEqualToString:@"2"]){
        self.tuiLabel.hidden = NO;
        self.order_money.textColor = [UIColor colorWithHexString:@"FF2600"];
        self.order_money.text = [NSString stringWithFormat:@"%.2f",[model.order_money_bak floatValue]+ [model.order_money2_bak floatValue]];
    }else if ([model.return_type isEqualToString:@"3"]){
        self.tuiLabel.hidden = NO;
        self.tuiLabel.text = @"换";
        self.order_money.textColor = [UIColor colorWithHexString:@"FF2600"];
        self.order_money.text = [NSString stringWithFormat:@"%.2f",[model.order_money_bak floatValue] + [model.order_money2_bak floatValue]];
    }else{
        self.tuiLabel.hidden = YES;
        self.order_money.textColor = [UIColor colorWithHexString:@"FF2600"];
        self.order_money.text = [NSString stringWithFormat:@"%.2f",[model.order_money_bak floatValue]+ [model.order_money2_bak floatValue]];
    }
    

    if ([model.sv_order_source isEqualToString:@"0"]) {
        
        if ([model.order_payment2 isEqualToString:@"待收"]) {
            
            if ([model.order_payment isEqualToString:@"现金"]) {
                self.icon.image = [UIImage imageNamed:@"sales_cash"];
            } else if ([model.order_payment isEqualToString:@"储值卡"]) {
                self.icon.image = [UIImage imageNamed:@"sales_stored"];
            } else if ([model.order_payment isEqualToString:@"支付宝"]) {
                self.icon.image = [UIImage imageNamed:@"sales_treasure"];
            } else if ([model.order_payment isEqualToString:@"银行卡"]) {
                self.icon.image = [UIImage imageNamed:@"sales_unionpay"];
            } else if ([model.order_payment isEqualToString:@"微信支付"]) {
                self.icon.image = [UIImage imageNamed:@"sales_wechat"];
            } else if ([model.order_payment isEqualToString:@"优惠券"]) {
                self.icon.image = [UIImage imageNamed:@"sales_coupons"];
            } else if ([model.order_payment isEqualToString:@"美团"]) {
                self.icon.image = [UIImage imageNamed:@"sales_regiment"];
            } else if ([model.order_payment isEqualToString:@"口碑"]) {
                self.icon.image = [UIImage imageNamed:@"sales_publicpraise"];
            } else if ([model.order_payment isEqualToString:@"闪惠"]) {
                self.icon.image = [UIImage imageNamed:@"sales_shanhui"];
            } else if ([model.order_payment isEqualToString:@"赊账"]) {
                self.icon.image = [UIImage imageNamed:@"sales_owe"];
            } else if ([model.order_payment isEqualToString:@"饿了么"]) {
                self.icon.image = [UIImage imageNamed:@"sales_hungry"];
            } else if ([model.order_payment isEqualToString:@"微信记账"]){
                self.icon.image = [UIImage imageNamed:@"sales_wechat"];
            }else if ([model.order_payment isEqualToString:@"支付宝记账"]){
                self.icon.image = [UIImage imageNamed:@"sales_treasure"];
            }else if ([model.order_payment isEqualToString:@"物流代收"]){
                self.icon.image = [UIImage imageNamed:@"daishou"];
            }else if ([model.order_payment isEqualToString:@"代收"]){
                self.icon.image = [UIImage imageNamed:@"daishou"];
            }else if ([model.order_payment isEqualToString:@"龙支付"]){
                self.icon.image = [UIImage imageNamed:@"jianhang"];
            }else if ([model.order_payment isEqualToString:@"扣次"]){
                self.icon.image = [UIImage imageNamed:@"chaxun_kouci"];
            }else{
                self.icon.image = [UIImage imageNamed:@"zidingyi"];
            }
            
        } else {
            
            self.icon.image = [UIImage imageNamed:@"sales_combination"];
            
        }
        
    } else if ([model.sv_order_source isEqualToString:@"1"]) {
        self.icon.image = [UIImage imageNamed:@"sales_store"];
    } else if ([model.sv_order_source isEqualToString:@"2"]) {
        self.icon.image = [UIImage imageNamed:@"sales_regiment"];
    } else if ([model.sv_order_source isEqualToString:@"3"]) {
        self.icon.image = [UIImage imageNamed:@"sales_hungry"];
    } else if ([model.sv_order_source isEqualToString:@"4"]) {
        self.icon.image = [UIImage imageNamed:@"sales_baidu"];
    } else if ([model.sv_order_source isEqualToString:@"5"]) {
        self.icon.image = [UIImage imageNamed:@"sales_publicpraise"];
    }
    
    
    
}

@end
