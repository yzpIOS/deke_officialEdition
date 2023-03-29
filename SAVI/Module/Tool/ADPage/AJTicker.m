//
//  AJTicker.m
//  AiJiaNew
//
//  Created by Sujiansong on 16/11/24.
//  Copyright © 2016年 aj1g.com. All rights reserved.
//  短信验证定时器

#import "AJTicker.h"

//NSString *sv_ad_skiptimer = ;


@interface AJTicker ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL shouldTicking;
@property (nonatomic, assign) NSInteger remain;
@property (nonatomic, weak)   UIButton *button;

@end

@implementation AJTicker

+ (instancetype)defaultTicker
{
    // int   kGetAuthCodeMaxTimeInterval = 5;
    static AJTicker *ticker;
//     AJTicker *ticker;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ticker = [[AJTicker alloc] init];
        [SVUserManager loadUserInfo];
        NSString *str = [SVUserManager shareInstance].sv_ad_skiptimer;
        int kGetAuthCodeMaxTimeInterval = [str intValue];
//        ticker.remain = kGetAuthCodeMaxTimeInterval;
        ticker.remain = kGetAuthCodeMaxTimeInterval;
        ticker.shouldTicking = YES;
        ticker.timer = [NSTimer timerWithTimeInterval:1 target:ticker selector:@selector(tick) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:ticker.timer forMode:NSRunLoopCommonModes];
    });
    return ticker;
}

//- (void)setKGetAuthCodeMaxTimeInterval:(NSInteger)kGetAuthCodeMaxTimeInterval
//{
//
//}

- (void)startTickerWithButton:(UIButton *)button
{
    self.button = button;
  //  self.kGetAuthCodeMaxTimeInterval = kGetAuthCodeMaxTimeInterval;
  //  self.remain = self.kGetAuthCodeMaxTimeInterval.integerValue;
    [self.button setTitle:[NSString stringWithFormat:@"%lds", _remain] forState:UIControlStateNormal];
//    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [self.button setEnabled:YES];
    self.shouldTicking = YES;
    self.button.alpha = 0.8;
//    self.button.backgroundColor = AJRGBAColor(255, 87, 98, 0.6);
}

//- (void)reset{
//    self.remain = 5;
//}

- (void)tick
{
    if(self.shouldTicking)
    {
        
        NSString *sv_ad_skipbtn = [SVUserManager shareInstance].sv_ad_skipbtn;
        if (sv_ad_skipbtn.intValue == 1) {
            if(_remain == 1)
            {
              //  NSString *str = [SVUserManager shareInstance].sv_ad_skiptimer;
    //            int kGetAuthCodeMaxTimeInterval = [str intValue];
    //            self.remain = kGetAuthCodeMaxTimeInterval;
//                int kGetAuthCodeMaxTimeInterval = 5;
//                self.remain = kGetAuthCodeMaxTimeInterval;
                self.shouldTicking = NO;
                [self.button setTitle:@"进入" forState:UIControlStateNormal];
    //            self.button.backgroundColor = AJSystemColor;
                [self.button setEnabled:YES];
                self.button.alpha = 1;
            }else if (_remain == 0){
                if (self.timeBlock) {
                    self.timeBlock();
                };
            }else
            {
                _remain--;
                [self.button setTitle:[NSString stringWithFormat:@"%lds", _remain] forState:UIControlStateNormal];
                self.button.alpha = 0.8;
              //  self.shouldTicking = YES;
               //  self.shouldTicking = NO;
                 [self.button setEnabled:YES];
    //            self.button.backgroundColor = AJRGBAColor(255, 87, 98, 0.6);
    //            [self.button setEnabled:NO];
            }
        }else{
            if(_remain == 0)
            {
              //  NSString *str = [SVUserManager shareInstance].sv_ad_skiptimer;
    //            int kGetAuthCodeMaxTimeInterval = [str intValue];
    //            self.remain = kGetAuthCodeMaxTimeInterval;
//                int kGetAuthCodeMaxTimeInterval = 5;
//                self.remain = kGetAuthCodeMaxTimeInterval;
//                self.shouldTicking = NO;
//                [self.button setTitle:@"进入" forState:UIControlStateNormal];
//    //            self.button.backgroundColor = AJSystemColor;
//                [self.button setEnabled:YES];
//                self.button.alpha = 1;
                if (self.timeBlock) {
                    self.timeBlock();
                };
            }
            else
            {
                _remain--;
                [self.button setTitle:[NSString stringWithFormat:@"%lds", _remain] forState:UIControlStateNormal];
                self.button.alpha = 0.8;
              //  self.shouldTicking = YES;
               //  self.shouldTicking = NO;
                 [self.button setEnabled:YES];
    //            self.button.backgroundColor = AJRGBAColor(255, 87, 98, 0.6);
    //            [self.button setEnabled:NO];
            }
        }
        
    }
}

- (BOOL)isTicking
{
//    NSString *str = [SVUserManager shareInstance].sv_ad_skiptimer;
//    int kGetAuthCodeMaxTimeInterval = [str intValue];
   // NSString *str = [SVUserManager shareInstance].sv_ad_skiptimer;
   NSString *sv_ad_skipbtn = [SVUserManager shareInstance].sv_ad_skipbtn;
    if (sv_ad_skipbtn.intValue == 1) {
//        NSString *str = [SVUserManager shareInstance].sv_ad_skiptimer;
//            int kGetAuthCodeMaxTimeInterval = [str intValue];
//       // int kGetAuthCodeMaxTimeInterval = 5;
//        return (_remain < kGetAuthCodeMaxTimeInterval ? YES : NO);
        return NO;
    }else{
//        int kGetAuthCodeMaxTimeInterval = 5;
//        return (_remain < kGetAuthCodeMaxTimeInterval ? YES : NO);
        
        return YES;
    }
    
}

@end
