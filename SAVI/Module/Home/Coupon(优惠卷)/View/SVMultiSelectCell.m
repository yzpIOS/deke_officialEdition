//
//  SVMultiSelectCell.m
//  SAVI
//
//  Created by houming Wang on 2018/7/12.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVMultiSelectCell.h"


@interface SVMultiSelectCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *vipName;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation SVMultiSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.iconImg.layer.cornerRadius = 22.5;
    self.iconImg.layer.masksToBounds = YES;
    
}

- (void)setModel:(SVVipListModel *)model {
    _model = model;
    
    if (![SVTool isBlankString:self.model.sv_mr_headimg]) {
        [self.iconImg sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:self.model.sv_mr_headimg]] placeholderImage:[UIImage imageNamed:@"iconView"]];
        self.nameLabel.hidden = YES;
    } else {
        self.nameLabel.text = [_model.sv_mr_name substringToIndex:1];
        self.nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        self.iconImg.image = [UIImage imageNamed:@"icon_black"];
        self.nameLabel.hidden = NO;
    }
    
    self.vipName.text = _model.sv_mr_name;
    
    self.phone.text = _model.sv_mr_mobile;
    
    if ([self.model.isSelect isEqualToString:@"1"]) {
        self.icon.image = [UIImage imageNamed:@"ic_yixuan.png"];
    } else {
        self.icon.image = [UIImage imageNamed:@"ic_mo-ren"];
    }
    
    
    
    
}

@end
