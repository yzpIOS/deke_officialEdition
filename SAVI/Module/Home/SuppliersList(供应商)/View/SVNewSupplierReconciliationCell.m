//
//  SVNewSupplierReconciliationCell.m
//  SAVI
//
//  Created by houming Wang on 2021/4/26.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import "SVNewSupplierReconciliationCell.h"
#import "SVReconciliationModel.h"

@interface SVNewSupplierReconciliationCell()

@property (weak, nonatomic) IBOutlet UILabel *sv_pc_noid;
@property (weak, nonatomic) IBOutlet UILabel *sv_typeName;

@property (weak, nonatomic) IBOutlet UILabel *sv_pc_total;


@end

@implementation SVNewSupplierReconciliationCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

//{
//    "state1": "-1",
//    "keywards": "",
//    "sv_enable": "-1",
//    "id": "0",
//    "reviewer_by": "0",
//    "pagesize": "20",
//    "page": "1",
//    "state": "0",
//    "sv_order_type": "0"
//}

- (void)setModel:(SVReconciliationModel *)model
{
    _model = model;
    self.sv_pc_noid.text = model.sv_pc_noid;
    self.sv_typeName.text = model.sv_typeName;
    if (model.sv_is_arrears == 1) {
        self.sv_pc_total.text = [NSString stringWithFormat:@"￥%.2f",model.sv_pc_total];
      //
        self.sv_pc_total.textColor = an_redColor;
    }else{
        self.sv_pc_total.text = @"无欠款";
        self.sv_pc_total.textColor = an_gradeColor;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
