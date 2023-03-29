//
//  SVReturnGoodsDetailCell.m
//  SAVI
//
//  Created by 杨忠平 on 2020/4/14.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVReturnGoodsDetailCell.h"
#import "SVduoguigeModel.h"

@interface SVReturnGoodsDetailCell()
@property (weak, nonatomic) IBOutlet UILabel *sv_p_barcode;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *sv_p_unit;
@property (weak, nonatomic) IBOutlet UILabel *sv_pc_price;
@property (weak, nonatomic) IBOutlet UILabel *sv_pc_pnumber;

@end
@implementation SVReturnGoodsDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


//- (void)setModel:(SVduoguigeModel *)model
//{
//    _model = model;
//    self.sv_p_barcode.text = model.sv_p_barcode;
//    self.name.text = model.sv_p_name;
//    self.sv_p_unit.text = model.sv_p_unit;
//    self.sv_pc_price.text = model.sv_pc_price;
//    self.sv_pc_pnumber.text = model.sv_pc_name;
//}

- (void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    self.sv_p_barcode.text = [NSString stringWithFormat:@"%@",dict[@"sv_p_barcode"]];
   NSString *sv_p_specs = dict[@"sv_p_specs"];
    if (kStringIsEmpty(sv_p_specs)) {
        self.name.text = [NSString stringWithFormat:@"%@",dict[@"sv_p_name"]];
    }else{
        self.name.text = [NSString stringWithFormat:@"%@(%@)",dict[@"sv_p_name"],dict[@"sv_p_specs"]];
    }
    
    self.sv_p_unit.text = [NSString stringWithFormat:@"%@",dict[@"sv_p_unit"]];
    
    self.sv_pc_price.text = [NSString stringWithFormat:@"%.2f",[dict[@"sv_pc_price"] doubleValue]];
    [SVUserManager loadUserInfo];
      NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
       if (kDictIsEmpty(sv_versionpowersDict)) {
        
       }else{
           NSDictionary *StockManage = sv_versionpowersDict[@"StockManage"];
           if (kDictIsEmpty(StockManage)) {
            
           }else{
        
               // 底部是否添加会员
               NSString *ReturnGoods_Price_Total = [NSString stringWithFormat:@"%@",StockManage[@"ReturnGoods_Price_Total"]];
               if (kStringIsEmpty(ReturnGoods_Price_Total)) {
                 
               }else{
                   if ([ReturnGoods_Price_Total isEqualToString:@"1"]) {
                     
                   }else{
                       self.sv_pc_price.text = @"***";
                   }
               }
              
           }
                                     
           
       }
    
  
    self.sv_pc_pnumber.text = [NSString stringWithFormat:@"%.2f", [dict[@"sv_pc_pnumber"] doubleValue] + [dict[@"sv_p_weight"] doubleValue]];
    
}

@end
