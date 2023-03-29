//
//  SVsubCardDetailCell.m
//  SAVI
//
//  Created by 杨忠平 on 2019/11/28.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVsubCardDetailCell.h"

@interface SVsubCardDetailCell()
@property (weak, nonatomic) IBOutlet UILabel *object;
@property (weak, nonatomic) IBOutlet UILabel *purchase;
@property (weak, nonatomic) IBOutlet UILabel *giveNum;
@property (weak, nonatomic) IBOutlet UILabel *sumMoney;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end

@implementation SVsubCardDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    self.object.text = dict[@"sv_p_name"];
    self.purchase.text = [NSString stringWithFormat:@"%@",dict[@"product_number"]];
    self.giveNum.text = [NSString stringWithFormat:@"%@",dict[@"sv_give_count"]];
    self.sumMoney.text = [NSString stringWithFormat:@"%@",dict[@"sv_p_totaloriginalprice"]];
    NSString *timeStr = [NSString stringWithFormat:@"%@",dict[@"sv_eff_range"]];
    NSString *timeRangeType = [NSString stringWithFormat:@"%@",dict[@"sv_eff_rangetype"]];
    if ([timeRangeType isEqualToString:@"3"]) { // 年
        self.time.text = [NSString stringWithFormat:@"%@年",timeStr];
    }else if ([timeRangeType isEqualToString:@"2"]){ // 月
        self.time.text = [NSString stringWithFormat:@"%@月",timeStr];
    }else if([timeRangeType isEqualToString:@"1"]){// 天
        self.time.text = [NSString stringWithFormat:@"%@天",timeStr];
    }
    
    
}

@end
