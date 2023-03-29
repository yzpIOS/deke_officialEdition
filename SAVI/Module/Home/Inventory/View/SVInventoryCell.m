//
//  SVInventoryCell.m
//  SAVI
//
//  Created by houming Wang on 2019/6/3.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import "SVInventoryCell.h"

@interface SVInventoryCell()
@property (weak, nonatomic) IBOutlet UITextField *beizhuTextField;

@end
@implementation SVInventoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
   
}

- (void)setSelectNumber:(NSInteger)selectNumber
{
    if (self.selectNumber == 1) { // 是盘点详情
        self.beizhuTextField.hidden = YES;
    }else{
        self.beizhuTextField.hidden = NO;
        self.beizhuTextField.layer.cornerRadius = 10;
        self.beizhuTextField.layer.masksToBounds = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
