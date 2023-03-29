//
//  SVNewShopDetailCell.m
//  SAVI
//
//  Created by houming Wang on 2021/2/5.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import "SVNewShopDetailCell.h"

@interface SVNewShopDetailCell()
@property (weak, nonatomic) IBOutlet UILabel *ArticleNumber;
@property (weak, nonatomic) IBOutlet UILabel *Specifications;
@property (weak, nonatomic) IBOutlet UILabel *stock;
@property (weak, nonatomic) IBOutlet UILabel *price;

@end

@implementation SVNewShopDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setModel:(SVduoguigeModel *)model
{
    _model = model;
    self.ArticleNumber.text = model.sv_p_artno;
    self.Specifications.text = model.sv_p_specs;
    self.stock.text = [NSString stringWithFormat:@"%.2f",model.sv_p_storage.doubleValue];
    [SVUserManager loadUserInfo];
    NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
    NSDictionary *CommodityManageDic = sv_versionpowersDict[@"CommodityManage"];
    self.price.text = [NSString stringWithFormat:@"%.2f",model.sv_p_unitprice.doubleValue];
    //零售价
    if (kDictIsEmpty(CommodityManageDic)) {
       // self.RetailAndWholesalePrices.hidden = NO;
      
    }else{
        NSString *Sv_p_unitprice = [NSString stringWithFormat:@"%@",CommodityManageDic[@"Sv_p_unitprice"]];
        if (kStringIsEmpty(Sv_p_unitprice)) {
          //  self.RetailAndWholesalePrices.hidden = NO;
          
        }else{
            if ([Sv_p_unitprice isEqualToString:@"1"]) {
          
              
        }else{
            self.price.text = @"***";
           
        }
        }
    }
   
}


@end
