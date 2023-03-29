//
//  SVStoreDetailCell.m
//  SAVI
//
//  Created by 杨忠平 on 2019/12/30.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVStoreDetailCell.h"

@interface SVStoreDetailCell()
@property (weak, nonatomic) IBOutlet UILabel *textName;
@property (weak, nonatomic) IBOutlet UILabel *consumptionNum;
@property (weak, nonatomic) IBOutlet UILabel *RechargeMoney;
@property (weak, nonatomic) IBOutlet UILabel *DoBusinessMoney;

@end

@implementation SVStoreDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



@end
