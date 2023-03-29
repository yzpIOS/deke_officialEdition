//
//  SVaddPurchaseCell.m
//  SAVI
//
//  Created by Sorgle on 2018/3/9.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVaddPurchaseCell.h"
#import "SVduoguigeModel.h"

@interface SVaddPurchaseCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *unitprice;


@property (weak, nonatomic) IBOutlet UITextField *countText;
@property (weak, nonatomic) IBOutlet UIButton *reduceButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

//@property (weak, nonatomic) IBOutlet UILabel *specLabel;

@property (weak, nonatomic) IBOutlet UILabel *specLabelTwo;
@end

@implementation SVaddPurchaseCell



-(void)setModel:(SVduoguigeModel *)model {
    _model = model;
    
    //图片
    self.iconView.layer.cornerRadius = 5;
    self.iconView.layer.masksToBounds = YES;
    if (![SVTool isBlankString:self.model.sv_p_images2]) {
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:self.model.sv_p_images2]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
    } else {
        
        if ([self.model.sv_p_images containsString:@"UploadImg"]) {
            
            NSData *data = [self.model.sv_p_images dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
            NSDictionary *dic = arr[0];
            NSString *sv_p_images_two = dic[@"code"];
           // sv_p_images = sv_p_images_two;
            [self.iconView sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:sv_p_images_two]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
        }else{
            self.iconView.image = [UIImage imageNamed:@"foodimg"];
        }
       
    }
    //名称
    self.goodsName.text = model.sv_p_name;
    if (kStringIsEmpty(model.sv_p_specs)) {
        self.specLabelTwo.hidden = YES;
    }else{
        self.specLabelTwo.hidden = NO;
        self.specLabelTwo.text = [NSString stringWithFormat:@"(%@)",model.sv_p_specs];
    }
    

    //进货价
    float num = [_model.sv_purchaseprice floatValue];
    self.money.text = [NSString stringWithFormat:@"%0.2f",num];

    [SVUserManager loadUserInfo];
       NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
       NSDictionary *StockManageDic = sv_versionpowersDict[@"StockManage"];
       NSString *StockManage = [NSString stringWithFormat:@"%@",StockManageDic[@"Procurement_Price_Total"]];
       if ([StockManage isEqualToString:@"0"]) {
//           self.isLookPriceView.hidden = YES;
             self.money.text = [NSString stringWithFormat:@"****"];
           //进货价
             
       }else{
          // float num = [_model.sv_purchaseprice floatValue];
         float num = [_model.sv_purchaseprice floatValue];
                      self.money.text = [NSString stringWithFormat:@"%0.2f",num];
       }
   
   

    
    //库存
    float number = [_model.sv_p_storage floatValue];
    self.unitprice.text = [NSString stringWithFormat:@"%.f",number];
    
    //选择件数
    if (self.model.stockpurchaseNumber.integerValue == 0) {
        self.model.stockpurchaseNumber = @"1";
    }
    self.countText.text = [NSString stringWithFormat:@"%@",self.model.stockpurchaseNumber];
    
    
}

//减按钮
- (IBAction)countReduce:(UIButton *)sender {
    
    if ([self.countText.text isEqualToString:@"1"]) {
        //        self.reduceButton.hidden = YES;
        if (self.removeAddPurchaseCellBlock) {
            self.removeAddPurchaseCellBlock(_model);
        }
        return;
    }
    NSInteger count = self.model.stockpurchaseNumber.integerValue;
    count --;
    self.model.stockpurchaseNumber = [NSString stringWithFormat:@"%ld",count];
    
    [self blockMethods];
}

//加按钮
- (IBAction)countAdd:(UIButton *)sender {
    
    //   / self.model.product_num ++;
    //    self.reduceButton.hidden = NO;
    
    NSInteger count = self.model.stockpurchaseNumber.integerValue;
    count ++;
    self.model.stockpurchaseNumber = [NSString stringWithFormat:@"%ld",count];
    
    //让图变大变小的图
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
    
    [self blockMethods];
    
}

//输入框--UITextField
- (IBAction)countTextAdd:(UITextField *)sender {
    
    if ([sender.text integerValue] <= 0) {
        
        sender.text = @"1";
        
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
    
    //    self.reduceButton.hidden = NO;
    
    //   self.model.product_num = [sender.text floatValue];
    self.model.stockpurchaseNumber = sender.text;
    [self blockMethods];
    
}

/**
 调用block
 */
-(void)blockMethods{
    
    if (self.caddPurchaseBlock) {
        self.caddPurchaseBlock();
    }
    self.countText.text = self.model.stockpurchaseNumber;
    
}

@end
