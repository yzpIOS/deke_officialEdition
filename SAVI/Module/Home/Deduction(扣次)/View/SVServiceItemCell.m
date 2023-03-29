//
//  SVServiceItemCell.m
//  SAVI
//
//  Created by 杨忠平 on 2019/12/6.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVServiceItemCell.h"
#import "SVCardRechargeInfoModel.h"

@interface SVServiceItemCell()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *totle;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *yanqi;

@end
@implementation SVServiceItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.yanqi.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagClick)];
    
    [self.yanqi addGestureRecognizer:tap];
}

- (void)tagClick{
    if (self.DelayBlock) {
        self.DelayBlock(_model);
    }
}

- (void)setModel:(SVCardRechargeInfoModel *)model
{
    _model = model;
    self.name.text = model.sv_p_name;
    self.totle.text = [NSString stringWithFormat:@"%@/%@",model.sv_mcc_leftcount,model.sv_mcc_sumcount];
     NSString *time = [model.validity_date substringToIndex:10];
    self.time.text = time;
    
}
@end
