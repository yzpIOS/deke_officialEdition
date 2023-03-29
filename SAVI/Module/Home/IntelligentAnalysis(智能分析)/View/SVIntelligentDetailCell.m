//
//  SVIntelligentDetailCell.m
//  SAVI
//
//  Created by houming Wang on 2019/9/18.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVIntelligentDetailCell.h"
#import "SVShopOverviewModel.h"
#import "SVStoreCategaryModel.h"
@interface SVIntelligentDetailCell()
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *businessSales;
@property (weak, nonatomic) IBOutlet UILabel *businessNum;
@property (weak, nonatomic) IBOutlet UILabel *excellentGifts;

@property (weak, nonatomic) IBOutlet UIView *fatherView;
@property (weak, nonatomic) IBOutlet UILabel *fatherName;
@property (weak, nonatomic) IBOutlet UILabel *fatherNum;
@property (weak, nonatomic) IBOutlet UILabel *fatherTotleMoney;

@end

@implementation SVIntelligentDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.fatherView.layer.cornerRadius = 10;
    self.fatherView.layer.masksToBounds = YES;
}

- (void)setModel:(SVShopOverviewModel *)model
{
    _model = model;
    if (model.selectVC == 1) {// 是店铺概况
        self.fatherView.hidden = YES;
    }else{
        self.fatherView.hidden = NO;
    }
    self.shopName.text = model.sv_us_name;
    self.businessSales.text = [NSString stringWithFormat:@"%.2f",[model.order_receivable floatValue]];
    self.businessNum.text = model.orderciunt;
    self.excellentGifts.text = [NSString stringWithFormat:@"%.2f",[model.order_pdgfee floatValue]];
}


- (void)setCategaryModel:(SVStoreCategaryModel *)categaryModel
{
    _categaryModel = categaryModel;
    
    self.shopName.text = categaryModel.sv_pc_name;
    self.businessSales.text = [NSString stringWithFormat:@"%.2f",[categaryModel.category_num doubleValue]];
    self.businessNum.text = [NSString stringWithFormat:@"%.2f",[categaryModel.category_total doubleValue]];
    self.excellentGifts.text = [NSString stringWithFormat:@"%.2f%@",[categaryModel.percent doubleValue],@"%"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

  
}

@end
