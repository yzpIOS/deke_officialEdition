//
//  SVOrderListCell.m
//  SAVI
//
//  Created by Sorgle on 17/4/15.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVOrderListCell.h"


@interface SVOrderListCell()
@property (weak, nonatomic) IBOutlet UILabel *singleNumber;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end

@implementation SVOrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setOrderListModel:(SVOrderListModel *)OrderListModel {
    _OrderListModel = OrderListModel;
    self.singleNumber.text = _OrderListModel.wt_nober;
    self.date.text = [_OrderListModel.wt_datetime substringToIndex:10];
    self.time.text = [_OrderListModel.wt_datetime substringWithRange:NSMakeRange(11, 8)];
}

@end
