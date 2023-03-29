//
//  SVSecondaryRecordCell.m
//  SAVI
//
//  Created by 杨忠平 on 2019/12/6.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVSecondaryRecordCell.h"
#import "SVSecondaryRecordModel.h"
@interface SVSecondaryRecordCell()
@property (weak, nonatomic) IBOutlet UILabel *object;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *pay;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end

@implementation SVSecondaryRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SVSecondaryRecordModel *)model
{//label.text = @"此处\n换行";
    _model = model;
    self.object.text = model.sv_mcr_productname;
    self.count.text = [NSString stringWithFormat:@"%@",model.sv_mcr_count];
    self.money.text = [NSString stringWithFormat:@"%@",model.sv_mcr_money];
    self.pay.text = [NSString stringWithFormat:@"%@",model.sv_mcr_payment];
    NSString *startTime = [model.sv_mcr_date substringToIndex:10];
  //  NSString *endTime = [model.sv_mcr_date substringToIndex:10];
   // 1.从第三个字符开始，截取长度为2的字符串.........注:空格算作一个字符
    NSString *endTime = [model.sv_mcr_date substringWithRange:NSMakeRange(11,8)];//str2 = "is"
    self.time.text = [NSString stringWithFormat:@"%@\n%@",startTime,endTime];
}

@end
