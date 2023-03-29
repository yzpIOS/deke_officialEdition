//
//  SVSuppliersListCell.m
//  SAVI
//
//  Created by Sorgle on 2017/12/30.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVSuppliersListCell.h"


@interface SVSuppliersListCell ()

@property (weak, nonatomic) IBOutlet UILabel *supplier;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
//欠款
@property (weak, nonatomic) IBOutlet UILabel *arrears;

@end

@implementation SVSuppliersListCell

-(void)setModel:(SVSupplierListModel *)model {
    
    _model = model;
    
    self.supplier.text = _model.sv_suname;
    self.name.text = _model.sv_sulinkmnm;
    self.phone.text = _model.sv_sumoble;
    
    if (_model.arrears > 0) {
        self.arrears.hidden = YES;
    } else {
        self.arrears.hidden = NO;
    }
    
}


@end
