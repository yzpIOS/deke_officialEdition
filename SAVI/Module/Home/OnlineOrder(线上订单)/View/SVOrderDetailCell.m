//
//  SVOrderDetailCell.m
//  SAVI
//
//  Created by 杨忠平 on 2020/3/19.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVOrderDetailCell.h"
#import "SVOrderProductListModel.h"

@interface SVOrderDetailCell()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *discount;
@property (weak, nonatomic) IBOutlet UILabel *product_num;
@property (weak, nonatomic) IBOutlet UILabel *sv_product_unitprice;
@property (weak, nonatomic) IBOutlet UILabel *totleMoney;

@end

@implementation SVOrderDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = BackgroundColor;
    self.icon.layer.cornerRadius = 10;
    self.icon.layer.masksToBounds = YES;
}

- (void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    self.nameLabel.text = dict[@"product_name"]; // 名称
    self.discount.text = [NSString stringWithFormat:@"%.0f折",[dict[@"product_discount"] floatValue] * 10]; // 折扣
    self.product_num.text = [NSString stringWithFormat:@"x%.0f",[dict[@"product_num"]doubleValue]]; // 数量
    NSArray *sv_p_images = dict[@"sv_p_images"];
    if (!kArrayIsEmpty(sv_p_images)) {
       NSDictionary *dic = sv_p_images[0];
        [self.icon sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:dic[@"code"]]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
    } else {

        self.icon.image = [UIImage imageNamed:@"foodimg"];
    }// 图片
    self.totleMoney.text = [NSString stringWithFormat:@"￥%.2f",[dict[@"product_total"] doubleValue]];// 总价
    
    self.sv_product_unitprice.text = [NSString stringWithFormat:@"单价:￥%.2f",[dict[@"product_unitprice"] doubleValue]];// 总价
}

@end
