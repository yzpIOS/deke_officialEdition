//
//  SVWaresRecordCell.m
//  SAVI
//
//  Created by Sorgle on 2017/10/13.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVWaresRecordCell.h"

@interface SVWaresRecordCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitpriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *individualLabel;


@end

@implementation SVWaresRecordCell

-(void)setModel:(SVWaresRecordModel *)model{
    
    _model = model;
    if (_model.order_datetime.length >= 10) {
        NSString *str1 = [_model.order_datetime substringToIndex:10];//截取掉下标10之前的字符串
        self.dateLabel.text = str1;
    }else{
        self.dateLabel.text = _model.order_datetime;
    }
    self.dateLabel.adjustsFontSizeToFitWidth = YES;
    self.dateLabel.minimumScaleFactor = 0.5;
    
    self.numberLabel.text = _model.product_num;
    self.unitpriceLabel.text = [NSString stringWithFormat:@"%.2f",_model.product_unitprice.floatValue];
    
    if ([SVTool isBlankString:self.model.sv_mr_name]) {
        
        self.individualLabel.text = @"散客";
        self.individualLabel.textColor = [UIColor grayColor];
        
    } else {
        
        self.individualLabel.text = _model.sv_mr_name;
        self.individualLabel.textColor = RGBA(254, 202, 22, 1);
        
    }
    
}

@end
