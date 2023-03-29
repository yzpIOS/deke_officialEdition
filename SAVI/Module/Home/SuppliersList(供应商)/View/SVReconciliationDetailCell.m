//
//  SVReconciliationDetailCell.m
//  SAVI
//
//  Created by houming Wang on 2021/4/29.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import "SVReconciliationDetailCell.h"

@interface SVReconciliationDetailCell()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *code;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *number;


@end
@implementation SVReconciliationDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    self.icon.image = [UIImage imageNamed:@"foodimg"];
    self.title.text = dict[@"sv_p_name"];
    self.code.text =  dict[@"sv_p_barcode"];
    self.price.text = [NSString stringWithFormat:@"￥%.2f",[dict[@"sv_pc_price"] doubleValue]];
    self.money.text = [NSString stringWithFormat:@"%.2f",[dict[@"sv_pc_combined"] doubleValue]];
    self.number.text = [NSString stringWithFormat:@"%.2f",[dict[@"sv_pc_pnumber"] doubleValue]];
}

@end
