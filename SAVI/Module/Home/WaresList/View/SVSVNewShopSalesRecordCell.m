//
//  SVSVNewShopSalesRecordCell.m
//  SAVI
//
//  Created by houming Wang on 2021/2/6.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import "SVSVNewShopSalesRecordCell.h"

@interface SVSVNewShopSalesRecordCell()
@property (weak, nonatomic) IBOutlet UILabel *SalesOrderNo;
@property (weak, nonatomic) IBOutlet UILabel *SalesTarget;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UILabel *price;


@end
@implementation SVSVNewShopSalesRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    self.SalesOrderNo.text = [NSString stringWithFormat:@"%@",dict[@"order_running_id"]];
    NSString *sv_mr_name = [NSString stringWithFormat:@"%@",dict[@"sv_mr_name"]];
    if (kStringIsEmpty(sv_mr_name) || [sv_mr_name containsString:@"null"]) {
        self.SalesTarget.text = @"散客";
    }else{
        self.SalesTarget.text = sv_mr_name;
    }
    
    self.num.text = [NSString stringWithFormat:@"%.2f",[dict[@"product_num"]doubleValue]];
    [SVUserManager loadUserInfo];
    NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
    NSDictionary *CommodityManageDic = sv_versionpowersDict[@"CommodityManage"];
    self.price.text = [NSString stringWithFormat:@"%.2f",[dict[@"product_total"]doubleValue]];
    //零售价
    if (kDictIsEmpty(CommodityManageDic)) {
      //  self.RetailAndWholesalePrices.hidden = NO;
      
    }else{
        NSString *Sv_p_unitprice = [NSString stringWithFormat:@"%@",CommodityManageDic[@"Sv_p_unitprice"]];
        if (kStringIsEmpty(Sv_p_unitprice)) {
          
          
        }else{
            if ([Sv_p_unitprice isEqualToString:@"1"]) {
          
             
              
        }else{
            self.price.text = @"***";
           
        }
        }
    }
   
}


@end
