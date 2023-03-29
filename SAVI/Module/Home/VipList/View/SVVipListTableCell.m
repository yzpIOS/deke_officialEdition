//
//  SVVipListTableCell.m
//  SAVI
//
//  Created by Sorgle on 17/4/14.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVVipListTableCell.h"

@interface SVVipListTableCell ()
//头像
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

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *guashiState; // 是否挂失
//@property (weak, nonatomic) IBOutlet UILabel *expirationTime;
@property (weak, nonatomic) IBOutlet UILabel *dengji;
@property (weak, nonatomic) IBOutlet UIView *guoqiView;
@property (weak, nonatomic) IBOutlet UILabel *guoqiLabel;
@property (weak, nonatomic) IBOutlet UIView *dengjiView;

@end

@implementation SVVipListTableCell

- (void)setModel:(SVVipListModel *)model {
    
    _model = model;
    [self updateCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
 
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    
}

- (void)updateCell {
    

    [self.cellButton setImage:[UIImage imageNamed:@"ic_yixuan.png"] forState:UIControlStateSelected];
    [self.cellButton setImage:[UIImage imageNamed:@"ic_mo-ren"] forState:UIControlStateNormal];
    if ([self.model.isSelect isEqualToString:@"1"]) {
        self.cellButton.selected = YES;
    }
    else{
        self.cellButton.selected = NO;
    }

    
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
    

    self.guoqiView.layer.cornerRadius = 5;
    self.guoqiView.layer.masksToBounds = YES;
    self.guoqiView.layer.borderWidth = 1;
    self.guoqiView.layer.borderColor = [UIColor redColor].CGColor;

    if (_model.sv_mr_status == 0) { // 正常
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
    
    if (kStringIsEmpty(_model.sv_ml_name)) {
        self.dengjiView.hidden = YES;
    }else{
        self.dengjiView.hidden = NO;
        self.dengji.text = _model.sv_ml_name;
    }
    
    
    if (_model.JurisdictionNum == 1) {// 不用显示*号
         self.phone.text = _model.sv_mr_mobile;
    }else{// 显示*号
        if (_model.sv_mr_mobile.length < 11) {
            self.phone.text = _model.sv_mr_mobile;
        }else{
            self.phone.text = [_model.sv_mr_mobile stringByReplacingCharactersInRange:NSMakeRange(3, 5)  withString:@"*****"];
        }
    }
    
    //设置view的圆角
    self.iconImg.layer.cornerRadius = 22.5;
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

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self updateCell];
    
}


//ic_yixuan.png
- (IBAction)selectButton:(UIButton *)sender {
    if ([self.model.isSelect isEqualToString:@"1"]) {
        self.model.isSelect = @"0";
    }
    else{
        self.model.isSelect = @"1";
    }
    
    if (self.model_block) {
        
        self.model_block(self.model,self.index);
        
    }
    
    [self updateCell];
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
