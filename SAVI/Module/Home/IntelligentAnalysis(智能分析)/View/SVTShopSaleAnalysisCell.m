//
//  SVTShopSaleAnalysisCell.m
//  SAVI
//
//  Created by 杨忠平 on 2020/2/25.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVTShopSaleAnalysisCell.h"
#import "SVShopOverviewModel.h"

@interface SVTShopSaleAnalysisCell()
@property (weak, nonatomic) IBOutlet UILabel *fatherName; // 商品名称
@property (weak, nonatomic) IBOutlet UILabel *fatherNumber; // 数量

@property (weak, nonatomic) IBOutlet UILabel *fatherCount; // 笔数
@property (weak, nonatomic) IBOutlet UILabel *fatherTotleMoney; // 营业总额
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIView *cicleView;
@property (weak, nonatomic) IBOutlet UILabel *number;

@property (weak, nonatomic) IBOutlet UILabel *sv_mr_cardno;


@end

@implementation SVTShopSaleAnalysisCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cicleView.layer.cornerRadius = 12.5;
    self.cicleView.layer.masksToBounds = YES;
  //  self.fatherName.
    self.fatherName.adjustsFontSizeToFitWidth = YES;
    self.fatherName.minimumScaleFactor = 0.5;
    
    self.fatherCount.adjustsFontSizeToFitWidth = YES;
    self.fatherCount.minimumScaleFactor = 0.5;
    
    self.fatherTotleMoney.adjustsFontSizeToFitWidth = YES;
    self.fatherTotleMoney.minimumScaleFactor = 0.5;
    
    self.fatherNumber.adjustsFontSizeToFitWidth = YES;
    self.fatherNumber.minimumScaleFactor = 0.5;
}

- (void)setMemberModel:(SVShopOverviewModel *)memberModel
{
    _memberModel = memberModel;
    self.fatherName.text = memberModel.sv_mr_name;
    self.fatherCount.text = memberModel.orderciunt;
    self.fatherNumber.text = memberModel.count;
    self.fatherTotleMoney.text = [NSString stringWithFormat:@"%.2f",[memberModel.order_receivable doubleValue]];
    self.sv_mr_cardno.text = memberModel.sv_mr_cardno;
    if ([memberModel.number integerValue] == 1) {
        self.iconImage.hidden = NO;
        self.iconImage.image = [UIImage imageNamed:@"numberOne"];
        self.cicleView.hidden = YES;
    }else if ([memberModel.number integerValue] == 2){
        self.iconImage.hidden = NO;
        self.iconImage.image = [UIImage imageNamed:@"numberTwo"];
        self.cicleView.hidden = YES;
    }else if ([memberModel.number integerValue] == 3){
        self.iconImage.hidden = NO;
        self.iconImage.image = [UIImage imageNamed:@"numberThree"];
        self.cicleView.hidden = YES;
    }else{
        self.cicleView.hidden = NO;
        self.iconImage.hidden = YES;
        self.number.text = memberModel.number;
    }
    
    
    
}

@end
