//
//  SVNumberOfCopiesCell.m
//  SAVI
//
//  Created by houming Wang on 2018/9/28.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVNumberOfCopiesCell.h"


@interface SVNumberOfCopiesCell()
@property (weak, nonatomic) IBOutlet UITextField *textFiledMoney;

@property (nonatomic,assign) NSInteger page;
@end

@implementation SVNumberOfCopiesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.page = 1;
    self.textFiledMoney.text = [NSString stringWithFormat:@"%ld",self.page];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//按减号
- (IBAction)countReduce:(id)sender {
//    if ([self.textFiledMoney.text isEqualToString:@"1"]) {
//        if (self.removeAddPurchaseCellBlock) {
//            self.removeAddPurchaseCellBlock(_model);
//        }
//
//        return;
//    }
    if (self.page > 1) {
        self.page --;
    }
    
    [self blockMethods];
    
}
// 处理输入框
- (IBAction)countTextAdd:(UITextField *)sender {
    
   
    if ([sender.text integerValue] <= 0) {
        
        sender.text = @"1";
        
    }
    
    //让图变大变小的
    self.textFiledMoney.transform = CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:0.1   animations:^{
        self.textFiledMoney.transform = CGAffineTransformMakeScale(1.5, 1.5);
    }completion:^(BOOL finish){
        [UIView animateWithDuration:0.1      animations:^{
            self.textFiledMoney.transform = CGAffineTransformMakeScale(0.9, 0.9);
        }completion:^(BOOL finish){
            [UIView animateWithDuration:0.1   animations:^{
                self.textFiledMoney.transform = CGAffineTransformMakeScale(1, 1);
            }completion:^(BOOL finish){
            }];
        }];
    }];
    
    self.page = [sender.text floatValue];
    
    [self blockMethods];
}

// 按加号
- (IBAction)countAdd:(id)sender {
    self.page ++;
    self.textFiledMoney.transform = CGAffineTransformMakeScale(1, 1);
    
    [UIView animateWithDuration:0.1   animations:^{
        self.textFiledMoney.transform = CGAffineTransformMakeScale(1.5, 1.5);
    }completion:^(BOOL finish){
        [UIView animateWithDuration:0.1      animations:^{
            self.textFiledMoney.transform = CGAffineTransformMakeScale(0.9, 0.9);
        }completion:^(BOOL finish){
            [UIView animateWithDuration:0.1   animations:^{
                self.textFiledMoney.transform = CGAffineTransformMakeScale(1, 1);
            }completion:^(BOOL finish){
            }];
        }];
    }];
    
     [self blockMethods];
}

/**
 调用block
 */
-(void)blockMethods{
    
//    if (self.caddPurchaseBlock) {
//        self.caddPurchaseBlock();
//    }
    self.textFiledMoney.text = [NSString stringWithFormat:@"%ld", self.page];
    
    
    if (self.severalCopiesCellBlock) {
        self.severalCopiesCellBlock(self.page);
    }
}

@end
