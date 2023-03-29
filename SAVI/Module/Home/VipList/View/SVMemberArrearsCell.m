//
//  SVMemberArrearsCell.m
//  SAVI
//
//  Created by houming Wang on 2020/11/24.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVMemberArrearsCell.h"

@interface SVMemberArrearsCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
//名称
@property (weak, nonatomic) IBOutlet UILabel *vipName;
//储值
@property (weak, nonatomic) IBOutlet UILabel *stored;
//电话
@property (weak, nonatomic) IBOutlet UILabel *phone;
//积分
@property (weak, nonatomic) IBOutlet UILabel *integral;

@property (weak, nonatomic) IBOutlet UIButton *cellButton;
@property (weak, nonatomic) IBOutlet UILabel *owe;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *guashiState; // 是否挂失
@property (weak, nonatomic) IBOutlet UILabel *oweMoney;

@end
@implementation SVMemberArrearsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.owe.layer.cornerRadius = 5;
    self.owe.layer.masksToBounds = YES;
}

- (void)setModel:(SVVipListModel *)model {
    
    _model = model;
    [self updateCell];
}

- (void)updateCell {
    
    
  
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
         [dateFormatter setDateFormat:@"yyyy-MM-dd"];
     //下面以 '2017-04-24 08:57:29'为例代表服务器返回的时间字符串
    NSString *sv_mr_deadline;
    if (kStringIsEmpty(_model.sv_mr_deadline)) {
        sv_mr_deadline = @"9999-12-31T23:59:59.999999+08:00";
    }else{
        sv_mr_deadline = _model.sv_mr_deadline;
    }
         NSDate *date = [dateFormatter dateFromString:[sv_mr_deadline substringToIndex:10]];
//     NSDate *date2 = [dateFormatter dateFromString:[model.sv_coupon_bendate substringToIndex:10]];
     NSDate *currentdate = [self getCurrentTime];
    int time = [self compareOneDay:currentdate withAnotherDay:date];
    
    self.oweMoney.text = [NSString stringWithFormat:@"%.2f",_model.sv_mw_credit];
    
    //    self.cellButton.selected = self.model.isSelect;
    if (_model.sv_mr_status == 0) { // 正常
        self.guashiState.hidden = YES;
        if (time == -1) {// 没过期
            self.guashiState.hidden = YES;
        }else{
           self.guashiState.text = @"已过期";
            self.guashiState.hidden = NO;
        }
    }else{
        self.guashiState.hidden = NO;
       // self.guashiState.text = @"已挂失";
        if (time == -1) {// 没过期
           self.guashiState.text = @"已挂失";
           // self.guashiState.hidden = NO;
        }else{
          //  self.guashiState.hidden = YES;
             self.guashiState.text = [NSString stringWithFormat:@"%@%@",@"已挂失",@"已过期"];
            
        }
    }
    
    
   // if (_model.JurisdictionNum == 1) {// 不用显示*号
        self.phone.text = _model.sv_mr_mobile;
//    }else{// 显示*号
//        if (_model.sv_mr_mobile.length < 11) {
//            self.phone.text = _model.sv_mr_mobile;
//        }else{
//            self.phone.text = [_model.sv_mr_mobile stringByReplacingCharactersInRange:NSMakeRange(3, 5)  withString:@"*****"];
//        }
//    }
    
    //设置view的圆角
    self.iconImg.layer.cornerRadius = 30;
    //UIImageView切圆的时候就要用到这一句了
    self.iconImg.layer.masksToBounds = YES;
    
    if (![SVTool isBlankString:self.model.sv_mr_headimg]) {
        [self.iconImg sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:self.model.sv_mr_headimg]] placeholderImage:[UIImage imageNamed:@"iconView"]];
        self.nameLabel.hidden = YES;
    } else {
        if (![SVTool isBlankString:_model.sv_mr_name]) {
            self.nameLabel.text = [_model.sv_mr_name substringToIndex:1];
            self.nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
            self.iconImg.image = [UIImage imageNamed:@"icon_black"];
            self.nameLabel.hidden = NO;
        }
        
    }
    
    self.vipName.text = _model.sv_mr_name;
    
    self.stored.text = [NSString stringWithFormat:@"%0.2f",[_model.sv_mw_availableamount floatValue]];
    
    
    self.integral.text = _model.sv_mw_availablepoint;
}


#pragma mark -得到当前时间date
- (NSDate *)getCurrentTime{
    
    //2017-04-24 08:57:29
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    NSDate *date = [formatter dateFromString:dateTime];
//    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
//    NSString *dateString = [formatter stringFromDate:date];
//    NSLog(@"datastring  = %@",dateString);
    return date;
}

- (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"oneDay : %@, anotherDay : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //在指定时间前面 过了指定时间 过期
        NSLog(@"oneDay  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //没过指定时间 没过期
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //刚好时间一样.
    //NSLog(@"Both dates are the same");
    return 0;
    
}


@end
