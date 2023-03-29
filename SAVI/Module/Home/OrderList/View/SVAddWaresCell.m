//
//  SVAddWaresCell.m
//  SAVI
//
//  Created by Sorgle on 2017/6/3.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVAddWaresCell.h"

@interface SVAddWaresCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *waresName;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *inventory;

@end


@implementation SVAddWaresCell

- (void)setModel:(SVAddWaresModel *)model {
    
    _model = model;
    
    
    //    if (![self.model.sv_p_images2 isKindOfClass:[NSNull class]]) {
    //        [self.iconImg sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:self.model.sv_p_images2]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
    //    }
    
    self.waresName.text = _model.sv_p_name;
    
    self.money.text = _model.sv_p_unitprice;
    
    self.inventory.text = _model.sv_p_storage;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    
}

@end
