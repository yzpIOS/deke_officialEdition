//
//  SVPayManagementCell.m
//  SAVI
//
//  Created by Sorgle on 2017/10/17.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVPayManagementCell.h"

@interface SVPayManagementCell()

@property (weak, nonatomic) IBOutlet UILabel *payName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *money;


@end

@implementation SVPayManagementCell

-(void)setModel:(SVPayManagementModel *)model{
    
    _model = model;
    
    self.payName.text = _model.e_expenditureclassname;
    
    self.money.text = _model.e_expenditure_money;
    
    NSString *time = [_model.e_expendituredate substringWithRange:NSMakeRange(11, 5)];
    
    self.time.text = time;
    
}

@end
