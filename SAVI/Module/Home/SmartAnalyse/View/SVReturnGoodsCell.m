//
//  SVReturnGoodsCell.m
//  SAVI
//
//  Created by houming Wang on 2018/11/2.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVReturnGoodsCell.h"
#import "SVCustormPaymentModel.h"

@interface SVReturnGoodsCell()
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;

@end
@implementation SVReturnGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SVCustormPaymentModel *)model
{
    _model = model;
    self.nameL.text = model.payment;
    self.moneyL.text=[NSString stringWithFormat:@"%.2f",[model.amount floatValue]];
//    self.moneyL.text = [NSString ];
}

@end
