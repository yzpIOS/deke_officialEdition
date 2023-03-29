//
//  SVSVPurchasingRecordsCell.m
//  SAVI
//
//  Created by houming Wang on 2021/2/6.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import "SVSVPurchasingRecordsCell.h"

@interface SVSVPurchasingRecordsCell()
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *Warehousing;
@property (weak, nonatomic) IBOutlet UILabel *Specifications;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet UILabel *supplier;
@property (weak, nonatomic) IBOutlet UILabel *PurchaseOrderNumber;

@end
@implementation SVSVPurchasingRecordsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
}

- (void)setDict:(NSDictionary *)dict
{
    self.supplier.text = [NSString stringWithFormat:@"供应商：%@",dict[@"sv_suname"]];
    self.PurchaseOrderNumber.text = [NSString stringWithFormat:@"采购单号：%@",dict[@"sv_pc_noid"]];
    NSString *timeString = dict[@"sv_pc_cdate"];
    NSString *time1 = [timeString substringToIndex:10];
    NSString *time2 = [timeString substringWithRange:NSMakeRange(11, 8)];
    self.date.text = [NSString stringWithFormat:@"%@ %@",time1,time2];
    self.Warehousing.text = dict[@"sv_warehouse_name"];
    self.Specifications.text = dict[@"sv_p_specs"];
    self.num.text = [NSString stringWithFormat:@"%.2f",[dict[@"sv_pc_pnumber"] doubleValue]];
    
    
    [SVUserManager loadUserInfo];
    NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
    NSDictionary *CommodityManageDic = sv_versionpowersDict[@"CommodityManage"];
    if (kDictIsEmpty(CommodityManageDic)) {
     self.price.text = [NSString stringWithFormat:@"%.2f",[dict[@"sv_pc_price"] doubleValue]];
    }else{
        NSString *Sv_purchaseprice = [NSString stringWithFormat:@"%@",CommodityManageDic[@"Sv_purchaseprice"]];
        if (kStringIsEmpty(Sv_purchaseprice)) {
            self.price.text = [NSString stringWithFormat:@"%.2f",[dict[@"sv_pc_price"] doubleValue]];
        }else{
            if ([Sv_purchaseprice isEqualToString:@"1"]) {
          
                self.price.text = [NSString stringWithFormat:@"%.2f",[dict[@"sv_pc_price"] doubleValue]];
        }else{
            self.price.text = @"***";
        }
        }
    }
   
}

- (void)setFrame:(CGRect)frame{
   // frame.origin.x += 10;
    frame.origin.y += 10;
    frame.size.height -= 10;
   // frame.size.width -= 20;
    [super setFrame:frame];
}

@end
