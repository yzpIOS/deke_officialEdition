//
//  SVEjectViewCell.m
//  SAVI
//
//  Created by 杨忠平 on 2019/12/23.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVEjectViewCell.h"

@interface SVEjectViewCell()
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end
@implementation SVEjectViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//- (void)setMoneyText:(NSString *)moneyText
//{
//    _moneyText = moneyText;
//    self.money.text = moneyText;
//}

- (void)setDict:(NSMutableDictionary *)dict
{
    _dict = dict;
    self.name.text = dict[@"name"];
    self.money.text = dict[@"money"];
    
}

@end
