//
//  SVSupplierCell.m
//  SAVI
//
//  Created by houming Wang on 2019/8/12.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import "SVSupplierCell.h"
#import "SVSupplierListModel.h"

@interface SVSupplierCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabelOne;
@property (weak, nonatomic) IBOutlet UILabel *payMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabelTwo;

@end
@implementation SVSupplierCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setFrame:(CGRect)frame{
    //    frame.origin.x += 10;
    frame.origin.y += 5;
    frame.size.height -= 5;
    //    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)setModel:(SVSupplierListModel *)model
{
    _model = model;
    if (model.arrears.floatValue == 0) {
        self.nameLabelOne.hidden = YES;
        self.payMoneyLabel.hidden = YES;
        self.nameLabelTwo.hidden = NO;
        self.nameLabelTwo.text = model.sv_suname;
    }else{
        self.nameLabelTwo.hidden = YES;
        self.nameLabelOne.hidden = NO;
        self.payMoneyLabel.hidden = NO;
        self.nameLabelOne.text = model.sv_suname;
        self.payMoneyLabel.text = [NSString stringWithFormat:@"应付欠款：%@",model.arrears];
    }
}

@end
