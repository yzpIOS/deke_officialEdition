//
//  SVSelectShopListCell.m
//  SAVI
//
//  Created by houming Wang on 2019/7/31.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import "SVSelectShopListCell.h"
#import "SVduoguigeModel.h"
@interface SVSelectShopListCell ()
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *purchasePrice;
@property (weak, nonatomic) IBOutlet UILabel *rightNumber;
@property (weak, nonatomic) IBOutlet UILabel *specLabel;

@end

@implementation SVSelectShopListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SVduoguigeModel *)model
{
    _model = model;
    self.nameLabel.text = model.sv_p_name;
    self.codeLabel.text = model.sv_p_barcode;
    [SVUserManager loadUserInfo];
       NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
       NSDictionary *StockManageDic = sv_versionpowersDict[@"StockManage"];
       NSString *StockManage = [NSString stringWithFormat:@"%@",StockManageDic[@"Procurement_Price_Total"]];
       if ([StockManage isEqualToString:@"0"]) {
//           self.isLookPriceView.hidden = YES;
             self.purchasePrice.text = [NSString stringWithFormat:@"****"];
           //进货价
             
       }else{
          // float num = [_model.sv_purchaseprice floatValue];
         double num = [_model.sv_purchaseprice floatValue];
         self.purchasePrice.text = [NSString stringWithFormat:@"%.2f",num];
       //  self.purchasePrice.text = model.sv_purchaseprice;
       }
    
    self.rightNumber.text = model.stockpurchaseNumber;
    if (kStringIsEmpty(model.sv_p_specs)) {
        self.specLabel.hidden = YES;
    }else{
        self.specLabel.hidden = NO;
        self.specLabel.text = [NSString stringWithFormat:@"(%@)",model.sv_p_specs];
    }
}

@end
