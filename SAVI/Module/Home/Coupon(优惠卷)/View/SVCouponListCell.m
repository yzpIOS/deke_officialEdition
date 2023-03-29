//
//  SVCouponListCell.m
//  SAVI
//
//  Created by houming Wang on 2018/7/9.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVCouponListCell.h"
#import "SVCouponListModel.h"

@interface SVCouponListCell()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *Symbol;
@property (weak, nonatomic) IBOutlet UILabel *twoSymbol;
@property (weak, nonatomic) IBOutlet UILabel *sv_coupon_money;


@property (weak, nonatomic) IBOutlet UILabel *sv_coupon_name;
@property (weak, nonatomic) IBOutlet UILabel *sv_coupon_use_conditions;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *surplusLabel;


@end

@implementation SVCouponListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = BlueBackgroundColor;
}

-(void)setModel:(SVCouponListModel *)model{
    _model = model;
    
    if ([model.sv_coupon_type isEqualToString:@"0"]) {
        self.type.text = @"代金券";
        self.Symbol.hidden = NO;
        self.twoSymbol.hidden = YES;
        self.icon.image = [UIImage imageNamed:@"coupon_blue"];
        self.sv_coupon_money.text = [NSString stringWithFormat:@"%.2f",model.sv_coupon_money.doubleValue];
    } else {
        self.type.text = @"折扣券";
        self.Symbol.hidden = YES;
        self.twoSymbol.hidden = NO;
        self.icon.image = [UIImage imageNamed:@"coupon_violet"];
        self.sv_coupon_money.text = [NSString stringWithFormat:@"%.2f",model.sv_coupon_money.doubleValue *0.1];
    }
    
   // self.surplusLabel.text = [NSString stringWithFormat:@"剩余：%@张",model.sv_coupon_surplus_num];
    self.sv_coupon_name.text = model.sv_coupon_name;
    self.sv_coupon_use_conditions.text = [NSString stringWithFormat:@"满%@元可用",model.sv_coupon_use_conditions];
    self.date.text = [NSString stringWithFormat:@"%@一%@",[model.sv_coupon_bendate substringToIndex:10],[model.sv_coupon_enddate substringToIndex:10]];
    
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //下面以 '2017-04-24 08:57:29'为例代表服务器返回的时间字符串
        NSDate *date = [dateFormatter dateFromString:[model.sv_coupon_enddate substringToIndex:10]];
    NSDate *date2 = [dateFormatter dateFromString:[model.sv_coupon_bendate substringToIndex:10]];
    NSDate *currentdate = [self getCurrentTime];
   int time = [self compareOneDay:currentdate withAnotherDay:date];
    NSLog(@"time = %d",time);
    _model.time = time;
    if (time == 1) {// 已过期
        self.image.hidden = NO;
        self.image.image = [UIImage imageNamed:@"Expired"];
    }else{
//        self.image.hidden = YES;
       
        int time2 = [self compareOneDay:currentdate withAnotherDay:date2];
         NSLog(@"time2 = %d",time2);
        
         _model.time2 = time2;
           if (time2 == -1) {// 没到期
                  self.image.hidden = NO;
                  self.image.image = [UIImage imageNamed:@"NotStarted"];
               
              }else{
                  self.image.hidden = YES;
              }
        
        
    }
    
   
    
    
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
