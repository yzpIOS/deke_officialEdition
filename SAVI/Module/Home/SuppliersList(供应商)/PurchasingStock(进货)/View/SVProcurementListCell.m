//
//  SVProcurementListCell.m
//  SAVI
//
//  Created by Sorgle on 2017/12/30.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVProcurementListCell.h"

@implementation SVProcurementListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.caogaoLabel.layer.cornerRadius = 10;
    self.caogaoLabel.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
