//
//  SVTimesCountCell.m
//  SAVI
//
//  Created by houming Wang on 2018/7/5.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVTimesCountCell.h"


@interface SVTimesCountCell()
@property (weak, nonatomic) IBOutlet UIView *whiteView;

@property (weak, nonatomic) IBOutlet UILabel *sv_p_name;
@property (weak, nonatomic) IBOutlet UILabel *sv_mcc_sumcount;
@property (weak, nonatomic) IBOutlet UILabel *sv_mcc_leftcount;
@property (weak, nonatomic) IBOutlet UILabel *validity_date;

@end

@implementation SVTimesCountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.whiteView.layer.cornerRadius = 10;
    self.backgroundColor = BlueBackgroundColor;
    
    
}

- (void)setModel:(SVTimesCountModel *)model {
    _model = model;
    
    self.sv_p_name.text = model.sv_p_name;
    self.sv_mcc_sumcount.text = model.sv_mcc_sumcount;
    self.sv_mcc_leftcount.text = model.sv_mcc_leftcount;
    self.sv_mcc_leftcount.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    self.validity_date.text = [model.validity_date substringToIndex:10];
    
}

@end
