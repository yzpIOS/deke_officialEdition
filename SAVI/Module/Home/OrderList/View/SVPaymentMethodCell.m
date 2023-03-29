//
//  SVPaymentMethodCell.m
//  SAVI
//
//  Created by houming Wang on 2021/3/23.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import "SVPaymentMethodCell.h"

@interface SVPaymentMethodCell()


@end

@implementation SVPaymentMethodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.money.textColor = [UIColor grayColor];
}

- (void)setFrame:(CGRect)frame{
   // frame.origin.x += 10;
    frame.origin.y += 10;
    frame.size.height -= 10;
  //  frame.size.width -= 20;
    [super setFrame:frame];
}
@end
