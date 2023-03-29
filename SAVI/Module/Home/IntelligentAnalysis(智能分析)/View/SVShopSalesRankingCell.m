//
//  SVShopSalesRankingCell.m
//  SAVI
//
//  Created by 杨忠平 on 2020/1/7.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVShopSalesRankingCell.h"

@interface SVShopSalesRankingCell()
@property (weak, nonatomic) IBOutlet UILabel *nameText;
@property (weak, nonatomic) IBOutlet UILabel *moneyAndMore;
@property (weak, nonatomic) IBOutlet UILabel *allMoney;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIView *cicleView;
@property (weak, nonatomic) IBOutlet UILabel *number;

@end

@implementation SVShopSalesRankingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.cicleView.layer.cornerRadius = 12.5;
    self.cicleView.layer.masksToBounds = YES;
}

- (void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    self.nameText.text = dict[@"product_name"];



    self.moneyAndMore.text = [NSString stringWithFormat:@"单价:￥%.2f  总价:￥%.2f",[dict[@"sv_p_unitprice"]doubleValue],[dict[@"product_total"]doubleValue]];


    self.allMoney.text = [NSString stringWithFormat:@"%.2f",[dict[@"product_num"] floatValue]];
    
    if ([dict[@"number"] integerValue] == 1) {
        self.iconImage.hidden = NO;
        self.iconImage.image = [UIImage imageNamed:@"numberOne"];
        self.cicleView.hidden = YES;
    }else if ([dict[@"number"] integerValue] == 2){
        self.iconImage.hidden = NO;
        self.iconImage.image = [UIImage imageNamed:@"numberTwo"];
        self.cicleView.hidden = YES;
    }else if ([dict[@"number"] integerValue] == 3){
        self.iconImage.hidden = NO;
        self.iconImage.image = [UIImage imageNamed:@"numberThree"];
        self.cicleView.hidden = YES;
    }else{
        self.cicleView.hidden = NO;
        self.iconImage.hidden = YES;
        self.number.text = dict[@"number"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
