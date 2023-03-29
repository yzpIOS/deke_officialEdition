//
//  SVCouponDetailsCell.m
//  SAVI
//
//  Created by houming Wang on 2018/7/11.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVCouponDetailsCell.h"


@interface SVCouponDetailsCell()
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *sv_coupon_code;

@end

@implementation SVCouponDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setModel:(SVCouponDetailsModel *)model {
    _model = model;
    
    if (model.isdate == 0) {
        self.date.text = [model.sv_modification_date substringToIndex:10];
    } else {
        self.date.text = [model.sv_creation_date substringToIndex:10];
    }
    self.sv_coupon_code.text = model.sv_coupon_code;
    
}


@end
