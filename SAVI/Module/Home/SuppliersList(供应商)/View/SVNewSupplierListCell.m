//
//  SVNewSupplierListCell.m
//  SAVI
//
//  Created by houming Wang on 2021/4/13.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import "SVNewSupplierListCell.h"
#import "SVSupplierListModel.h"

@interface SVNewSupplierListCell()
@property (weak, nonatomic) IBOutlet UILabel *contacts;
@property (weak, nonatomic) IBOutlet UILabel *tel;
@property (weak, nonatomic) IBOutlet UILabel *CreditStatus;
@property (weak, nonatomic) IBOutlet UILabel *supplier;
@property (weak, nonatomic) IBOutlet UILabel *isEnable;
@property (weak, nonatomic) IBOutlet UIView *isEnableView;

@end

@implementation SVNewSupplierListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SVSupplierListModel *)model
{
    _model = model;
    self.contacts.text = model.sv_sulinkmnm;
    self.tel.text = model.sv_sumoble;
    if ([model.arrears_state isEqualToString:@"有欠款"]) {
        self.CreditStatus.textColor = [UIColor redColor];
    }else{
        self.CreditStatus.textColor = RGBA(110, 110, 110, 1);
    }
    self.CreditStatus.text = model.arrears_state;
    self.supplier.text = model.sv_suname;
    if (model.sv_enable == 1) {
        self.isEnable.text = @"已启用";
        self.isEnableView.layer.borderColor =GreenBackgroundColor.CGColor;
        self.isEnableView.backgroundColor = RGBA(237, 255, 245, 1);
        self.isEnable.textColor = GreenBackgroundColor;
    }else{
        self.isEnable.text = @"已暂停";
        self.isEnableView.layer.borderColor = [UIColor redColor].CGColor;
        self.isEnableView.backgroundColor = RGBA(253, 242, 241, 1);
        self.isEnable.textColor = [UIColor redColor];
    }
    self.isEnableView.layer.borderWidth = 1;
    self.isEnableView.layer.cornerRadius = 5;
    self.isEnableView.layer.masksToBounds = YES;
    
}

@end
