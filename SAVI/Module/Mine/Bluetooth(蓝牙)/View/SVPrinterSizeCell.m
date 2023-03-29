//
//  SVPrinterSizeCell.m
//  SAVI
//
//  Created by houming Wang on 2018/5/9.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVPrinterSizeCell.h"

@interface SVPrinterSizeCell()

@end

@implementation SVPrinterSizeCell


/**
 当我们需要自定义一个View控件时，会有 initWithFrame、initWithCoder、awakeFromNib 这三个系统方法，
 */
-(void)awakeFromNib{
    [super awakeFromNib];
    [SVUserManager loadUserInfo];
    if ([[SVUserManager shareInstance].printerSize intValue] == 58) {
        [self oneResponseEvent];
    } else if ([[SVUserManager shareInstance].printerSize intValue] == 80) {
        [self twoResponseEvent];
    }else if ([[SVUserManager shareInstance].printerSize intValue] == 110){
        [self threeResponseEvent];
    }
}

- (IBAction)oneResponseEvent {
    
    [self.ontButton setImage:[UIImage imageNamed:@"Print_FiftyEightHighlight"] forState:UIControlStateNormal];
    [self.twoButton setImage:[UIImage imageNamed:@"Print_Eighty"] forState:UIControlStateNormal];
    [self.threeButton setImage:[UIImage imageNamed:@"Print_OneHundredTen"] forState:UIControlStateNormal];
    [self blockMethods:58];
}


- (IBAction)twoResponseEvent {
    
    [self.ontButton setImage:[UIImage imageNamed:@"Print_FiftyEight"] forState:UIControlStateNormal];
    [self.twoButton setImage:[UIImage imageNamed:@"Print_EightyHighlight"] forState:UIControlStateNormal];
    [self.threeButton setImage:[UIImage imageNamed:@"Print_OneHundredTen"] forState:UIControlStateNormal];
    [self blockMethods:80];
}


- (IBAction)threeResponseEvent {
    [self.ontButton setImage:[UIImage imageNamed:@"Print_FiftyEight"] forState:UIControlStateNormal];
     [self.twoButton setImage:[UIImage imageNamed:@"Print_Eighty"] forState:UIControlStateNormal];
    [self.threeButton setImage:[UIImage imageNamed:@"Print_OneHundredTenHightlight"] forState:UIControlStateNormal];
    [self blockMethods:110];
}


/**
 调用block
 */
-(void)blockMethods:(NSInteger)number{
    
    if (self.printerSixeCellBlock) {
        self.printerSixeCellBlock(number);
    }
    
}




@end
