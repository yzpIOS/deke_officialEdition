//
//  SVColorCell.m
//  SAVI
//
//  Created by 杨忠平 on 2020/1/7.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVColorCell.h"

@interface SVColorCell()
@property (weak, nonatomic) IBOutlet UILabel *textName;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UIView *colorView;

@end
@implementation SVColorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.colorView.layer.cornerRadius = 5;
    self.colorView.layer.masksToBounds = YES;
}

- (void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    self.textName.text = dict[@"payment_method"];
    self.money.text = [NSString stringWithFormat:@"￥%.1f",[dict[@"payment_amount"] floatValue]];
    self.colorView.backgroundColor = dict[@"color"];
}

- (void)setConsumeDict:(NSDictionary *)consumeDict
{
    _consumeDict = consumeDict;
    self.textName.text = consumeDict[@"payment"];
    self.money.text = [NSString stringWithFormat:@"￥%.1f",[consumeDict[@"amount"] floatValue]];
  //  self.colorView.backgroundColor = consumeDict[@"color"];
}


- (void)setMemberDict:(NSDictionary *)memberDict
{
    _memberDict = memberDict;
    self.textName.text = memberDict[@"name"];
    self.money.text = memberDict[@"count"];
}

- (void)setActiveDict:(NSDictionary *)activeDict
{
    _activeDict = activeDict;
    self.textName.text = activeDict[@"ratio"];
    self.money.text = [NSString stringWithFormat:@"￥%.1f",[activeDict[@"remark"] floatValue]];
    self.colorView.backgroundColor = activeDict[@"color"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
