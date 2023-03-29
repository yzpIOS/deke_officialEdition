//
//  SVDetaildraftFirmOfferCell.m
//  SAVI
//
//  Created by houming Wang on 2019/6/13.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import "SVDetaildraftFirmOfferCell.h"
#import "SVduoguigeModel.h"
#import "SVPandianDetailModel.h"
#import "SVOrderDetailsModel.h"
@interface SVDetaildraftFirmOfferCell()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *specL;
@property (weak, nonatomic) IBOutlet UILabel *storeL;
@property (weak, nonatomic) IBOutlet UILabel *shiLabel;
@property (weak, nonatomic) IBOutlet UILabel *yingkuiLabel;

@property(retain,nonatomic) NSMutableString *stringNumber;
@property (nonatomic,assign) NSInteger selctNumber;
@property (weak, nonatomic) IBOutlet UILabel *actualInventoryLabel;
@property (weak, nonatomic) IBOutlet UIView *stockPurchaseNumberView;
@property (weak, nonatomic) IBOutlet UIView *stockpurchasePriceView;
@property (weak, nonatomic) IBOutlet UILabel *stockpurchasePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockpurchaseNumberLabel;
@property (weak, nonatomic) IBOutlet UIView *jinhuoView;

@property (weak, nonatomic) IBOutlet UILabel *jinhuoshuLabel;

@property (weak, nonatomic) IBOutlet UILabel *jinhuojiaLabel;
@property (weak, nonatomic) IBOutlet UIView *isLookPriceView;

@end
@implementation SVDetaildraftFirmOfferCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
//    self.icon.layer.cornerRadius = 35;
//    self.icon.layer.masksToBounds = YES;
    self.shipanView.layer.cornerRadius = 20;
    self.shipanView.layer.masksToBounds = YES;
    self.btn_7.layer.cornerRadius = 25;
    self.btn_7.layer.masksToBounds = YES;
    self.btn_8.layer.cornerRadius = 25;
    self.btn_8.layer.masksToBounds = YES;
    self.btn_9.layer.cornerRadius = 25;
    self.btn_9.layer.masksToBounds = YES;
    self.btn_4.layer.cornerRadius = 25;
    self.btn_4.layer.masksToBounds = YES;
    self.btn_5.layer.cornerRadius = 25;
    self.btn_5.layer.masksToBounds = YES;
    self.btn_6.layer.cornerRadius = 25;
    self.btn_6.layer.masksToBounds = YES;
    self.btn_1.layer.cornerRadius = 25;
    self.btn_1.layer.masksToBounds = YES;
    self.btn_2.layer.cornerRadius = 25;
    self.btn_2.layer.masksToBounds = YES;
    self.btn_3.layer.cornerRadius = 25;
    self.btn_3.layer.masksToBounds = YES;
    self.btn_circle.layer.cornerRadius = 25;
    self.btn_circle.layer.masksToBounds = YES;
    self.btn_0.layer.cornerRadius = 25;
    self.btn_0.layer.masksToBounds = YES;
    self.btn_clear_0.layer.cornerRadius = 25;
    self.btn_clear_0.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 25;
    self.sureBtn.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = 5;
    self.icon.layer.masksToBounds = YES;
    
    self.stockPurchaseNumberView.layer.cornerRadius = 15;
    self.stockPurchaseNumberView.layer.masksToBounds = YES;
    self.stockpurchasePriceView.layer.cornerRadius = 15;
    self.stockpurchasePriceView.layer.masksToBounds = YES;
    
    self.stockpurchasePriceLabel.adjustsFontSizeToFitWidth = YES;
    self.stockpurchasePriceLabel.minimumScaleFactor = 0.5;
    self.stockpurchaseNumberLabel.adjustsFontSizeToFitWidth = YES;
    self.stockpurchaseNumberLabel.minimumScaleFactor = 0.5;
    
    
    UITapGestureRecognizer *numberViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(numberViewTapClick)];
    self.stockPurchaseNumberView.userInteractionEnabled = YES;
    [self.stockPurchaseNumberView addGestureRecognizer:numberViewTap];
    
    self.stockPurchaseNumberView.layer.borderWidth = 1;
    self.stockPurchaseNumberView.layer.borderColor = navigationBackgroundColor.CGColor;
    
    UITapGestureRecognizer *PriceViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PriceViewTapClick)];
    self.stockpurchasePriceView.userInteractionEnabled = YES;
    [self.stockpurchasePriceView addGestureRecognizer:PriceViewTap];
    
    self.selctNumber = 3;
    
    self.string=[[NSMutableString alloc]init];//初始化可变字符串，分配内存
    self.stringNumber = [[NSMutableString alloc]init];
    
    [SVUserManager loadUserInfo];
    NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
    NSDictionary *StockManageDic = sv_versionpowersDict[@"StockManage"];
    NSString *StockManage = [NSString stringWithFormat:@"%@",StockManageDic[@"Procurement_Price_Total"]];
    if ([StockManage isEqualToString:@"0"]) {
       // self.isLookPriceView.hidden = YES;
        self.isLookPriceView.hidden = NO;
    }else{
        self.isLookPriceView.hidden = YES;
       // self.isLookPriceView.hidden = NO;
    }
}
#pragma mark - 进货数
- (void)numberViewTapClick{
    [self.string setString:@""];//清空字符
    self.stockpurchasePriceView.layer.borderWidth = 0;
    self.stockpurchasePriceView.layer.borderColor = [UIColor clearColor].CGColor;
    
    self.stockPurchaseNumberView.layer.borderWidth = 1;
    self.stockPurchaseNumberView.layer.borderColor = navigationBackgroundColor.CGColor;
    
    self.selctNumber = 3; // 进货数
}
#pragma mark - 进货价
- (void)PriceViewTapClick{
    [self.string setString:@""];//清空字符
    self.stockPurchaseNumberView.layer.borderWidth = 0;
    self.stockPurchaseNumberView.layer.borderColor = [UIColor clearColor].CGColor;
    
    self.stockpurchasePriceView.layer.borderWidth = 1;
    self.stockpurchasePriceView.layer.borderColor = navigationBackgroundColor.CGColor;
    
    self.selctNumber = 4; // 进货价
}

- (IBAction)keyBoardNumberClick:(UIButton *)sender {
    
    if (self.selctNumber == 1) { // 是盘点已添加商品那边来的
        //数字连续输入
        [self.string appendString:[sender currentTitle]];
        self.shiLabel.text = self.string;
        
        double count = self.shiLabel.text.doubleValue - _model.sv_p_storage.doubleValue;
        if (count > 0) {
            self.yingkuiLabel.text = [NSString stringWithFormat:@"盈 %.2f",count];
            self.yingkuiLabel.textColor = [UIColor redColor];
        }else if (count == 0){
            self.yingkuiLabel.text = @"平衡";
            self.yingkuiLabel.textColor = [UIColor grayColor];
        }else{
            self.yingkuiLabel.text = [NSString stringWithFormat:@"亏 %.2f",fabs(count)];
            self.yingkuiLabel.textColor = navigationBackgroundColor;
        }
    }else if(self.selctNumber == 2){ // 是盘点详情那边来的
        //数字连续输入
        [self.string appendString:[sender currentTitle]];
        self.shiLabel.text = self.string;
        
        double count = self.shiLabel.text.doubleValue - _model_two.sv_storestock_checkdetail_checkbeforenum.doubleValue;
        if (count > 0) {
            self.yingkuiLabel.text = [NSString stringWithFormat:@"盈 %.2f",count];
            self.yingkuiLabel.textColor = [UIColor redColor];
        }else if (count == 0){
            self.yingkuiLabel.text = @"平衡";
            self.yingkuiLabel.textColor = [UIColor grayColor];
        }else{
            self.yingkuiLabel.text = [NSString stringWithFormat:@"亏 %.2f",fabs(count)];
            self.yingkuiLabel.textColor = navigationBackgroundColor;
        }
    }else if(self.selctNumber == 3){ // 进货数
        
   
            //数字连续输入
            [self.string appendString:[sender currentTitle]];
            self.stockpurchaseNumberLabel.text = self.string;
     
    }else if(self.selctNumber == 4){ // 进货价
  
            //数字连续输入
               [self.string appendString:[sender currentTitle]];
               self.stockpurchasePriceLabel.text = self.string;
             //  self.model.sv_purchaseprice = self.string;
      
   
    }else if (self.selctNumber == 5){
        //数字连续输入
        [self.string appendString:[sender currentTitle]];
        self.shiLabel.text = self.string;
    }else{
        //数字连续输入
        [self.string appendString:[sender currentTitle]];
        self.shiLabel.text = self.string;
    }
}

- (IBAction)clearClick:(id)sender {
    self.shiLabel.text = @"";
    [self.string setString:@""];//清空字符
    self.yingkuiLabel.text = self.string;
    
    if (self.selctNumber == 3) {
        self.stockpurchaseNumberLabel.text = @"";
        [self.string setString:@""];//清空字符
    }else if (self.selctNumber == 4){
        self.stockpurchasePriceLabel.text = @"";
        [self.string setString:@""];//清空字符
    }
   
}


#pragma mark - 进货
- (void)setModel:(SVduoguigeModel *)model // 进货
{
    if (model.isStockPurchase.integerValue == 1) {
        self.actualInventoryLabel.hidden = YES;
        self.shipanView.hidden = YES;
        _model = model;
        self.nameL.text = model.sv_p_name;
        self.specL.text = model.sv_p_specs;
        self.storeL.text = model.sv_p_storage;
        self.stockpurchasePriceLabel.text = model.sv_purchaseprice;
        if (![SVTool isBlankString:model.sv_p_images]) {
            [self.icon sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:model.sv_p_images]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
        } else {
            
            self.icon.image = [UIImage imageNamed:@"foodimg"];
        }
        if (kStringIsEmpty(model.stockpurchaseNumber)) {
            self.stockpurchaseNumberLabel.text = @"";
        }else{
            self.stockpurchaseNumberLabel.text = model.stockpurchaseNumber;
        }
    }else if (model.isStockPurchase.integerValue == 2)// 退货
    {
        self.actualInventoryLabel.hidden = YES;
        self.shipanView.hidden = YES;
        self.jinhuoshuLabel.text = @"退货数:";
        self.jinhuojiaLabel.text = @"退货价:";
        _model = model;
        self.nameL.text = model.sv_p_name;
        self.specL.text = model.sv_p_specs;
        self.storeL.text = model.sv_p_storage;
        self.stockpurchasePriceLabel.text = model.sv_purchaseprice;
        if (![SVTool isBlankString:model.sv_p_images]) {
            [self.icon sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:model.sv_p_images]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
        } else {
            
            self.icon.image = [UIImage imageNamed:@"foodimg"];
        }
        if (kStringIsEmpty(model.stockpurchaseNumber)) {
            self.stockpurchaseNumberLabel.text = @"";
        }else{
            self.stockpurchaseNumberLabel.text = model.stockpurchaseNumber;
        }

    }else{
        self.jinhuoView.hidden = YES;
        self.shipanView.hidden = NO;
        self.selctNumber = 1;// 是盘点已添加商品那边来的
        _model = model;
        self.nameL.text = model.sv_p_name;
        self.specL.text = model.sv_p_specs;
        self.storeL.text = model.sv_p_storage;
        self.shiLabel.text = model.FirmOfferNum;
        [self.string setString:@""];//清空字符
        int count = self.shiLabel.text.intValue - model.sv_p_storage.intValue;
        if (![SVTool isBlankString:model.sv_p_images]) {
            [self.icon sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:model.sv_p_images]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
        } else {
            
            self.icon.image = [UIImage imageNamed:@"foodimg"];
        }
        if (!kStringIsEmpty(model.FirmOfferNum)) {
            // self.yingkuiLabel.hidden = NO;
            if (count > 0) {
                self.yingkuiLabel.text = [NSString stringWithFormat:@"盈 %i",count];
                self.yingkuiLabel.textColor = [UIColor redColor];
            }else if (count == 0){
                self.yingkuiLabel.text = @"平衡";
                self.yingkuiLabel.textColor = [UIColor grayColor];
            }else{
                self.yingkuiLabel.text = [NSString stringWithFormat:@"亏 %i",abs(count)];
                self.yingkuiLabel.textColor = navigationBackgroundColor;
            }
        }else{
            self.yingkuiLabel.text = @"";
        }
    }
   
  
    
}

- (void)setModel_two:(SVPandianDetailModel *)model_two // 盘点
{
    self.jinhuoView.hidden = YES;
    self.shipanView.hidden = NO;
    self.selctNumber = 2;// 是盘点详情那边来的
    _model_two = model_two;
    self.nameL.text = model_two.sv_storestock_checkdetail_pname;
    self.specL.text = model_two.sv_storestock_checkdetail_specs;
    [self.string setString:@""];//清空字符
    self.storeL.text = model_two.sv_storestock_checkdetail_checkbeforenum;
    if ([model_two.sv_storestock_checkdetail_checknum isEqualToString:@"-1"]) {
        self.shiLabel.text = @"";
        self.yingkuiLabel.text = @"";
//        int count = self.shiLabel.text.intValue - model_two.sv_storestock_checkdetail_checkbeforenum.intValue;
//        //        if (!kStringIsEmpty(model_two.sv_storestock_checkdetail_checknum)) {
//        // self.yingkuiLabel.hidden = NO;
//        if (count > 0) {
//            self.yingkuiLabel.text = [NSString stringWithFormat:@"盈 %i",count];
//            self.yingkuiLabel.textColor = [UIColor redColor];
//        }else if (count == 0){
//            self.yingkuiLabel.text = @"平衡";
//            self.yingkuiLabel.textColor = [UIColor grayColor];
//        }else{
//            self.yingkuiLabel.text = [NSString stringWithFormat:@"亏 %i",abs(count)];
//            self.yingkuiLabel.textColor = navigationBackgroundColor;
//        }
        
    }else{
        self.jinhuoView.hidden = YES;
        self.shipanView.hidden = NO;
        self.shiLabel.text = model_two.sv_storestock_checkdetail_checknum;
         int count = self.shiLabel.text.intValue - model_two.sv_storestock_checkdetail_checkbeforenum.intValue;
//        if (!kStringIsEmpty(model_two.sv_storestock_checkdetail_checknum)) {
            // self.yingkuiLabel.hidden = NO;
            if (count > 0) {
                self.yingkuiLabel.text = [NSString stringWithFormat:@"盈 %i",count];
                self.yingkuiLabel.textColor = [UIColor redColor];
            }else if (count == 0){
                self.yingkuiLabel.text = @"平衡";
                self.yingkuiLabel.textColor = [UIColor grayColor];
            }else{
                self.yingkuiLabel.text = [NSString stringWithFormat:@"亏 %i",abs(count)];
                self.yingkuiLabel.textColor = navigationBackgroundColor;
            }
//        }else{
//            self.yingkuiLabel.text = @"";
//        }
    }

}

- (IBAction)sureClick:(UIButton *)sender {
   
    if (self.selctNumber == 1) {
        _model.FirmOfferNum = self.shiLabel.text;
        _model.isSelect = @"1";
        if (self.sureBtnClickBlock) {
            self.sureBtnClickBlock(sender.tag, _model);
        }
       // [self numberViewTapClick];
    }else if (self.selctNumber == 2){
        _model_two.sv_storestock_checkdetail_checknum = self.shiLabel.text;
        if (self.sureBtnClickBlock_two) {
            self.sureBtnClickBlock_two(sender.tag, _model_two);
        }
       // [self numberViewTapClick];
    }else if (self.selctNumber == 3){
        
        if (self.model.isStockPurchase.integerValue == 2) { // 是退货的
               //数字连续输入
               [self.string appendString:[sender currentTitle]];
               if (self.model.sv_p_storage.floatValue < self.stockpurchaseNumberLabel.text.floatValue) {
                   [SVTool TextButtonActionWithSing:@"库存数不足"];
               }else if (self.model.sv_p_storage.floatValue <= 0){
                   [SVTool TextButtonActionWithSing:@"库存数不足"];
               }else{
                   _model.sv_purchaseprice = self.stockpurchasePriceLabel.text;
                   _model.stockpurchaseNumber = self.stockpurchaseNumberLabel.text;
                   _model.isSelect = @"1";
                   if (self.sureBtnClickBlock) {
                       self.sureBtnClickBlock(sender.tag, _model);
                   }
                   
                   
               }
             [self.string setString:@""];//清空字符
            [self numberViewTapClick];
        }else{
            _model.sv_purchaseprice = self.stockpurchasePriceLabel.text;
                  _model.stockpurchaseNumber = self.stockpurchaseNumberLabel.text;
                  _model.isSelect = @"1";
                  if (self.sureBtnClickBlock) {
                      self.sureBtnClickBlock(sender.tag, _model);
                  }
                  // [self.string setString:@""];//清空字符
            // [self numberViewTapClick];
        }
        
      [self numberViewTapClick];
    }else if (self.selctNumber == 4){
        
        if (self.model.isStockPurchase.integerValue == 2) { // 是退货的
                      //数字连续输入
                      [self.string appendString:[sender currentTitle]];
                      if (self.model.sv_p_storage.floatValue < self.stockpurchaseNumberLabel.text.floatValue) {
                          [SVTool TextButtonActionWithSing:@"库存数不足"];
                          
                      }else if (self.model.sv_p_storage.floatValue <= 0){
                          [SVTool TextButtonActionWithSing:@"库存数不足"];
                        
                      }else{
                          _model.sv_purchaseprice = self.stockpurchasePriceLabel.text;
                          _model.stockpurchaseNumber = self.stockpurchaseNumberLabel.text;
                          _model.isSelect = @"1";
                          if (self.sureBtnClickBlock) {
                              self.sureBtnClickBlock(sender.tag, _model);
                          }
                        //  [self.string setString:@""];//清空字符
                        //   [self numberViewTapClick];
                      }
             [self.string setString:@""];//清空字符
            [self numberViewTapClick];
        }else{
            _model.stockpurchaseNumber = self.stockpurchaseNumberLabel.text;
                 _model.sv_purchaseprice = self.stockpurchasePriceLabel.text;
                 _model.isSelect = @"1";
                 if (self.sureBtnClickBlock) {
                     self.sureBtnClickBlock(sender.tag, _model);
                 }
               //   [self.string setString:@""];//清空字符
             [self numberViewTapClick];
        }
        
     
    }
    

    
}

@end
