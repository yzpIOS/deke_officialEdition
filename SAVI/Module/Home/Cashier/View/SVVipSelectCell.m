//
//  SVVipSelectCell.m
//  SAVI
//
//  Created by Sorgle on 2017/5/28.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVVipSelectCell.h"

@interface SVVipSelectCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *vipName;

@property (weak, nonatomic) IBOutlet UILabel *money;

@property (weak, nonatomic) IBOutlet UILabel *AccountNumber;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *guashi;
@property (weak, nonatomic) IBOutlet UILabel *integral;

@property (weak, nonatomic) IBOutlet UILabel *dengji;
@property (weak, nonatomic) IBOutlet UIView *guoqiView;
@property (weak, nonatomic) IBOutlet UILabel *guoqiLabel;
@property (weak, nonatomic) IBOutlet UIView *dengjiView;

@end

@implementation SVVipSelectCell


-(void)setVipModel:(SVVipSelectModdl *)vipModel{
    _vipModel = vipModel;
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
             [dateFormatter setDateFormat:@"yyyy-MM-dd"];
         //下面以 '2017-04-24 08:57:29'为例代表服务器返回的时间字符串
    NSString *sv_mr_deadline;
       if (kStringIsEmpty(vipModel.sv_mr_deadline)) {
           sv_mr_deadline = @"9999-12-31T23:59:59.999999+08:00";
       }else{
           sv_mr_deadline = vipModel.sv_mr_deadline;
       }
             NSDate *date = [dateFormatter dateFromString:[sv_mr_deadline substringToIndex:10]];
    //     NSDate *date2 = [dateFormatter dateFromString:[model.sv_coupon_bendate substringToIndex:10]];
         NSDate *currentdate = [self getCurrentTime];
        int time = [self compareOneDay:currentdate withAnotherDay:date];
    if (vipModel.sv_mr_status == 0) {
       // self.guashi.hidden = YES;
        self.guashi.hidden = YES;
        if (time == -1) {// 没过期
             self.guashi.hidden = YES;

        }else{
           self.guashi.text = @"已过期";
           self.guashi.hidden = NO;

        }
    }else{
//        self.guashi.hidden = NO;
//        self.guashi.text = @"已挂失";
        self.guashi.hidden = NO;
        // self.guashiState.text = @"已挂失";
         if (time == -1) {// 没过期
             self.guashi.text = @"已挂失";
            // self.guashiState.hidden = NO;
         }else{
           //  self.guashiState.hidden = YES;
             self.guashi.text = [NSString stringWithFormat:@"%@%@",@"已挂失",@"已过期"];
         }
    }
    
    
    
    self.guoqiView.layer.cornerRadius = 5;
    self.guoqiView.layer.masksToBounds = YES;
    self.guoqiView.layer.borderWidth = 1;
    self.guoqiView.layer.borderColor = [UIColor redColor].CGColor;
    if (vipModel.sv_mr_status == 0) { // 正常
        self.guoqiView.hidden = YES;
        if (time == -1) {// 没过期
            self.guoqiView.hidden = YES;
        }else{
           self.guoqiLabel.text = @"已过期";
            self.guoqiView.hidden = NO;
        }
    }else{
        self.guoqiView.hidden = NO;
       // self.guashiState.text = @"已挂失";
        if (time == -1) {// 没过期
           self.guoqiLabel.text = @"已挂失";
           // self.guashiState.hidden = NO;
        }else{
          //  self.guashiState.hidden = YES;
             self.guoqiLabel.text = [NSString stringWithFormat:@"%@%@",@"已挂失",@"已过期"];
            
        }
    }
    
    self.dengjiView.layer.cornerRadius = 5;
    self.dengjiView.layer.masksToBounds = YES;
    self.dengjiView.layer.borderWidth = 1;
    self.dengjiView.layer.borderColor = [UIColor colorWithHexString:@"e79520"].CGColor;
    
    if (kStringIsEmpty(vipModel.sv_ml_name)) {
        self.dengjiView.hidden = YES;
    }else{
        self.dengjiView.hidden = NO;
        self.dengji.text = vipModel.sv_ml_name;
    }
    
     
    
    if (_vipModel.JurisdictionNum == 1) {// 不用显示*号
        self.AccountNumber.text = _vipModel.sv_mr_mobile;
    }else{// 显示*号
        if (_vipModel.sv_mr_mobile.length < 11) {
            self.AccountNumber.text = _vipModel.sv_mr_mobile;
        }else{
            self.AccountNumber.text = [_vipModel.sv_mr_mobile stringByReplacingCharactersInRange:NSMakeRange(3, 5)  withString:@"*****"];
        }
    }
    
    //设置view的圆角
    self.iconImg.layer.cornerRadius = 22.5;
    //UIImageView切圆的时候就要用到这一句了
    self.iconImg.layer.masksToBounds = YES;
    
    if (![SVTool isBlankString:self.vipModel.sv_mr_headimg]) {
        [self.iconImg sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:self.vipModel.sv_mr_headimg]] placeholderImage:[UIImage imageNamed:@"iconView"]];
        self.nameLabel.hidden = YES;
    } else {
        if (![SVTool isBlankString:self.vipModel.sv_mr_name]) {
            self.nameLabel.hidden = NO;
            self.nameLabel.text = [_vipModel.sv_mr_name substringToIndex:1];
            self.nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
            self.iconImg.image = [UIImage imageNamed:@"icon_black"];
            self.nameLabel.hidden = NO;
        }
       
    }
    
    self.vipName.text = _vipModel.sv_mr_name;
    
    self.money.text = [NSString stringWithFormat:@"储值：%.2f",[_vipModel.sv_mw_availableamount floatValue]];
    
    self.integral.text = [NSString stringWithFormat:@"积分：%.2f",[_vipModel.sv_mw_availablepoint floatValue]];
    
   
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
