//
//  SVIntegralDeductionCell.m
//  SAVI
//
//  Created by 杨忠平 on 2019/12/12.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVIntegralDeductionCell.h"

@implementation SVIntegralDeductionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.integralView.layer.cornerRadius = 7.5;
    self.integralView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
