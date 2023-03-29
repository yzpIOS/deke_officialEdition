//
//  SVHairCouponCell.m
//  SAVI
//
//  Created by houming Wang on 2018/7/12.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVHairCouponCell.h"


@interface SVHairCouponCell()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *Symbol;
@property (weak, nonatomic) IBOutlet UILabel *twoSymbol;
@property (weak, nonatomic) IBOutlet UILabel *sv_coupon_money;

@property (weak, nonatomic) IBOutlet UILabel *sv_coupon_name;
@property (weak, nonatomic) IBOutlet UILabel *sv_coupon_use_conditions;
@property (weak, nonatomic) IBOutlet UILabel *date;


@end

@implementation SVHairCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = BlueBackgroundColor;
}

-(void)setModel:(SVCouponListModel *)model {
    _model = model;
    
    if ([model.sv_coupon_type isEqualToString:@"0"]) {
        self.type.text = @"代金券";
        self.Symbol.hidden = NO;
        self.twoSymbol.hidden = YES;
        self.icon.image = [UIImage imageNamed:@"coupon_blue"];        
    } else {
        self.type.text = @"折扣券";
        self.Symbol.hidden = YES;
        self.twoSymbol.hidden = NO;
        self.icon.image = [UIImage imageNamed:@"coupon_violet"];
    }
    
    if (self.selected == YES) {
        self.selectIcon.image = [UIImage imageNamed:@"ic_yixuan.png"];
    } else {
        self.selectIcon.image = [UIImage imageNamed:@"ic_mo-ren"];
    }
    
    if ([model.sv_coupon_surplus_num isEqualToString:@"0"]) {
        self.selectIcon.hidden = YES;
        self.sv_coupon_surplus_num.text = @"已全部发放";
        self.sv_coupon_surplus_num.textColor = RedFontColor;
    } else {
        self.selectIcon.hidden = NO;
        self.sv_coupon_surplus_num.text = [NSString stringWithFormat:@"余%@张",model.sv_coupon_surplus_num];
        self.sv_coupon_surplus_num.textColor = RGBA(85, 85, 85, 1);
    }
    
    self.sv_coupon_money.text = model.sv_coupon_money;
    self.sv_coupon_name.text = model.sv_coupon_name;
    self.sv_coupon_use_conditions.text = [NSString stringWithFormat:@"满%@元可用",model.sv_coupon_use_conditions];
    self.date.text = [NSString stringWithFormat:@"%@一%@",[model.sv_coupon_bendate substringToIndex:10],[model.sv_coupon_enddate substringToIndex:10]];
}




@end
