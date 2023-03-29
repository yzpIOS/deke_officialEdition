//
//  SVTimingCardCell.m
//  SAVI
//
//  Created by houming Wang on 2019/2/21.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import "SVTimingCardCell.h"
#import "SVSettlementTimesCountModel.h"


@interface SVTimingCardCell()
@property (weak, nonatomic) IBOutlet UILabel *nameL;

//@property (weak, nonatomic) IBOutlet UIButton *cellButton;

@end

@implementation SVTimingCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SVSettlementTimesCountModel *)model
{
  
    _model = model;
    [self updateCell];
    
}

- (void)updateCell {
  //  _model = model;

    if ([self.model.selectIndex isEqualToString:@"1"]) {
        self.iconImage.image = [UIImage imageNamed:@"ic_yixuan.png"];
    }
    else{
        self.iconImage.image = [UIImage imageNamed:@"ic_mo-ren"];
    }
    //    [self.cellButton setImage:[UIImage imageNamed:@"ic_yixuan.png"] forState:UIControlStateSelected];
    //    [self.cellButton setImage:[UIImage imageNamed:@"ic_mo-ren"] forState:UIControlStateNormal];
    self.nameL.text = _model.sv_p_name;
    self.timeL.text = [NSString stringWithFormat:@"%ld次",_model.sv_mcc_leftcount];
    
    if (self.selctModelBlock) {
        self.selctModelBlock(_model);
    }
}

//- (void)layoutSubviews {
//
//    [super layoutSubviews];
//    [self updateCell];
//
//}

//- (void)setIndex:(NSInteger)index
//{
//    if ([_model.selectIndex isEqualToString:@"1"]) {
//        self.iconImage.image = [UIImage imageNamed:@"ic_yixuan.png"];
//        _model.selectIndex = @"0";
//    }else{
//        self.iconImage.image = [UIImage imageNamed:@"ic_mo-ren"];
//        _model.selectIndex = @"1";
//    }
//}



//- (void)setSelected:(BOOL)selected{
//
//    [super setSelected:selected];
//
//    if ([self.model.selectIndex isEqualToString:@"1"]) {
//        self.model.selectIndex = @"0";
//    }
//    else{
//        self.model.selectIndex = @"1";
//    }
//
//    if (self.selctModelBlock) {
//        self.selctModelBlock(_model);
//    }
//     [self updateCell];
//}

@end
