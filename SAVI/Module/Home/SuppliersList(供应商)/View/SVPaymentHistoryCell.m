//
//  SVPaymentHistoryCell.m
//  SAVI
//
//  Created by houming Wang on 2021/4/30.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import "SVPaymentHistoryCell.h"

@interface SVPaymentHistoryCell()
@property (weak, nonatomic) IBOutlet UILabel *SettlementNo;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *beizhu;

@end

@implementation SVPaymentHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
  
    
}


- (void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    self.SettlementNo.text = dict[@"sv_repaycode"];
    self.money.text = [NSString stringWithFormat:@"%.2f",[dict[@"sv_repaymoney"] doubleValue]];
    NSString *timeString = dict[@"sv_createdate"];
    NSString *time1 = [timeString substringToIndex:10];
   // NSString *time2 = [timeString substringWithRange:NSMakeRange(11, 8)];
//    self.PurchaseTime.text = [NSString stringWithFormat:@"%@",time1];
    self.time.text = [NSString stringWithFormat:@"%@",time1];
    self.beizhu.text = dict[@"sv_remark"];
}


@end
