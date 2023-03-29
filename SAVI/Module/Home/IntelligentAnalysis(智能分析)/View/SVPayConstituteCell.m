//
//  SVPayConstituteCell.m
//  SAVI
//
//  Created by 杨忠平 on 2020/2/12.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVPayConstituteCell.h"
#import "SVShopOverviewModel.h"

@interface SVPayConstituteCell()
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *businessSales;
@property (weak, nonatomic) IBOutlet UILabel *businessNum;
@property (weak, nonatomic) IBOutlet UILabel *excellentGifts;
@end
@implementation SVPayConstituteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SVShopOverviewModel *)model
{
    _model = model;
    
    self.shopName.text = model.sv_us_name;
    self.businessSales.text = [NSString stringWithFormat:@"%.2f",[model.order_receivable doubleValue] + [model.order_unreceivable doubleValue]];
    self.businessSales.adjustsFontSizeToFitWidth = YES;
    self.businessSales.minimumScaleFactor = 0.5;
    self.businessNum.text = model.orderciunt;
    self.excellentGifts.text = [NSString stringWithFormat:@"%.2f",[model.order_pdgfee doubleValue]];
}

@end
