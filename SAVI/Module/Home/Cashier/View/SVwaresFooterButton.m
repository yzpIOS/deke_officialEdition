//
//  SVwaresFooterButton.m
//  SAVI
//
//  Created by Sorgle on 17/5/18.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVwaresFooterButton.h"

@interface SVwaresFooterButton ()



@end

@implementation SVwaresFooterButton

- (void)setSumCount:(NSInteger)sumCount {
    
    //_sumCount = sumCount;
    //self.sumCountlbl.text = [NSString stringWithFormat:@"%ld", (long)sumCount];
    //if (sumCount) {
        ////抖动的动效
        //CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        //shakeAnimation.duration = 0.25f;
        //shakeAnimation.fromValue = [NSNumber numberWithFloat:-5];
        //shakeAnimation.toValue = [NSNumber numberWithFloat:5];
        //shakeAnimation.autoreverses = YES;
        //
        //if (_sumCount < sumCount) {
        //    [self.sumCountlbl.layer addAnimation:shakeAnimation forKey:nil];
        //    [self.icon.layer addAnimation:shakeAnimation forKey:nil];
        //}
    
        //_cnt = cnt;
        _sumCount = sumCount;
        if (sumCount == 0) {
            self.sumCountlbl.text = @"0";
        } else {
            self.sumCountlbl.text = [NSString stringWithFormat:@"%ld",(long)sumCount];
        }
        //显示
        //self.sumCountlbl.hidden = NO;
        //self.symbollbl.hidden = NO;
        //self.moneylbl.hidden = NO;
        //刷新字体的动效
        //CATransition *animation = [CATransition animation];
        //animation.duration = 0.25f;
        
        //设置99+
        //if (sumCount>99) {
            //self.sumCountlbl.frame.size = CGSizeMake(22, 13);
            //self.sumCountlbl.font = [UIFont boldSystemFontOfSize:10];
            //self.sumCountlbl.text = @"99+";
        //} else {
            //self.sumCountlbl.frame =  CGRectMake(35, 7, 15, 13);
            //self.sumCountlbl.font = [UIFont boldSystemFontOfSize:11];
            //self.sumCountlbl.text = [NSString stringWithFormat:@"%ld",(long)sumCount];
            //[self.sumCountlbl.layer addAnimation:animation forKey:nil];
        //}
    //} else {
        //隐藏
        //self.sumCountlbl.hidden = YES;
        //self.symbollbl.hidden = YES;
        //self.moneylbl.hidden = YES;
    //}

    
}

- (void)setMoney:(double)money {
    
    if (_money < money) {
        //让图变大变小的图
        self.moneylbl.transform = CGAffineTransformMakeScale(1, 1);
        [UIView animateWithDuration:0.1   animations:^{
            self.moneylbl.transform = CGAffineTransformMakeScale(1.1, 1.1);
        }completion:^(BOOL finish){
            [UIView animateWithDuration:0.1      animations:^{
                self.moneylbl.transform = CGAffineTransformMakeScale(0.9, 0.9);
            }completion:^(BOOL finish){
                [UIView animateWithDuration:0.1   animations:^{
                    self.moneylbl.transform = CGAffineTransformMakeScale(1, 1);
                }completion:^(BOOL finish){
                }];
            }];
        }];
    } else if (_money > money) {
        //让图变大变小的图
        self.moneylbl.transform = CGAffineTransformMakeScale(1, 1);
        [UIView animateWithDuration:0.1   animations:^{
            self.moneylbl.transform = CGAffineTransformMakeScale(0.5, 0.5);
        }completion:^(BOOL finish){
            [UIView animateWithDuration:0.1      animations:^{
                self.moneylbl.transform = CGAffineTransformMakeScale(0.9, 0.9);
            }completion:^(BOOL finish){
                [UIView animateWithDuration:0.1   animations:^{
                    self.moneylbl.transform = CGAffineTransformMakeScale(1, 1);
                }completion:^(BOOL finish){
                }];
            }];
        }];
    }else {

        
    }
    
    _money = money;
    self.moneylbl.text = [NSString stringWithFormat:@"%.2f", money];
}

@end
