//
//  SVMembercreditCell.m
//  SAVI
//
//  Created by houming Wang on 2020/11/25.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVMembercreditCell.h"
#import "SVMemberCreditModel.h"
@interface SVMembercreditCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *circleView;
@property (weak, nonatomic) IBOutlet UILabel *order_running_id;
@property (weak, nonatomic) IBOutlet UILabel *order_datetime;
@property (weak, nonatomic) IBOutlet UILabel *order_money;

@property (weak, nonatomic) IBOutlet UILabel *order_moneyLabel;


@property (weak, nonatomic) IBOutlet UILabel *order_datetime2;

@end

@implementation SVMembercreditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.order_money2.delegate = self;
    self.circleView.layer.cornerRadius = 5;
    self.circleView.layer.masksToBounds = YES;
    self.circleView.layer.borderColor = [UIColor colorWithHexString:@"f4f4f4"].CGColor;
    self.circleView.layer.borderWidth = 1;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    SVMemberCreditModel *model = self.valuesArray[textField.tag];
    if ([textField.text doubleValue] > [model.order_money2 doubleValue]) {
        textField.text = [NSString stringWithFormat:@"%.2f",model.order_money2.doubleValue];
        [SVTool TextButtonActionWithSing:@"还款金额不能大于赊账金额"];
    }else{
        if ([textField.text doubleValue] <= 0) {
            textField.text = [NSString stringWithFormat:@"%.2f",model.order_money2.doubleValue];
            [SVTool TextButtonActionWithSing:@"金额应大于0"];
        }else{
            if (self.order_moneyAndBlock) {
                self.order_moneyAndBlock(self.indexRow, textField.text);
            }
        }
        
    }
    
   
}

- (void)setModel:(SVMemberCreditModel *)model
{
    _model = model;
    self.order_moneyLabel.hidden = YES;
    self.order_running_id.text = model.order_running_id;
   // NSString *order_datetime = dict[@"order_datetime"];
    NSString *timeString = model.order_datetime;
    if (!kStringIsEmpty(timeString)) {
        NSString *time1 = [timeString substringToIndex:10];
        NSString *time2 = [timeString substringWithRange:NSMakeRange(11, 8)];
        self.order_datetime.text = time1;
        self.order_datetime2.text = time2;
    }
    self.order_money.text = [NSString stringWithFormat:@"%.2f",[model.order_money2 doubleValue]];
    self.order_money2.text = [NSString stringWithFormat:@"%.2f",[model.sv_credit_money doubleValue]];
    if (model.isSelected) {
    
        self.backgroundColor =  RGBA(197, 205, 244, 1);
 
    } else {

        self.backgroundColor =  [UIColor whiteColor];
     
    }
}

- (void)setModel2:(SVMemberCreditModel *)model2
{
    _model2 = model2;
    self.order_money2.hidden = YES;
    self.circleView.layer.cornerRadius = 5;
    self.circleView.layer.masksToBounds = YES;
    self.circleView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.circleView.layer.borderWidth = 1;
    self.order_running_id.text = model2.sv_order_id;
   // NSString *order_datetime = dict[@"order_datetime"];
    NSString *timeString = model2.sv_date;
    if (!kStringIsEmpty(timeString)) {
        NSString *time1 = [timeString substringToIndex:10];
        NSString *time2 = [timeString substringWithRange:NSMakeRange(11, 8)];
        self.order_datetime.text = time1;
        self.order_datetime2.text = time2;
    }
    self.order_money.text = [NSString stringWithFormat:@"%.2f",[model2.sv_money doubleValue]];
    self.order_moneyLabel.text = model2.sv_payment_method_name;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
