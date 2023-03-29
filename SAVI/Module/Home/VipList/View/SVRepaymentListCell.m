//
//  SVRepaymentListCell.m
//  SAVI
//
//  Created by houming Wang on 2018/6/26.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVRepaymentListCell.h"


@interface SVRepaymentListCell()

@property (weak, nonatomic) IBOutlet UIView *whiteView;

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *order_running_id;
@property (weak, nonatomic) IBOutlet UILabel *order_payment;
@property (weak, nonatomic) IBOutlet UILabel *order_datetime;
@property (weak, nonatomic) IBOutlet UILabel *sv_credit_money;

@end

@implementation SVRepaymentListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.whiteView.layer.cornerRadius = 10;
    self.backgroundColor = BlueBackgroundColor;
    
}

- (void)setModel:(SVRepaymentModel *)model {
    _model = model;
    
    if (![SVTool isBlankString:model.order_id]) {
        self.order_running_id.text = [NSString stringWithFormat:@"%@ / %@",model.order_running_id,model.order_id];
        self.order_running_id.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        self.order_payment.text = model.order_payment;
        self.order_datetime.text = [model.order_datetime substringToIndex:10];
        self.sv_credit_money.text = model.sv_credit_money;
        
        self.icon.hidden = NO;
        if ([model.isSelect isEqualToString:@"1"]) {
            self.icon.image = [UIImage imageNamed:@"ic_yixuan.png"];
        } else {
            self.icon.image = [UIImage imageNamed:@"ic_mo-ren"];
        }
    } else {
        self.icon.hidden = YES;
        self.order_running_id.text = model.sv_order_id;
        self.order_running_id.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        self.order_payment.text = model.sv_payment_method_name;
        self.order_datetime.text = [model.sv_date substringToIndex:10];
        self.sv_credit_money.text = model.sv_money;
    }

}

//-(void)setRepaymentListModel:(SVRepaymentListModel *)RepaymentListModel {
//    _RepaymentListModel = RepaymentListModel;
//
//    self.icon.hidden = YES;
//    self.order_running_id.text = RepaymentListModel.sv_member_id;
//    self.order_running_id.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
//    self.order_payment.text = RepaymentListModel.sv_payment_method_name;
//    self.order_datetime.text = [RepaymentListModel.sv_date substringToIndex:10];
//    self.sv_credit_money.text = RepaymentListModel.sv_money;
//}

@end
