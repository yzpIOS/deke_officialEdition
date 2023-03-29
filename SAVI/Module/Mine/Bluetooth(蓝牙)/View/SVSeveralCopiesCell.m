//
//  SVSeveralCopiesCell.m
//  SAVI
//
//  Created by houming Wang on 2018/5/9.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVSeveralCopiesCell.h"

@interface SVSeveralCopiesCell()
@property (weak, nonatomic) IBOutlet UIButton *severalOneButton;
@property (weak, nonatomic) IBOutlet UIButton *severalTwoButton;
@property (weak, nonatomic) IBOutlet UIButton *severalThreeButton;
@property (weak, nonatomic) IBOutlet UIButton *severalFourButton;
@end

@implementation SVSeveralCopiesCell

-(void)awakeFromNib{
    [super awakeFromNib];
    [SVUserManager loadUserInfo];
    if ([[SVUserManager shareInstance].printerNumber intValue] == 1) {
        [self oneResponseEvent:self.severalOneButton];
    } else if ([[SVUserManager shareInstance].printerNumber intValue] == 2) {
        [self twoResponseEvent:self.severalTwoButton];
    } else if ([[SVUserManager shareInstance].printerNumber intValue] == 3) {
        [self threeResponseEvent:self.severalThreeButton];
    } else if ([[SVUserManager shareInstance].printerNumber intValue] == 4) {
        [self fourresponseEvesnt:self.severalFourButton];
    }
}



- (IBAction)oneResponseEvent:(id)sender {
    [self.severalOneButton setTitleColor:selectedColor forState:UIControlStateNormal];
    [self.severalTwoButton setTitleColor:GlobalFontColor forState:UIControlStateNormal];
    [self.severalThreeButton setTitleColor:GlobalFontColor forState:UIControlStateNormal];
    [self.severalFourButton setTitleColor:GlobalFontColor forState:UIControlStateNormal];
    [self blockMethods:1];
}

- (IBAction)twoResponseEvent:(id)sender {
    [self.severalTwoButton setTitleColor:selectedColor forState:UIControlStateNormal];
    [self.severalOneButton setTitleColor:GlobalFontColor forState:UIControlStateNormal];
    [self.severalThreeButton setTitleColor:GlobalFontColor forState:UIControlStateNormal];
    [self.severalFourButton setTitleColor:GlobalFontColor forState:UIControlStateNormal];
    [self blockMethods:2];
}

- (IBAction)threeResponseEvent:(id)sender {
    [self.severalThreeButton setTitleColor:selectedColor forState:UIControlStateNormal];
    [self.severalTwoButton setTitleColor:GlobalFontColor forState:UIControlStateNormal];
    [self.severalOneButton setTitleColor:GlobalFontColor forState:UIControlStateNormal];
    [self.severalFourButton setTitleColor:GlobalFontColor forState:UIControlStateNormal];
    [self blockMethods:3];
}

- (IBAction)fourresponseEvesnt:(id)sender {
    [self.severalFourButton setTitleColor:selectedColor forState:UIControlStateNormal];
    [self.severalTwoButton setTitleColor:GlobalFontColor forState:UIControlStateNormal];
    [self.severalThreeButton setTitleColor:GlobalFontColor forState:UIControlStateNormal];
    [self.severalOneButton setTitleColor:GlobalFontColor forState:UIControlStateNormal];
    [self blockMethods:4];
}

/**
 调用block
 */
-(void)blockMethods:(NSInteger)number{
    
    if (self.severalCopiesCellBlock) {
        self.severalCopiesCellBlock(number);
    }
    
}


@end
