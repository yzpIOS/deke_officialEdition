//
//  SVPurchaseDeteilsCell.m
//  SAVI
//
//  Created by Sorgle on 2017/12/30.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVPurchaseDeteilsCell.h"

@interface SVPurchaseDeteilsCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *sv_p_name;
@property (weak, nonatomic) IBOutlet UILabel *sv_pc_combined;
@property (weak, nonatomic) IBOutlet UILabel *sv_pc_pnumber;
@property (weak, nonatomic) IBOutlet UILabel *sv_p_unit;

@property (weak, nonatomic) IBOutlet UITextField *countText;
@property (weak, nonatomic) IBOutlet UIButton *reduceButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UIImageView *img;

@property (weak, nonatomic) IBOutlet UILabel *spectLabel;

@end

@implementation SVPurchaseDeteilsCell

-(void)setModel:(SVPurchaseDeteilsModel *)model{
    _model = model;
    
    self.iconImg.layer.cornerRadius = 5;
    self.iconImg.layer.masksToBounds = YES;
    
    self.sv_p_name.text = _model.sv_p_name;
    
    [SVUserManager loadUserInfo];
          NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
          NSDictionary *StockManageDic = sv_versionpowersDict[@"StockManage"];
          NSString *StockManage = [NSString stringWithFormat:@"%@",StockManageDic[@"Procurement_Price_Total"]];
          if ([StockManage isEqualToString:@"0"]) {
      //        self.isLookPriceView.hidden = YES;
              self.sv_pc_combined.text = @"****";
            
          }else{
      //        self.isLookPriceView.hidden = NO;
             self.sv_pc_combined.text = [NSString stringWithFormat:@"￥%@",_model.sv_pc_price];
          }
    
  
    
    self.sv_p_unit.text = _model.sv_p_unit;
    
    if (!kStringIsEmpty(model.sv_p_specs)) {
        self.spectLabel.text = [NSString stringWithFormat:@"(%@)",model.sv_p_specs];
    }
    
    if ([_model.sv_pricing_method integerValue] == 0) {
        self.sv_pc_pnumber.text = _model.sv_pc_pnumber;
        //第一次来取值
        if (_model.product_num == 0) {
            _model.product_num = [_model.sv_pc_pnumber floatValue];
        }
        //相等，不可以改变_model.product_num值
        if (_model.product_num == [_model.sv_pc_pnumber floatValue]) {
            _model.product_num = [_model.sv_pc_pnumber floatValue];
        }
    }
    if ([_model.sv_pricing_method integerValue] == 1) {
        self.sv_pc_pnumber.text = _model.sv_p_weight;
        //第一次来取值
        if (_model.product_num == 0) {
            _model.product_num = [_model.sv_p_weight floatValue];
        }
        //相等，不可以改变_model.product_num值
        if (_model.product_num == [_model.sv_p_weight floatValue]) {
            _model.product_num = [_model.sv_p_weight floatValue];
        }
    }
    self.countText.text = [NSString stringWithFormat:@"%ld",(long)self.model.product_num];
    
    if ([self.countText.text isEqual:@"0"]) {
        self.img.hidden = NO;
    } else {
        self.img.hidden = YES;
    }
}

//减按钮
- (IBAction)countReduce:(UIButton *)sender {
    
    if ([self.countText.text isEqualToString:@"1"] || self.model.product_num <= 0) {
        self.reduceButton.hidden = YES;
        return;
    }
    
    self.model.product_num --;
    
    [self blockMethods];
    
    
}

//加按钮
- (IBAction)countAdd:(UIButton *)sender {
    
    if ([self.countText.text isEqualToString:self.sv_pc_pnumber.text]) {
        return;
    }
    
    self.model.product_num ++;
    self.reduceButton.hidden = NO;
    
    [self blockMethods];
    
}

//输入框--UITextField
- (IBAction)countTextAdd:(UITextField *)sender {
    
    if ([sender.text integerValue] <= 0) {
        
        sender.text = @"1";
        
    }
    
    if ([sender.text integerValue] > [self.sv_pc_pnumber.text integerValue]) {
        sender.text = self.sv_pc_pnumber.text;
    }
    
    //让图变大变小的
    self.countText.transform = CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:0.1   animations:^{
        self.countText.transform = CGAffineTransformMakeScale(1.5, 1.5);
    }completion:^(BOOL finish){
        [UIView animateWithDuration:0.1      animations:^{
            self.countText.transform = CGAffineTransformMakeScale(0.9, 0.9);
        }completion:^(BOOL finish){
            [UIView animateWithDuration:0.1   animations:^{
                self.countText.transform = CGAffineTransformMakeScale(1, 1);
            }completion:^(BOOL finish){
            }];
        }];
    }];
    
    self.reduceButton.hidden = NO;
    self.model.product_num = [sender.text floatValue];
    self.countText.text = sender.text;
    
    [self blockMethods];
}

/**
 调用block
 */
-(void)blockMethods{
    
    if (self.purchaseDeteilsBlock) {
        self.purchaseDeteilsBlock();
    }
    self.countText.text = [NSString stringWithFormat:@"%ld", (long)self.model.product_num];
    
}



@end
