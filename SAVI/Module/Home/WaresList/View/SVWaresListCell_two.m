//
//  SVWaresListCell_two.m
//  SAVI
//
//  Created by houming Wang on 2019/5/28.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import "SVWaresListCell_two.h"


@interface SVWaresListCell_two()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitpriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *SpecificationsLabel;
@property (weak, nonatomic) IBOutlet UILabel *individualLabel;
@end
@implementation SVWaresListCell_two

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

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
    self.numberLabel.adjustsFontSizeToFitWidth = YES;
    self.numberLabel.minimumScaleFactor = 0.5;
    
    self.unitpriceLabel.text = [NSString stringWithFormat:@"%.2f",_model.product_unitprice.floatValue];
    self.unitpriceLabel.adjustsFontSizeToFitWidth = YES;
    self.unitpriceLabel.minimumScaleFactor = 0.5;
    
    self.SpecificationsLabel.text = _model.sv_p_specs;
    self.SpecificationsLabel.adjustsFontSizeToFitWidth = YES;
    self.SpecificationsLabel.minimumScaleFactor = 0.5;
    
    if ([SVTool isBlankString:self.model.sv_mr_name]) {
        
        self.individualLabel.text = @"散客";
        self.individualLabel.textColor = [UIColor grayColor];
        
    } else {
        
        self.individualLabel.text = _model.sv_mr_name;
        self.individualLabel.textColor = RGBA(254, 202, 22, 1);
        
    }
    
    self.individualLabel.adjustsFontSizeToFitWidth = YES;
    self.individualLabel.minimumScaleFactor = 0.5;
    
}
@end
